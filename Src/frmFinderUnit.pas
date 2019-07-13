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

unit frmFinderUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ngGuide, egFinder;

type

  TfrmFinder = class(TForm)
    pnlControls: TPanel;
    lbResults: TListBox;
    pbStart: TButton;
    pnlOptions: TPanel;
    cbCaseSensitive: TCheckBox;
    cbStayOnTop: TCheckBox;
    pbStop: TButton;
    pbClear: TButton;
    lblFind: TLabel;
    pbClose: TButton;
    pnlProgress: TPanel;
    prbProgress: TProgressBar;
    cmbFind: TComboBox;
    cbAllGuides: TCheckBox;
    rbAllEntries: TRadioButton;
    rbShortOnly: TRadioButton;
    rbLongOnly: TRadioButton;
    barStatus: TStatusBar;
    pnlPriority: TPanel;
    rbHiPriority: TRadioButton;
    rbMedPriority: TRadioButton;
    rbLowPriority: TRadioButton;
    procedure cbStayOnTopClick(Sender: TObject);
    procedure cmbFindChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbStopClick(Sender: TObject);
    procedure pbClearClick(Sender: TObject);
    procedure pbCloseClick(Sender: TObject);
    procedure lbResultsDblClick(Sender: TObject);
    procedure lbResultsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbResultsClick(Sender: TObject);
  private
    thdFinder       : TFinderThread;
    Procedure refreshControlsForFind( bFinding : Boolean );
    Procedure foundHit( oHit : TFinderHit );
    Procedure findFinished;
    Procedure updateProgress( lPos : LongInt; lMax : LongInt );
    Procedure updateStatus( sStatus : String );
  public
    bOemToAnsi       : Boolean;
    Function finding : Boolean;
  end;

var
  frmFinder: TfrmFinder;

implementation

uses WegMainUnit, ngUtils, Registry, egConstants, frmGuidesUnit;

{$R *.DFM}

procedure TfrmFinder.FormDestroy(Sender: TObject);
begin

  If thdFinder <> Nil Then
  Begin
    If Not thdFinder.Suspended Then
    Begin
      thdFinder.Terminate;
      thdFinder.WaitFor;
    End;
    thdFinder.Free;
  End;

  DestroyStringListObjects( lbResults.Items );

  Inherited;

end;

procedure TfrmFinder.cbStayOnTopClick(Sender: TObject);
begin

  If cbStayOnTop.Checked Then
    FormStyle := fsStayOnTop
  Else
    FormStyle := fsNormal;
      
end;

procedure TfrmFinder.cmbFindChange(Sender: TObject);
begin
  pbStart.Enabled := Length( cmbFind.Text ) > 0;
end;

procedure TfrmFinder.FormShow(Sender: TObject);
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
        Top                := ReadInteger( REG_FINDER_TOP );
        Left               := ReadInteger( REG_FINDER_LEFT );
        Width              := ReadInteger( REG_FINDER_WIDTH );
        Height             := ReadInteger( REG_FINDER_HEIGHT );
        cmbFind.Items.Text := ReadString( REG_FINDER_HISTORY );
      Except
        cmbFind.Items.Text := '';
      End;
  
      CloseKey;
  
    End;

  End;

  regEntry.Free;

  cbStayOnTop.Checked := ( FormStyle = fsStayOnTop );

  lbResults.Font := frmWegMain.lbText.Font;
  cmbFindChange( Nil );

end;

procedure TfrmFinder.pbStartClick(Sender: TObject);
Var
  iHisIndex : Integer;
  sToFind   : String;
  slGuides  : TStringList;
begin

  sToFind  := cmbFind.Text;
  slGuides := TStringList.Create;

  { If a finder thread object is kicking around, free it }
  If thdFinder <> Nil Then
    thdFinder.Free;

  { If we are searching all guides get the list from the guide manager }
  If cbAllGuides.Checked Then
    slGuides.Text := frmGuides.guideNames.Text
  Else
    slGuides.Add( frmWegMain.ng.fileName );

  { Create a new finder thread }
  thdFinder := TFinderThread.Create( slGuides, sToFind );

  { Set the priority of the search thread }
  If rbHiPriority.Checked Then
    thdFinder.Priority := tpHighest
  Else If rbMedPriority.Checked Then
    thdFinder.Priority := tpNormal
  Else If rbLowPriority.Checked Then
    thdFinder.Priority := tpLowest;

  { Tell the thread about the current OEM to ANSI status }
  thdFinder.bOemToAnsi := bOemToAnsi;

  { Add find text to finder history }

  iHisIndex := cmbFind.Items.IndexOf( sToFind );

  If iHisIndex = -1 Then
  Begin
    If cmbFind.Items.Count = 20 Then
      cmbFind.Items.Delete( 19 );
    cmbFind.Items.Insert( 0, sToFind );
  End
  Else
  Begin
    cmbFind.Items.Delete( iHisIndex );
    cmbFind.Items.Insert( 0, sToFind );
  End;

  cmbFind.Text := sToFind;
  cmbFindChange( Nil );

  { What type of search? }
  If rbShortOnly.Checked Then
    thdFinder.ssLookIn := [ fssShort ]
  Else If rbLongOnly.Checked Then
    thdFinder.ssLookIn := [ fssLong ]
  Else
    thdFinder.ssLookIn := [ fssShort, fssLong ];

  { Refresh the controls based to their 'finding' state }
  refreshControlsForFind( True );

  { Give the thread the information it needs to update us and then
    start it up }
  thdFinder.procFound    := foundHit;
  thdFinder.procFinished := findFinished;
  thdFinder.procProgress := updateProgress;
  thdFinder.procStatus   := updateStatus;
  thdFinder.bMatchCase   := cbCaseSensitive.Checked;
  thdFinder.Resume;

end;

procedure TfrmFinder.pbStopClick(Sender: TObject);
Var
  iSavCsr : Integer;
begin

  iSavCsr       := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  updateStatus( 'Stopping search...' );
  thdFinder.Terminate;
  thdFinder.WaitFor;
  thdFinder.Free;
  thdFinder := Nil;
  refreshControlsForFind( False );
  cmbFindChange( Nil );
  updateStatus( 'Search stopped' );

  Screen.Cursor := iSavCsr;

end;

Procedure TfrmFinder.refreshControlsForFind( bFinding : Boolean );
Begin

  cmbFind.Enabled         := Not bFinding;
  pbStart.Enabled         := Not bFinding;
  pbStop.Enabled          :=     bFinding;
  pbClear.Enabled         := ( Not bFinding ) And ( lbResults.Items.Count <> 0 ); 
  cbCaseSensitive.Enabled := Not bFinding;
  cbStayOnTop.Enabled     := Not bFinding;
  cbAllGuides.Enabled     := Not bFinding;
  lblFind.Enabled         := Not bFinding;
  rbAllEntries.Enabled    := Not bFinding;
  rbShortOnly.Enabled     := Not bFinding;
  rbLongOnly.Enabled      := Not bFinding;
  rbHiPriority.Enabled    := Not bFinding;
  rbMedPriority.Enabled   := Not bFinding;
  rbLowPriority.Enabled   := Not bFinding;

  If Not bFinding Then
    prbProgress.Position := 0;

End;

Function TFrmFinder.finding : Boolean;
Begin
  Result := ( thdFinder <> Nil ) And ( thdFinder.running );
End;

procedure TfrmFinder.pbClearClick(Sender: TObject);
begin
  DestroyStringListObjects( lbResults.Items );
  lbResults.Items.Clear;
  prbProgress.Position := 0;
  refreshControlsForFind( False );
  updateStatus( '' );
end;

procedure TfrmFinder.pbCloseClick(Sender: TObject);
begin
  Close;
end;

Procedure TfrmFinder.foundHit( oHit : TFinderHit );
Begin
  lbResults.Items.AddObject( oHit.sText, oHit );
End;

Procedure TfrmFinder.findFinished;
Begin
  refreshControlsForFind( False );
  updateStatus( 'Finished' );
End;

procedure TfrmFinder.lbResultsDblClick(Sender: TObject);
begin
  If lbResults.ItemIndex <> -1 Then
    With ( lbResults.Items.Objects[ lbResults.ItemIndex ] As TFinderHit ) Do
      frmWegMain.jumpToGuideEntryLine( sGuide, lEntry, iLine );
end;

procedure TfrmFinder.lbResultsKeyPress(Sender: TObject; var Key: Char);
begin
  If ( Key = #13 ) And ( lbResults.ItemIndex <> -1 ) Then
    lbResultsDblClick( Nil );
end;

Procedure TfrmFinder.updateProgress( lPos : LongInt; lMax : LongInt );
Begin
  prbProgress.Position := lPos;
  prbProgress.Max      := lMax;
End;

Procedure TfrmFInder.updateStatus( sStatus : String );
Begin
  barStatus.SimpleText := sStatus;
End;

procedure TfrmFinder.FormCreate(Sender: TObject);
Var
  regEntry : TRegistry;
begin

	regEntry := TRegistry.Create;

	{ Restore the form style attribute }
	If regEntry.OpenKey( APP_REG_KEY, False ) Then
	Begin

    Try
      If regEntry.ReadBool( REG_FINDER_ONTOP ) Then
        FormStyle := fsStayOnTop
      Else
        FormStyle := fsNormal;
    Except
      FormStyle := fsNormal;
    End;  

    regEntry.CloseKey;

  End;

end;

procedure TfrmFinder.FormClose(Sender: TObject; var Action: TCloseAction);
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
        WriteInteger( REG_FINDER_TOP,    Top );
        WriteInteger( REG_FINDER_LEFT,   Left );
        WriteInteger( REG_FINDER_WIDTH,  Width );
        WriteInteger( REG_FINDER_HEIGHT, Height );
      End;

      { Remember any settings }
      WriteBool( REG_FINDER_ONTOP,     cbStayOnTop.Checked );
      WriteString( REG_FINDER_HISTORY, cmbFind.Items.Text );

      CloseKey;

    End;

  End;

  regEntry.Free;

end;

procedure TfrmFinder.lbResultsClick(Sender: TObject);
begin

  If Not finding Then
    If lbResults.ItemIndex <> -1 Then
      updateStatus( 'Found in ''' +
                    ( lbResults.Items.Objects[ lbResults.ItemIndex ] As TFinderHit ).sTitle +
                    '''' );
                    
end;

end.
