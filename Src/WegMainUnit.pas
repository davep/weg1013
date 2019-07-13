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

unit WegMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ExtCtrls, Buttons, ngGuide, StdCtrls, ToolWin, ngEntry,
  Registry, FileHistoryList, egColour, EntryHistoryList, ShellAPI;

type

  TTrackerDirection = ( tdJump, tdBacktrack, tdForetrack );
  
  TfrmWegMain = class(TForm)
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileSep1: TMenuItem;
    mnuFileExit: TMenuItem;
    dlgFileOpen: TOpenDialog;
    popTree: TPopupMenu;
    popTreeExpandAll: TMenuItem;
    popTreeCollapseAll: TMenuItem;
    barStatus: TStatusBar;
    lbText: TListBox;
    treNGMenu: TTreeView;
    pnlToolBar: TPanel;
    sbFileOpen: TSpeedButton;
    sbPrevious: TSpeedButton;
    sbUp: TSpeedButton;
    sbNext: TSpeedButton;
    mnuNavigate: TMenuItem;
    mnuNavigatePrevious: TMenuItem;
    mnuNavigateUp: TMenuItem;
    mnuNavigateNext: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpAbout: TMenuItem;
    sbDown: TSpeedButton;
    mnuNavigateDown: TMenuItem;
    mnuFileSep2: TMenuItem;
    mnuFileSaveText: TMenuItem;
    dlgFileSave: TSaveDialog;
    sbFileSaveText: TSpeedButton;
    spltSplitter: TSplitter;
    sbExit: TSpeedButton;
    mnuFileSaveSource: TMenuItem;
    lblSeeAlso: TLabel;
    ddlSeeAlso: TComboBox;
    dlgFind: TFindDialog;
    sbSearchFind: TSpeedButton;
    mnuSearch: TMenuItem;
    mnuSearchFind: TMenuItem;
    mnuSearchFindAgain: TMenuItem;
    dlgPrintSetup: TPrinterSetupDialog;
    mnuFilePrint: TMenuItem;
    mnuFilePrinterSetup: TMenuItem;
    mnuFileSplit3: TMenuItem;
    dlgPrint: TPrintDialog;
    sbFilePrint: TSpeedButton;
    mnuEdit: TMenuItem;
    mnuEditCopyText: TMenuItem;
    mnuEditSplit1: TMenuItem;
    mnuEditPRefs: TMenuItem;
    mnuEditCopySource: TMenuItem;
    mnuFileReOpen: TMenuItem;
    mnuSearchGlobalFind: TMenuItem;
    sbSearchFindGlobal: TSpeedButton;
    mnuView: TMenuItem;
    mnuViewShowHideMenu: TMenuItem;
    mnuFileGuideManager: TMenuItem;
    sbGuideManager: TSpeedButton;
    popEntry: TPopupMenu;
    popEntrySaveText: TMenuItem;
    popEntrySaveSource: TMenuItem;
    popEntrySplit1: TMenuItem;
    popEntryCopyText: TMenuItem;
    popEntryCopySource: TMenuItem;
    popEntrySplit2: TMenuItem;
    popEntryPrint: TMenuItem;
    popEntrySplit3: TMenuItem;
    popEntryZoom: TMenuItem;
    popTreeSplit1: TMenuItem;
    popTreeHide: TMenuItem;
    mnuViewExpandAll: TMenuItem;
    mnuViewCollapseAll: TMenuItem;
    mnuViewSplit1: TMenuItem;
    mnuViewURLScanner: TMenuItem;
    popEntrySplit4: TMenuItem;
    popEntryURLScanner: TMenuItem;
    sbViewURLScanner: TSpeedButton;
    mnuNavigateSplit1: TMenuItem;
    mnuNavigateBacktrack: TMenuItem;
    sbBacktrack: TSpeedButton;
    mnuViewBookmarks: TMenuItem;
    sbBookmarks: TSpeedButton;
    sbForetrack: TSpeedButton;
    mnuNavigateForetrack: TMenuItem;
    mnuViewSplit2: TMenuItem;
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure popTreeExpandAllClick(Sender: TObject);
    procedure popTreeCollapseAllClick(Sender: TObject);
    procedure treNGMenuChange(Sender: TObject; Node: TTreeNode);
    procedure lbTextDblClick(Sender: TObject);
    procedure mnuNavigatePreviousClick(Sender: TObject);
    procedure mnuNavigateUpClick(Sender: TObject);
    procedure mnuNavigateNextClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure lbTextClick(Sender: TObject);
    procedure mnuNavigateDownClick(Sender: TObject);
    procedure mnuFileSaveTextClick(Sender: TObject);
    procedure mnuFileSaveSourceClick(Sender: TObject);
    procedure ddlSeeAlsoChange(Sender: TObject);
    procedure mnuSearchFindClick(Sender: TObject);
    procedure dlgFindFind(Sender: TObject);
    procedure mnuFilePrinterSetupClick(Sender: TObject);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mnuEditCopyTextClick(Sender: TObject);
    procedure mnuEditCopySourceClick(Sender: TObject);
    procedure mnuEditPRefsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mnuFileClick(Sender: TObject);
    procedure mnuSearchFindAgainClick(Sender: TObject);
    procedure lbTextDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure mnuSearchGlobalFindClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbTextKeyPress(Sender: TObject; var Key: Char);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuViewShowHideMenuClick(Sender: TObject);
    procedure mnuFileGuideManagerClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure ddlSeeAlsoKeyPress(Sender: TObject; var Key: Char);
    procedure popEntryPopup(Sender: TObject);
    procedure mnuViewURLScannerClick(Sender: TObject);
    procedure treNGMenuDblClick(Sender: TObject);
    procedure mnuNavigateBacktrackClick(Sender: TObject);
    procedure mnuViewBookmarksClick(Sender: TObject);
    procedure treNGMenuKeyPress(Sender: TObject; var Key: Char);
    procedure lbTextMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuNavigateForetrackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure refreshForm;
    Procedure refreshText;
    Procedure refreshGuideTitle;
    Procedure refreshNavigation( bOff : Boolean );
    Procedure initFormForNewGuide;
    Function  jump( l : LongInt ) : Boolean;
    Procedure jumpToEntryLine( iLine : Integer );
    Procedure populateSeeAlso;
    Procedure refreshStatus;
    Procedure saveGuideName;
    Procedure saveGuideHistory;
    Procedure restoreTextFont;
    Function  rangeSelected  : Boolean;
    Function  rangeSelection : TStringList;
    Function  rangeSourceSelection : TStringList;
    Procedure positionMenuTreeForEntry;
    Procedure rememberLocation( tdDirection : TTrackerDirection ); 
    Procedure setMiscPrefs;

  public
    ng       : TNortonGuide;
    oEntry   : TNGEntry;
    oColours : TEGColours;

    Constructor Create( AOwner : TComponent ); Override;
    Destructor  Destroy; Override;
    Function    openGuide( sFile : String; bJumpToFirst : Boolean ) : Boolean;
    Procedure   mnuFileReOpenOptionClick( Sender: TObject );
    Procedure   refreshTextItemHeight;
    Procedure   setTextStyle( bColour : Boolean );
    Procedure   jumpToGuideEntryLine( sGuide : String; lEntry : LongInt; iLine : Integer );
    Procedure   setOemToAnsi( bOn : Boolean );
    Procedure   setSingleClickJump( bOn : Boolean );
    Procedure   setNameInTitle( bOn : Boolean );
    Procedure   acceptFiles( var msg : TMessage ); Message WM_DROPFILES;

  protected
    regRegEntry       : TRegistry;
    fhlHistory        : TFileHistoryList;
    iFindLine         : Integer;
    sFindStr          : String;
    lFindMatchCase    : Boolean;
    bLoadingMenu      : Boolean;
    bForcingMenu      : Boolean;
    oBacktrack        : TEntryHistoryList;
    oForetrack        : TEntryHistoryList;
    bBacktracking     : Boolean;
    bOemToAnsi        : Boolean;
    bSingleClickJumps : Boolean;
    bGuideNameInTitle : Boolean;

  end;

var
  frmWegMain: TfrmWegMain;

implementation

uses frmAboutUnit, Printers, Clipbrd, frmPrefsUnit, egConstants, ngUtils,
  frmFinderUnit, frmGuidesUnit, frmURLsUnit, frmBookmarksUnit;

{$R *.DFM}

Constructor TfrmWegMain.Create( AOwner : TComponent );
Begin

  Inherited;

  ng                := TNortonGuide.Create;
  regRegEntry       := TRegistry.Create;
  fhlHistory        := TFileHistoryList.Create;
  oColours          := TEGColours.Create;
  oBacktrack        := TEntryHistoryList.Create;
  oForeTrack        := TEntryHistoryList.Create;
  bLoadingMenu      := False;
  bForcingMenu      := False;
  bBacktracking     := False;
  bOemToAnsi        := False;
  bSingleClickJumps := False;
  bGuideNameInTitle := False;

  setMiscPrefs;

End;

Destructor TfrmWegMain.Destroy;
Begin
  ng.Close;
  ng.Free;
  regRegEntry.Free;
  oEntry.Free;
  fhlHistory.Free;
  oColours.Free;
  oBacktrack.Free;
  oForeTrack.Free;
  Inherited;
End;

Procedure TFrmWegMain.refreshForm;
Begin
  { Refresh stuff based on what is happening }
  treNGMenu.Enabled           := ng.isOpen;
  mnuSearchGlobalFind.Enabled := ng.isOpen;
  sbSearchFindGlobal.Enabled  := ng.isOpen;
End;

Procedure TfrmWegMain.refreshText;
Var
  iLine   : Integer;
  iSavCsr : Integer;
Begin

  iSavCsr        := Screen.Cursor;
  Screen.Cursor  := crHourGlass;

  Try

    lbText.Clear;

    If oEntry = Nil Then
    Begin

      lbText.Enabled             := False;
      mnuFileSaveText.Enabled    := False;
      sbFileSaveText.Enabled     := False;
      mnuFileSaveSource.Enabled  := False;
      mnuFilePrint.Enabled       := False;
      sbFilePrint.Enabled        := False;
      mnuEditCopyText.Enabled    := False;
      mnuEditCopySource.Enabled  := False;
      mnuSearchFind.Enabled      := False;
      mnuViewURLScanner.Enabled  := False;
      sbSearchFind.Enabled       := False;
      mnuSearchFindAgain.Enabled := False;
      sbViewURLScanner.Enabled   := False;

    End
    Else
    Begin

      lbText.Items.BeginUpdate;
      For iLine := 1 To oEntry.lines Do
      Begin
        lbText.Items.Add( oEntry.plainLine( iLine - 1 ) );
      End;
      lbText.Items.EndUpdate;

      lbText.Enabled             := True;
      mnuFileSaveText.Enabled    := True;
      sbFileSaveText.Enabled     := True;
      mnuFileSaveSource.Enabled  := True;
      mnuFilePrint.Enabled       := True;
      mnuEditCopyText.Enabled    := True;
      mnuEditCopySource.Enabled  := True;
      mnuViewURLScanner.Enabled  := True;
      sbFilePrint.Enabled        := True;
      mnuSearchFind.Enabled      := True;
      sbSearchFind.Enabled       := True;
      mnuSearchFindAgain.Enabled := True;
      sbViewURLScanner.Enabled   := True;

    End;

    refreshNavigation( False );
    refreshGuideTitle;

  Finally

    Screen.Cursor := iSavCsr;

  End;

End;

Procedure TfrmWegMain.refreshGuideTitle;
Begin

    barStatus.Panels[ 0 ].Text := ng.guideType;

    With barStatus.Panels[ 1 ] Do
    Begin

      Text := ng.title;

      If oEntry <> Nil Then
        If oEntry.parentMenu > -1 Then
        Begin
          Text := Text + ' >> ' + ng.menuTitle( oEntry.parentMenu );
          If oEntry.parentPrompt > -1 Then
            Text := Text + ' >> ' + ng.menu( oEntry.parentMenu ).prompt( oEntry.parentPrompt );
        End;

    End;

   If bGuideNameInTitle Then
     Caption := 'Expert Guide - ' + barStatus.Panels[ 1 ].Text
   Else
     Caption := 'Expert Guide';

End;

Procedure TfrmWegMain.refreshNavigation( bOff : Boolean );
Begin

  If ( oEntry = Nil ) Or bOff Then
  Begin
    sbPrevious.Enabled           := False;
    sbDown.Enabled               := False;
    sbUp.Enabled                 := False;
    sbNext.Enabled               := False;
    sbBacktrack.Enabled          := Not oBacktrack.empty;
    sbForetrack.Enabled          := Not oForetrack.empty;
    mnuNavigatePrevious.Enabled  := False;
    mnuNavigateDown.Enabled      := False;
    mnuNavigateUp.Enabled        := False;
    mnuNavigateNext.Enabled      := False;
    mnuNavigateBacktrack.Enabled := False;
    lblSeeAlso.Enabled           := False;
    ddlSeeAlso.Enabled           := False;
    ddlSeeAlso.Items.Clear;
  End
  Else
  Begin
    sbPrevious.Enabled           := oEntry.hasPrevious;
    sbDown.Enabled               := oEntry.hasJumpPoint( lbText.ItemIndex );
    sbUp.Enabled                 := oEntry.hasUp;
    sbNext.Enabled               := oEntry.hasNext;
    sbBacktrack.Enabled          := Not oBacktrack.empty;
    sbForetrack.Enabled          := Not oForetrack.empty;
    mnuNavigatePrevious.Enabled  := oEntry.hasPrevious;
    mnuNavigateDown.Enabled      := oEntry.hasJumpPoint( lbText.ItemIndex );
    mnuNavigateUp.Enabled        := oEntry.hasUp;
    mnuNavigateNext.Enabled      := oEntry.hasNext;
    mnuNavigateBacktrack.Enabled := Not oBacktrack.empty;
    mnuNavigateForetrack.Enabled := Not oForetrack.empty;
    lblSeeAlso.Enabled           := oEntry.hasSeeAlso;
    ddlSeeAlso.Enabled           := oEntry.hasSeeAlso;
    populateSeeAlso;
  End;
  
End;

Procedure TfrmWegMain.initFormForNewGuide;
Var
  iMenus : Integer;
  iMenu  : Integer;
  iSubs  : Integer;
  iSub   : Integer;
  oMenu  : TTreeNode;
Begin

  With treNGMenu Do
  Begin

    oEntry.Free;
    oEntry := Nil;

    If Not ng.hasMenus Then
      oEntry := ng.loadMenuEntry( 0, 0 );

    refreshText;

    iMenus := ng.menus();

    { Let treNGMenuChange know it shouldn't do it's thing }
    bLoadingMenu := True;

    treNGMenu.Items.Clear;

    For iMenu := 0 To iMenus - 1 Do
    Begin

      oMenu := treNGMenu.Items.Add( Nil, ng.menuTitle( iMenu ) );
      iSubs := ng.menu( iMenu ).prompts();

      For iSub := 0 To iSubs - 1 Do
      Begin
        treNGMenu.Items.AddChild( oMenu, ng.menu( iMenu ).prompt( iSub ) );
      End;

    End;

    If mnuViewExpandAll.Checked Then
      treNGMenu.FullExpand
    Else If mnuViewCollapseAll.Checked Then
      treNGMenu.FullCollapse;
      
    bLoadingMenu := False;

    refreshGuideTitle;
    
  End;

End;

procedure TfrmWegMain.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmWegMain.mnuFileOpenClick(Sender: TObject);
begin

  With regRegEntry Do
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

  If dlgFileOpen.Execute Then
    openGuide( dlgFileOpen.FileName, True );

end;

procedure TfrmWegMain.popTreeExpandAllClick(Sender: TObject);
begin
  mnuViewExpandAll.Checked   := True;
  popTreeExpandAll.Checked   := True;
  mnuViewCollapseAll.Checked := False;
  popTreeCollapseAll.Checked := False;
  treNGMenu.FullExpand;
end;

procedure TfrmWegMain.popTreeCollapseAllClick(Sender: TObject);
begin
  mnuViewExpandAll.Checked   := False;
  popTreeExpandAll.Checked   := False;
  mnuViewCollapseAll.Checked := True;
  popTreeCollapseAll.Checked := True;
  treNGMenu.FullCollapse;
end;

procedure TfrmWegMain.treNGMenuChange(Sender: TObject; Node: TTreeNode);
Var
  iSavCsr : Integer;
begin

  If ( Node.Parent <> Nil ) And ( Not bLoadingMenu ) And ( Not bForcingMenu ) Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try
      rememberLocation( tdJump );
      oEntry.Free;
      oEntry := ng.loadMenuEntry( Node.Parent.Index, Node.Index );
      refreshText;
    Finally
      Screen.Cursor := iSavCsr;
    End;
    
  End;

end;

procedure TfrmWegMain.lbTextDblClick(Sender: TObject);
begin
  If oEntry.isShort And oEntry.hasJumpPoint( lbText.ItemIndex ) Then
  Begin
    rememberLocation( tdJump );
    jump( oEntry.jumpPoint( lbText.ItemIndex ) );
  End;
end;

Function TfrmWegMain.jump( l : LongInt ) : Boolean;
Var
  iSavCsr : Integer;
Begin

  If ng.isEntryPointer( l ) Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try

      { Load the new guide entry }
      oEntry.Free;
      oEntry := ng.loadEntry( l );

      { Refresh the entry display with the new entry }
      refreshText;

      { Sync the menu }
      If ( oEntry.parentMenu > -1 ) And ( oEntry.parentPrompt > -1 ) Then
        positionMenuTreeForEntry;

    Finally
      Screen.Cursor := iSavCsr;
      Result        := True;
    End;
    
  End
  Else
  Begin
    MessageBeep( MB_ICONHAND	); 
    MessageDlg( 'Invalid entry pointer.', mtError, [ mbOk ], 0 );
    Result := False;
  End;

End;

procedure TfrmWegMain.mnuNavigatePreviousClick(Sender: TObject);
begin
  rememberLocation( tdJump );
  jump( oEntry.previous );
end;

procedure TfrmWegMain.mnuNavigateUpClick(Sender: TObject);
Var
  iLine : Integer;
begin
  rememberLocation( tdJump );
  iLine := oEntry.parentLine;
  jump( oEntry.parent );
  jumpToEntryLine( iLine );
  refreshNavigation( False );
end;

procedure TfrmWegMain.mnuNavigateNextClick(Sender: TObject);
begin
  rememberLocation( tdJump );
  jump( oEntry.next );
end;

procedure TfrmWegMain.mnuHelpAboutClick(Sender: TObject);
Var
  frmAbout : TfrmAbout;
begin
  frmAbout := TFrmAbout.Create( self );
  frmAbout.showModal;
  frmAbout.Free;
end;

procedure TfrmWegMain.lbTextClick(Sender: TObject);
begin

  If bSingleClickJumps And oEntry.isShort And oEntry.hasJumpPoint( lbText.ItemIndex ) Then
  Begin
    rememberLocation( tdJump );
    jump( oEntry.jumpPoint( lbText.ItemIndex ) );
  End
  Else
    refreshNavigation( False );
    
end;

procedure TfrmWegMain.mnuNavigateDownClick(Sender: TObject);
begin
  rememberLocation( tdJump );
  jump( oEntry.jumpPoint( lbText.ItemIndex ) );
end;

procedure TfrmWegMain.mnuFileSaveTextClick(Sender: TObject);
Var
  slRange : TStringList;
  iSavCsr : Integer;
begin

  If rangeSelected Then
    dlgFileSave.Title := 'Save Selected Text As...'
  Else
    dlgFileSave.Title := 'Save Text As...';
    
  If dlgFileSave.Execute Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try
      If rangeSelected Then
      Begin
        slRange := rangeSelection;
        slRange.SaveToFile( dlgFileSave.FileName );
        slRange.Free;
      End
      Else
        lbText.Items.SaveToFile( dlgFileSave.FileName );
    Finally
      Screen.Cursor := iSavCsr;
    End;

  End;

end;

procedure TfrmWegMain.mnuFileSaveSourceClick(Sender: TObject);
Var
  slRange : TStringList;
  iSavCsr : Integer;
begin

  If rangeSelected Then
    dlgFileSave.Title := 'Save Selected Source Lines As...'
  Else
    dlgFileSave.Title := 'Save Source As...';

  If dlgFileSave.Execute Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try
      If rangeSelected Then
      Begin
        slRange := rangeSourceSelection;
        slRange.SaveToFile( dlgFileSave.FileName );
        slRange.Free;
      End
      Else
        oEntry.saveSource( dlgFileSave.FileName );
    Finally
      Screen.Cursor := iSavCsr;
    End;

  End;

end;

Procedure TfrmWegMain.populateSeeAlso;
Var
  iSeeAlsos : Integer;
  i         : Integer;
Begin

  iSeeAlsos := oEntry.seeAlsos;

  ddlSeeAlso.Items.Clear;
  
  For i := 0 To iSeeAlsos - 1 Do
  Begin
    ddlSeeAlso.Items.Add( oEntry.seeAlso( i ) );
  End;

End;

procedure TfrmWegMain.ddlSeeAlsoChange(Sender: TObject);
Var
  iSeeAlso : Integer;
begin

  iSeeAlso := ddlSeeAlso.ItemIndex;
  
  If ( Not ddlSeeAlso.DroppedDown ) And ( iSeeAlso > -1 ) Then
  Begin
    rememberLocation( tdJump );
    jump( oEntry.seeAlsoOffset( iSeeAlso ) );
  End;

end;

procedure TfrmWegMain.mnuSearchFindClick(Sender: TObject);
begin
  dlgFind.Execute;
end;

procedure TfrmWegMain.dlgFindFind(Sender: TObject);
Var
  lFound : Boolean;
begin

  { If the find text has changed re-start from the top }
  If dlgFind.FindText <> sFindStr Then
    iFindLine := 0;
    
  sFindStr       := dlgFind.FindText;
  lFindMatchCase := frMatchCase In dlgFind.Options;
  lFound         := False;

  While ( iFindLine < lbText.Items.Count ) And ( Not lFound ) Do
  Begin

    If lFindMatchCase Then
      lFound := Pos( sFindStr, lbText.Items[ iFindLine ] ) > 0
    Else
      lFound := Pos( UpperCase( sFindStr ), UpperCase( lbText.Items[ iFindLine ] ) ) > 0;

    If lFound Then
    Begin
      jumpToEntryLine( iFindLine );
      refreshNavigation( False );
      Inc( iFindLine );
    End
    Else
      Inc( iFindLine );

  End;

  If Not lFound Then
  Begin
    MessageBeep( MB_ICONEXCLAMATION );
    MessageDlg( 'Text not found, search will resume from top.', mtWarning	, [ mbOk ], 0 );
    iFindLine := 0
  End;

end;

procedure TfrmWegMain.mnuFilePrinterSetupClick(Sender: TObject);
begin
  dlgPrintSetup.Execute;
end;

procedure TfrmWegMain.mnuFilePrintClick(Sender: TObject);
Var
  tfPrint : TextFile;
  i       : Integer;
  slLines : TStringList;
  iSavCsr : Integer;
begin

  If dlgPrint.Execute Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try
        
      If rangeSelected Then
        slLines := rangeSelection
      Else
        slLines := TStringList( lbText.Items );

      AssignPrn( tfPrint );
      Rewrite( tfPrint );

      Printer.Canvas.Font := lbText.Font;

      { For some strange reason some fonts that claim to be (and display as)
        fixed pitch won't print as fixed pitch (anyone know why?). So, force
        the issue. }
      Printer.Canvas.Font.Pitch := fpFixed;

      For i := 0 To slLines.Count -1 Do
      Begin
        WriteLn( tfPrint, slLines[ i ] );
      End;

      CloseFile( tfPrint );

      If rangeSelected Then
        slLines.Free;

    Finally
      Screen.Cursor := iSavCsr;
    End;

  End;

end;

procedure TfrmWegMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  { Remember which guide we were viewing }
  saveGuideName;

  { Remember the guide history list }
  saveGuideHistory;

  { Remember the form details }
  With regRegEntry Do
  Begin
    If OpenKey( APP_REG_KEY, True ) Then
    Begin
      If WindowState <> wsMaximized Then
      Begin
        WriteInteger( REG_FORM_TOP,    Top );
        WriteInteger( REG_FORM_LEFT,   Left );
        WriteInteger( REG_FORM_WIDTH,  Width );
        WriteInteger( REG_FORM_HEIGHT, Height );
      End;  
      WriteInteger( REG_FORM_SPLIT, treNGMenu.Width );
      CloseKey;
    End;
  End;

end;

Procedure TfrmWegMain.saveGuideName;
Begin

  If ng.isOpen Then
    With regRegEntry Do
    Begin
      If OpenKey( APP_REG_KEY, True ) Then
      Begin

        WriteString( REG_LAST_GUIDE, ng.fileName() );

        If oEntry <> Nil Then
        Begin
          WriteInteger( REG_LAST_ENTRY, oEntry.offset );
          WriteInteger( REG_LAST_LINE,  lbText.ItemIndex );
        End
        Else
        Begin
          DeleteValue( REG_LAST_ENTRY );
          DeleteValue( REG_LAST_LINE );
        End;
        
        CloseKey;
        
      End;
    End;  

End;

Procedure TfrmWegMain.saveGuideHistory;
Begin

  If fhlHistory.count > 0 Then
    With regRegEntry Do
    Begin
      If OpenKey( APP_REG_KEY, True ) Then
      Begin
        WriteString( REG_FILE_HISTORY_NAMES,  fhlHistory.names );
        WriteString( REG_FILE_HISTORY_TITLES, fhlHistory.titles );
        CloseKey;
      End;
    End;

End;

procedure TfrmWegMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles( Handle, True );
end;

procedure TfrmWegMain.FormShow(Sender: TObject);
Var
  sToOpen    : String;
  lJumpEntry : LongInt;
  iJumpLine  : Integer;
  bPreOpen   : Boolean;
  bJump      : Boolean;
begin

  { Restore the saved UI information }
  If regRegEntry.OpenKey( APP_REG_KEY, False ) Then
  Begin
    With regRegEntry Do
    Begin
      Try
        Top             := ReadInteger( REG_FORM_TOP );
        Left            := ReadInteger( REG_FORM_LEFT );
        Width           := ReadInteger( REG_FORM_WIDTH );
        Height          := ReadInteger( REG_FORM_HEIGHT );
        treNGMenu.Width := ReadInteger( REG_FORM_SPLIT );
      Except
        { Do nothing }
      End;
      CloseKey;
    End;
  End;

  { Restore the user's colour scheme }
  oColours.loadUserPrefs;

  { Restore the font for the text list box }
  restoreTextFont;

  { Restore the Re-Open history }
  With regRegEntry Do
  Begin
    If OpenKey( APP_REG_KEY, False ) Then
    Begin
      Try
        fhlHistory.setHistory( ReadString( REG_FILE_HISTORY_NAMES ),
                               ReadString( REG_FILE_HISTORY_TITLES ) );
      Except
        fhlHistory.setHistory( '', '' );
      End;
      CloseKey;
    End;
  End;

  { Work out which guide we should pre-open }
  bPreOpen   := False;
  bJump      := False;
  lJumpEntry := 0; { Stop the compiler bitching }
  iJumpLine  := 0; { Stop the compiler bitching }

  If ParamCount > 0 Then
  Begin
    sToOpen  := ParamStr( 1 );
    bPreOpen := True;
  End
  Else
  Begin
    If regRegEntry.OpenKey( APP_REG_KEY, False ) Then
    Begin

      { Try to get the guide name }
      Try
        sToOpen  := regRegEntry.ReadString( REG_LAST_GUIDE );
        bPreOpen := True;
      Except
        { Do Nothing }
      End;

      { If there is a "last guide", try to put the user back where they
        were the last time. }
      If bPreOpen Then
        Try
          lJumpEntry := regRegEntry.ReadInteger( REG_LAST_ENTRY );
          iJumpLine  := regRegEntry.ReadInteger( REG_LAST_LINE );
          bJump      := True;
        Except
          bJump := False;
        End;

      regRegEntry.CloseKey;

    End;
  End;

  If bJump Then
  Begin
    jumpToGuideEntryLine( sToOpen, lJumpEntry, iJumpLine );
    lbText.SetFocus;
  End
  Else If bPreOpen Then
    openGuide( sToOpen, True );

  refreshStatus;

end;

Function TfrmWegMain.openGuide( sFile : String; bJumpToFirst : Boolean ) : Boolean;
Var
  ngNew : TNortonGuide;
Begin

  ngNew            := TNortonGuide.Create;
  ngNew.bOemToAnsi := bOemToAnsi;
  Result           := False;

  If ngNew.open( sFile ) Then
  Begin
    If ngNew.isValid Then
    Begin
      rememberLocation( tdJump );
      ng.Close;
      ng.Free;
      ng := ngNew;
      initFormForNewGuide;
      If ( oEntry = Nil ) And bJumpToFirst Then
      Begin
        oEntry := ng.loadMenuEntry( 0, 0 );
        refreshText;
        positionMenuTreeForEntry;
        lbText.SetFocus;
      End;
      refreshForm;
      Result := True;
    End
    Else
    Begin
      ngNew.close;
      ngNew.Free;
      MessageBeep( MB_ICONHAND );
      MessageDlg( sFile + ' isn''t a valid Norton Guide.', mtError, [ mbOk ], 0 );
    End
  End
  Else
    ngNew.Free;

  If Result Then
  Begin
    fhlHistory.add( sFile, ng.title );
    saveGuideName;
    saveGuideHistory;
  End;
    
End;

procedure TfrmWegMain.mnuEditCopyTextClick(Sender: TObject);
Var
  slRange : TStringList;
begin

  If rangeSelected Then
  Begin
    slRange := rangeSelection;
    Clipboard.SetTextBuf( PChar( slRange.Text ) );
    slRange.Free;
  End
  Else
    Clipboard.SetTextBuf( PChar( lbText.Items.Text ) );
    
end;

procedure TfrmWegMain.mnuEditCopySourceClick(Sender: TObject);
Var
  slRange : TStringList;
begin

  If rangeSelected Then
  Begin
    slRange := rangeSourceSelection;
    Clipboard.SetTextBuf( PChar( slRange.Text ) );
    slRange.Free;
  End
  Else
    Clipboard.SetTextBuf( PChar( oEntry.source ) );

end;

procedure TfrmWegMain.mnuEditPRefsClick(Sender: TObject);
Var
  frmPrefs : TfrmPrefs;
begin

  frmPrefs := TfrmPrefs.Create( self );
  frmPrefs.ShowModal;
  frmPrefs.Free;

end;

procedure TfrmWegMain.FormResize(Sender: TObject);
begin
  refreshStatus;
end;

Procedure TfrmWegMain.refreshStatus;
Begin
  With barStatus Do
  Begin
    Panels[ 0 ].Width := 30;
    Panels[ 1 ].Width := self.Width - Panels[ 0 ].Width - 150;
  End;  
End;

procedure TfrmWegMain.mnuFileClick(Sender: TObject);
Var
  mnuNew : TMenuItem;
  iFiles : Integer;
  iFile  : Integer;
begin

  iFiles := fhlHistory.count;

  { Any files in the file history? }
  If iFiles > 0 Then
  Begin

    { Yup, enable the Re-Open menu option }
    mnuFileReOpen.Enabled := True;

    { Now build up the sub-menu. We'll re-cycle any existing menu items }
    For iFile := 0 To iFiles - 1 Do
    Begin

      If iFile <= ( mnuFileReOpen.Count - 1 ) Then
      Begin
        mnuNew := mnuFileReOpen.Items[ iFile ];
      End
      Else
      Begin
        mnuNew := TMenuItem.Create( mnuFileReOpen );
        mnuFileReOpen.Add( mnuNew );
      End;

      mnuNew.Caption := Format( '&%X', [ iFile ] ) + ' ' + fhlHistory.fileTitle( iFile );
      mnuNew.Tag     := iFile;
      mnuNew.OnClick := mnuFileReOpenOptionClick;

    End;

  End;

  If rangeSelected Then
  Begin
    mnuFileSaveText.Caption   := '&Save Selected Text...';
    mnuFileSaveSource.Caption := 'Save Selected So&urce...';
    mnuFilePrint.Caption      := '&Print Selection...';
  End
  Else
  Begin
    mnuFileSaveText.Caption   := '&Save Text...';
    mnuFileSaveSource.Caption := 'Save So&urce...';
    mnuFilePrint.Caption      := '&Print...';
  End;

end;

Procedure TfrmWegMain.mnuFileReOpenOptionClick( Sender: TObject );
Begin
  openGuide( fhlHistory.fileName( ( Sender As TMenuItem ).Tag ), True );
End;

Procedure TfrmWegMain.restoreTextFont;
Begin

  With regRegEntry Do
  Begin
    If OpenKey( APP_REG_KEY, False ) Then
    Begin
      Try
        lbText.Font.Name    := ReadString( REG_PREFS_TEXT_FONT_NAME );
        lbText.Font.CharSet := ReadInteger( REG_PREFS_TEXT_FONT_CHARSET );
        lbText.Font.Pitch   := TFontPitch( ReadInteger( REG_PREFS_TEXT_FONT_PITCH ) );
        lbText.Font.Size    := ReadInteger( REG_PREFS_TEXT_FONT_SIZE );
        setTextStyle( ReadBool( REG_PREFS_USE_COLOUR ) );
      Except
        setTextStyle( True );
      End;
      CloseKey;
    End;
  End;

End;

procedure TfrmWegMain.mnuSearchFindAgainClick(Sender: TObject);
begin
  If Length( sFindStr ) > 0 Then
    dlgFindFind( Nil );
end;

procedure TfrmWegMain.lbTextDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
Type
  TCtrlMode = ( cmNormal, cmBold, cmUnderline, cmReverse );
Var
  cmMode  : TCtrlMode;
  brBrush : TBrush;
  sRaw    : String;
  iLeft   : Integer;
  canDraw : TCanvas;
  iCtrl   : Integer;
  iClr    : Integer;
  sText   : String;
begin

  cmMode  := cmNormal;
  brBrush := TBrush.Create;
  sRaw    := oEntry.line( Index );
  iLeft   := Rect.Left;
  canDraw := ( Control As TListBox ).Canvas;

  If odSelected In State Then
  Begin

    { The current line is selected, simply paint it in the selected colour }

    If odFocused In State Then
      brBrush.Color := oColours.focBack
    Else
      brBrush.Color := oColours.selBack;
      
    canDraw.Brush := brBrush;

    If odFocused In State Then
      canDraw.Font.Color := oColours.focText
    Else
      canDraw.Font.Color := oColours.selText;

    canDraw.FillRect( Rect );
    canDraw.TextOut( iLeft, Rect.Top, ( Control As TListBox ).Items[ Index ] );

  End
  Else
  Begin

    { Paint the line using the NG control sequences }
    
    brBrush.Color      := oColours.normalBack;
    canDraw.Brush      := brBrush;
    canDraw.Font.Color := oColours.normalText;
    canDraw.FillRect( Rect );

    { Find the first control sequence }
    iCtrl := Pos( '^', sRaw );

    While iCtrl <> 0 Do
    Begin

      { Draw the text up the the next control sequence }
      sText := Copy( sRaw, 1, iCtrl - 1 );
      canDraw.TextOut( iLeft, Rect.Top, sText );
      iLeft := iLeft + canDraw.TextWidth( sText );

      Case sRaw[ iCtrl + 1 ] Of

        'A', 'a' : { Colour Attribute }
        Begin
          iClr                := Hex2Int( Copy( sRaw, iCtrl + 2, 2 ) );
          canDraw.Font.Color  := oColours.map( iClr And $F );
          canDraw.Brush.Color := oColours.map( ( iClr And $F0 ) Shr 4 );
          cmMode              := cmNormal;
          iCtrl := iCtrl + 4;
        End;

        'B', 'b' : { Toggle bold }
        Begin
          If cmMode = cmBold Then
          Begin
            canDraw.Font.Color  := oColours.normalText;
            canDraw.Brush.Color := oColours.normalBack;
            cmMode              := cmNormal;
          End
          Else
          Begin
            canDraw.Font.Color  := oColours.boldText;
            canDraw.Brush.Color := oColours.boldBack;
            cmMode              := cmBold;
          End;
          iCtrl := iCtrl + 2;
        End;

        'C', 'c' : { Character }
        Begin
          If bOemToAnsi Then
            sText := DosToWinStr( Hex2Char( Copy( sRaw, iCtrl + 2, 2 ) ) )
          Else
            sText := Hex2Char( Copy( sRaw, iCtrl + 2, 2 ) );
          canDraw.TextOut( iLeft, Rect.Top, sText );
          iLeft := iLeft + canDraw.TextWidth( sText );
          iCtrl := iCtrl + 4;
        End;

        'N', 'n' : { Back to normal }
        Begin
          canDraw.Font.Color  := oColours.normalText;
          canDraw.Brush.Color := oColours.normalBack;
          cmMode              := cmNormal;
          iCtrl := iCtrl + 2;
        End;

        'R', 'r' : { Reverse }
        Begin
          If cmMode = cmReverse Then
          Begin
            canDraw.Font.Color  := oColours.normalText;
            canDraw.Brush.Color := oColours.normalBack;
            cmMode              := cmNormal;
          End
          Else
          Begin
            canDraw.Font.Color  := oColours.revText;
            canDraw.Brush.Color := oColours.revBack;
            cmMode              := cmReverse;
          End;
          iCtrl := iCtrl + 2;
        End;

        'U', 'u' : { Underlined }
        Begin
          If cmMode = cmUnderline Then
          Begin
            canDraw.Font.Color  := oColours.normalText;
            canDraw.Brush.Color := oColours.normalBack;
            cmMode              := cmNormal;
          End
          Else
          Begin
            canDraw.Font.Color  := oColours.undlText;
            canDraw.Brush.Color := oColours.undlBack;
            cmMode              := cmUnderline;
          End;
          iCtrl := iCtrl + 2;
        End;

        '^' :
        Begin
          canDraw.TextOut( iLeft, Rect.Top, '^' );
          iLeft := iLeft + canDraw.TextWidth( '^' );
          iCtrl := iCtrl + 2;
        End;

        Else
          Inc( iCtrl );

      End;

      sRaw  := Copy( sRaw, iCtrl, Length( sRaw ) );
      iCtrl := Pos( '^', sRaw );

    End;

    { Draw what's left }
    canDraw.TextOut( iLeft, Rect.Top, sRaw );
    
  End;

  brBrush.Free;

end;

Procedure TfrmWegMain.refreshTextItemHeight;
Begin
  { Based on rumour and guesswork. It isn't exact but it works for most font
    combinations. if you know the correct way of doing this then please let
    me know. }
  lbText.ItemHeight := Abs( lbText.Font.Height ) + Round( Abs( lbText.Font.Height ) * 0.2 );
End;

Procedure TfrmWegMain.setTextStyle( bColour : Boolean );
Begin

  If bColour Then
  Begin
    lbText.Style := lbOwnerDrawFixed;
    lbText.Color := oColours.normalBack;
    refreshTextItemHeight;
  End
  Else
  Begin
    lbText.Style := lbStandard;
    lbText.Color := clWindow;
  End;

End;

procedure TfrmWegMain.mnuSearchGlobalFindClick(Sender: TObject);
begin
  frmFinder.bOemToAnsi := bOemToAnsi;
  frmFinder.show;
end;

procedure TfrmWegMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If frmFinder.finding Then
  Begin
    MessageBeep( MB_ICONQUESTION );
    CanClose := ( MessageDlg( 'You have a global guide search in progress, ' +
                              'are you sure' + #13#10 + 'you want to exit?',
                              mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes );
  End;                              
end;

procedure TfrmWegMain.lbTextKeyPress(Sender: TObject; var Key: Char);
begin

  { Handle some of the key strokes from the Dos/Linux version of EG }
  Case Key Of

    #13           : If lbText.ItemIndex <> -1 Then lbTextDblClick( Nil );
    #27, 'Q', 'q' : If oEntry.hasUp           Then mnuNavigateUpClick( Nil ) Else If treNGMenu.Visible Then treNGMenu.setFocus();
    '-'           : If oEntry.hasPrevious     Then mnuNavigatePreviousClick( Nil );
    '+'           : If oEntry.hasNext         Then mnuNavigateNextClick( Nil );
    '/', '\'      :                                mnuSearchFindClick( Nil );
    'n'           :                                mnuSearchFindAgainClick( Nil );
    'S'           :                                mnuFileSaveSourceClick( Nil );
    's'           :                                mnuFileSaveTextClick( Nil );
    'r'           :                                mnuFileOpenClick( Nil );
    'D', 'd'      :                                mnuFileGuideManagerClick( Nil );
    'v'           :                                mnuHelpAboutClick( Nil );

  End;
    
end;

Procedure TfrmWegMain.jumpToGuideEntryLine( sGuide : String; lEntry : LongInt; iLine : Integer );
Var
  bCanJump : Boolean;
Begin

  bCanJump := True;

  { Are we viewing the guide the user wants to jump to? }
  If UpperCase( sGuide ) <> UpperCase( ng.fileName ) Then
    { No, close the current one and open the new one }
    bCanJump := openGuide( sGuide, False )
  Else
    rememberLocation( tdJump );

  { Still ok to jump? }
  If bCanJump Then
    { Yup, are we looking at that entry anyway? }
    If ( oEntry <> Nil ) And ( oEntry.offset = lEntry ) Then
    Begin
      { Yup, jump to the target line }
      jumpToEntryLine( iLine );
      refreshNavigation( False );
    End
    { Nope, attempt to jump to the entry }
    Else If jump( lEntry ) Then
    Begin
      { Jumped, jump to the target line }
      jumpToEntryLine( iLine );
      refreshNavigation( False );
    End;

End;

procedure TfrmWegMain.mnuViewClick(Sender: TObject);
begin
  If treNGMenu.Visible Then
    mnuViewShowHideMenu.Caption := '&Hide Menu'
  Else
    mnuViewShowHideMenu.Caption := '&Show Menu';
end;

procedure TfrmWegMain.mnuViewShowHideMenuClick(Sender: TObject);
begin

  { Toggle the visibility of the guide menus }
  spltSplitter.Visible := Not spltSplitter.Visible;
  treNGMenu.Visible    := Not treNGMenu.Visible;

  { Enable/Disable any menu items that work on the menu tree }
  mnuViewExpandAll.Enabled   := treNGMenu.Visible;
  mnuViewCollapseAll.Enabled := treNGMenu.Visible;

  { If we just hid the guide menus and the guide entry panel is enabled
    then set focus to it, otherwise if we just revealed the guide menus
    set focus to them. }  
  If ( Not treNGMenu.Visible ) And ( lbText.Enabled ) Then
    lbText.SetFocus
  Else If treNGMenu.Visible Then
    treNGMenu.SetFocus;

end;

procedure TfrmWegMain.mnuFileGuideManagerClick(Sender: TObject);
begin
  frmGuides.show;
end;

Function TfrmWegMain.rangeSelected : Boolean;
Begin
  Result := lbText.SelCount > 1;
End;

Function TfrmWegMain.rangeSelection : TStringList;
Var
  iLines  : Integer;
  iLine   : Integer;
Begin

  iLines := lbText.Items.Count - 1;
  Result := TStringList.Create;

  For iLine := 0 To iLines Do
    If lbText.Selected[ iLine ] Then
      Result.Add( lbText.Items[ iLine ] );

End;

Function TfrmWegMain.rangeSourceSelection : TStringList;
Var
  iLines  : Integer;
  iLine   : Integer;
Begin

  iLines := lbText.Items.Count - 1;
  Result := TStringList.Create;

  For iLine := 0 To iLines Do
    If lbText.Selected[ iLine ] Then
      Result.Add( oEntry.line( iLine ) );

End;

procedure TfrmWegMain.mnuEditClick(Sender: TObject);
begin

  If rangeSelected Then
  Begin
    mnuEditCopyText.Caption   := '&Copy Selected Text';
    mnuEditCopySource.Caption := 'C&opy Selected Source';
  End
  Else
  Begin
    mnuEditCopyText.Caption   := '&Copy Text';
    mnuEditCopySource.Caption := 'C&opy Source';
  End;

end;

{ ItemIndex doesn't work when using MultiSelect. There has to be a
  better way of jumping to a line but this is all I could come up with
  for now. If you've got a better method then let me know. }
  
Procedure TfrmWegMain.jumpToEntryLine( iLine : Integer );
Var
  iLines : Integer;
  i      : Integer;
Begin

  lbText.Items.BeginUpdate;

  iLines := lbText.Items.Count - 1;

  For i := 0 To iLines Do
  Begin
    If lbText.Selected[ i ] Then
      lbText.Selected[ i ] := False;
  End;

  { This little kludge will bump the selected item up one line if it is right
    at the bottom of the viewable area of the listbox. Again, this is pretty
    horrible, there has to be an easier way of affecting 'ItemIndex' when
    in multi-select mode }
  If iLine < lbText.Items.Count - 1 Then
  Begin
    lbText.Selected[ iLine + 1 ] := True;
    lbText.Selected[ iLine + 1 ] := False;
  End;

  lbText.Selected[ iLine ] := True;

  lbText.Items.EndUpdate;

End;

procedure TfrmWegMain.ddlSeeAlsoKeyPress(Sender: TObject; var Key: Char);
Var
  iSeeAlso : Integer;
begin

  iSeeAlso := ddlSeeAlso.ItemIndex;
  
  If ( Key = #13 ) And ( iSeeAlso > -1 ) Then
  Begin
    rememberLocation( tdJump );
    jump( oEntry.seeAlsoOffset( iSeeAlso ) );
    lbText.SetFocus;
  End;
  
end;

procedure TfrmWegMain.popEntryPopup(Sender: TObject);
begin

  If rangeSelected Then
  Begin
    popEntrySaveText.Caption   := '&Save Selected Text...';
    popEntrySaveSource.Caption := 'Save Selected S&ource...';
    popEntryCopyText.Caption   := '&Copy Selected Text';
    popEntryCopySource.Caption := 'C&opy Selected Source';
    popEntryPrint.Caption      := '&Print Selection...';
  End
  Else
  Begin
    popEntrySaveText.Caption   := '&Save Text...';
    popEntrySaveSource.Caption := 'Save S&ource...';
    popEntryCopyText.Caption   := '&Copy Text';
    popEntryCopySource.Caption := 'C&opy Source';
    popEntryPrint.Caption      := '&Print...';
  End;

  If treNGMenu.Visible Then
    popEntryZoom.Caption := '&Zoom'
  Else
    popEntryZoom.Caption := 'Un-&Zoom';  

end;

procedure TfrmWegMain.mnuViewURLScannerClick(Sender: TObject);
Var
  frmURLs : TfrmURLs;
begin

  frmURLs := TfrmURLs.Create( self );
  frmURLs.ShowModal;
  frmURLs.Free;

end;

Procedure TfrmWegMain.positionMenuTreeForEntry;

  Function FindMenuItemNode : TTreeNode;
  Var
    tnNode  : TTreeNode;
    iMenu   : Integer;
  Begin

    tnNode := treNGMenu.Items[ 0 ];
    iMenu  := 0;

    While iMenu < oEntry.parentMenu Do
    Begin
      Inc( iMenu );
      tnNode := tnNode.GetNextSibling;
    End;

    Result := tnNode.Item[ oEntry.parentPrompt ];

  End;

Begin

  bForcingMenu       := True;
  treNGMenu.Selected := FindMenuItemNode;
  bForcingMenu       := False;

End;

procedure TfrmWegMain.treNGMenuDblClick(Sender: TObject);
Var
  iSavCsr : Integer;
begin

  If ( treNGMenu.Selected.Parent <> Nil ) Then
  Begin

    iSavCsr       := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    Try
      oEntry.Free;
      oEntry := ng.loadMenuEntry( treNGMenu.Selected.Parent.Index,
                                  treNGMenu.Selected.Index );
      refreshText;
    Finally
      Screen.Cursor := iSavCsr;
    End;
    
  End;
  
end;

procedure TfrmWegMain.mnuNavigateBacktrackClick(Sender: TObject);
Var
  oBacktrackItem : TEntryHistoryItem;
begin

  If Not oBacktrack.empty Then
  Begin
    bBacktracking  := True;
    oBacktrackItem := oBacktrack.pop;
    rememberLocation( tdBacktrack );
    self.jumpToGuideEntryLine( oBacktrackItem.sGuide, oBacktrackItem.lEntry, oBacktrackItem.iLine );
    oBacktrackItem.Free;
    bBacktracking := False;
  End;

end;

procedure TfrmWegMain.mnuNavigateForetrackClick(Sender: TObject);
Var
  oForetrackItem : TEntryHistoryItem;
begin

  If Not oForetrack.empty Then
  Begin
    bBacktracking  := True;
    oForetrackItem := oForetrack.pop;
    rememberLocation( tdForetrack );
    self.jumpToGuideEntryLine( oForetrackItem.sGuide, oForetrackItem.lEntry, oForetrackItem.iLine );
    oForetrackItem.Free; 
    bBacktracking := False;
  End;

end;

Procedure TfrmWegMain.rememberLocation( tdDirection : TTrackerDirection );
Begin

  If ( oEntry <> Nil ) Then
  Begin

    Case tdDirection Of

      tdJump :
      Begin
        If Not bBacktracking Then
        Begin
          oForetrack.Clear;
          oBacktrack.push( TEntryHistoryItem.Create( ng.fileName, oEntry.offset, lbText.ItemIndex ) );
        End;
      End;

      tdBacktrack : oForetrack.push( TEntryHistoryItem.Create( ng.fileName, oEntry.offset, lbText.ItemIndex ) );
      tdForetrack : oBacktrack.push( TEntryHistoryItem.Create( ng.fileName, oEntry.offset, lbText.ItemIndex ) );

    End;
    
    refreshNavigation( False );
    
  End;

End;

Procedure TfrmWegMain.setOemToAnsi( bOn : Boolean );
Var
  oNewEntry : TNGEntry;
Begin

  { Save off the new setting }
  bOemToAnsi           := bOn;
  ng.bOemToAnsi        := bOn;
  frmFinder.bOemToAnsi := bOn;

  { If we are viewing an entry... }
  If oEntry <> Nil Then
  Begin
    { ...re-draw it }
    oNewEntry := ng.loadEntry( oEntry.offset );
    oEntry.Free;
    oEntry := oNewEntry;
    refreshText;
  End;

End;

Procedure TfrmWegMain.setSingleClickJump( bOn : Boolean );
Begin
  bSingleClickJumps := bOn;
End;

Procedure TfrmWegMain.setNameInTitle( bOn : Boolean );
Begin
  bGuideNameInTitle := bOn;
  refreshGuideTitle;
End;

Procedure TfrmWegMain.setMiscPrefs;
Begin

  With regRegEntry Do
  Begin

    If OpenKey( APP_REG_KEY, False ) Then
    Begin

      Try
        bOemToAnsi    := ReadBool( REG_PREFS_OEM_TO_ANSI );
        ng.bOemToAnsi := bOemToAnsi;
      Except
        bOemToAnsi    := False;
        ng.bOemToAnsi := False;
      End;

      Try
        bSingleClickJumps := ReadBool( REG_PREFS_SINGLE_CLICK_JUMPS );
      Except
        bSingleClickJumps := False;
      End;

      Try
        bGuideNameInTitle := ReadBool( REG_PREFS_NAME_IN_TITLE );
      Except
        bGuideNameInTitle := False;
      End;
      
      CloseKey;

    End;

  End;
  
End;

procedure TfrmWegMain.mnuViewBookmarksClick(Sender: TObject);
begin
  frmBookmarks.Show;
end;

procedure TfrmWegMain.treNGMenuKeyPress(Sender: TObject; var Key: Char);
begin

  If ( Key = #13 ) And lbText.Enabled Then
    lbText.SetFocus;

end;

procedure TfrmWegMain.lbTextMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var
  iLine    : Integer;
  pntMouse : TPoint;
begin

  If lbText.Enabled Then
  Begin

    pntMouse.x := X;
    pntMouse.y := Y;
    
    iLine := lbText.ItemAtPos( pntMouse, True );

    If iLine > -1 Then
      If oEntry.isShort And oEntry.hasJumpPoint( iLine ) Then
        lbText.Cursor := crHandPoint
      Else
        lbText.Cursor := crDefault
    Else
      lbText.Cursor := crDefault;

  End
  Else
    lbText.Cursor := crDefault;

end;

Procedure TfrmWegMain.acceptFiles( var msg : TMessage );
Var
  acFileName : Array [0..MAX_PATH - 1] Of Char;
  iFiles     : Integer;
Begin

  iFiles := DragQueryFile( msg.WParam, $FFFFFFFF, acFileName, MAX_PATH );

  If iFiles = 1 Then
  Begin
    DragQueryFile( msg.WParam, 0, acFileName, MAX_PATH );
    openGuide( acFileName, True );
  End
  Else
  Begin
    MessageBeep( MB_ICONEXCLAMATION );
    MessageDlg( 'Sorry, weg can only open one guide at a time.', mtWarning, [ mbOk ], 0 );
  End;

  DragFinish( msg.WParam );

End;

end.
