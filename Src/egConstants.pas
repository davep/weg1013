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

unit egConstants;

interface

Const

  { Application's registry entry key }
  APP_REG_KEY                  = 'Software\Hagbard''s World\Expert Guide';

  { Last guide used }
  REG_LAST_GUIDE               = 'Last Guide';
  REG_LAST_ENTRY               = 'Last Entry';
  REG_LAST_LINE                = 'Last Line';

  { Location/content details of the main form }
  REG_FORM_TOP                 = 'Form.Top';
  REG_FORM_LEFT                = 'Form.Left';
  REG_FORM_WIDTH               = 'Form.Width';
  REG_FORM_HEIGHT              = 'Form.Height';
  REG_FORM_SPLIT               = 'Form.Split';

  { Location/content details of the guide manager }
  REG_GUIDES_TOP               = 'Guides.Top';
  REG_GUIDES_LEFT              = 'Guides.Left';
  REG_GUIDES_WIDTH             = 'Guides.Width';
  REG_GUIDES_HEIGHT            = 'Guides.Height';
  REG_GUIDES_TITLE_WIDTH       = 'Guides.Titles.Width';
  REG_GUIDES_NAMES_WIDTH       = 'Guides.Names.Width';
  REG_FILE_DIRECTORY_NAMES     = 'Directory.Names';
  REG_FILE_DIRECTORY_TITLES    = 'Directory.Titles';

  { Location/content details of the boomkarks manager }
  REG_BOOKMARKS_TOP            = 'Bookmarks.Top';
  REG_BOOKMARKS_LEFT           = 'Bookmarks.Left';
  REG_BOOKMARKS_WIDTH          = 'Bookmarks.Width';
  REG_BOOKMARKS_HEIGHT         = 'Bookmarks.Height';
  REG_BOOKMARKS_MARKS          = 'Bookmarks.Marks';
  REG_BOOKMARKS_GUIDES         = 'Bookmarks.Guides';
  REG_BOOKMARKS_OFFSETS        = 'Bookmarks.Offsets';

  { Location/content details of the guide wide finder }
  REG_FINDER_TOP               = 'Finder.Top';
  REG_FINDER_LEFT              = 'Finder.Left';
  REG_FINDER_WIDTH             = 'Finder.Width';
  REG_FINDER_HEIGHT            = 'Finder.Height';
  REG_FINDER_ONTOP             = 'Finder.StayOnTop';
  REG_FINDER_HISTORY           = 'Finder.History';

  { User preferences }
  REG_PREFS_DEF_DIR            = 'Prefs.DefaultGuideDir';
  REG_PREFS_TEXT_FONT_NAME     = 'Prefs.TextFont.Name';
  REG_PREFS_TEXT_FONT_CHARSET  = 'Prefs.TextFont.CharSet';
  REG_PREFS_TEXT_FONT_PITCH    = 'Prefs.TextFont.Pitch';
  REG_PREFS_TEXT_FONT_SIZE     = 'Prefs.TextFont.Size';
  REG_PREFS_USE_COLOUR         = 'Prefs.UseColour';
  REG_PREFS_COLOUR_DOSMAP      = 'Prefs.Colour.DosMap.';
  REG_PREFS_OEM_TO_ANSI        = 'Prefs.OemToANSI';
  REG_PREFS_SINGLE_CLICK_JUMPS = 'Prefs.SingleClickJumps';
  REG_PREFS_NAME_IN_TITLE      = 'Prefs.GuideNameInWindowTitle';

  { File history }
  REG_FILE_HISTORY_NAMES       = 'History.Names';
  REG_FILE_HISTORY_TITLES      = 'History.Titles';

implementation
  
end.
