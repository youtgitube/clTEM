; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "clTEM"
#define MyAppVersion "1.2.0"
#define MyAppPublisher "Jon Peters"
#define MyAppURL "https://github.com/ADyson/clTEM"
#define MyAppExeName "clTEM.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{1E55E74D-6C0A-405C-ACE6-66722EC1CF09}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=Setup Release
OutputBaseFilename=Install clTEM
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=Front end\clTEM.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "Front end\bin\x64\Release\clTEM.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotential.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotentialConv.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotentialConventional.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotentialConventional2.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotentialOpt.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\BinnedAtomicPotentialOpt2.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\clFFT.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\Elysium.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\fparams.dat"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\Framework.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\Framework.UI.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\GeneratePropagator.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\Multiply.cl"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\OpenCL Simulation Code.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Front end\bin\x64\Release\dotNetFx45_Full_setup.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; BeforeInstall: InstallNetFramework; Check: "not NetFrameworkIsInstalled"
Source: "Front end\bin\x64\Release\vcredist_2013_x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; BeforeInstall: InstallVCRedist; Check: "not VCRedistIsInstalled"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]
//http://stackoverflow.com/questions/27582762/inno-setup-for-visual-c-redistributable-package-for-visual-studio-2013
#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF
type
  INSTALLSTATE = Longint;
const
  INSTALLSTATE_INVALIDARG = -2;  // An invalid parameter was passed to the function.
  INSTALLSTATE_UNKNOWN = -1;     // The product is neither advertised or installed.
  INSTALLSTATE_ADVERTISED = 1;   // The product is advertised but not installed.
  INSTALLSTATE_ABSENT = 2;       // The product is installed for a different user.
  INSTALLSTATE_DEFAULT = 5;      // The product is installed for the current user.

  VC_2013_REDIST = '{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E}'; //Microsoft.VS.VC_RuntimeMinimumVSU_x86,v12
  VC_2013_REDIST_x64 = '{A749D8E6-B613-3BE3-8F5F-045C84EBA29B}'; //Microsoft.VS.VC_RuntimeMinimumVSU_amd64,v12

  function MsiQueryProductState(szProduct: String): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCRedistIsInstalled: Boolean;
begin
  Result := MsiQueryProductState(VC_2013_REDIST_x64) = INSTALLSTATE_DEFAULT;
end;

procedure InstallVCRedist;
var 
  StatusText: string;
  ResultCode: Integer;
begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing Visual C++ redistributable 2013 x64...';
  //WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    begin
      if not Exec(ExpandConstant('{tmp}\vcredist_2013_x64.exe'), '/q /passive /norestart', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
      begin
      // you can interact with the user that the installation failed
      MsgBox('Visual C++ redistributable 2013 x64 installation failed with code: ' + IntToStr(ResultCode) + '.', mbError, MB_OK);
      end;
    end;
  finally
  WizardForm.StatusLabel.Caption := StatusText;
  WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

// http://www.codeproject.com/Tips/506096/InnoSetup-with-NET-installer-x-x-sample
// this will differ for different versions of .net
function NetFrameworkIsInstalled: Boolean;
var
  key: string;
  install, serviceCount, release: cardinal;
  success: boolean;
begin
  // 4.5 is an update to version 4.0
  key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full';
  // v4.0 stuff
  success := RegQueryDWordValue(HKLM, key, 'Install', install);
  success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
  // v4.5 stuff
  success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
  success := success and (release >= 378389);

  Result := success and (install = 1) and (serviceCount >= 0);  // 0 for no service pack
end;

procedure InstallNetFramework;
var
  StatusText: string;
  ResultCode: Integer;
begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing .NET framework...';
  //WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    begin
      if not Exec(ExpandConstant('{tmp}\dotNetFx45_Full_setup.exe'), '/q /passive /norestart', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
      begin
      // you can interact with the user that the installation failed
      MsgBox('.NET installation failed with code: ' + IntToStr(ResultCode) + '.', mbError, MB_OK);
      end;
    end;
  finally
  WizardForm.StatusLabel.Caption := StatusText;
  WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
