Expert Guide For Windows
========================

Welcome
-------

Welcome to yet another Norton Guide reader written by me. This time, because
I'm playing around with Delphi, I've written a Windows version of Expert guide
(previous versions have been for OS/2, Dos and Linux). I'm sure you don't
need to be told what a Norton Guide reader is or how it works so don't expect
to find any docs.

WEG is released, under the GPL, with full source code. Please take the time
to read the file COPYING if you want to further enhance this software, in
fact, why not take the time to read it anyway?

Installation
------------

Currently WEG comes with no install system. All you need to do is copy
WEG.EXE to whereever you keep your Windows software and away you go. You may
want to use the Explorer to associate WEG.EXE with *.NG files so you can
view them with a double click.

Please note, WEG creates an entry in your registry, when removing WEG you
may also want to remove:

  HKEY_CURRENT_USER\Software\Hagbard's World\Expert Guide

If anyone knows of an OpenSource/FreeSoftware Installer/Uninstaller let me
know and I'll look at making use of that to automate the above.

Display Issues
--------------

As you can imagine, trying to get what are in effect DOS oriented files to
display correctly under Windows can be, err, fun. Because of the many and
varied display types, colour ranges and fonts what you see on your screen
probably won't be what I see on my screen. I developed and run WEG on a
1024x768 16bit High Colour display, I find the best font for the NG text is
MS LineDraw 10.

The DOS colour mapping is configurable via the preferences dialog so if the
default colours don't work for you you can play with them to your heart's
content. Failing that, you can turn off the full colour display in the same
dialog.

Latest Release
--------------

You'll always find the latest release of WEG at:

    http://www.acemake.com/hagbard/
or
    http://www.hagbard.demon.co.uk/

See the file Changes.Txt for details of what has changed in this and previous
releases.

Feedback
--------

Please feel free to send me any feedback, ideas, enhancement requests, bug
reports, bug fixes (even better) or anything else. I'd appreaciate if you
sent email concerining WEG to weg@hagbard.demon.co.uk, if you just want
a chat then use the email address at the end of this file.

Things To Do
------------

The following are things I'm planning to do or users have requested:

o Printing  - Re-write the print system in a more Windows like way. Perhaps
              provide support for colour printing?
o Artwork   - I need a really nice icon. Anyone an artist?
o Colour    - Make the tokenised (Bold, Reverse, etc...) colours configurable.
o Design    - WEG could really do with throwing away and starting again from
              scratch. It works, but I'd do it different next time.

Known bugs
----------

o None at the moment.

Thanks
------

Thanks go to:

o Arnold Johnson for his invaluable input.
o Mark 'Gomez' Adams for his "20% hack" when dealing with fonts and for
  the space on www.acemake.com.
o Viktor Trunov for his feedback and ideas and for testing WEG against
  Russian language guides.
o The inmates of comp.lang.clipper for their feedback, ideas and support.

Dave Pearson
davep@hagbard.demon.co.uk
