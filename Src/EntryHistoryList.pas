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

unit EntryHistoryList;

interface

Uses Classes;

Type
  TEntryHistoryItem = Class
    Public
    { Public member variables }
      sGuide : String;
      lEntry : LongInt;
      iLine  : Integer;

    { Public methods }
      Constructor Create( sGuide : String; lEntry : LongInt; iLine : Integer );

  End;

  TEntryHistoryList = Class
    Public
    { Public member variables }
      iMaxEntries : Integer;

    { Public methods }
      Constructor Create;
      Destructor  Destroy; Override;
      Procedure   push( oItem : TEntryHistoryItem );
      Function    pop : TEntryHistoryItem;
      Procedure   clear;
      Function    empty : Boolean;

    Protected
    {Protected member variables }
      slList : TStringList;
      
  End;

implementation

Uses ngUtils;

Constructor TEntryHistoryItem.Create( sGuide : String; lEntry : LongInt; iLine : Integer );
Begin
  self.sGuide := sGuide;
  self.lEntry := lEntry;
  self.iLine  := iLine;
End;

Constructor TEntryHistoryList.Create;
Begin
  slList      := TStringList.Create;
  iMaxEntries := 42; { Well, it had to be didn't it? }
End;

Destructor TEntryHistoryList.Destroy;
Begin
  DestroyStringListObjects( slList );
  slList.Free;
End;

Procedure TEntryHistoryList.push( oItem : TEntryHistoryItem );
Begin
  If slList.Count = iMaxEntries Then
    slList.Delete( 0 );
  slList.AddObject( '', oItem );
End;

Function TEntryHistoryList.pop : TEntryHistoryItem;
Begin
  Result := ( slList.Objects[ slList.Count - 1 ] As TEntryHistoryItem );
  slList.Delete( slList.Count - 1 );
End;

Procedure TEntryHistoryList.clear;
Begin
  DestroyStringListObjects( slList );
  slList.Clear;
End;

Function TEntryHistoryList.empty : Boolean;
Begin
  Result := slList.Count = 0;
End;

end.
