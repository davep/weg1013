{

     WEG - EXPERT GUIDE FOR WINDOWS
     Copyright (C) 1998,1999 David A Pearson

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the license, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

}

unit egFinder;

interface

Uses Windows, Dialogs, ComCtrls, Classes, ngGuide;

Type

  { Class used to hold the details of a "hit" }
  TFinderHit = Class
    { Public instance variables }
    Public
      sGuide : String;
      sTitle : String; 
      sText  : String;
      lEntry : LongInt;
      iLine  : Integer;
  End;

  { Callback types for informing the thread parent about various events }
  TFinderThreadCallbackFoundProc    = Procedure( oHit : TFinderHit ) Of Object;
  TFinderThreadCallbackFinishedProc = Procedure Of Object;
  TFinderThreadCallbackProgressProc = Procedure( lPos : LongInt; lMax : LongInt ) Of Object;
  TFinderThreadCallbackStatusProc   = Procedure( sStatus : String ) Of Object;

  { Search styles }
  TFinderSearchStyle  = ( fssShort, fssLong );
  TFinderSearchStyles = Set Of TFinderSearchStyle;

  { Finder thread class }
  TFinderThread = Class( TThread )

    { Public instance variables }
    Public
      bOemToAnsi   : Boolean;
      procFound    : TFinderThreadCallbackFoundProc;
      procFinished : TFinderThreadCallbackFinishedProc;
      procProgress : TFinderThreadCallbackProgressProc;
      procStatus   : TFinderThreadCallbackStatusProc;
      bMatchCase   : Boolean;
      ssLookIn     : TFinderSearchStyles;

    { Public methods }
      Constructor Create( slGuides : TStringList; sFind : String );
      Destructor  Destroy; Override;
      Function    running : Boolean;

    { Protected instance variables }
    Protected
      slGuides : TStringList;
      sFind    : String;
      ng       : TNortonGuide;
      oHit     : TFinderHit; { Class wide to allow Syncronize }
      bWorking : Boolean;

    { Protected methods }
      Procedure execute; override;
      Procedure notifyFound;
      Procedure updateProgress;
      Procedure showFinding;

  End;

implementation

Uses SysUtils, ngEntry, ngUtils;

Constructor TFinderThread.Create( slGuides : TStringList; sFind : String );
Begin

  { Start suspended, caller will resume us. }
  Inherited Create( True );

  bOemToAnsi    := False;                 { By default, don't convert }
  ssLookIn      := [ fssShort, fssLong ]; { Look in everything by default }
  self.slGuides := slGuides;              { Remember the guides to look in }
  self.sFind    := sFind;                 { Remember what to look for }
  ng            := TNortonGuide.Create;   { Create a Norton Guide instance }

End;

Destructor TFinderThread.Destroy;
Begin

  If ng <> Nil Then
  Begin
    ng.Close;
    ng.Free;
  End;

  slGuides.Free;
  
  Inherited;
  
End;

Function TFinderThread.running : Boolean;
Begin
  Result := ( Not ( Suspended Or Terminated ) ) And bWorking;
End;

Procedure TFinderThread.execute;
Var
  oEntry    : TNGEntry;
  iLine     : Integer;
  iLines    : Integer;
  iHit      : Integer;
  bLookHere : Boolean;
  iGuide    : Integer;
  sNeedle   : String;
  sHayStack : String;
Begin

  bWorking := True;
  iGuide   := 0;

  { Make sure the needle is formatted correctly before we go looking in the
    haystack. }
  If bMatchCase Then
    sNeedle := sFind
  Else
    sNeedle := AnsiUpperCase( sFind );
    
  While ( Not Terminated ) And ( iGuide < slGuides.Count ) Do
  Begin

    If ng.open( slGuides[ iGuide ] ) Then
    Begin

      If ng.isValid Then
      Begin

        ng.bOemToAnsi := bOemToAnsi;
        
        ng.goTop;

        showFinding;

        While ( Not Terminated ) And ( Not ng.eof ) Do
        Begin

          If ng.lookingAtShortEntry Then
            bLookHere := fssShort In ssLookIn
          Else If ng.lookingAtLongEntry Then
            bLookHere := fssLong In ssLookIn
          Else { Don't look, broken entry, oh dear! }
            bLookHere := False;

          { Update the progress bar }
          Synchronize( updateProgress );

          If bLookHere Then
          Begin

            { Grab the entry }
            oEntry := ng.loadCurrentEntry;

            iLines := oEntry.lines;
            iLine  := 0;

            While ( Not Terminated ) And ( iLine < iLines ) Do
            Begin

              { Grab the haystack }
              If bOemToAnsi Then
                sHayStack := DosToWinStr( oEntry.plainLine( iLine ) )
              Else
                sHayStack := oEntry.plainLine( iLine );

              { See if we've got a hit }
              If bMatchCase Then
                iHit := Pos( sNeedle, sHayStack )
              Else
                iHit := Pos( sNeedle, AnsiUpperCase( sHayStack ) );

              If iHit <> 0 Then { We have a hit }
              Begin
                oHit        := TFinderHit.Create;
                oHit.sGuide := ng.fileName;
                oHit.sTitle := ng.title;
                oHit.sText  := oEntry.plainLine( iLine );
                oHit.lEntry := oEntry.offset;
                oHit.iLine  := iLine;
                Synchronize( notifyFound );
              End;

              Inc( iLine );

            End;

            oEntry.Free;

          End
          Else
            ng.skip;

        End;

      End;

      ng.close;
      
    End;

    Inc( iGuide );
    
  End;

  If Not Terminated Then
    procFinished;

  bWorking := False;
  
End;

Procedure TFinderThread.notifyFound;
Begin
  If Assigned( procFound ) Then
    procFound( oHit );
End;

Procedure TFinderThread.updateProgress;
Begin
  If Assigned( procProgress ) Then
    procProgress( ng.bytePos, ng.byteSize );
End;

Procedure TFinderThread.showFinding;
Begin
  If Assigned( procStatus ) Then
    procStatus( 'Searching in ''' + ng.title + '''' );
End;

end.
