{

     WEG - EXPERT GUIDE FOR WINDOWS
     Copyright (C) 1998 David A Pearson

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

program weg;

uses
  Forms,
  WegMainUnit in 'WegMainUnit.pas' {frmWegMain},
  ngGuide in 'ngGuide.pas',
  ngUtils in 'ngUtils.pas',
  ngMenu in 'ngMenu.pas',
  ngMenuItem in 'ngMenuItem.pas',
  ngEntry in 'ngEntry.pas',
  ngSeeAlso in 'ngSeeAlso.pas',
  frmAboutUnit in 'frmAboutUnit.pas' {frmAbout},
  frmPrefsUnit in 'frmPrefsUnit.pas' {frmPrefs},
  egConstants in 'egConstants.pas',
  FileHistoryList in 'FileHistoryList.pas',
  frmCopyrightUnit in 'frmCopyrightUnit.pas' {frmCopyright},
  frmWarrantyUnit in 'frmWarrantyUnit.pas' {frmWarranty},
  egColour in 'egColour.pas',
  frmFinderUnit in 'frmFinderUnit.pas' {frmFinder},
  egFinder in 'egFinder.pas',
  frmGuidesUnit in 'frmGuidesUnit.pas' {frmGuides},
  frmURLsUnit in 'frmURLsUnit.pas' {frmURLs},
  EntryHistoryList in 'EntryHistoryList.pas',
  frmBookmarksUnit in 'frmBookmarksUnit.pas' {frmBookmarks},
  frmAddBookmarkUnit in 'frmAddBookmarkUnit.pas' {frmAddBookmark};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Expert Guide';
  Application.CreateForm(TfrmWegMain, frmWegMain);
  Application.CreateForm(TfrmFinder, frmFinder);
  Application.CreateForm(TfrmGuides, frmGuides);
  Application.CreateForm(TfrmURLs, frmURLs);
  Application.CreateForm(TfrmBookmarks, frmBookmarks);
  Application.Run;
end.
