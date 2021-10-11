unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Menus, XPMan;

type

  TPole = record
    x: Byte;
    y: Byte;
  end;

  TMain = class(TForm)
    sg: TStringGrid;
    Button1: TButton;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    XPManifest1: TXPManifest;
    About1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private

    SapMap: TPole; 

  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

procedure TMain.Button1Click(Sender: TObject);
var
  hWn: HWND;
  PID, hProc, dwReaded: DWord;
  buf: Byte;
  i, r: Dword;
  StartAddr: Dword;
begin
  hWn := HWND(FindWindow(nil, PChar('Miner')));
  if not IsWindow(hWn) then
  hWn := HWND(FindWindow(nil, PChar('Сапер')));
  If IsWindow(hWn) Then
  Begin
    GetWindowThreadProcessId(hWn, @PID);
    hProc := OpenProcess(PROCESS_VM_READ, False, PID);
    Try
      If (hProc <> 0) Then
      Begin
        ReadProcessMemory(hProc, ptr($10056AC), @buf, 1, dwReaded);
        SapMap.x := buf;
        ReadProcessMemory(hProc, ptr($10056A8), @buf, 1, dwReaded);
        SapMap.y := buf;

        sg.ColCount := SapMap.x;
        sg.RowCount := SapMap.y;
        if (sg.ColCount = 9) and (sg.RowCount = 9) then
        begin
          sg.Height := 147;
          sg.Width := 147;

          Height := sg.Top+sg.Height+56;
          Width := sg.Left+sg.Width+16;
        end
        else if (sg.ColCount = 16) and (sg.RowCount = 16) then
        begin
          sg.Height := 259;
          sg.Width := 259;

          Height := sg.Top+sg.Height+56;
          Width := sg.Left+sg.Width+16;
        end
        else if (sg.ColCount = 30) and (sg.RowCount = 16) then
        begin
          sg.Height := 259;
          sg.Width := 483;

          Height := sg.Top+sg.Height+56;
          Width := sg.Left+sg.Width+16;
        end;
        For i := 0 To (sg.ColCount - 1) Do
          For r := 0 To (sg.RowCount - 1) Do sg.Cells[i,r] := ' ';

        StartAddr := $01005361;
        For i := 0 To (SapMap.y - 1) Do
        Begin
          For r := 0 To (SapMap.x - 1) Do
          Begin
            ReadProcessMemory(hProc, ptr((i*$20) + StartAddr + r), @buf, 1, dwReaded);
            If (buf = $8F) Then sg.Cells[r, i] := '*';
         End;
      End;

    End;
    Finally
      CloseHandle(hProc);
    End;
End;

end;

procedure TMain.Exit1Click(Sender: TObject);
begin

  Close;

end;

procedure TMain.About1Click(Sender: TObject);
begin

  MessageBox(Handle,'This is a Beta version of Anti Miner' +
                    #10 + 'Original Code: www.xakep.ru' +
                    #10 + 'Rewritten in Delphi by 4kusN!ck' +
                    #10 + 'for www.delphisources.ru' +
                    #10 + 'as example of using ReadProcessMemory' +
                    #10 + '2006','Anti Miner Beta',MB_ICONINFORMATION);

end;

end.
