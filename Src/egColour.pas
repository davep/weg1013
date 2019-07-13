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

unit egColour;

interface

Type
  TEGColours = Class
    { Public instance variables }
    Public
      aDosMap     : Array[ 0.. 15 ] Of LongInt;

    { Public methods }
      Constructor Create;
      Procedure   loadUserPrefs;
      Procedure   saveUserPrefs;
      Function    map( iColour : Integer ) : LongInt;
      Function    normalText : LongInt;
      Function    normalBack : LongInt;
      Function    boldText   : LongInt;
      Function    boldBack   : LongInt;
      Function    revText    : LongInt;
      Function    revBack    : LongInt;
      Function    undlText   : LongInt;
      Function    undlBack   : LongInt;
      Function    selText    : LongInt;
      Function    selBack    : LongInt;
      Function    focText    : LongInt;
      Function    focBack    : LongInt;

    { Protected member variables }
    Protected
      iNormalText : Integer;
      iNormalBack : Integer;
      iBoldText   : Integer;
      iBoldBack   : Integer;
      iRevText    : Integer;
      iRevBack    : Integer;
      iUndlText   : Integer;
      iUndlBack   : Integer;
      iSelText    : Integer;
      iSelBack    : Integer;
      iFocText    : Integer;
      iFocBack    : Integer;
      
    { Protected methods }
      Procedure defaultColours;

  End;

implementation

Uses Registry, egConstants, SysUtils;

Constructor TEGColours.Create;
Begin

  { Set the default colours }
  defaultColours;

End;

Procedure TEGColours.loadUserPrefs;
Var
  regEntry : TRegistry;
  iColour  : Integer;
Begin

  regEntry := TRegistry.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, False ) Then
    Begin

      Try
        For iColour := 0 To 15 Do
        Begin
          aDosMap[ iColour ] := ReadInteger( REG_PREFS_COLOUR_DOSMAP + IntToStr( iColour ) );
        End;
      Except
        { We can't load them from the registry, re-set the defaults }
        defaultColours;
      End;

      CloseKey;
      
    End;

  End;

  regEntry.Free;

End;

Procedure TEGColours.saveUserPrefs;
Var
  regEntry : TRegistry;
  iColour  : Integer;
Begin

  regEntry := TRegistry.Create;

  With regEntry Do
  Begin

    If OpenKey( APP_REG_KEY, True ) Then
    Begin

      For iColour := 0 To 15 Do
      Begin
        WriteInteger( REG_PREFS_COLOUR_DOSMAP + IntToStr( iColour ), aDosMap[ iColour ] );
      End;

      CloseKey;

    End;

  End;

  regEntry.Free;

End;

Procedure TEGColours.defaultColours;
Begin

  { Set up the DOS colour mappings }
  aDosMap[ 00 ] := $000000; { Black     }
  aDosMap[ 01 ] := $800000; { Blue      }
  aDosMap[ 02 ] := $00A800; { Green     }
  aDosMap[ 03 ] := $A8A800; { Cyan      }
  aDosMap[ 04 ] := $0000A8; { Red       }
  aDosMap[ 05 ] := $A800A8; { Violet    }
  aDosMap[ 06 ] := $404080; { Brown     }
  aDosMap[ 07 ] := $C0C0C0; { White     }
  aDosMap[ 08 ] := $545454; { Hi-Black  }
  aDosMap[ 09 ] := $FF0000; { Hi-Blue   }
  aDosMap[ 10 ] := $00FF54; { Hi-Green  }
  aDosMap[ 11 ] := $FFFF54; { Hi-Cyan   }
  aDosMap[ 12 ] := $0000FF; { Hi-Red    }
  aDosMap[ 13 ] := $FF00FF; { Hi-Violet }
  aDosMap[ 14 ] := $00FFFF; { Hi-Brown  }
  aDosMap[ 15 ] := $FFFFFF; { Hi-White  }

  { Set up the default colours }
  iNormalText := 15;
  iNormalBack := 01;
  iBoldText   := 14;
  iBoldBack   := 01;
  iRevText    := 15;
  iRevBack    := 04;
  iUndlText   := 13;
  iUndlBack   := 01;
  iSelText    := 07;
  iSelBack    := 04;
  iFocText    := 15;
  iFocBack    := 04;

End;

Function TEGColours.map( iColour : Integer ) : LongInt;
Begin
  Result := aDosMap[ iColour ];
End;

Function TEGColours.normalText : LongInt; Begin Result := map( iNormalText ); End;
Function TEGColours.normalBack : LongInt; Begin Result := map( iNormalBack ); End;
Function TEGColours.boldText   : LongInt; Begin Result := map( iBoldText   ); End;
Function TEGColours.boldBack   : LongInt; Begin Result := map( iBoldBack   ); End;
Function TEGColours.revText    : LongInt; Begin Result := map( iRevText    ); End;
Function TEGColours.revBack    : LongInt; Begin Result := map( iRevBack    ); End;
Function TEGColours.undlText   : LongInt; Begin Result := map( iUndlText   ); End;
Function TEGColours.undlBack   : LongInt; Begin Result := map( iUndlBack   ); End;
Function TEGColours.selText    : LongInt; Begin Result := map( iSelText    ); End;
Function TEGColours.selBack    : LongInt; Begin Result := map( iSelBack    ); End;
Function TEGColours.focText    : LongInt; Begin Result := map( ifocText    ); End;
Function TEGColours.focBack    : LongInt; Begin Result := map( ifocBack    ); End;

end.
