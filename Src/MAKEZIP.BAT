  @Echo Off

  SetLocal

  Set _Ver_=%@ExecStr[grep ProductVersion weg.dof | sed -e 's/.*=\(.*\)/\1/']
  Set _Ver_=%@Replace[.,,%_Ver_]

  MkDir weg%_VER_
  MkDir weg%_VER_\Src

  Del weg%_VER_ /qy
  Del weg%_VER_\Src /qy

  Copy *.Pas       weg%_VER_\Src
  Copy *.Dfm       weg%_VER_\Src
  Copy *.Ico       weg%_VER_\Src
  Copy *.Res       weg%_VER_\Src
  Copy *.Dpr       weg%_VER_\Src
  Copy *.Dof       weg%_VER_\Src
  Copy *.Bmp       weg%_VER_\Src
  Copy MakeZip.Bat weg%_VER_\Src

  Copy weg.exe     weg%_VER_
  Copy ReadMe.Txt  weg%_VER_
  Copy Changes.Txt weg%_VER_
  Copy COPYING     weg%_VER_

  Zip -r weg%_VER_.zip weg%_VER_\*
