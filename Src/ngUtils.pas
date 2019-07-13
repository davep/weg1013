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

unit ngUtils;

interface

Uses Forms, Classes;

Const
  NG_MAGIC_NG     = $474E;
  NG_MAGIC_EH     = $4845;
  NG_ENTRY_SHORT  = 0;
  NG_ENTRY_LONG   = 1;
  NG_ENTRY_MENU   = 2;

Function  ngDecrypt( b : Byte )                             : Byte;
Function  ngReadByte( f : TFileStream; bDecrypt : Boolean ) : Byte;
Function  ngReadWord( f : TFileStream; bDecrypt : Boolean ) : Word;
Function  ngReadLong( f : TFileStream; bDecrypt : Boolean ) : LongInt;
Function  ngReadStr(  f : TFileStream; iLength : Integer )  : String;
Function  ngReadStrZ( f : TFileStream; iLength : Integer; bDecrypt : Boolean ) : String;
Function  ngExpandText( s : String ) : String;
Procedure DestroyStringListObjects( sl : TStrings );
Function  Hex2Int( s : String ) : Integer;
Function  Hex2Char( s : String ) : Char;
Procedure FireURL( App : TApplication; sURL : String );
Function  SelectFolder( sCaption: String ): String;
Function  DosToWinStr( s : String ) : String;

implementation

Uses SysUtils, ShellAPI, Windows, Dialogs, ShlObj, ActiveX;

Function ngDecrypt( b : Byte ) : Byte;
Begin
  Result := ( b XOr $1A );
End;

Function ngReadByte( f : TFileStream; bDecrypt : Boolean ) : Byte;
Var
  c : Byte;
Begin
  f.Read( c, 1 );
  If bDecrypt Then
    Result := ngDecrypt( c )
  Else
    Result := c
End;

Function ngReadWord( f : TFileStream; bDecrypt : Boolean  ) : Word;
Var
  cLow  : Byte;
  cHigh : Byte;
Begin
  cLow   := ngReadByte( f, bDecrypt );
  cHigh  := ngReadByte( f, bDecrypt );
  Result := ( ( cHigh Shl 8 ) + cLow );
End;

Function ngReadLong( f : TFileStream; bDecrypt : Boolean ) : LongInt;
Var
  wLow  : Word;
  wHigh : Word;
Begin
  wLow   := ngReadWord( f, bDecrypt );
  wHigh  := ngReadWord( f, bDecrypt );
  Result := ( ( wHigh Shl 16 ) + wLow );
End;

Function ngExpandText( s : String ) : String;
Var
  iLen    : Integer;
  i       : Integer;
  iRLE    : Integer;
  iExpand : Integer;
  bJump   : Boolean;
Begin

  iLen   := Length( s );
  Result := '';
  bJump  := False;

  For i := 1 To iLen Do
  Begin

    If Ord( s[ i ] ) = $FF Then
    Begin

      bJump := True;
      iRLE  := Ord( s[ i + 1 ] );

      For iExpand := 1 To iRLE Do
      Begin
        Result := Result + ' ';
      End;

    End
    Else If Not bJump Then
    Begin
      Result := Result + s[ i ];
    End
    Else
      bJump := False;

  End;

End;

Function ArrToStrZ( a : Array Of Byte; iMax : Integer ) : String;
Var
  iChar : Integer;
Begin

  Result := '';
  iChar  := 0;

  While ( Ord( a[ iChar ] ) <> 0 ) And ( iChar < iMax ) Do
  Begin
    Result := Result + Char( a[ iChar ] );
    Inc( iChar );
  End;

End;

Function ngReadStr( f : TFileStream; iLength : Integer ) : String;
Var
  aBuff : Array[ 0..512 ] Of Byte;  // Note the limit.
Begin
  f.Read( aBuff, iLength );
  Result := ArrToStrZ( aBuff, iLength );
End;

Function ngReadStrZ( f : TFileStream; iLength : Integer; bDecrypt : Boolean ) : String;
Var
  cByte   : Byte;
  iChar   : Integer;
  lSavOff : LongInt;
  aBuff   : Array[ 0..512 ] Of Byte;  // Note the limit.
Begin

  lSavOff := f.Seek( 0, soFromCurrent );
  Result  := '';
  iChar   := 0;

  f.Read( aBuff, iLength );

  If bDecrypt Then
  Begin
    Repeat
      cByte := ngDecrypt( aBuff[ iChar ] );
      If cByte <> 0 Then
        Result := Result + Chr( ngDecrypt( aBuff[ iChar ] ) );
      Inc( iChar );
    Until ( cByte = 0 ) Or ( iChar = iLength );
  End;

  f.Seek( lSavOff + Length( Result ) + 1, soFromBeginning );
  
End;

Procedure DestroyStringListObjects( sl : TStrings );
Var
  i : Integer;
Begin

  For i := 0 To sl.Count - 1 Do
  Begin
    sl.Objects[ i ].Free;
  End;

End;

{ I'd have thought that Delphi would have one of these but I can't find it }

Function Hex2Int( s : String ) : Integer;
Var
  iLen  : Integer;
  i     : Integer;
  iMult : Integer;
Begin

  iMult  := 1;
  s      := UpperCase( s );
  iLen   := Length( s );
  Result := 0;

  For i := iLen DownTo 1 Do
  Begin

    Case s[ i ] Of
      '0'..'9' : Result := Result + ( ( Ord( s[ i ] ) - Ord( '0' ) ) * iMult );
      'A'..'F' : Result := Result + ( ( Ord( s[ i ] ) - Ord( '7' ) ) * iMult );
    End;

    iMult := iMult * $10;

  End;

End;

Function Hex2Char( s : String ) : Char;
Begin

  Result := Chr( Hex2Int( s ) );

  { Convert a NUL char to a space (for obvious reasons) }
  If Result = #0 Then
    Result := ' ';

End;

Procedure FireUrl( App : TApplication; sURL : String );
Begin
  If ShellExecute( App.MainForm.Handle, nil, PChar( sURL ),
                   PChar( '' ), PChar( '' ), SW_SHOWNORMAL ) <= 32 Then
    MessageDlg( 'Unable to invoke web browser', mtError, [ mbOk ], 0 );
End;

Function SelectFolder( sCaption : String ) : String;
Var
  tbiBrowseInfo : TBrowseInfo;
  acBuff        : Array[ 0..MAX_PATH ] Of Char;
  idlList       : PItemIDList;
Begin

  With tbiBrowseInfo Do
  Begin
    hwndOwner      := Application.Handle;
    pidlRoot       := Nil;
    pszDisplayName := @acBuff;
    lpszTitle      := PChar( sCaption );
    ulFlags        := BIF_RETURNONLYFSDIRS;
    lpfn           := Nil;
  End;

  idlList := SHBrowseForFolder( tbiBrowseInfo );

  If ( idlList <> Nil ) And SHGetPathFromIDList( idlList, acBuff ) Then
  Begin
    Result := acBuff;
    CoTaskMemFree( idlList );
  End
  Else
    Result := '';

End;

Function DosToWinStr( s : String ) : String;
Var
  acResult : Array[ 0..512 ] Of Char; { Note the limit }
Begin
  OemToChar( PChar( s ), acResult );
  Result := String( acResult );
End;

end.
