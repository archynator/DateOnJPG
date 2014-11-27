DateOnJPG
=========

CLI tool to print an EXIF DateTimeOriginal value from JPEG file properties on a JPG image(s)

Hello everyone!
Since I couldn't find anything on the web that would suit my needs, I created this very useful batch processing utility to add EXIF DateTimeOriginal stamp on thousands of pictures in one go without the need to launch any software where you need to load pics in it, then adjust settings, etc, etc... Besides, most such programs are quite expensive shareware :( I advise to drop this file in Windows directory and use .bat file with command line parameters to execute it. Hopefully somebody else will find this thing useful too.

Possible parameter combinations:

1) DateOnJPG f FILENAME pos_x pos_y fontname fontsize fontstyle[BoldItalicUnderlineStrike] fontcolor[R G B] BG_transparency BG_color[R G B]

2) DateOnJPG d DIRECTORY filemask pos_x pos_y fontname fontsize fontstyle[BoldItalicUnderlineStrike] fontcolor[R G B] BG_transparency BG_color[R G B]

f - single file

FILENAME - single filename

d - directory

DIRECTORY - directory name. All files matching filemask in this directory will be processed (subdirectories not included). In .bat files it is useful to use "%CD%" wildcard here and drop the .bat where the pics are.

filemask - mask to filter out specific filenames in directory

pos_x - distance from left for the text output

pos_y - distance from top for the text output

fontname - Windows fontname

fontsize - font size (0-255)

fontstyle - To use this option delete from "BoldItalicUnderlineStrike" options that are not needed

fontcolor - Use 0 to 255 for each RGB color channel

BG_transparency - background transparency - 0 or 1 (1 is transparent)

BG_color - background color. Use 0 to 255 for each RGB color channel or can can be left empty if transparent background is used

Examples:

1) DateOnJPG d "C:\Users\Artis\Pictures" *.jpg 20 10 Tahoma 12 BoldUnderline 200 70 255 0 70 20 20
2) DateOnJPG f "C:\Users\Artis\Pictures\test.jpg" 10 20 Arial 18 ItalicUnderline 0 128 0 1
3) DateOnJPG d "%CD%" *.jpg 0 0 Courier 10 Bold 255 255 255 0 0 0 0

NOTE	Tool can also be run directly from any directory without command line parameters. If it will detect any .jpg image in that folder, it will ask whether to proccess them with default settings or not.
			Default settings are: pos_x,pos_y=0; fontname=Arial; fontsize=12; fontstyle=Bold; fontcolor=(255 0 0) - red, BG_transparency=TRUE, BG_color=(0 0 0) - black. 

WARNING:	This tool will overwrite original files without any confirmation, so make sure you have a backup!!!
					If not sure if output formatting will be satysfying, run some tests with few pictures in a separate folder to find best suitable settings before going big scale.

Best regards
Artis Avsjukovs
