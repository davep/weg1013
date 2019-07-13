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

unit ngSeeAlso;

interface

Uses Classes, ngMenu;

Type
  TNGSeeAlso = Class( TNGMenu )
    { Public methods }
      Constructor Create; Override;
      Procedure   load( f : TFileStream );
      Function    prompts : Integer;
  End;

implementation

Uses ngMenuItem, ngUtils;

Constructor TNGSeeAlso.Create;
Begin
  sTitle := 'See Also';
  Inherited;
End;

Function TNGSeeAlso.prompts : Integer;
Begin
  Result := iPrompts;
End;

Procedure TNGSeeAlso.load( f : TFileStream );
Var
  iPrompt : Integer;
Begin

  iPrompts := ngReadWord( f, True );

  For iPrompt := 0 To ( iPrompts - 1 ) Do
  Begin
    slPrompts.AddObject( '', TNGMenuItem.Create( '', ngReadLong( f, True ) ) );
  End;

  For iPrompt := 0 To iPrompts - 1 Do
  Begin
    With ( slPrompts.Objects[ iPrompt ] As TNGMenuItem ) Do
    Begin
      sPrompt := ngExpandText( ngReadStrZ( f, 51, True ) );
      slPrompts[ iPrompt ] := sPrompt;
    End;
  End;
  
End;

end.
