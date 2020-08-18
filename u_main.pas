unit u_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, CheckLst, Buttons, Dos, lclintf, Menus, u_about_us, IniFiles, Clipbrd,
  contnrs;

type

  { TFMain }

  { TMyObject }

  TMyObject = class(TObject)
  public
    Findex: Integer;
    constructor Create(index: Integer);

  end;


  TFMain = class(TForm)
    btn_select: TSpeedButton;
    btn_apply: TButton;
    chk_copy: TCheckBox;
    cbxHidden: TCheckBox;
    ed_times: TEdit;
    ed_1: TEdit;
    ed_2: TEdit;
    edtDirectory: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbl_times: TLabel;
    ListBox1: TCheckListBox;
    ListBox2: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    mn_selectAll: TMenuItem;
    mn_unSelectAll: TMenuItem;
    mn_INC: TMenuItem;
    mn_RN: TMenuItem;
    mn_RNA: TMenuItem;
    mnCopy: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pm: TPopupMenu;
    pm2: TPopupMenu;
    pm_pattern: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    btn_pattern: TSpeedButton;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure btn_patternClick(Sender: TObject);
    procedure btn_selectClick(Sender: TObject);
    procedure btn_applyClick(Sender: TObject);
    procedure chk_copyChange(Sender: TObject);
    procedure edtDirectoryChange(Sender: TObject);
    procedure ed_1Change(Sender: TObject);
    procedure ed_2Change(Sender: TObject);
    procedure ed_timesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ListBox1ClickCheck(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure mn_selectAllClick(Sender: TObject);
    procedure mn_INCClick(Sender: TObject);
    procedure mnCopyClick(Sender: TObject);
    procedure mn_RNAClick(Sender: TObject);
    procedure mn_RNClick(Sender: TObject);
    procedure mn_unSelectAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FList: TFPObjectList;
    procedure setTimesStatus;

  public
    procedure showListFile;
    procedure showResult;
  end;

var
  FMain: TFMain;

implementation

{$R *.lfm}

{ TMyObject }

constructor TMyObject.Create(index: Integer);
begin
  inherited Create;
  Findex:= index;
end;

{ TFMain }

procedure TFMain.btn_selectClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then begin
     edtDirectory.Text:= SelectDirectoryDialog1.FileName;
     showListFile;
  end;
end;

procedure TFMain.btn_patternClick(Sender: TObject);
begin
  pm_pattern.PopUp;
end;

procedure TFMain.btn_applyClick(Sender: TObject);
var
  i, n, j: Integer;
  msg: string;
  obj: TFPObjectList;
begin
  if not DirectoryExists(edtDirectory.Text) then begin
     MessageDlg('Directory is not exits. Operation can not be done.', mtInformation, [mbOK], 0);
     Exit;
  end;

  n:= 0;

  for i:=0 to ListBox1.Items.Count-1 do
    if ListBox1.Checked[i] then begin
      obj:= TFPObjectList(FList.Items[i]);
      for j:=0 to obj.Count - 1 do begin
        if chk_copy.Checked then begin
          if ListBox1.items.Strings[i] <>  ListBox2.items.Strings[TMyObject(obj.Items[j]).Findex] then begin

            inc(n);
            CopyFile(edtDirectory.Text + '\' + ListBox1.Items.Strings[i],
                     edtDirectory.Text + '\' + ListBox2.items.Strings[TMyObject(obj.Items[j]).Findex]);
          end;

        end else begin //jadi rename

          if ListBox1.items.Strings[i] <>  ListBox2.items.Strings[TMyObject(obj.Items[0]).Findex] then begin
            inc(n);
            RenameFile(edtDirectory.Text + '\' + ListBox1.Items.Strings[i],
              edtDirectory.Text + '\' + ListBox2.items.Strings[TMyObject(obj.Items[0]).Findex]);
          end;

        end;
      end;


    end;

    {
    if ListBox1.Checked[i] and (ListBox1.Items.Strings[i]<>ListBox2.Items.Strings[i]) then begin
       inc(n);
       if chk_copy.Checked then begin

         CopyFile(edtDirectory.Text + '\' + ListBox1.Items.Strings[i],edtDirectory.Text + '\' + ListBox2.Items.Strings[i])
       end else
         RenameFile(edtDirectory.Text + '\' + ListBox1.Items.Strings[i],
           edtDirectory.Text + '\' + ListBox2.Items.Strings[i]);
    end;
    }
  if chk_copy.Checked then begin
     if n = 0 then
       msg:= 'No copy done.'
     else
       msg:= IntToStr(n) + ' files copied.';
  end else begin
    if n = 0 then
      msg:= 'No changed found.'
    else
      msg:= IntToStr(n) + ' files changed.';
  end;

  MessageDlg(msg, mtInformation, [mbOK], 0);
  showListFile;

end;

procedure TFMain.chk_copyChange(Sender: TObject);
begin
  setTimesStatus;
end;

procedure TFMain.edtDirectoryChange(Sender: TObject);
begin
  showListFile;

  //ShowMessage(GetAppConfigDir(True));
  with TIniFile.Create(GetAppConfigDir(True) +'renamer.ini',[]) do begin
     WriteString('SETTING','LAST_FOLDER',  edtDirectory.Text);
     Free;
  end;

end;

procedure TFMain.ed_1Change(Sender: TObject);
begin
  showResult;
end;

procedure TFMain.ed_2Change(Sender: TObject);
begin
  showResult;
end;

procedure TFMain.ed_timesChange(Sender: TObject);
begin
  showResult;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  with TIniFile.Create(GetAppConfigDir(True) +'renamer.ini',[]) do begin
    edtDirectory.Text:= ReadString('SETTING','LAST_FOLDER','');
    Free;
  end;
  setTimesStatus;
end;

procedure TFMain.Image1Click(Sender: TObject);
begin
  OpenURL('https://paypal.me/mambamaestro');
  //OpenURL('https://www.google.com/');
end;

procedure TFMain.Image2Click(Sender: TObject);
begin
  pm.PopUp;
end;

procedure TFMain.ListBox1ClickCheck(Sender: TObject);
begin
  showResult;
end;

procedure TFMain.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  obj: TFPObjectList;
  i: Integer;
begin
  {remove checked}
  for i:=0 to ListBox2.Count - 1 do
    ListBox2.Selected[i]:= False;


  obj:= TFPObjectList(FList.Items[ListBox1.ItemIndex]);
  for i:= 0 to obj.Count - 1 do
    ListBox2.Selected[TMyObject(obj.Items[i]).Findex]:= True;

  //ListBox2.Selected[ListBox1.ItemIndex]:= True;
end;

procedure TFMain.ListBox1SelectionChange(Sender: TObject; User: boolean);
var
  obj: TFPObjectList;
  i: Integer;
begin
  {remove checked}
  for i:=0 to ListBox2.Count - 1 do
    ListBox2.Selected[i]:= False;


  obj:= TFPObjectList(FList.Items[ListBox1.ItemIndex]);
  for i:= 0 to obj.Count - 1 do
    ListBox2.Selected[TMyObject(obj.Items[i]).Findex]:= True;

  //ListBox2.Selected[ListBox1.ItemIndex]:= True;
end;

procedure TFMain.MenuItem1Click(Sender: TObject);
begin
  //
  OpenURL('https://youtu.be/6L64WPVNYKM');
end;

procedure TFMain.MenuItem2Click(Sender: TObject);
begin
  FAboutUs.ShowModal;
end;

procedure TFMain.mn_selectAllClick(Sender: TObject);
var i: Integer;
begin
  for i:=0 to ListBox1.Count - 1 do
    ListBox1.Selected[i]:= True;

end;

procedure TFMain.mn_INCClick(Sender: TObject);
var
  s: string;
  pos_start: Integer;
begin
  s:= ed_2.Text;
  pos_start:= ed_2.SelStart;
  s:= LeftStr(s, ed_2.SelStart) + '[INC]' + RightStr(s, Length(s)-ed_2.SelStart);
  ed_2.Text:= s;
  ed_2.SetFocus;
  ed_2.SelStart:= pos_start + 5;
end;

procedure TFMain.mnCopyClick(Sender: TObject);
begin
  Clipboard.AsText:= ListBox1.Items.Strings[ListBox1.ItemIndex];
end;

procedure TFMain.mn_RNAClick(Sender: TObject);
var
  s: string;
  pos_start: Integer;
begin
  s:= ed_2.Text;
  pos_start:= ed_2.SelStart;
  s:= LeftStr(s, ed_2.SelStart) + '[RNA]' + RightStr(s, Length(s)-ed_2.SelStart);
  ed_2.Text:= s;
  ed_2.SetFocus;
  ed_2.SelStart:= pos_start + 5;
end;

procedure TFMain.mn_RNClick(Sender: TObject);
var
  s: string;
  pos_start: Integer;
begin
  s:= ed_2.Text;
  pos_start:= ed_2.SelStart;
  s:= LeftStr(s, ed_2.SelStart) + '[RN]' + RightStr(s, Length(s)-ed_2.SelStart);
  ed_2.Text:= s;
  ed_2.SetFocus;
  ed_2.SelStart:= pos_start + 4;
end;

procedure TFMain.mn_unSelectAllClick(Sender: TObject);
var i: Integer;
begin
  for i:=0 to ListBox1.Count - 1 do
    ListBox1.Selected[i]:= False;

end;

procedure TFMain.Timer1Timer(Sender: TObject);
begin
  FAboutUs.refreshAbout;
  Timer1.Interval:= 30*60*1000;
end;

procedure TFMain.setTimesStatus;
begin
  if chk_copy.Checked then begin
    btn_pattern.Show;
    with lbl_times.Font do begin
      Color:= clDefault;
      Style:= Style - [fsItalic];
    end;
    with ed_times do begin
      Font.Color:= clDefault;
      Font.Style:= Font.Style - [fsItalic];
      ReadOnly:= False;
    end;
  end else begin
    btn_pattern.Hide;
    with lbl_times.Font do begin
      Color:= clGray;
      Style:= Style + [fsItalic];
    end;
    with ed_times do begin
      Font.Color:= clGray;
      Font.Style:= Font.Style + [fsItalic];
      ReadOnly:= True;
    end;
  end;

  showResult;

end;

procedure TFMain.showListFile;
var
  ListOfFiles   : array of string;
  ListOfFolders : array of string;
  SearchResult  : SearchRec;
  Attribute     : Word;
  Message       : string;
  i             : Integer;
begin
  if Trim(edtDirectory.Text) = '' then exit;

  SetLength(ListOfFiles, 0);
  SetLength(ListOfFolders, 0);

  // Prepare attribute
  Attribute := archive or readonly;
  if cbxHidden.Checked then
    Attribute := Attribute or hidden;

  // List the files
  FindFirst (edtDirectory.Text+DirectorySeparator+'*.*', Attribute, SearchResult);
  while (DosError = 0) do
  begin
    SetLength(ListOfFiles, Length(ListOfFiles) + 1); // Increase the list
    ListOfFiles[High(ListOfFiles)] := SearchResult.Name; // Add it at the end of the list
    FindNext(SearchResult);
  end;
  FindClose(SearchResult);

  // List the sub folders
  //if (cbxFolder.Checked) then
  //begin
  //  Attribute := Attribute or faDirectory;
  //  FindFirst (edtDirectory.Text+DirectorySeparator+'*.*', Attribute, SearchResult);
  //  while (DosError = 0) do
  //  begin
  //    if (SearchResult.Attr and directory) <> 0 then
  //    begin
  //      SetLength(ListOfFolders, Length(ListOfFolders) + 1); // Increase the list
  //      ListOfFolders[High(ListOfFolders)] := SearchResult.Name; // Add it at the end of the list
  //    end;
  //    FindNext(SearchResult);
  //  end;
  //  FindClose(SearchResult);
  //end;

  // Show the result
  Message := 'The directory contains ' + Length(ListOfFiles).ToString + ' file(s).' + #13;
  ListBox1.Items.Clear;
  for i := Low(ListOfFiles) to High(ListOfFiles) do begin
    //Message := Message + ListOfFiles[i] + #13;

    ListBox1.Items.Add(ListOfFiles[i]);
    ListBox1.Checked[i]:= True;
  end;

  showResult;

  //if (cbxFolder.Checked) then
  //begin
  //  Message := Message + #13 + 'And ' + Length(ListOfFolders).ToString + ' folder(s).' + #13;
  //  for i := Low(ListOfFolders) to High(ListOfFolders) do
  //    Message := Message + ListOfFolders[i] + #13;
  //end;
  //ShowMessage(Message);


end;

procedure TFMain.showResult;
var
  i, j: Integer;
  s_new, s_pattern, i_rna: string;
  //lst: TStringList;
  lst: TStrings;
  i_inc, xtimes, i_rn: Integer;
  obj: TFPObjectList;

function randomRNA(count: integer): string;
const
  C_ALPHA = '1QAZ2WSX3EDC4RFV5TGB6YHN7UJM8IK9OL0P';
var
  i, r: Integer;
  s: string;

begin

  s:='';
  for i:= 1 to count do begin
    r:= Random(Length(C_ALPHA));
    if r = 0 then r:= 1;
    s:= s + C_ALPHA[r];
  end;
  Result:= s;
end;

begin
  Randomize;
  //lst:= TStringList.Create;
  lst:= ListBox2.Items;
  i_inc:= 0;

  ListBox2.Items.Clear;

  if Assigned(FList) then FList.Free;
  FList:= TFPObjectList.Create(True);     //menandai, list result di listbox2 milik item mana di listbox1


  for i:= 0 to ListBox1.Items.Count - 1 do begin

    obj:= TFPObjectList.Create(False);

    if ListBox1.Checked[i] then begin

       s_pattern:= StringReplace(ListBox1.Items.Strings[i], ed_1.Text, ed_2.Text, []);
       s_new:= s_pattern;

       //jika pattern nggak ada sama sekali, maka s_new langsung ditambahkan, jika ada,
       //maka s_new adalah hasil dari perubahan/replace s_pattern

       if chk_copy.Checked then
         xtimes:= StrToInt(ed_times.Text)
       else
         xtimes:= 1;


       //yang tidak terdapat pattern, dilewati/tak perlu dicopy banyak kali
       if (pos('[INC]',s_new)> 0) or (pos('[RN]',s_new)> 0) or (pos('[RNA]',s_new)> 0) then begin
         for j:=1 to xtimes do begin

           //ulangi jika ada duplikat nama
           repeat
             s_new:= s_pattern;
             //if counter added
             while pos('[INC]',s_new)> 0 do begin
               inc(i_inc);
               s_new:= StringReplace(s_new,'[INC]',IntToStr(i_inc), [rfIgnoreCase]);
             end;

             //if random number added
             while pos('[RN]',s_new)> 0 do begin
               i_rn:= Random(xtimes*99);
               s_new:= StringReplace(s_new,'[RN]',IntToStr(i_rn), [rfIgnoreCase]);
             end;

             //if random alpha added
             while pos('[RNA]',s_new)> 0 do begin
               i_rn:= Random(xtimes*99);
               s_new:= StringReplace(s_new,'[RNA]',randomRNA(Length(IntToStr(i_rn))), [rfIgnoreCase]);
             end;


           until lst.IndexOf(s_new)<0;
           lst.Add(s_new);
           obj.Add(TMyObject.Create(lst.Count - 1));
         end
       end else begin
         lst.Add(s_new);
         obj.Add(TMyObject.Create(lst.Count - 1));
       end;

       //ListBox2.Items.Add(s_new);
    end else begin
      lst.Add(ListBox1.Items.Strings[i]);
      obj.Add(TMyObject.Create(lst.Count - 1));
    end;

    FList.Add(obj);


  end;
  obj:= nil;
  //ListBox2.Items.Clear;
  //ListBox2.Items.DelimitedText:= lst.DelimitedText;
  //lst.Free;
  lst:= nil;
end;


end.

