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

unit frmURLsUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmURLs = class(TForm)
    lbURLs: TListBox;
    pbClose: TButton;
    pbBrowse: TButton;
    procedure pbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbBrowseClick(Sender: TObject);
    procedure lbURLsKeyPress(Sender: TObject; var Key: Char);
  private
    Procedure huntForURL( sType : String; sText : String );
    Function  extractURL( s : String; iPos : Integer ) : String;
  public
    { Public declarations }
  end;

var
  frmURLs: TfrmURLs;

implementation

uses WegMainUnit, ngUtils;

{$R *.DFM}

procedure TfrmURLs.pbCloseClick(Sender: TObject);
begin
  Close;
end;

{ The following code is pretty lame, I could do this a lot easier if Delphi
  had a regular expression engine. }
  
procedure TfrmURLs.FormShow(Sender: TObject);
Var
  iSavCsr : Integer;
  iLine   : Integer;
  iLines  : Integer;
  iFocus  : Integer;
begin

  iSavCsr       := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  iLines        := frmWegMain.lbText.Items.Count - 1;
  iFocus        := 0;

  For iLine := 0 To iLines Do
  Begin

    huntForURL( 'HTTP',   frmWegMain.lbText.Items[ iLine ] );
    huntForURL( 'FTP',    frmWegMain.lbText.Items[ iLine ] );
    huntForURL( 'NEWS',   frmWegMain.lbText.Items[ iLine ] );
    huntForURL( 'MAILTO', frmWegMain.lbText.Items[ iLine ] );
    
  End;

  lbURLs.Enabled   := lbURLs.Items.Count > 0;
  pbBrowse.Enabled := lbURLs.Items.Count > 0;

  If lbURLs.Enabled Then
    lbURLs.ItemIndex := iFocus;

  Screen.Cursor    := iSavCsr;

end;

Procedure TfrmURLs.huntForURL( sType : String; sText : String );
Var
  iURLPos : Integer;
Begin

  iURLPos := Pos( AnsiUpperCase( sType + ':' ), AnsiUpperCase( sText ) );

  If iURLPos > 0 Then
    lbURLs.Items.Add( extractURL( sText, iURLPos ) );

End;

Function TfrmURLs.extractURL( s : String; iPos : Integer ) : String;
Var
  bEOU : Boolean;
  iMax : Integer;
Begin

  bEOU   := False;
  iMax   := Length( s );
  Result := '';

  While ( Not bEOU ) And ( iPos <= iMax ) Do
  Begin

    { This isn't the smartest way of doing things but it will do for now. If
      only Delphi had native regular expression support.... }
    If Pos( s[ iPos ], ' ",;''' ) = 0 Then
      Result := Result + s[ iPos ]
    Else
      bEOU := True;

    Inc( iPos );

  End;

End;

procedure TfrmURLs.pbBrowseClick(Sender: TObject);
begin
  FireURL( Application, lbURLs.Items[ lbURLs.ItemIndex ] );
end;


procedure TfrmURLs.lbURLsKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then
    pbBrowseClick( Nil );
end;

end.
