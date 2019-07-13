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

unit frmAboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmAbout = class(TForm)
    pbOk: TButton;
    lblVersion: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    gbGuideCredits: TGroupBox;
    memCredits: TMemo;
    imgIcon: TImage;
    lblWarranty: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblCopying: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure pbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure URLClick(Sender: TObject);
    procedure lblCopyingClick(Sender: TObject);
    procedure lblWarrantyClick(Sender: TObject);
    procedure FireEmailUrl(Sender: TObject);
    Function  AppVersion : String;
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses ngUtils, WegMainUnit, ShellAPI, frmCopyrightUnit, frmWarrantyUnit;

{$R *.DFM}

procedure TfrmAbout.pbOkClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
Var
  sVersion : String;
begin

  sVersion := AppVersion;

  If sVersion <> '' Then
    lblVersion.Caption := 'Expert Guide For Windows v' + sVersion +
                          ', Copyright (C) 1998,1999 Dave Pearson';

  If frmWegMain.ng.IsOpen Then
  Begin
    memCredits.Font := frmWegMain.lbText.Font;
    memCredits.Text := frmWegMain.ng.credits;
  End;

end;

procedure TfrmAbout.URLClick(Sender: TObject);
begin
  FireURL( Application, PChar( ( Sender As TLabel ).Caption ) );
end;

procedure TfrmAbout.lblCopyingClick(Sender: TObject);
Var
  frmCopyright : TfrmCopyright;
begin
  frmCopyright := TfrmCopyright.Create( self );
  frmCopyright.showModal;
  frmCopyright.Free;
end;

procedure TfrmAbout.lblWarrantyClick(Sender: TObject);
Var
  frmWarranty : TfrmWarranty;
begin
  frmWarranty := TfrmWarranty.Create( self );
  frmWarranty.ShowModal;
  frmWarranty.Free;
end;

procedure TfrmAbout.FireEmailUrl(Sender: TObject);
begin
  If ShellExecute( Application.MainForm.Handle, nil,
                   PChar( 'mailto:' + ( Sender As TLabel ).Caption ),
                   PChar( '' ), PChar( '' ), SW_SHOWNORMAL ) <= 32 Then
    MessageDlg( 'Unable to invoke mail client', mtError, [ mbOk ], 0 );
end;

Function TfrmAbout.AppVersion : String;
Var
  pcBuff    : PChar;
  dwBuffLen : DWord;
  dwDummy   : DWord;
  pVersion  : Pointer;
  uiVerLen  : UInt;
Begin

  Result    := '';
  dwBuffLen := GetFileVersionInfoSize( PChar( Application.ExeName ), dwDummy );

  If dwBuffLen <> 0 Then
  Begin

    Try
      GetMem( pcBuff, dwBuffLen + 1 );
      Try
        If GetFileVersionInfo( PChar( Application.ExeName ), 0, dwBuffLen, pcBuff ) Then
          If VerQueryValue( pcBuff, '\\StringFileInfo\\080904E4\\ProductVersion',
                            pVersion, uiVerLen ) Then
            Result := PChar( pVersion );
      Finally
        FreeMem( pcBuff );
      End;
    Finally
      { Do Nothing }
    End;

  End;

End;

end.
