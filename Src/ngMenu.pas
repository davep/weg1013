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

unit ngMenu;

interface

Uses Classes;

Type
  TNGMenu = Class
    Public
    { Public Methods }
      Constructor Create; Virtual;
      Destructor  Destroy; Override;
      Function    prompt( iPrompt : Integer ) : String;
      Function    offset( iPrompt : Integer ) : LongInt;
      Function    prompts                     : Integer;
      Function    title                       : String;
      Procedure   load( f : TFileStream );
      Procedure   addPrompt( sPrompt : String; lOffset : LongInt );

    { Protected member variables }
    Protected
      iPrompts  : Integer;
      sTitle    : String;
      slPrompts : TStringList;

  End;

implementation

Uses SysUtils, ngMenuItem, ngUtils;

Constructor TNGMenu.Create;
Begin
  slPrompts := TStringList.Create;
End;

Destructor TNGMenu.Destroy;
Begin
  DestroyStringListObjects( slPrompts );
  slPrompts.Free;
  Inherited;
End;

Function TNGMenu.prompt( iPrompt : Integer ) : String;
Begin
  Result := DosToWinStr( Trim( slPrompts[ iPrompt ] ) );
End;

Function TNGMenu.offset( iPrompt : Integer ) : LongInt;
Begin
  With ( slPrompts.Objects[ iPrompt ] As TNgMenuItem ) Do
  Begin
    Result := lOffset;
  End;
End;

Function TNGMenu.prompts : Integer;
Begin
  Result := iPrompts - 1;
End;

Function TNGMenu.title : String;
Begin
  Result := DosToWinStr( Trim( sTitle ) );
End;

Procedure TNGMenu.load( f : TFileStream );
Var
  iPrompt : Integer;
Begin

  ngReadWord( f, False );

  iPrompts := ngReadWord( f, True );

  f.Seek( 20, soFromCurrent );

  For iPrompt := 1 To ( iPrompts - 1 ) Do
  Begin
    slPrompts.AddObject( '', TNGMenuItem.Create( '', ngReadLong( f, True ) ) );
  End;

  f.Seek( iPrompts * 8, soFromCurrent );

  sTitle := ngExpandText( ngReadStrZ( f, 50, True ) );

  For iPrompt := 1 To iPrompts - 1 Do
  Begin
    With ( slPrompts.Objects[ ( iPrompt - 1 ) ] As TNGMenuItem ) Do
    Begin
      sPrompt := ngExpandText( ngReadStrZ( f, 50, True ) );
      slPrompts[ ( iPrompt - 1 ) ] := sPrompt;
    End;
  End;

  ngReadByte( f, False );

End;

Procedure TNGMenu.addPrompt( sPrompt : String; lOffset : LongInt );
Begin
  slPrompts.AddObject( sPrompt, TNGMenuItem.Create( sPrompt, lOffset ) );
End;

end.
