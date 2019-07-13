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

unit ngEntry;

interface

Uses SysUtils, Classes, ngUtils, ngSeeAlso, Math;

Type
  TNGEntry = Class
    Public
    { Public instance variables }
      bOemToAnsi : Boolean;
      
    { Public Methods }
      Constructor Create;
      Destructor  Destroy; Override;
      Function lines        : Integer;
      Function isShort      : Boolean;
      Function isLong       : Boolean;
      Function offset       : LongInt;
      Function parentLine   : Integer;
      Function parent       : LongInt;
      Function previous     : LongInt;
      Function next         : LongInt;
      Function parentMenu   : Integer;
      Function parentPrompt : Integer;
      Function hasSeeAlso   : Boolean;
      Function seeAlsos     : Integer;
      Function seeAlso( iSeeAlso : Integer ) : String;
      Function seeAlsoOffset( iSeeAlso : Integer ) : LongInt;
      Function hasPrevious : Boolean;
      Function hasUp       : Boolean;
      Function hasNext     : Boolean;
      Function text        : String;
      Function source      : String;
      Function line( iLine : Integer ) : String;
      Function plainLine( iLine : Integer ) : String;
      Function hasJumpPoint( iLine : Integer ) : Boolean;
      Function jumpPoint( iLine : Integer ) : LongInt;
      Procedure load( f : TFileStream );
      Procedure saveSource( sFile : String );

    { Protected member variables }
    Protected
      iType         : Integer;
      iLines        : Integer;
      iSize         : Integer;
      lOffset       : LongInt;
      iParentLine   : Integer;
      lParent       : LongInt;
      lPrevious     : LongInt;
      iParentMenu   : Integer;
      iParentPrompt : Integer;
      lNext         : LongInt;
      bHasSeeAlso   : Boolean;
      slLines       : TStringList;
      oSeeAlso      : TNGSeeAlso;

    { Protected methods }
      Procedure loadShort( f : TFileStream );
      Procedure loadLong( f : TFileStream );
      Procedure loadText( f : TFileStream; bPreLoaded : Boolean );
      Function  stripControls( sRaw : String ) : String;

  End;

implementation

Type
  TNGEntryLineContainer = Class
    { Public member variables }
      lOffset : LongInt;
  End;

Constructor TNGEntry.Create;
Begin
  bOemToAnsi := False;
  slLines    := TStringList.Create;
  oSeeAlso   := TNGSeeAlso.Create;
End;

Destructor TNGEntry.Destroy;
Begin
  DestroyStringListObjects( slLines );
  slLines.Free;
  oSeeAlso.Free;
  Inherited;
End;

Function TNGEntry.lines : Integer;
Begin
  Result := iLines;
End;

Function TNGEntry.isShort : Boolean;
Begin
  Result := ( iType = NG_ENTRY_SHORT );
End;

Function TNGEntry.isLong : Boolean;
Begin
  Result := ( iType = NG_ENTRY_LONG );
End;

Function TNGEntry.offset : LongInt;
Begin
  Result := lOffset;
End;

Function TNGEntry.parentLine : Integer;
Begin
  Result := iParentLine;
End;

Function TNGEntry.parent : LongInt;
Begin
  Result := lParent;
End;

Function TNGEntry.previous : LongInt;
Begin
  Result := lPrevious;
End;

Function TNGEntry.next : LongInt;
Begin
  Result := lNext;
End;

Function TNGEntry.parentMenu : Integer;
Begin
  Result := iParentMenu;
End;

Function TNGEntry.parentPrompt : Integer;
Begin
  Result := iParentPrompt;
End;

Function TNGEntry.hasSeeAlso : Boolean;
Begin
  Result := bHasSeeAlso And isLong;
End;

Function TNGEntry.seeAlsos : Integer;
Begin
  Result := oSeeAlso.prompts;
End;

Function TNGEntry.seeAlso( iSeeAlso : Integer ) : String;
Begin
  Result := oSeeAlso.prompt( iSeeAlso );
End;

Function TNGEntry.seeAlsoOffset( iSeeAlso : Integer ) : LongInt;
Begin
  Result := oSeeAlso.offset( iSeeAlso );
End;

Function TNGEntry.line( iLine : Integer ) : String;
Begin
  Result := slLines[ iLine ];
End;

Function TNGEntry.plainLine( iLine : Integer ) : String;
Begin
  Result := stripControls( slLines[ iLine ] );
End;

Function TNGEntry.jumpPoint( iLine : Integer ) : LongInt;
Begin
  Result := ( slLines.Objects[ iLine ] As TNGEntryLineContainer ).lOffset;
End;

Function TNGEntry.hasJumpPoint( iLine : Integer ) : Boolean;
Begin
  Result := isShort And ( iLine >= 0 ) And ( iLine < iLines ) And ( ( slLines.Objects[ iLine ] As TNGEntryLineContainer ).lOffset <> -1 );
End;

Function TNGEntry.hasPrevious : Boolean;
Begin
  Result := IsLong And ( lPrevious <> 0 );
End;

Function TNGEntry.hasUp : Boolean;
Begin
  Result := ( lParent <> 0 );
End;

Function TNGEntry.hasNext : Boolean;
Begin
  Result := lNext <> 0;
End;


Procedure TNGEntry.load( f : TFileStream );
Begin

  oSeeAlso.Free;

  oSeeAlso      := TNGSeeAlso.Create;
  lOffset       := f.Seek( 0, soFromCurrent );
  iType         := ngReadWord( f, True );
  iSize         := ngReadWord( f, True );
  iLines        := ngReadWord( f, True );
  bHasSeeAlso   := ( ngReadWord( f, True ) > 0 );
  iParentLine   := ngReadWord( f, True );
  lParent       := ngReadLong( f, True );
  iParentMenu   := ngReadWord( f, True );
  iParentPrompt := ngReadWord( f, True );
  lPrevious     := ngReadLong( f, True );
  lNext         := ngReadLong( f, True );

  { Do a bit of tidying up }
  If lPrevious     = -1    Then lPrevious     := 0;
  If lNext         = -1    Then lNext         := 0;
  If lParent       = -1    Then lParent       := 0;
  If iParentMenu   = $FFFF Then iParentMenu   := -1;
  If iParentPrompt = $FFFF Then iParentPrompt := -1;

  If isShort Then
    loadShort( f )
  Else
    loadLong( f );

End;

Procedure TNGEntry.loadShort( f : TFileStream );
Var
  iLine   : Integer;
  oOffset : TNGEntryLineContainer;
Begin

  For iLine := 1 To iLines Do
  Begin
    ngReadWord( f, False ); // Skip unknown word.
    oOffset         := TNGEntryLineContainer.Create;
    oOffset.lOffset := ngReadLong( f, True );
    slLines.AddObject( '', oOffset );
  End;

  loadText( f, True );

End;

Procedure TNGEntry.loadLong( f : TFileStream );
Begin

  loadText( f, False );

  If bHasSeeAlso Then
  Begin
    oSeeAlso.load( f );
  End;  

End;

Procedure TNGEntry.loadText( f : TFileStream; bPreLoaded : Boolean );
Var
  iLine : Integer;
Begin

  For iLine := 1 To iLines Do
    If bPreLoaded Then
      If bOemToAnsi Then
        slLines[ iLine - 1 ] := DosToWinStr( ngExpandText( ngReadStrZ( f, 512, True ) ) )
      Else
        slLines[ iLine - 1 ] := ngExpandText( ngReadStrZ( f, 512, True ) )
    Else
      If bOemToAnsi Then
        slLines.Add( DosToWinStr( ngExpandText( ngReadStrZ( f, 512, True ) ) ) )
      Else
        slLines.Add( ngExpandText( ngReadStrZ( f, 512, True ) ) );

End;

Procedure TNGEntry.saveSource( sFile : String );
Begin
  slLines.SaveToFile( sFile );
End;

Function TNGEntry.text : String;
Var
  i      : Integer;
  iLines : Integer;
Begin

  Result := '';
  iLines := slLines.Count;

  For i := 0 To iLines - 1 Do
  Begin
    Result := Result + stripControls( slLines[ i ] ) + #13#10;
  End;

End;

Function TNGEntry.source : String;
Begin
  Result := slLines.Text;
End;

Function TNGEntry.stripControls( sRaw : String ) : String;
Var
  iCtrl : Integer;
Begin

  Result := '';

  { Find the first control sequence }
  iCtrl := Pos( '^', sRaw );

  While iCtrl <> 0 Do
  Begin

    { Copy text up to the next control sequence }
    Result := Result + Copy( sRaw, 1, iCtrl - 1 );
    
    Case sRaw[ iCtrl + 1 ] Of

      'A', 'a' : iCtrl := iCtrl + 4;
      'B', 'b' : iCtrl := iCtrl + 2;
      'C', 'c' :
      Begin
        If bOemToAnsi Then
          Result := Result + DosToWinStr( Hex2Char( Copy( sRaw, iCtrl + 2, 2 ) ) )
        Else
          Result := Result + Hex2Char( Copy( sRaw, iCtrl + 2, 2 ) );
        iCtrl  := iCtrl  + 4;
      End;
      'N', 'n' : iCtrl := iCtrl + 2;
      'R', 'r' : iCtrl := iCtrl + 2;
      'U', 'u' : iCtrl := iCtrl + 2;
      '^' :
      Begin
        Result := Result + '^';
				iCtrl := iCtrl + 2;
      End;

      Else
        Inc( iCtrl );

    End;

    sRaw  := Copy( sRaw, iCtrl, Length( sRaw ) );
    iCtrl := Pos( '^', sRaw );

  End;

  { Copy remaining text }
  Result := Result + sRaw;

End;

end.
