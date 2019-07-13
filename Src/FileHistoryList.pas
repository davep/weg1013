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

unit FileHistoryList;

interface

Uses Classes;

Type
  TFileHistoryList = Class
    Public
    { Public member variables }
      iMaxFiles : Integer;

    { Public Methods }
      Constructor Create;
      Destructor  Destroy; Override;
      Procedure   add( sFile : String; sTitle : String );
      Procedure   setHistory( sHistory : String; sTitles : String );
      Function    names : String;
      Function    titles : String;
      Function    count : Integer;
      Function    fileName( iFile : Integer ) : String;
      Function    fileTitle( iFile : Integer ) : String;

    { Protected member variables }
    Protected
      slFiles  : TStringList;
      slTitles : TStringList;

  End;

implementation

Constructor TFileHistoryList.Create;
Begin
  slFiles   := TStringList.Create;
  slTitles  := TStringList.Create;
  iMaxFiles := 10;
End;

Destructor TFileHistoryList.Destroy;
Begin
  slFiles.Free;
  slTitles.Free;
  Inherited;
End;

Procedure TFileHistoryList.add( sFile : String; sTitle : String );
Var
  iIndex : Integer;
Begin

  { Is the file in the list? }
  iIndex := slFiles.IndexOf( sFile );

  If iIndex > -1 Then
  Begin
    { File is already in the list, promote it }
    slFiles.Delete( iIndex );
    slFiles.Insert( 0, sFile );
    slTitles.Delete( iIndex );
    slTitles.Insert( 0, sTitle );
  End
  Else
  Begin { The file isn't in the list, add it }
    { Is the list at the max size? }
    If slFiles.Count = iMaxFiles Then
    Begin
      { Yup, delete the last entry }
      slFiles.Delete( slFiles.Count - 1 );
      slTitles.Delete( slTitles.Count - 1 );
    End;
    { Now put the new file at the top of the list }
    slFiles.Insert( 0, sFile );
    slTitles.Insert( 0, sTitle );
  End;

End;

Procedure TFileHistoryList.setHistory( sHistory : String; sTitles : String );
Begin
  slFiles.Clear;
  slTitles.Clear;
  slFiles.Text  := sHistory;
  slTitles.Text := sTitles;
End;

Function TFileHistoryList.names : String;
Begin
  Result := slFiles.Text;
End;

Function TFileHistoryList.titles : String;
Begin
  Result := slTitles.Text;
End;

Function TFileHistoryList.count : Integer;
Begin
  Result := slFiles.Count;
End;

Function TFileHistoryList.fileName( iFile : Integer ) : String;
Begin
  Result := slFiles[ iFile ];
End;

Function TFileHistoryList.fileTitle( iFile : Integer ) : String;
Begin
  Result := slTitles[ iFile ];
End;

end.
