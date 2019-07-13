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

unit frmBookmarksUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmBookmarks = class(TForm)
    pnlButtons: TPanel;
    pbAdd: TButton;
    pbRemove: TButton;
    pbGoto: TButton;
    pbClose: TButton;
    lvBookmarks: TListView;
    procedure pbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbAddClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbGotoClick(Sender: TObject);
    procedure pbRemoveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvBookmarksChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvBookmarksKeyPress(Sender: TObject; var Key: Char);
  private
    slGuides  : TStringList;
    slOffsets : TStringList;
    bLoaded   : Boolean;
    Procedure refreshForm;
    Procedure loadGuideDirectory;
    Procedure saveGuideDirectory;
  public
    { Public declarations }
  end;

var
  frmBookmarks: TfrmBookmarks;

implementation

Uses Registry, egConstants, frmAddBookmarkUnit, WegMainUnit, ngUtils;

Type
  TNGBookmark = Class
    Public
    { Public instance variables }
      sGuide : String;
      lEntry : LongInt;

    { Public methods }
      Constructor Create( sGuide : String; lEntry : LongInt );
      
  End;
  
{$R *.DFM}

Constructor TNGBookmark.Create( sGuide : String; lEntry : LongInt );
Begin
  self.sGuide := sGuide;
  self.lEntry := lEntry;
End;

procedure TfrmBookmarks.pbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBookmarks.FormShow(Sender: TObject);
Var
  regEntry : TRegistry;
begin

  { Restore the saved UI information }

  regEntry := TRegistry.Create;

  If regEntry.OpenKey( APP_REG_KEY, False ) Then
  Begin

    With regEntry Do
    Begin

      Try
        Top    := ReadInteger( REG_BOOKMARKS_TOP );
        Left   := ReadInteger( REG_BOOKMARKS_LEFT );
        Width  := ReadInteger( REG_BOOKMARKS_WIDTH );
        Height := ReadInteger( REG_BOOKMARKS_HEIGHT );
      Except
        { Do nothing }
      End;

      CloseKey;

    End;

  End;

  regEntry.Free;

  If Not bLoaded Then
    loadGuideDirectory;
  
  refreshForm;

end;

procedure TfrmBookmarks.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  regEntry : TRegistry;
begin

  regEntry := TRegistry.Create;
  
  { Remember the form details }
  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, True ) Then
    Begin

      If WindowState <> wsMaximized Then
      Begin
        WriteInteger( REG_BOOKMARKS_TOP,    Top );
        WriteInteger( REG_BOOKMARKS_LEFT,   Left );
        WriteInteger( REG_BOOKMARKS_WIDTH,  Width );
        WriteInteger( REG_BOOKMARKS_HEIGHT, Height );
      End;

      CloseKey;
      
    End;
    
  End;
  
  regEntry.Free;

end;

procedure TfrmBookmarks.pbAddClick(Sender: TObject);
Var
  frmAddBookmark : TfrmAddBookmark;
  tliBookmark    : TListItem;
begin

  frmAddBookmark := TfrmAddBookmark.Create( self );
  
  If frmAddBookmark.ShowModal = mrOk Then
  Begin

    tliBookmark         := lvBookmarks.Items.Add;
    tliBookmark.Caption := frmAddBookmark.edtTitle.Text;
    tliBookmark.Data    := TNGBookmark.Create( frmWegMain.ng.fileName, frmWegMain.oEntry.offset );

    saveGuideDirectory;
    refreshForm;

  End;

  frmAddBookmark.Free;

end;

Procedure TfrmBookmarks.refreshForm;
Begin

  pbAdd.Enabled       := frmWegMain.oEntry <> Nil;
  pbGoto.Enabled      := lvBookmarks.ItemFocused <> Nil;
  pbRemove.Enabled    := lvBookmarks.ItemFocused <> Nil;
  lvBookmarks.Enabled := lvBookmarks.Items.Count > 0;

End;

procedure TfrmBookmarks.FormActivate(Sender: TObject);
begin
  refreshForm;
end;

procedure TfrmBookmarks.FormDestroy(Sender: TObject);
Var
  iItem : Integer;
begin

  { Free up the bookmark data }
  For iItem := 0 To lvBookmarks.Items.Count - 1 Do
  Begin
    TNGBookmark( lvBookmarks.Items[ iItem ] ).Free;
  End;
  
end;

procedure TfrmBookmarks.pbGotoClick(Sender: TObject);
Var
  liBookmark : TListItem;
  oBookmark  : TNGBookmark;
begin

  liBookmark := lvBookmarks.ItemFocused;

  If liBookmark <> Nil Then
  Begin
    oBookmark := liBookmark.Data;
    frmWegMain.jumpToGuideEntryLine( oBookmark.sGuide, oBookmark.lEntry, 0 );
    frmWegMain.lbText.SetFocus;
  End;

end;

procedure TfrmBookmarks.pbRemoveClick(Sender: TObject);
Var
  liBookmark : TListItem;
  oBookmark  : TNGBookmark;
begin

  liBookmark := lvBookmarks.ItemFocused;

  If liBookmark <> Nil Then
  Begin

    oBookmark := liBookmark.Data;
    
    MessageBeep( MB_ICONQUESTION );
    If MessageDlg( 'Remove ''' + liBookmark.Caption +
                   '''?', mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes Then
    Begin

      oBookmark.Free;
      liBookmark.Delete;

      saveGuideDirectory;
      refreshForm;

    End;

  End;
  
end;

procedure TfrmBookmarks.FormCreate(Sender: TObject);
begin
  slGuides  := TStringList.Create;
  slOffsets := TStringList.Create;
end;

procedure TfrmBookmarks.FormResize(Sender: TObject);
begin
  lvBookmarks.Columns[ 0 ].Width := lvBookmarks.Width - 4;
end;

procedure TfrmBookmarks.lvBookmarksChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  refreshForm;
end;

Procedure TfrmBookmarks.loadGuideDirectory;
Var
  regEntry  : TRegistry;
  slNames   : TStringList;
  slGuides  : TStringList;
  slOffsets : TStringList;
  liItem    : TListItem;
  i         : Integer;
Begin

  regEntry  := TRegistry.Create;
  slNames   := TStringList.Create;
  slGuides  := TStringList.Create;
  slOffsets := TStringList.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, False ) Then
    Begin
      Try
        slNames.Text   := ReadString( REG_BOOKMARKS_MARKS );
        slGuides.Text  := ReadString( REG_BOOKMARKS_GUIDES );
        slOffsets.Text := ReadString( REG_BOOKMARKS_OFFSETS );
      Except
        slNames.Text   := '';
        slGuides.Text  := '';
        slOffsets.Text := '';
      End;  
      CloseKey;
    End;

  End;

  regEntry.Free;

  lvBookmarks.Items.Clear;
  
  For i := 0 To slNames.Count - 1 Do
  Begin
    liItem         := lvBookmarks.Items.Add;
    liItem.Caption := slNames[ i ];
    liItem.Data    := TNGBookmark.Create( slGuides[ i ], StrToInt( slOffsets[ i ] ) );
  End;

  slNames.Free;
  slGuides.Free;
  slOffsets.Free;

  bLoaded := True;
    
End;

Procedure TfrmBookmarks.saveGuideDirectory;
Var
  regEntry  : TRegistry;
  slNames   : TStringList;
  slGuides  : TStringList;
  slOffsets : TStringList;
  i         : Integer;
Begin

  slNames   := TStringList.Create;
  slGuides  := TStringList.Create;
  slOffsets := TStringList.Create;
  
  For i := 0 To lvBookmarks.Items.Count - 1 Do
  Begin
    slNames.Add( lvBookmarks.Items[ i ].Caption );
    With TNGBookmark( lvBookmarks.Items[ i ].Data ) Do
    Begin
      slGuides.Add( sGuide );
      slOffsets.Add( IntToStr( lEntry ) );
    End;
  End;

  regEntry := TRegistry.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, True ) Then
    Begin
      WriteString( REG_BOOKMARKS_MARKS,   slNames.Text );
      WriteString( REG_BOOKMARKS_GUIDES,  slGuides.Text );
      WriteString( REG_BOOKMARKS_OFFSETS, slOffsets.Text );
      CloseKey;
    End;

  End;

  regEntry.Free;
  slNames.Free;
  slGuides.Free;
  slOffsets.Free;

End;

procedure TfrmBookmarks.lvBookmarksKeyPress(Sender: TObject; var Key: Char);
begin

  If Key = #13 Then
    pbGotoClick( Nil );
    
end;

end.
