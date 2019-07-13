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

unit frmPrefsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Registry, ExtCtrls;

type
  TfrmPrefs = class(TForm)
    pbOk: TButton;
    pbCancel: TButton;
    edtGuideDir: TEdit;
    lblGuideDir: TLabel;
    dlgFont: TFontDialog;
    pbTextFont: TButton;
    pnlTextFont: TPanel;
    cbUseColour: TCheckBox;
    dlgColour: TColorDialog;
    lblNormal: TLabel;
    lblBright: TLabel;
    lblBlack: TLabel;
    lblBlue: TLabel;
    lblGreen: TLabel;
    lblCyan: TLabel;
    lblRed: TLabel;
    lblViolet: TLabel;
    lblBrown: TLabel;
    lblWhite: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    pbResetColours: TButton;
    Label1: TLabel;
    Label2: TLabel;
    pbSelFolder: TButton;
    cbOemToAnsi: TCheckBox;
    cbSingleClick: TCheckBox;
    cbGuideTitle: TCheckBox;
    procedure pbOkClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pbTextFontClick(Sender: TObject);
    procedure dosMapchangeColour(Sender: TObject);
    procedure pbResetColoursClick(Sender: TObject);
    procedure pbSelFolderClick(Sender: TObject);
  private
    { Private declarations }
    regEntry : TRegistry;
    aColours : Array[ 0..15 ] Of TPanel;
  public
    { Public declarations }
  end;

var
  frmPrefs: TfrmPrefs;

implementation

Uses ngUtils, egConstants, WegMainUnit, egColour;

{$R *.DFM}

procedure TfrmPrefs.pbOkClick(Sender: TObject);
Var
  i : Integer;
begin

  If regEntry.OpenKey( APP_REG_KEY, True ) Then
  Begin

    With regEntry Do
    Begin

      WriteString(  REG_PREFS_DEF_DIR,            edtGuideDir.Text );
      WriteString(  REG_PREFS_TEXT_FONT_NAME,     pnlTextFont.Font.Name );
      WriteInteger( REG_PREFS_TEXT_FONT_CHARSET,  pnlTextFont.Font.CharSet );
      WriteInteger( REG_PREFS_TEXT_FONT_PITCH,    Integer( pnlTextFont.Font.Pitch ) );
      WriteInteger( REG_PREFS_TEXT_FONT_SIZE,     pnlTextFont.Font.Size );
      WriteBool(    REG_PREFS_USE_COLOUR,         cbUseColour.Checked );
      WriteBool(    REG_PREFS_OEM_TO_ANSI,        cbOemToAnsi.Checked );
      WriteBool(    REG_PREFS_SINGLE_CLICK_JUMPS, cbSingleClick.Checked );
      WriteBool(    REG_PREFS_NAME_IN_TITLE,      cbGuideTitle.Checked );

      frmWegMain.lbText.Font := pnlTextFont.Font;
      frmWegMain.setOemToAnsi( cbOemToAnsi.Checked );
      frmWegMain.setSingleClickJump( cbSingleClick.Checked );
      frmWegMain.setTextStyle( cbUseColour.Checked );
      frmWegMain.setNameInTitle( cbGuideTitle.Checked );
      frmWegMain.refreshTextItemHeight;
      
      CloseKey;

    End;
    
  End;

  With frmWegMain.oColours Do
  Begin

    For i := 0 To 15 Do
    Begin
      aDosMap[ i ] := aColours[ i ].Color;
    End;

    saveUserPrefs;

    If cbUseColour.Checked Then
    Begin
      frmWegMain.lbText.Color := normalBack;
      frmWegMain.lbText.Invalidate;
    End;
    
  End;

  Close;
  
end;

procedure TfrmPrefs.pbCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrefs.FormCreate(Sender: TObject);
begin

  regEntry := TRegistry.Create;

  aColours[ 00 ] := Panel1;
  aColours[ 01 ] := Panel2;
  aColours[ 02 ] := Panel3;
  aColours[ 03 ] := Panel4;
  aColours[ 04 ] := Panel5;
  aColours[ 05 ] := Panel6;
  aColours[ 06 ] := Panel7;
  aColours[ 07 ] := Panel8;
  aColours[ 08 ] := Panel9;
  aColours[ 09 ] := Panel10;
  aColours[ 10 ] := Panel11;
  aColours[ 11 ] := Panel12;
  aColours[ 12 ] := Panel13;
  aColours[ 13 ] := Panel14;
  aColours[ 14 ] := Panel15;
  aColours[ 15 ] := Panel16;

end;

procedure TfrmPrefs.FormDestroy(Sender: TObject);
begin
  regEntry.Free;
end;

procedure TfrmPrefs.FormActivate(Sender: TObject);
Var
  i : Integer;
begin

  If regEntry.OpenKey( APP_REG_KEY, False ) Then
  Begin

    With regEntry Do
    Begin

      Try
        edtGuideDir.Text         := ReadString( REG_PREFS_DEF_DIR );
        pnlTextFont.Font.Name    := ReadString( REG_PREFS_TEXT_FONT_NAME );
        pnlTextFont.Font.CharSet := ReadInteger( REG_PREFS_TEXT_FONT_CHARSET );
        pnlTextFont.Font.Pitch   := TFontPitch( ReadInteger( REG_PREFS_TEXT_FONT_PITCH ) );
        pnlTextFont.Font.Size    := ReadInteger( REG_PREFS_TEXT_FONT_SIZE );
        pnlTextFont.Caption      := pnlTextFont.Font.Name;
      Except
        pnlTextFont.Font         := frmWegMain.lbText.Font;
        pnlTextFont.Caption      := frmWegMain.lbText.Font.Name;
      End;

      Try
        cbUseColour.Checked := ReadBool( REG_PREFS_USE_COLOUR );
      Except
        cbUseColour.Checked := True;
      End;

      Try
        cbOemToAnsi.Checked := ReadBool( REG_PREFS_OEM_TO_ANSI );
      Except
        cbOemToAnsi.Checked := False;
      End;

      Try
        cbSingleClick.Checked := ReadBool( REG_PREFS_SINGLE_CLICK_JUMPS );
      Except
        cbSingleClick.Checked := False;
      End;

      Try
        cbGuideTitle.Checked := ReadBool( REG_PREFS_NAME_IN_TITLE );
      Except
        cbGuideTitle.Checked := False;
      End;

      CloseKey;
      
    End;

  End;

  With frmWegMain.oColours Do
  Begin
    For i := 0 To 15 Do
    Begin
      aColours[ i ].Color := map( i );
    End;
  End;

end;

procedure TfrmPrefs.pbTextFontClick(Sender: TObject);
begin
  dlgFont.Font := pnlTextFont.Font;
  If dlgFont.Execute Then
  Begin
    pnlTextFont.Font    := dlgFont.Font;
    pnlTextFont.Caption := dlgFont.Font.Name;
  End;
end;

procedure TfrmPrefs.dosMapchangeColour(Sender: TObject);
begin

  dlgColour.Color := ( Sender As TPanel ).Color;

  If dlgColour.Execute Then
    ( Sender As TPanel ).Color := dlgColour.Color;

end;

procedure TfrmPrefs.pbResetColoursClick(Sender: TObject);
Var
  oDefClrs : TEGColours;
  i        : Integer;
begin

  oDefClrs := TEGColours.Create;

  For i := 0 To 15 Do
  Begin
    aColours[ i ].Color := oDefClrs.aDosMap[ i ];
  End;

  oDefClrs.Free;

end;

procedure TfrmPrefs.pbSelFolderClick(Sender: TObject);
Var
  sFolder : String;
begin

  sFolder := SelectFolder( 'Default Guide Directory' );

  If sFolder <> '' Then
    edtGuideDir.Text := sFolder;
    
end;

end.
