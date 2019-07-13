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

unit ngGuide;

interface

Uses Classes, ngMenu, ngEntry;

Type
  TNortonGuide = Class
    Public
    { Public member variables }
      bOemToAnsi : Boolean;
      
    { Public interface }
      Constructor Create;
      Destructor  Destroy; Override;
      Function    open( sFile : String ) : Boolean;
      Procedure   close;
      Function    isValid : Boolean;
      Function    isOpen : Boolean;
      Function    fileName : String;
      Function    title : String;
      Function    credits : String;
      Function    menus : Integer;
      Function    menuTitle( iMenu : Integer ) : String;
      Function    menu( iMenu : Integer ) : TNGMenu;
      Function    loadEntry( lOffset : LongInt ) : TNGEntry;
      Function    loadMenuEntry( iMenu, iPrompt : Integer ) : TNGEntry;
      Function    loadCurrentEntry : TNGEntry;
      Function    hasMenus : Boolean;
      Function    isEntryPointer( lOffset : LongInt ) : Boolean;
      Function    guideType : String;
      Procedure   goTop;
      Procedure   skip;
      Function    eof : Boolean;
      Function    entryID : Integer;
      Function    lookingAtLongEntry : Boolean;
      Function    lookingAtShortEntry : Boolean;
      Function    byteSize : LongInt;
      Function    bytePos  : LongInt;

    { Protected instance variables }
    Protected
      iMenuCount  : Integer;
      sTitle      : String;
      sFile       : String;
      asCredits   : Array[ 0..4 ] Of String;
      fsNG        : TFileStream;
      bOpen       : Boolean;
      iMagic      : Integer;
      slMenus     : TStringList;
      bHasMenus   : Boolean;
      lFirstEntry : LongInt;

    { Protected methods }
      Procedure readHeader;
      Procedure loadMenus;
      Procedure skipEntry;
      Function  defaultMenu : LongInt;

  End;

implementation

Uses SysUtils, ngUtils;

Constructor TNortonGuide.Create;
Begin
  bOemToAnsi := False;
  slMenus    := TStringList.Create;
End;

Destructor TNortonGuide.Destroy;
Begin
  DestroyStringListObjects( slMenus );
  slMenus.Free;
  fsNG.Free;
  Inherited;
End;

Function TNortonGuide.open( sFile : String ) : Boolean;
Begin

  Close; // Just in case.

  Try
    fsNG   := TFileStream.Create( sFile, fmOpenRead Or fmShareDenyNone );
    Result := True;
  Except
    fsNG.Free; { Do I need to do this? }
    Result := False;
  End;

  bOpen := Result;

  If bOpen Then
  Begin
    readHeader;
    If isValid Then
      self.sFile := sFile; 
      If iMenuCount > 0 Then
      Begin
        loadMenus;
        lFirstEntry := fsNG.Seek( 0, soFromCurrent );
      End
      Else
        lFirstEntry := defaultMenu;  
  End;

End;

Procedure TNortonGuide.close;
Begin
  If isOpen Then
  Begin
    fsNG.Free;
    fsNG       := Nil;
    sTitle     := '';
    iMenuCount := 0;
    iMagic     := 0;
    DestroyStringListObjects( slMenus );
    slMenus.Clear;
  End;
End;

Function TNortonGuide.isValid : Boolean;
Begin
  Result := ( iMagic = NG_MAGIC_NG ) Or ( iMagic = NG_MAGIC_EH );
End;

Function TNortonGuide.isOpen : Boolean;
Begin
  Result := bOpen;
End;

Function TNortonGuide.fileName : String;
Begin
  Result := sFile;
End;

Function TNortonGuide.title : String;
Begin
  Result := DosToWinStr( sTitle );
End;

Function TNortonGuide.credits : String;
Var
  i : Integer;
Begin

  Result := '';
  
  For i := 0 To 4 Do
    If bOemToAnsi Then
      Result := Result + DosToWinStr( asCredits[ i ] ) + #13#10
    Else
      Result := Result + asCredits[ i ] + #13#10;

End;

Function TNortonGuide.menus : Integer;
Begin
  Result := iMenuCount;
End;

Function TNortonGuide.menuTitle( iMenu : Integer ) : String;
Begin
  Result := slMenus[ iMenu ];
End;

Function TNortonGuide.menu( iMenu : Integer ) : TNGMenu;
Begin
  Result := ( slMenus.Objects[ iMenu ] As TNGMenu );
End;

Function TNortonGuide.hasMenus : Boolean;
Begin
  Result := bHasMenus;
End;

Procedure TNortonGuide.readHeader;
Var
  iCredit : Integer;
Begin

  iMagic := ngReadWord( fsNG, False );

  ngReadWord( fsNG, False );    // Skip unknown word.
  ngReadWord( fsNG, False );    // Skip unknown word.

  iMenuCount := ngReadWord( fsNG, False );
  sTitle     := ngReadStr( fsNG, 40 );

  For iCredit := 0 To 4 Do
  Begin
    asCredits[ iCredit ] := ngReadStr( fsNG, 66 );
  End;

End;

Procedure TNortonGuide.skipEntry;
Begin
  fsNG.Seek( 22 + ngReadWord( fsNG, True ), soFromCurrent );
End;

Procedure TNortonGuide.loadMenus;
Var
  iID   : Integer;
  iMenu : Integer;
  oMenu : TNGMenu;
Begin

  iMenu := 0;

  Repeat

    iID := ngReadWord( fsNG, True );

    Case iID Of
      NG_ENTRY_SHORT : skipEntry;
      NG_ENTRY_LONG  : skipEntry;
      NG_ENTRY_MENU  :
      Begin
        oMenu := TNGMenu.Create;
        oMenu.load( fsNG );
        slMenus.AddObject( '', oMenu );
        slMenus[ iMenu ] := oMenu.title;
        Inc( iMenu );
      End;
      Else
        iID := 5;
    End;

  Until ( iID = 5 ) Or ( iMenu = iMenuCount );

  bHasMenus := True;
  
End;

Function TNortonGuide.defaultMenu : LongInt;
Var
  oMenu  : TNGMenu;
  lFirst : LongInt;
  iID    : Integer;
Begin

  lFirst := 0; { Keep the compiler quiet }

  Repeat

    iID := ngReadWord( fsNG, True );

    Case iID Of
      NG_ENTRY_SHORT : lFirst := fsNG.Seek( 0, soFromCurrent ) - 2;
      NG_ENTRY_LONG  : lFirst := fsNG.Seek( 0, soFromCurrent ) - 2;
      NG_ENTRY_MENU  : skipEntry;
      Else
        iID := 5;
    End;

  Until iID In [ NG_ENTRY_SHORT, NG_ENTRY_LONG, 5 ];

  If iID <> 5 Then
  Begin
    iMenuCount := 1;
    oMenu      := TNGMenu.Create;
    oMenu.addPrompt( 'Root', lFirst );
    slMenus.AddObject( 'Root', oMenu );
    bHasMenus := False;
  End;

  Result := lFirst;
  
End;

Function TNortonGuide.loadEntry( lOffset : LongInt ) : TNGEntry;
Begin

  Result            := TNGEntry.Create;
  Result.bOemToAnsi := bOemToAnsi;

  fsNG.Seek( lOffset, soFromBeginning );
  Result.load( fsNG );
  
End;

Function TNortonGuide.loadMenuEntry( iMenu, iPrompt : Integer ) : TNGEntry;
Begin

  Result            := TNGEntry.Create;
  Result.bOemToAnsi := bOemToAnsi;

  fsNG.Seek( menu( iMenu ).offset( iPrompt ), soFromBeginning );
  Result.load( fsNG );
  
End;

Function TNortonGuide.loadCurrentEntry : TNGEntry;
Begin

  { Create and load the entry }
  Result            := TNGEntry.Create;
  Result.bOemToAnsi := bOemToAnsi;
  
  Result.load( fsNg );

  { Now skip past it to the next one }
  fsNg.Seek( Result.offset, soFromBeginning );
  ngReadWord( fsNg, False );
  skipEntry;
  
End;

Function TNortonGuide.isEntryPointer( lOffset : LongInt ) : Boolean;
Var
  lSavPos : LongInt;
  iID     : Integer;
Begin

  Result := False;

  If lOffset <> -1 Then { -1 appears to be a special case }
  Begin

    lSavPos := fsNG.Seek( 0, soFromCurrent );

    fsNG.Seek( lOffset, soFromBeginning );
    iID := ngReadWord( fsNG, True );
    fsNG.Seek( lSavPos, soFromBeginning );

    Result := iID In [ NG_ENTRY_SHORT, NG_ENTRY_LONG ];
    
  End;

End;

Function TNortonGuide.guideType : String;
Begin

  If iMagic = NG_MAGIC_NG Then
    Result := 'NG'
  Else
    Result := 'EH';

End;

Procedure TNortonGuide.goTop;
Begin
  fsNg.Seek( lFirstEntry, soFromBeginning );
End;

Function TNortonGuide.eof : Boolean;
Var
  lCurrPos : LongInt;
  lLastPos : LongInt;
  iID      : Integer;
Begin

  { Find the size of the file }
  lCurrPos := fsNg.Seek( 0, soFromCurrent );
  lLastPos := fsNg.Seek( 0, soFromEnd );

  { Restore the position }
  fsNg.Seek( lCurrPos, soFromBeginning );

  If lCurrPos >= lLastPos Then
    Result := True
  Else
  Begin

    { Now check that we are looking at a guide entry, if not, assume eof }
    iID    := ngReadWord( fsNg, True );
    Result := Not ( iID In [ NG_ENTRY_SHORT, NG_ENTRY_LONG ] );

    { Restore the position }
    fsNg.Seek( lCurrPos, soFromBeginning );

  End;

End;

Procedure TNortonGuide.skip;
Begin
  ngReadWord( fsNg, False );
  skipEntry;
End;

Function TNortonGuide.entryID : Integer;
Var
  lSavOff : LongInt;
Begin

  lSavOff := fsNg.Seek( 0, soFromCurrent );
  Result  := ngReadWord( fsNg, True );
  fsNg.Seek( lSavOff, soFromBeginning );
  
End;

Function TNortonGuide.lookingAtShortEntry : Boolean;
Begin
  Result := entryID = NG_ENTRY_SHORT;
End;

Function TNortonGuide.lookingAtLongEntry : Boolean;
Begin
  Result := entryID = NG_ENTRY_LONG;
End;

Function TNortonGuide.byteSize : LongInt;
Var
  lSavOff : LongInt;
Begin

  lSavOff := fsNg.Seek( 0, soFromCurrent );
  Result  := fsNg.Seek( 0, soFromEnd );
  fsNg.Seek( lSavOff, soFromBeginning );

End;

Function TNortonGuide.bytePos : LongInt;
Begin
  Result := fsNg.Seek( 0, soFromCurrent );
End;

end.
