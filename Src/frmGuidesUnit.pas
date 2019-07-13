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

unit frmGuidesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ShellAPI;

type
  TfrmGuides = class(TForm)
    pnlButtons: TPanel;
    pbOpen: TButton;
    pbAdd: TButton;
    pbRemove: TButton;
    lvGuides: TListView;
    pbClose: TButton;
    dlgFileOpen: TOpenDialog;
    pbClear: TButton;
    procedure pbCloseClick(Sender: TObject);
    procedure pbAddClick(Sender: TObject);
    procedure pbRemoveClick(Sender: TObject);
    procedure lvGuidesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure pbOpenClick(Sender: TObject);
    procedure lvGuidesDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbClearClick(Sender: TObject);
    procedure lvGuidesKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    bLoaded : Boolean;
    Procedure refreshButtons;
    Procedure loadGuideDirectory;
    Procedure saveGuideDirectory;
  public
    Function  guideNames : TStringList;
    Procedure addGuide( sGuide : String );
    Procedure acceptFiles( var msg : TMessage ); Message WM_DROPFILES;
  end;

var
  frmGuides: TfrmGuides;

implementation

Uses egConstants, ngGuide, Registry, WegMainUnit;

{$R *.DFM}

Procedure TfrmGuides.refreshButtons;
Begin
  pbOpen.Enabled   := lvGuides.ItemFocused <> Nil;
  pbRemove.Enabled := lvGuides.ItemFocused <> Nil;
  pbClear.Enabled  := lvGuides.Items.Count <> 0;
End;

procedure TfrmGuides.pbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGuides.pbAddClick(Sender: TObject);
Var
  regEntry : TRegistry;
  iFiles   : Integer;
  iFile    : Integer;
  iSavCsr  : Integer;
begin

  regEntry := TRegistry.Create;

  With regEntry Do
  Begin
    If OpenKey( APP_REG_KEY, False ) Then
    Begin
      Try
        dlgFileOpen.InitialDir := ReadString( REG_PREFS_DEF_DIR );
      Except
        dlgFileOpen.InitialDir := '';
      End;
      CloseKey;
    End;
  End;

  regEntry.Free;
  
  If dlgFileOpen.Execute Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try

      iFiles := dlgFileOpen.Files.Count - 1;

      lvGuides.Items.BeginUpdate;

      { For all selected files }
      For iFile := 0 To iFiles Do
        addGuide( dlgFileOpen.Files[ iFile ] );

      lvGuides.Items.EndUpdate;
      saveGuideDirectory;

    Finally
      Screen.Cursor := iSavCsr;
    End;
    
  End;

  refreshButtons;
  
end;

procedure TfrmGuides.pbRemoveClick(Sender: TObject);
begin

  If lvGuides.ItemFocused <> Nil Then
  Begin
    MessageBeep( MB_ICONQUESTION );
    If MessageDlg( 'Remove ''' + lvGuides.ItemFocused.Caption +
                   '''?', mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes Then
      lvGuides.ItemFocused.Delete;
  End;
    
end;

procedure TfrmGuides.lvGuidesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  refreshButtons;
end;

procedure TfrmGuides.pbOpenClick(Sender: TObject);
begin
  If frmWegMain.openGuide( lvGuides.ItemFocused.SubItems[ 0 ], True ) Then
    Close;
end;

procedure TfrmGuides.lvGuidesDblClick(Sender: TObject);
begin
  If lvGuides.ItemFocused <> Nil Then
    pbOpenClick( Nil );
end;

Procedure TfrmGuides.loadGuideDirectory;
Var
  regEntry : TRegistry;
  slNames  : TStringList;
  slTitles : TStringList;
  tliItem  : TListItem;
  i        : Integer;
Begin

  regEntry := TRegistry.Create;
  slNames  := TStringList.Create;
  slTitles := TStringList.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, False ) Then
    Begin
      Try
        slNames.Text  := ReadString( REG_FILE_DIRECTORY_NAMES );
        slTitles.Text := ReadString( REG_FILE_DIRECTORY_TITLES );
      Except
        slNames.Text  := '';
        slTitles.Text := '';
      End;  
      CloseKey;
    End;

  End;

  regEntry.Free;

  lvGuides.Items.Clear;
  
  For i := 0 To slNames.Count - 1 Do
  Begin
    tliItem         := lvGuides.Items.Add;
    tliItem.Caption := slTitles[ i ];
    tliItem.SubItems.Add( slNames[ i ] );
  End;

  slNames.Free;
  slTitles.Free;

  bLoaded := True;
    
End;

Procedure TfrmGuides.saveGuideDirectory;
Var
  regEntry : TRegistry;
  slNames  : TStringList;
  slTitles : TStringList;
  i        : Integer;
Begin

  slNames  := TStringList.Create;
  slTitles := TStringList.Create;
  
  For i := 0 To lvGuides.Items.Count - 1 Do
  Begin
    slTitles.Add( lvGuides.Items[ i ].Caption );
    slNames.Add( lvGuides.Items[ i ].SubItems[ 0 ] );
  End;

  regEntry := TRegistry.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, True ) Then
    Begin
      WriteString( REG_FILE_DIRECTORY_NAMES,  slNames.Text );
      WriteString( REG_FILE_DIRECTORY_TITLES, slTitles.Text );
      CloseKey;
    End;

  End;

  regEntry.Free;
  slNames.Free;
  slTitles.Free;

End;

procedure TfrmGuides.FormShow(Sender: TObject);
Var
  regEntry : TRegistry;
begin

  regEntry := TRegistry.Create;

  { Restore the saved UI information }
  If regEntry.OpenKey( APP_REG_KEY, False ) Then
  Begin

    With regEntry Do
    Begin

      Try
        Top                         := ReadInteger( REG_GUIDES_TOP );
        Left                        := ReadInteger( REG_GUIDES_LEFT );
        Width                       := ReadInteger( REG_GUIDES_WIDTH );
        Height                      := ReadInteger( REG_GUIDES_HEIGHT );
        lvGuides.Columns[ 0 ].Width := ReadInteger( REG_GUIDES_TITLE_WIDTH );
        lvGuides.Columns[ 1 ].Width := ReadInteger( REG_GUIDES_NAMES_WIDTH );
      Except
        { Do nothing }
      End;

      CloseKey;

    End;

  End;

  regEntry.Free;

  { If the guide directory hasn't been loaded, load it }
  If Not bLoaded Then
    loadGuideDirectory;

end;

procedure TfrmGuides.pbClearClick(Sender: TObject);
begin

  MessageBeep( MB_ICONQUESTION );
  If MessageDlg( 'Clear all guides from list?', mtConfirmation,
                 [ mbYes, mbNo ], 0 ) = mrYes Then
  Begin
    lvGuides.Items.Clear;
    saveGuideDirectory;
    refreshButtons;
  End;
    
end;

procedure TfrmGuides.lvGuidesKeyPress(Sender: TObject; var Key: Char);
begin
  If ( lvGuides.ItemFocused <> Nil ) And ( Key = #13 ) Then
    pbOpenClick( Nil );
end;

procedure TfrmGuides.FormClose(Sender: TObject; var Action: TCloseAction);
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
        WriteInteger( REG_GUIDES_TOP,    Top );
        WriteInteger( REG_GUIDES_LEFT,   Left );
        WriteInteger( REG_GUIDES_WIDTH,  Width );
        WriteInteger( REG_GUIDES_HEIGHT, Height );
      End;

      { Remember the widths of the list-view columns }
      WriteInteger( REG_GUIDES_TITLE_WIDTH, lvGuides.Columns[ 0 ].Width );
      WriteInteger( REG_GUIDES_NAMES_WIDTH, lvGuides.Columns[ 1 ].Width );

      CloseKey;

    End;

  End;

  regEntry.Free;

end;

Function TfrmGuides.guideNames : TStringList;
Var
  i : Integer;
Begin

  { If the guide directory hasn't been loaded, load it }
  If Not bLoaded Then
    loadGuideDirectory;

  Result := TStringList.Create;

  For i := 0 To lvGuides.Items.Count - 1 Do
    Result.Add( lvGuides.Items[ i ].SubItems[ 0 ] );

End;

Procedure TfrmGuides.addGuide( sGuide : String );
Var
  ng      : TNortonGuide;
  tliItem : TListItem;
Begin

  ng := TNortonGuide.Create;

  { If we can open the guide }
  If ng.open( sGuide ) Then
  Begin

    { And if it is a valid guide }
    If ng.isValid Then
    Begin

      { And if we've not got this guide already... }
      If lvGuides.FindCaption( 0, ng.Title, False, True, True ) = Nil Then
      Begin

        { Add it }
        tliItem         := lvGuides.Items.Add;
        tliItem.Caption := ng.title;
        tliItem.SubItems.Add( sGuide );

      End
      Else
      Begin
        MessageBeep( MB_ICONINFORMATION );
        MessageDlg( '''' + ng.Title + ''' is already listed, ignoring.',
                    mtInformation, [ mbOk ], 0 );
      End;

    End
    Else
    Begin
      MessageBeep( MB_ICONERROR );
      MessageDlg( sGuide + ' doesn''t appear to be a Norton Guide.'
                  + #13 + 'Ignoring', mtError, [ mbOk ], 0 );
    End;

    ng.close;

  End
  Else
  Begin
    MessageBeep( MB_ICONERROR );
    MessageDlg( 'Can''t open ' + sGuide + ', ignoring.', mtError, [ mbOk ], 0 );
  End;

  ng.Free;
  
End;

Procedure TfrmGuides.acceptFiles( var msg : TMessage );
Var
  acFileName : Array [0..MAX_PATH - 1] Of Char;
  iFiles     : Integer;
  iFile      : Integer;
  iSavCsr    : Integer;
Begin

  iSavCsr       := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  Try

    iFiles := DragQueryFile( msg.WParam, $FFFFFFFF, acFileName, MAX_PATH );

    For iFile := 1 To iFiles Do
    Begin
      DragQueryFile( msg.WParam, iFile - 1, acFileName, MAX_PATH );
      addGuide( acFileName );
    End;

    DragFinish( msg.WParam );

  Finally
    Screen.Cursor := iSavCsr;
  End;

End;

procedure TfrmGuides.FormCreate(Sender: TObject);
begin
  DragAcceptFiles( Handle, True );
end;

end.
