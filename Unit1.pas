unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils, StdCtrls, Dialogs, ExtCtrls, JPEG, CCR.Exif;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Test_label: TLabel;
    procedure ListDir(Path, Mask: String; List: TListBox);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function StrtoFontStyle(St: string): TFontStyles;
var
  S: TFontStyles;
begin
  S  := [];
  St := UpperCase(St);
  if St = 'BOLD' then S := [fsBold]
  else if St = 'ITALIC' then S := [fsItalic]
  else if St = 'UNDERLINE' then S := [fsUnderLine]
  else if St = 'STRIKEOUT' then S := [fsStrikeOut]

  else if St = 'BOLDITALIC' then S := [fsbold, fsItalic]
  else if St = 'BOLDUNDERLINE' then S := [fsBold, fsUnderLine]
  else if St = 'BOLDSTRIKE' then S := [fsBold, fsStrikeOut]

  else if St = 'BOLDITALICUNDERLINE' then S := [fsBold..fsUnderLine]
  else if St = 'BOLDITALICSTRIKE' then S := [fsBold, fsItalic, fsStrikeOut]
  else if St = 'BOLDUNDERLINESTRIKE' then S := [fsBold, fsUnderline, fsStrikeOut]
  else if St = 'BOLDITALICUNDERLINESTRIKE' then S := [fsBold..fsStrikeOut]

  else if St = 'ITALICUNDERLINE' then S := [fsItalic, fsUnderline]
  else if St = 'ITALICSTRIKE' then S := [fsItalic, fsStrikeOut]

  else if St = 'UNDERLINESTRIKE' then S := [fsUnderLine, fsStrikeOut]
  else if St = 'ITALICUNDERLINESTRIKE' then S := [fsItalic..fsStrikeOut];

  StrtoFontStyle := S;
end;

procedure TForm1.ListDir(Path, Mask: String; List: TListBox);
{Path : string that contains start path for listing filenames and directories
 List : List box in which found filenames are going to be stored }
var
SearchRec:TsearchRec;
Result:integer;
S:string; { Used to hold current directory, GetDir(0,s) }
begin
     try {Exception handler }
        ChDir(Path);
     except on EInOutError do
            begin
                 MessageDlg('Error changing directory!',mtWarning,[mbOK],0);
                 Application.Terminate;
            end;
     end;
     if length(path)<> 3 then path:=path+'\';   { Checking if path is root, if not add }
     FindFirst(path+mask,faAnyFile,SearchRec); { '\' at the end of the string         }
                                                { and then add '*.*' for all file     }
     Repeat
           If (SearchRec.Attr<>16) and //dir with ReadOnly attribute
           (SearchRec.Attr<>48) and    //dir with ReadOnly and Archive attribute
           (SearchRec.Attr<>18) and    //dir with ReadOnly and Hidden attribute
           (SearchRec.Attr<>50) and  //dir with all three parameters
           (SearchRec.Name<>'') then
//           begin
//                if CheckBox1.Checked then
//                if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then { Ignore '.' and '..' }
//                begin
//                     GetDir(0,s); { Get current dir of default drive }
//                     if length(s)<>3 then s:=s+'\'; { Checking if root }
//                     //List.Items.Add(s+SearchRec.Name); { Adding to list }
//                     ListDir(s+SearchRec.Name,Mask,List); { ListDir found directory }
//                end;
//           end
//           else { if not directory }
           begin
                GetDir(0,s); { Get current dir of default drive }
//                if length(s)<>3 then List.items.add(s+'\'+SearchRec.Name) { Checking if root }
                  // else List.items.add(s+SearchRec.Name); { Adding to list }
                  List.items.add(s+'\'+SearchRec.Name);
           end;
           Result:=FindNext(SearchRec);
           Application.ProcessMessages;
     until result<>0; { Found all files, go out }
     GetDir(0,s);
     //if length(s)<>3 then ChDir('..'); { if not root then go back one level }
end;

procedure TForm1.FormCreate(Sender: TObject);
var i, FontR, FontG, FontB, BgR, BgG, BgB, f_size: byte;
    pos_x, pos_y, x: Integer;
    f_style: TFontStyles;
    BgTp: boolean;
    f_name, file_name, dir_name, f_mask, img_date: string;
    file_list: TListBox;
    tmp_img: TImage;
    jpeg: TJPEGImage;
    bmp: TBitmap;
    ExifData: TExifData;
label processing, finished;
begin
    //Add in final compilation
    Application.ShowMainForm:=False; //Hide main form

    //Initializing default file & directory name
    file_name:='';//ExtractFileDir(Application.ExeName)+'\2014-06-11 07-04-34.jpg'; //Change to '' in final compilation
    dir_name:=ExtractFileDir(Application.ExeName);

    //Initializing default file mask
    f_mask:='*.jpg';

    //Initializing default position
    pos_x:=0;
    pos_y:=0;

    //Initializing default font name
    f_name:='Arial';

    //Initializing default font size
    f_size:=12;

    //Initializing default font style
    f_style:=[fsBold];

    //Initializing red fonts
    FontR:=255;
    FontG:=0;
    FontB:=0;

    //Initializing transparent background
    BgTp:=False;

    //Initializing black background
    BgR:=0;
    BgG:=0;
    BgB:=0;

    //Loading individual file
    i:=1;
    if ParamStr(i)='f' then
    begin
        file_name:=ParamStr(i+1);
        if FileExists(file_name) then
            Label2.Caption:=file_name
        else
        begin
            Label2.Caption:='File not found!';
            MessageDlg('Specified file not found! - '+file_name,mtWarning,[mbOK],0);
            Application.Terminate;
        end;
        i:=i+2;
    end
    else
    //Loading directory
    if ParamStr(i)='d' then
    begin
        dir_name:=ParamStr(i+1);
        if DirectoryExists(dir_name) then
            Label4.Caption:=dir_name
        else
        begin
            Label4.Caption:='Directory not found!';
            MessageDlg('Specified directory not found! - '+dir_name,mtWarning,[mbOK],0);
            Application.Terminate;
        end;

        //Loading file mask
        If ParamStr(i+2)<>'' then
            f_mask:=ParamStr(i+2);
        Label18.Caption:=f_mask; //Set file mask
        i:=i+3;
    end;

    //Pos X
    if ParamStr(i)<>'' then
        pos_x:=StrToInt(ParamStr(i));
    Label6.Caption:=ParamStr(i);
    //Pos Y
    if ParamStr(i+1)<>'' then
        pos_y:=StrToInt(ParamStr(i+1));
    Label8.Caption:=ParamStr(i+1);

    //Font name,size,style
    i:=i+2;
    if ParamStr(i)<>'' then
        f_name:=ParamStr(i);
    if ParamStr(i+1)<>'' then
        f_size:=StrToInt(ParamStr(i+1));
    if ParamStr(i+2)<>'' then
        f_style:=StrToFontStyle(ParamStr(i+2));

    Test_label.Font.Name:=f_name;
    Test_label.Font.Size:=f_size;
    Test_label.Font.Style:=f_style;
    Label10.Caption:=f_name+' '+IntToStr(f_size)+' '+ParamStr(i+2);

    //Loading font color
    i:=i+3;
    if ParamStr(i)<>'' then
        FontR:=StrToInt(ParamStr(i));
    if ParamStr(i+1)<>'' then
        FontG:=StrToInt(ParamStr(i+1));
    if ParamStr(i+2)<>'' then
        FontB:=StrToInt(ParamStr(i+2));

    Test_label.Font.Color:=RGB(FontR,FontG,FontB);
    Label16.Caption:='('+IntToStr(FontR)+','+IntToStr(FontG)+','+IntToStr(FontB)+')';

    //Loading background transparency
    i:=i+3;
    if ParamStr(i)<>'' then
        BgTp:=StrToBool(ParamStr(i));
    Test_label.Transparent:=BgTp;
    Label12.Caption:=IfThen(BgTp,'True','False');

    //Loading background color
    i:=i+1;
    if ParamStr(i)<>'' then
        BgR:=StrToInt(ParamStr(i));
    if ParamStr(i+1)<>'' then
        BgG:=StrToInt(ParamStr(i+1));
    if ParamStr(i+2)<>'' then
        BgB:=StrToInt(ParamStr(i+2));

    if BgTp=False then
        Test_label.Color:=RGB(BgR,BgG,BgB);
    Label14.Caption:='('+IntToStr(BgR)+','+IntToStr(BgG)+','+IntToStr(BgB)+')';

    //Creating file list
    file_list:=TListBox.Create(Owner);
    file_list.Parent:=Form1;
//    file_list.Top:=50;
//    file_list.Left:=110;
//    file_list.Width:=600;//ClientWidth-file_list.Left;
//    file_list.Height:=Label14.Top+Label14.Height-file_list.Top;
//    file_list.Visible:=True;

    //Creating TImage component (can be removed in final compilation)
//    tmp_img:=TImage.Create(Form1);
//    tmp_img.Parent:=Form1;
//    tmp_img.Top:=170;
//    tmp_img.Left:=5;
//    tmp_img.AutoSize:=True;
//    //tmp_img.Width:=ClientWidth;
//    //tmp_img.Height:=ClientHeight-tmp_img.Top;
//    tmp_img.Visible:=True;

    //Loading directory listing
    if file_name<>'' then
        file_list.Items.Append(file_name)
    else
        ListDir(dir_name, f_mask, file_list);

    //Loading JPEG image
    if (file_list.Items.Count>0) and (ParamStr(1)='') then
        if MessageDlg('Process all .jpg images in current folder with default settings?',mtConfirmation, mbOKCancel, 0) = mrOK then
            GoTo processing
        else
            GoTo finished;

processing:

    //Creating objects
    ExifData := TExifData.Create;
    jpeg:=TJPEGImage.Create;
    bmp:=TBitmap.Create;
    try
        for x:=0 to file_list.Items.Count - 1 do
        begin

            //Extracting EXIF OriginalDateTime
            ExifData.LoadFromGraphic(file_list.Items[x]); //LoadFromJPEG before v1.5.0
            img_date:=ExifData.DateTimeOriginal.AsString;  //returns an empty string if tag doesn't exist

            jpeg.LoadFromFile(file_list.Items[x]);
            bmp.Assign(jpeg);

            //Setting up font style
            bmp.Canvas.Font.Name:=f_name;
            bmp.Canvas.Font.Size:=f_size;
            bmp.Canvas.Font.Style:=f_style;
            bmp.Canvas.Font.Color:=RGB(FontR,FontG,FontB);
            if BgTp then
                bmp.Canvas.Brush.Style:=bsClear
            else
            begin
                bmp.Canvas.Brush.Style:=bsSolid;
                bmp.Canvas.Brush.Color:=RGB(BgR,BgG,BgB);
            end;
            bmp.Canvas.TextOut(pos_x,pos_y,img_date);
            //tmp_img.Picture.Bitmap.Assign(bmp); //Remove in final compilation
            jpeg.Assign(bmp);

            //Saving JPEG and Exif data to a file
            jpeg.SaveToFile(file_list.Items[x]);
            ExifData.SaveToGraphic(file_list.Items[x]);
        end;
    finally
        ExifData.Free;
        bmp.free;
        jpeg.free;
    end;

    //Remove in final compilation
    //Form1.Height:=tmp_img.Top+tmp_img.Height+42;
    //Form1.Width:=tmp_img.Left+tmp_img.Width+20;

finished:
    file_list.Free;
    //tmp_img.Free;
    Application.Terminate;
end;

end.
