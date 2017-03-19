{##############################################################################

Aplicativo que realiza consulta dos webservices da fazenda conforme os modelos e estado;

Componentes usados: ACBr - projetoacbr.com.br
Delphi XE a Berlin: Componentes nativos;
Desenvolvido por Francisco Aurino
Email: franciscoaurino@gmail.com

Código OpenSource podendo ser alterado conforme necessidade.
No entanto, o componente é da ACBr;

Aplicativo com base no DEMO ACBr e com recursos adicionais;


}
unit Unit1;

interface

uses
  Registry, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ACBrBase, ACBrDFe, ACBrNFe, Vcl.StdCtrls,
  ACBrNFeDANFeESCPOS, ACBrUtil, ACBrNFeDANFEFRDM, ACBrNFeDANFEClass, ACBrNFeDANFEFR,
  Vcl.ExtCtrls, AdvGlowButton, IdBaseComponent, IdAntiFreezeBase, WinInet, ShellApi,
  Vcl.IdAntiFreeze, Vcl.ImgList, Vcl.Buttons, DateUtils, ACBrCTe, ACBrMDFe, pcnRetConsReciNFe,
  pcnConversaoNFe, pcnNFe, OleCtrls, SHDocVw, System.ImageList;


type
  TForm1 = class(TForm)
    ACBrNFe1: TACBrNFe;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    Panel1: TPanel;
    Label1: TLabel;
    ImageList1: TImageList;
    PStatus: TGroupBox;
    statusnett: TLabel;
    statusnet: TSpeedButton;
    statusnfee: TLabel;
    statusnfe: TSpeedButton;
    btnStatusNFe: TButton;
    btnStatusNET: TButton;
    Statuscertificadoo: TLabel;
    StatusCertificado: TSpeedButton;
    btnVCerticado: TButton;
    DataAtual_: TLabel;
    DataCertificado: TLabel;
    StatusCtee: TLabel;
    StatusCte: TSpeedButton;
    StatusNFCe: TSpeedButton;
    StatusNFCee: TLabel;
    ACBrCTe1: TACBrCTe;
    btnStatusCTe: TButton;
    btnStatusNFCe: TButton;
    edtNumSerie: TEdit;
    sbtnGetCert: TSpeedButton;
    ACBrNFCe1: TACBrNFe;
    statusMDFe: TSpeedButton;
    statusMDFee: TLabel;
    ACBrMDFe1: TACBrMDFe;
    btnStatusMDFe: TButton;
    Status_NFe: TLabel;
    Status_CTe: TLabel;
    Status_NFCe: TLabel;
    Status_MDFe: TLabel;
    GroupBox3: TGroupBox;
    SstatusNFe: TAdvGlowButton;
    SelecionaCertificado: TAdvGlowButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label2: TLabel;
    UF: TLabel;
    cbUF: TComboBox;
    GroupBox4: TGroupBox;
    SSL20: TCheckBox;
    SSL30: TCheckBox;
    TLS10: TCheckBox;
    TLS11: TCheckBox;
    TLS12: TCheckBox;
    btnIExplorer: TButton;
    Label3: TLabel;
    Panel2: TPanel;
    empresa: TLabel;
    statusIE: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure SstatusNFeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);


    procedure btnStatusNFeClick(Sender: TObject);
    procedure btnStatusNETClick(Sender: TObject);
    procedure btnVCerticadoClick(Sender: TObject);
    procedure btnStatusCTeClick(Sender: TObject);
    procedure btnStatusNFCeClick(Sender: TObject);
    procedure btnStatusMDFeClick(Sender: TObject);
    procedure btnIExplorerClick(Sender: TObject);
    procedure SelecionaCertificadoClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);




  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses  Unit2, strutils, math, TypInfo,  synacode,
   ACBrDFeConfiguracoes, pcnAuxiliar, ACBrDFeSSL,
  ACBrNFeNotasFiscais;



Function VersaoExe: String;
type
PFFI = ^vs_FixedFileInfo;
var
F : PFFI;
Handle : Dword;
Len : Longint;
Data : Pchar;
Buffer : Pointer;
Tamanho : Dword;
Parquivo: Pchar;
Arquivo : String;
begin
Arquivo := Application.ExeName;
Parquivo := StrAlloc(Length(Arquivo) + 1);
StrPcopy(Parquivo, Arquivo);
Len := GetFileVersionInfoSize(Parquivo, Handle);
Result := '';
if Len > 0 then
begin
Data:=StrAlloc(Len+1);
if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
begin
VerQueryValue(Data, '\',Buffer,Tamanho);
F := PFFI(Buffer);
Result := Format('%d.%d.%d.%d',
[HiWord(F^.dwFileVersionMs),
LoWord(F^.dwFileVersionMs),
HiWord(F^.dwFileVersionLs),
Loword(F^.dwFileVersionLs)]
);
end;
StrDispose(Data);
end;
StrDispose(Parquivo);
end;

procedure TForm1.SelecionaCertificadoClick(Sender: TObject);
begin
edtNumSerie.Text := ACBrNFe1.SSL.SelecionarCertificado;
empresa.Caption:= ACBrNFe1.SSL.CertRazaoSocial + ' | '+'CNPJ: '+ACBrNFe1.SSL.CertCNPJ ; //+ ' | ' + 'Validade: ' +FormatDateBr(ACBrNFe1.SSL.CertDataVenc);

end;

procedure TForm1.SstatusNFeClick(Sender: TObject);

begin

//limpando resultados

statusnet.Glyph.Assign(nil);
StatusNFe.Glyph.Assign(nil);
StatusNFCe.Glyph.Assign(nil);
StatusCTe.Glyph.Assign(nil);
StatusMDFe.Glyph.Assign(nil);
StatusCertificado.Glyph.Assign(nil);

Statusnett.Caption    := 'Status da Internet';
StatusNFee.Caption    := 'Status da NFe';
StatusNFCee.Caption   := 'Status da NFCe';
StatusCTee.Caption    := 'Status do CTe';
StatusMDFee.Caption   := 'Status da MDFe';
StatusCertificadoo.Caption   := 'Status do Certificado';

ImageList1.GetBitmap(2, statusnet.Glyph);
statusnett.Refresh;

ImageList1.GetBitmap(2, statusnfe.Glyph);
statusnett.Refresh;
ImageList1.GetBitmap(2, statusnfce.Glyph);
statusnett.Refresh;
ImageList1.GetBitmap(2, statusmdfe.Glyph);
statusnett.Refresh;
ImageList1.GetBitmap(2, statuscte.Glyph);
statusnett.Refresh;
ImageList1.GetBitmap(2, statuscertificado.Glyph);
statusnett.Refresh;




//edtNumSerie.Text := ACBrNFe1.SSL.SelecionarCertificado;
if edtNumSerie.Text = '' then
begin
showmessage('Nenhum Certificado Digital Informado.'+#13#10+'Informe o certificado digital para validar.');
exit;
end
else
begin

ACBrNFe1.Configuracoes.Certificados.NumeroSerie   := edtNumSerie.Text;
ACBrCTe1.Configuracoes.Certificados.NumeroSerie   := edtNumSerie.Text;
ACBrNFCe1.Configuracoes.Certificados.NumeroSerie  := edtNumSerie.Text;
ACBrMDFe1.Configuracoes.Certificados.NumeroSerie  := edtNumSerie.Text;

// mesma UF para as consultas
ACBrNFe1.Configuracoes.WebServices.UF := cbUF.Text;
ACBrCTe1.Configuracoes.WebServices.UF := cbUF.Text;
ACBrNFCe1.Configuracoes.WebServices.UF := cbUF.Text;
ACBrMDFe1.Configuracoes.WebServices.UF := cbUF.Text;

//mostrando a UF escolhida para consulta
UF.Caption := cbUF.Text;

        form1.Refresh;
        statusnett.Refresh;
        statusnett.Caption:='';
        Application.ProcessMessages;
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, statusnet.Glyph);
        statusnett.Font.Color := clBlue ;
        statusnett.Refresh;
        Application.ProcessMessages;
        statusnett.Caption := 'Verificando Status da internet...';
        statusnett.Refresh;
        Application.ProcessMessages;

btnStatusNET.Click;
end;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
timer1.Enabled := false;
  MessageDlg('Realize analise dos serviços da fazenda por UF.' + #13#10 + #13#10 +
             #13#10 +
             'www.inovatechi.com.br' + #13#10 +
             'contato@inovatechi.com.br' + #13#10 +
             '© Inovatechi Sistemas 2010 - 2017', mtInformation, [mbok],0);

end;

procedure TForm1.btnStatusNFCeClick(Sender: TObject);
var
CertDigital : String;
begin
        StatusNFCe.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, StatusNFCe.Glyph);
        StatusNFCe.Font.Color := clBlue ;

CertDigital:= FormatDateBr(ACBrCTe1.SSL.CertDataVenc);
dataatual_.Caption := DateToStr(date);
DataCertificado.Caption := CertDigital;

//atualizando status no painel de status
StatusCtee.Refresh;
Application.ProcessMessages;
StatusNFCee.Caption := 'Verificando Serviço da NFCe...';
StatusCtee.Refresh;
Application.ProcessMessages;

    if (cbUF.Text = 'MG') or (cbUF.Text = 'CE') or (cbUF.Text = 'TO')then // UF não atendidas pela NFC-e
        begin
          StatusNFCe.Glyph.Assign(nil);
          ImageList1.GetBitmap(0, StatusNFCe.Glyph);
          StatusNFCee.Font.Color := clBlue ;
          StatusNFCee.Caption := 'NFCe: Estado '+cbUF.Text+ ' não atendida.';
          btnStatusMDFe.Click;
        end
    else
        begin
         if statusnett.Caption = 'Internet: Offline' then
                      begin
                        StatusNFCe.Glyph.Assign(nil);
                        ImageList1.GetBitmap(3, StatusNFCe.Glyph);
                        StatusNFCee.Font.Color := clBlue ;
                        StatusNFCee.Caption := 'NFCe: Contigência Ativo';
                        btnStatusMDFe.Click;
                      end
                  else
                  begin

                       if (StrToDate(dataatual_.Caption) > StrToDate(DataCertificado.Caption)) then
                          begin
                          StatusNFCe.Glyph.Assign(nil);
                          ImageList1.GetBitmap(3, StatusNFCe.Glyph);
                          StatusNFCee.Font.Color := clBlue ;
                          StatusNFCee.Caption := 'NFCe: Contigência Ativo';
                          //btnStatusMDFe.Click;

                          end
                    else
                        begin
                                Status_NFCe.Refresh;
                                Application.ProcessMessages;
                                Status_NFCe.Caption := 'Verificando Status do serviço...';
                                Status_NFCe.Refresh;
                                Application.ProcessMessages;
                                ACBrNFCe1.WebServices.StatusServico.Executar;
                                Application.ProcessMessages;
                                Status_NFCe.Refresh;
                                Status_NFCe.Caption := ACBrNFCe1.WebServices.StatusServico.xMotivo;
                                Application.ProcessMessages;
                                //atualizando status no painel de status
                                StatusCtee.Refresh;
                                Application.ProcessMessages;
                                StatusNFCee.Caption := 'Verificando Status da NFCe...';
                                StatusNFCee.Refresh;
                                Application.ProcessMessages;

                                if Status_NFCe.Caption = 'Serviço em Operacao' then
                                begin
                                StatusNFCe.Glyph.Assign(nil);
                                ImageList1.GetBitmap(0, StatusNFCe.Glyph);
                                StatusNFCee.Font.Color := clred ;
                                StatusNFCee.Caption := 'NFCe: '+ Status_NFCe.Caption;
                               // btnStatusMDFe.Click;

                                end
                                else
                                begin
                                StatusNFCe.Glyph.Assign(nil);
                                ImageList1.GetBitmap(1, StatusNFCe.Glyph);
                                StatusNFCee.Font.Color := clgreen ;
                                StatusNFCee.Caption := 'NFCe: '+Status_NFCe.Caption;
                               //btnStatusMDFe.Click;

                                end;
                                btnStatusMDFe.Click;
                        end;
                  end;
        end;



end;

procedure TForm1.btnStatusNFeClick(Sender: TObject);
var
CertDigital : String;
begin
        statusnfe.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, statusnfe.Glyph);
        statusnfee.Font.Color := clBlue ;
        
CertDigital:= FormatDateBr(ACBrNFe1.SSL.CertDataVenc);
dataatual_.Caption := DateToStr(date);
DataCertificado.Caption := CertDigital;

//atualizando status no painel de status
statusnfee.Refresh;
Application.ProcessMessages;
statusnfee.Caption := 'Verificando Serviço da NFe...';
statusnfee.Refresh;
Application.ProcessMessages;
if statusnett.Caption = 'Internet: Offline' then
begin
                                            statusnfe.Glyph.Assign(nil);
                                            ImageList1.GetBitmap(3, statusnfe.Glyph);
                                            statusnfee.Font.Color := clBlue;
                                            statusnfee.Caption := 'NFe: Contigência Ativo';
                                            btnStatusCTe.Click;
end
else
begin
             //verificando certificado digital
                            if (StrToDate(dataatual_.Caption) > StrToDate(DataCertificado.Caption)) then
                                    begin
                                            statusnfe.Glyph.Assign(nil);
                                            ImageList1.GetBitmap(0, statusnfe.Glyph);
                                            statusnfee.Font.Color := clred ;
                                            statusnfee.Caption := 'NFe: Impossível Verificar';
                                            btnStatusCTe.Click;

                                    end
                            else
                                    begin     //₢ertificado ativo processa linha abaixo
                                            Status_NFe.Refresh;
                                            Application.ProcessMessages;
                                            Status_NFe.Caption := 'Verificando Status do serviço...';
                                            Status_NFe.Refresh;
                                            Application.ProcessMessages;
                                            ACBrNFe1.WebServices.StatusServico.Executar;
                                            Application.ProcessMessages;
                                            Status_NFe.Refresh;
                                            Status_NFe.Caption := ACBrNFe1.WebServices.StatusServico.xMotivo;
                                            //btnStatusCTe.Click;
                                            Application.ProcessMessages;
                                            //atualizando status no painel de status
                                            statusnfee.Refresh;
                                            Application.ProcessMessages;
                                            statusnfee.Caption := 'Verificando Status da NFe...';
                                            statusnfee.Refresh;
                                            Application.ProcessMessages;

                                            if Status_NFe.Caption = 'Serviço em Operacao' then
                                            begin
                                            statusnfe.Glyph.Assign(nil);
                                            ImageList1.GetBitmap(0, statusnfe.Glyph);
                                            statusnfee.Font.Color := clred ;
                                            statusnfee.Caption := 'NFe: '+ Status_NFe.Caption;
                                           // btnStatusCTe.Click;


                                            end
                                            else
                                            begin
                                            statusnfe.Glyph.Assign(nil);
                                            ImageList1.GetBitmap(1, statusnfe.Glyph);
                                            statusnfee.Font.Color := clgreen ;
                                            statusnfee.Caption := 'NFe: '+Status_NFe.Caption;
                                          //  btnStatusCTe.Click;

                                            end;
                                            btnStatusCTe.Click;
                                    end;

end;


  
end;

procedure TForm1.btnVCerticadoClick(Sender: TObject);
var
CertDigital : String;
begin
        StatusCertificado.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, StatusCertificado.Glyph);
        Statuscertificadoo.Font.Color := clBlue ;

CertDigital:= FormatDateBr(ACBrNFe1.SSL.CertDataVenc);
dataatual_.Caption := DateToStr(date);
DataCertificado.Caption := CertDigital;

//atualizando status no painel de status
Statuscertificadoo.Refresh;
Application.ProcessMessages;
Statuscertificadoo.Caption := 'Verificando Status da Certificado...';
Statuscertificadoo.Refresh;
Application.ProcessMessages;


      if (StrToDate(dataatual_.Caption) > StrToDate(DataCertificado.Caption)) then
        begin
                  StatusCertificado.Glyph.Assign(nil);
                  ImageList1.GetBitmap(0, StatusCertificado.Glyph);
                  Statuscertificadoo.Font.Color := clred ;
                  Statuscertificadoo.Caption :='Certificado: Vencido em '+CertDigital;
                  btnStatusNFe.Click;
        end
      else
        begin
                  StatusCertificado.Glyph.Assign(nil);
                  ImageList1.GetBitmap(1, StatusCertificado.Glyph);
                  Statuscertificadoo.Font.Color := clgreen ;
                  Statuscertificadoo.Caption := 'Certificado: Válido! Vencendo em '+CertDigital;
                  btnStatusNFe.Click;
        end;

 end;


procedure TForm1.btnIExplorerClick(Sender: TObject);
var
  Registro: TRegistry;
begin
  //acertando opções da internet (revogados / SSL / TSL)

  //verificar revogação de certificados do servidor
  Registro := TRegistry.Create(KEY_WRITE);
  Registro.RootKey := HKEY_CURRENT_USER;
  if registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', true) then
  begin
    Registro.WriteInteger('CertificateRevocation', 0);
  end;
  registro.CloseKey;

  //verificar se há certificados revogados do fornecedor
  if registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing', true) then begin
    Registro.WriteInteger('State', 146944);
  end;
  registro.CloseKey;

  //Usar SSL 3.0 / Usar TSL 1.0
  if registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', true) then begin
    Registro.WriteInteger('SecureProtocols', 168);
  end;

  //força para IE não ficar trabalhando off line
  if registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', true) then begin
    Registro.WriteInteger('GlobalUserOffline', 0);
  end;
  registro.CloseKey;

  registro.Free;
  statusIE.Visible := true;
  statusIE.Caption := 'Configurações do Certificado no '+#13#10+'Internet Explorer realizado com sucesso.';


  //tabelas de codigos do registro SLL

  {
0 => Keine sicheren Protokolle verwenden

8 => Nur SSL 2.0 verwenden

32 => Nur SSL 3.0 verwenden

40 => SSL 2.0 und SSL 3.0 verwenden

128 => Nur TLS 1.0 verwenden

136 => SSL 2.0 und TLS 1.0 verwenden

160 => SSL 3.0 und TLS 1.0 verwenden

168 => SSL 2.0, SSL 3.0, und TLS 1.0 verwenden

512 => Nur TLS 1.1 verwenden

520 => SSL 2.0 und TLS 1.1 verwenden

544 => SSL 3.0 und TLS 1.1 verwenden

552 => SSL 2.0, SSL 3.0 und TLS 1.1 verwenden

640 => TLS 1.0 und TLS 1.1 verwenden

648 => SSL 2.0, TLS 1.0 und TLS 1.1 verwenden

672 => SSL 3.0, TLS 1.0 und TLS 1.1 verwenden

680 => SSL 2.0, SSL 3.0, TLS 1.0 und TLS 1.1 verwenden

2048 => Nur TLS 1.2 verwenden

2056 => SSL 2.0 und TLS 1.2 verwenden

2080 => SSL 3.0 und TLS 1.2 verwenden

2088 => SSL 2.0, SSL 3.0 und TLS 1.2 verwenden

2176 => TLS 1.0 und TLS 1.2 verwenden

2184 => SSL 2.0, TLS 1.0 und TLS 1.2 verwenden

2208 => SSL 3.0, TLS 1.0 und TLS 1.2 verwenden

2216 => SSL 2.0, SSL 3.0, TLS 1.0 und TLS 1.2 verwenden

2560 => TLS 1.1 und TLS 1.2 verwenden

2568 => SSL 2.0, TLS 1.1 und TLS 1.2 verwenden

2592 => SSL 3.0, TLS 1.1 und TLS 1.2 verwenden

2600 => SSL 2.0, SSL 3.0, TLS 1.1 und TLS 1.2 verwenden

2688 => TLS 1.0, TLS 1.1 und TLS 1.2 verwenden

2696 => SSL 2.0, TLS 1.0, TLS 1.1 und TLS 1.2 verwenden

2720 => SSL 3.0, TLS 1.0, TLS 1.1 und TLS 1.2 verwenden

2728 => SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1 und TLS 1.2 verwenden
}


end;


procedure TForm1.btnStatusCTeClick(Sender: TObject);
var
CertDigital : String;
begin
StatusCte.Glyph.Assign(nil);
ImageList1.GetBitmap(2, StatusCte.Glyph);
StatusCtee.Font.Color := clBlue ;

CertDigital:= FormatDateBr(ACBrCTe1.SSL.CertDataVenc);
dataatual_.Caption := DateToStr(date);
DataCertificado.Caption := CertDigital;

//atualizando status no painel de status
StatusCtee.Refresh;
Application.ProcessMessages;
StatusCtee.Caption := 'Verificando Serviço da CTe...';
StatusCtee.Refresh;
Application.ProcessMessages;
 if statusnett.Caption = 'Internet: Offline' then
begin
  StatusCtee.Refresh;
  Application.ProcessMessages;
  StatusCte.Glyph.Assign(nil);
  ImageList1.GetBitmap(3, StatusCte.Glyph);
  StatusCtee.Font.Color := clBlue ;       //vermelho
  StatusCtee.Caption := 'CTe: Contigência Ativo';
  btnStatusNFCe.Click;
end
else
begin

if (StrToDate(dataatual_.Caption) > StrToDate(DataCertificado.Caption)) then
        begin   StatusCtee.Refresh;
                Application.ProcessMessages;
                StatusCte.Glyph.Assign(nil);
                ImageList1.GetBitmap(0, StatusCte.Glyph);
                StatusCtee.Font.Color := clred ;       //vermelho
                StatusCtee.Caption := 'CTe: Impossível Verificar';
                //btnStatusNFCe.Click;
        end
else
        begin
                Status_CTe.Refresh;
                Application.ProcessMessages;
                Status_CTe.Caption := 'Verificando Status do serviço...';
                Status_CTe.Refresh;
                Application.ProcessMessages;
                ACBrCTe1.WebServices.StatusServico.Executar;
                Application.ProcessMessages;
                Status_CTe.Refresh;
                Status_CTe.Caption := ACBrCTe1.WebServices.StatusServico.xMotivo;
                Application.ProcessMessages;
                //atualizando status no painel de status
                StatusCtee.Refresh;
                Application.ProcessMessages;
                StatusCtee.Caption := 'Verificando Status da CTe...';
                StatusCtee.Refresh;
                Application.ProcessMessages;

                if Status_CTe.Caption = 'Serviço em Operacao' then
                begin
                    StatusCtee.Refresh;
                    StatusCte.Glyph.Assign(nil);
                    ImageList1.GetBitmap(0, StatusCte.Glyph);
                    StatusCtee.Font.Color := clred ;   //vermelho
                    StatusCtee.Caption := 'CTe: '+ Status_CTe.Caption;
                  //  btnStatusNFCe.Click;
                    StatusCtee.Refresh;

                end
                else
                begin
                    StatusCtee.Refresh;
                    StatusCte.Glyph.Assign(nil);
                    ImageList1.GetBitmap(1, StatusCte.Glyph);
                    StatusCtee.Font.Color := clgreen ;   //verde
                    StatusCtee.Caption := 'CTe: '+Status_CTe.Caption;
                   // btnStatusNFCe.Click;
                    StatusCtee.Refresh;

                end;
                btnStatusNFCe.Click;
        end;
end;

end;


procedure TForm1.btnStatusMDFeClick(Sender: TObject);
var
CertDigital : String;
begin
        statusMDFe.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, statusMDFe.Glyph);
        statusMDFee.Font.Color := clBlue ;

CertDigital:= FormatDateBr(ACBrCTe1.SSL.CertDataVenc);
dataatual_.Caption := DateToStr(date);
DataCertificado.Caption := CertDigital;

//atualizando status no painel de status
statusMDFee.Refresh;
Application.ProcessMessages;
statusMDFee.Caption := 'Verificando Serviço da MDFe...';
statusMDFee.Refresh;
Application.ProcessMessages;

  if statusnett.Caption = 'Internet: Offline' then
  begin
                statusMDFe.Glyph.Assign(nil);
                ImageList1.GetBitmap(3, statusMDFe.Glyph);
                statusMDFee.Font.Color := clBlue ;
                statusMDFee.Caption := 'MDFe: Contigência Ativo';
  end
  else
  begin

if (StrToDate(dataatual_.Caption) > StrToDate(DataCertificado.Caption)) then
        begin
                statusMDFe.Glyph.Assign(nil);
                ImageList1.GetBitmap(0, statusMDFe.Glyph);
                statusMDFee.Font.Color := clred ;
                statusMDFee.Caption := 'MDFe: Impossível Verificar';

        end
else
        begin
                Status_MDFe.Refresh;
                Application.ProcessMessages;
                Status_MDFe.Caption := 'Verificando Status do serviço...';
                Status_MDFe.Refresh;
                Application.ProcessMessages;
                ACBrMDFe1.WebServices.StatusServico.Executar;
                Application.ProcessMessages;
                Status_MDFe.Refresh;
                Status_MDFe.Caption := ACBrMDFe1.WebServices.StatusServico.xMotivo;
                Application.ProcessMessages;
                //atualizando status no painel de status
                StatusCtee.Refresh;
                Application.ProcessMessages;
                statusMDFee.Caption := 'Verificando Status da MDFe...';
                statusMDFee.Refresh;
                Application.ProcessMessages;

                if Status_MDFe.Caption = 'Serviço em Operacao' then
                begin
                statusMDFe.Glyph.Assign(nil);
                ImageList1.GetBitmap(0, statusMDFe.Glyph);
                statusMDFee.Font.Color := clred ;
                statusMDFee.Caption := 'MDFe:: '+ Status_MDFe.Caption;

                end
                else
                begin
                statusMDFe.Glyph.Assign(nil);
                ImageList1.GetBitmap(1, statusMDFe.Glyph);
                statusMDFee.Font.Color := clgreen ;
                statusMDFee.Caption := 'MDFe: '+Status_MDFe.Caption;

                end;
        end;
  end;
  showmessage('Processo Realizado. Verifique Resultados Obtidos!');
end;

procedure TForm1.btnStatusNETClick(Sender: TObject);
var
i:dword;

begin
// verificando se há internet
        form1.Refresh;
        statusnett.Refresh;
        statusnett.Caption:='';
        Application.ProcessMessages;
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(2, statusnet.Glyph);
        statusnett.Font.Color := clBlue ;
        statusnett.Refresh;
        Application.ProcessMessages;
        statusnett.Caption := 'Verificando Status da internet...';
        statusnett.Refresh;
        Application.ProcessMessages;

if InternetCheckConnection('http://www.google.com/', 1, 0) then
begin
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(1, statusnet.Glyph);
        statusnett.Font.Color := clGreen ;
        statusnett.Caption := 'Internet: Online';
        btnVCerticado.Click;
end
else
begin
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(0, statusnet.Glyph);
        statusnett.Font.Color := clRed ;
        statusnett.Caption := 'Internet: Offline';
        btnVCerticado.Click;
end;
               {
if InternetGetConnectedState(@i,0) then
        begin
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(1, statusnet.Glyph);
        statusnett.Font.Color := clGreen ;
        statusnett.Caption := 'Internet: Online';
        btnVCerticado.Click;
        end
        else
        begin
        statusnet.Glyph.Assign(nil);
        ImageList1.GetBitmap(0, statusnet.Glyph);
        statusnett.Font.Color := clRed ;
        statusnett.Caption := 'Internet: Offline';
        btnVCerticado.Click;
        end;    }
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

Form1.Caption := 'Status Serviço Fazenda | Release: ' +VersaoExe;

  if not DirectoryExists(extractfilepath(Application.ExeName)+'\Logs\NFe') then
    ForceDirectories(extractfilepath(Application.ExeName)+'\Logs\NFe');
  if not DirectoryExists(extractfilepath(Application.ExeName)+'\Logs\NFCe') then
  ForceDirectories(extractfilepath(Application.ExeName)+'\Logs\NFCe');
  if not DirectoryExists(extractfilepath(Application.ExeName)+'\Logs\CTe') then
  ForceDirectories(extractfilepath(Application.ExeName)+'\Logs\Cte');
  if not DirectoryExists(extractfilepath(Application.ExeName)+'\Logs\MDFe') then
  ForceDirectories(extractfilepath(Application.ExeName)+'\Logs\MDFe');


{ACBrNFe1.SSL.SelecionarCertificado;
empresa.Caption:= 'Empresa: '+ACBrNFe1.SSL.CertRazaoSocial + ' | '+'CNPJ: '+ACBrNFe1.SSL.CertCNPJ+ ' | ' + 'Validade: ' +FormatDateBr(ACBrNFe1.SSL.CertDataVenc);
   }

end;

procedure TForm1.FormShow(Sender: TObject);

begin
  Height  := 304;
  Width   := 653;

SelecionaCertificado.SetFocus;
//CRIANDO PASTAS PARA RECEBER OS LOGS DAS CONSULTAS.
//path do ACBRNFe1
ACBrNFe1.Configuracoes.Arquivos.DownloadNFe.PathDownload  := ExtractFilePath(Application.ExeName)+'\Logs\NFe';
ACBrNFe1.Configuracoes.Arquivos.PathSalvar                := ExtractFilePath(Application.ExeName)+'\Logs\NFe';
ACBrNFe1.Configuracoes.Arquivos.PathNFe                   := ExtractFilePath(Application.ExeName)+'\Logs\NFe';
ACBrNFe1.Configuracoes.Arquivos.PathEvento                := ExtractFilePath(Application.ExeName)+'\Logs\NFe';
ACBrNFe1.Configuracoes.Arquivos.PathSchemas               := ExtractFilePath(Application.ExeName)+'\Schemas\NFe\';

//path do ACBrCTe
ACBrCTe1.Configuracoes.arquivos.DownloadCTe.PathDownload  := ExtractFilePath(Application.ExeName)+'\Logs\CTe';
ACBrCTe1.Configuracoes.Arquivos.PathSalvar                := ExtractFilePath(Application.ExeName)+'\Logs\CTe';
ACBrCTe1.Configuracoes.Arquivos.PathCTe                   := ExtractFilePath(Application.ExeName)+'\Logs\CTe';
ACBrCTe1.Configuracoes.Arquivos.PathEvento                := ExtractFilePath(Application.ExeName)+'\Logs\CTe';
ACBrCTe1.Configuracoes.Arquivos.PathSchemas               := ExtractFilePath(Application.ExeName)+'\Schemas\CTe\';

//path do ACBrNFCe
ACBrNFCe1.Configuracoes.Arquivos.DownloadNFe.PathDownload  := ExtractFilePath(Application.ExeName)+'\Logs\NFCe';
ACBrNFCe1.Configuracoes.Arquivos.PathSalvar                := ExtractFilePath(Application.ExeName)+'\Logs\NFCe';
ACBrNFCe1.Configuracoes.Arquivos.PathNFe                   := ExtractFilePath(Application.ExeName)+'\Logs\NFCe';
ACBrNFCe1.Configuracoes.Arquivos.PathEvento                := ExtractFilePath(Application.ExeName)+'\Logs\NFCe';
ACBrNFCe1.Configuracoes.Arquivos.PathSchemas               := ExtractFilePath(Application.ExeName)+'\Schemas\NFe\';

//path do ACBrMDFe
ACBrMDFe1.Configuracoes.Arquivos.DownloadMDFe.PathDownload := ExtractFilePath(Application.ExeName)+'\Logs\MDFe';
ACBrMDFe1.Configuracoes.Arquivos.PathSalvar                := ExtractFilePath(Application.ExeName)+'\Logs\MDFe';
ACBrMDFe1.Configuracoes.Arquivos.PathMDFe                  := ExtractFilePath(Application.ExeName)+'\Logs\MDFe';
ACBrMDFe1.Configuracoes.Arquivos.PathEvento                := ExtractFilePath(Application.ExeName)+'\Logs\MDFe';
ACBrMDFe1.Configuracoes.Arquivos.PathSchemas               := ExtractFilePath(Application.ExeName)+'\Schemas\MDFe\';


   //FormatDateTime('dd',Date); FormatDateTime('aaaa',Date);FormatDateTime('mm',Date);
end;




end.
