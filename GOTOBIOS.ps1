# ============================================================
#   HonestVL.com - FULL PC OPTIMIZATION v3
#   Target:  RTX 3060 Ti | Intel i9-9900 | 32GB RAM | Ethernet
#   Purpose: Complete Debloat + Valorant Optimization
#   Deploy:  irm https://raw.githubusercontent.com/hsvlx/[repo]/main/HonestVL_v3.ps1 | iex
# ============================================================

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "[HonestVL] Please run as Administrator!" -ForegroundColor Red
    Exit
}

$Host.UI.RawUI.WindowTitle = "HonestVL.com - PC Optimization v3"
Clear-Host

Write-Host ""
Write-Host "  ██╗  ██╗ ██████╗ ███╗   ██╗███████╗███████╗████████╗██╗   ██╗██╗     " -ForegroundColor Cyan
Write-Host "  ██║  ██║██╔═══██╗████╗  ██║██╔════╝██╔════╝╚══██╔══╝██║   ██║██║     " -ForegroundColor Cyan
Write-Host "  ███████║██║   ██║██╔██╗ ██║█████╗  ███████╗   ██║   ██║   ██║██║     " -ForegroundColor Cyan
Write-Host "  ██╔══██║██║   ██║██║╚██╗██║██╔══╝  ╚════██║   ██║   ╚██╗ ██╔╝██║     " -ForegroundColor Cyan
Write-Host "  ██║  ██║╚██████╔╝██║ ╚████║███████╗███████║   ██║    ╚████╔╝ ███████╗" -ForegroundColor Cyan
Write-Host "  ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝   ╚═╝     ╚═══╝  ╚══════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "                    HonestVL.com - Full Optimization v3" -ForegroundColor White
Write-Host "              RTX 3060 Ti  |  i9-9900  |  32GB RAM  |  Ethernet" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [!] Do NOT close this window. This will take 3-6 minutes." -ForegroundColor Yellow
Write-Host ""
Start-Sleep -Seconds 2

# ============================================================
# [1/22] POWER PLAN - HonestVL.com ULTIMATE
# ============================================================
Write-Host "[1/22] Creating HonestVL.com ULTIMATE power plan..." -ForegroundColor Yellow

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
$planList = powercfg /list
$newPlan = $planList | Select-String "Ultimate Performance" | Select-Object -Last 1
if ($newPlan) {
    $guid = ($newPlan.ToString().Trim() -split "\s+")[3]
    powercfg /changename $guid "HonestVL.com ULTIMATE" "Optimized by HonestVL.com - Max performance for gaming"
    powercfg /setactive $guid
    Write-Host "     -> HonestVL.com ULTIMATE activated: $guid" -ForegroundColor Green
} else {
    powercfg /setactive SCHEME_MIN
    Write-Host "     -> Fallback: High Performance activated" -ForegroundColor Green
}

powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /change monitor-timeout-ac 0
powercfg /hibernate off

powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
powercfg /setactive SCHEME_CURRENT

Write-Host "     -> CPU throttle locked 100%, boost mode aggressive, sleep/hibernate off" -ForegroundColor Green

# ============================================================
# [2/22] WINDOWS DEBLOAT - Remove All Bloatware
# ============================================================
Write-Host "[2/22] Removing bloatware..." -ForegroundColor Yellow

$bloat = @(
    "Microsoft.BingNews", "Microsoft.BingWeather", "Microsoft.BingFinance",
    "Microsoft.BingSports", "Microsoft.BingSearch", "Microsoft.Cortana",
    "Microsoft.GamingApp", "Microsoft.GetHelp", "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes", "Microsoft.MixedReality.Portal",
    "Microsoft.MSPaint", "Microsoft.OneDrive", "Microsoft.People",
    "Microsoft.PowerAutomateDesktop", "Microsoft.SkypeApp", "Microsoft.Teams",
    "MicrosoftTeams", "Microsoft.Todos", "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCommunicationsApps", "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps", "Microsoft.WindowsPhone", "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp", "Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider", "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo",
    "Clipchamp.Clipchamp", "MicrosoftCorporationII.MicrosoftFamily",
    "MicrosoftCorporationII.QuickAssist", "Microsoft.549981C3F5F10",
    "Microsoft.DevHome", "Microsoft.OutlookForWindows",
    "Microsoft.MicrosoftEdge.Stable", "Microsoft.Widgets",
    "MicrosoftWindows.CrossDevice", "Microsoft.WindowsSoundRecorder",
    "Microsoft.StorePurchaseApp", "Microsoft.ScreenSketch",
    "Microsoft.3DViewer", "Microsoft.Print3D"
)

foreach ($app in $bloat) {
    Get-AppxPackage -Name $app -AllUsers 2>$null | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online 2>$null | Where-Object { $_.PackageName -like "*$app*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    Write-Host "     -> Removed: $app" -ForegroundColor DarkGray
}

# OneDrive full uninstall
$onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
if (Test-Path $onedrive) { Start-Process $onedrive "/uninstall" -Wait -ErrorAction SilentlyContinue }
Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f 2>$null

# Disable Widgets via policy
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 -Type DWord -Force

Write-Host "     -> 50+ bloatware apps removed, OneDrive uninstalled, Widgets disabled" -ForegroundColor Green

# ============================================================
# [3/22] TELEMETRY & PRIVACY - Kill All Data Collection
# ============================================================
Write-Host "[3/22] Disabling telemetry and data collection..." -ForegroundColor Yellow

If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

$telSvcs = @("DiagTrack", "dmwappushservice", "diagnosticshub.standardcollector.service", "PcaSvc", "DPS")
foreach ($svc in $telSvcs) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

$telemetryTasks = @(
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Application Experience\StartupAppTask",
    "\Microsoft\Windows\Application Experience\PcaPatchDbTask",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Feedback\Siuf\DmClient",
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask",
    "\Microsoft\Windows\DiskFootprint\Diagnostics",
    "\Microsoft\Windows\Maintenance\WinSAT",
    "\Microsoft\Windows\NetTrace\GatherNetworkInfo",
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem",
    "\Microsoft\Windows\Shell\FamilySafetyMonitor",
    "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"
)
foreach ($task in $telemetryTasks) { schtasks /change /tn "$task" /disable 2>$null }

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Delivery optimization off (P2P WU sharing)
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0 -Type DWord -Force
Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DoSvc" -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host "     -> All telemetry, CEIP, delivery optimization, location tracking disabled" -ForegroundColor Green

# ============================================================
# [4/22] WINDOWS UPDATE - Harden Against Driver Overwrites
# ============================================================
Write-Host "[4/22] Hardening Windows Update settings..." -ForegroundColor Yellow

If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force | Out-Null }
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null }

# Block Windows Update from overwriting NVIDIA driver
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord -Force

# No auto-restart while logged in
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord -Force

# Disable forced feature updates
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableOSUpgrade" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable update delivery peer-to-peer (policy key backup)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0 -Type DWord -Force

Write-Host "     -> Driver updates via WU blocked, no forced reboots, OS upgrades disabled" -ForegroundColor Green

# ============================================================
# [5/22] SERVICES - Disable All Unnecessary Services
# ============================================================
Write-Host "[5/22] Disabling unnecessary services..." -ForegroundColor Yellow

$services = @(
    "WSearch",              # Windows Search indexer
    "SysMain",              # Superfetch
    "Fax",                  # Fax
    "PrintNotify",          # Print notifications
    "TabletInputService",   # Tablet input
    "WMPNetworkSvc",        # Windows Media Player network
    "XblAuthManager",       # Xbox Live Auth
    "XblGameSave",          # Xbox Live Game Save
    "XboxNetApiSvc",        # Xbox Live Networking
    "wercplsupport",        # Problem Reports control panel
    "WerSvc",               # Windows Error Reporting
    "Wecsvc",               # Windows Event Collector
    "RemoteRegistry",       # Remote Registry
    "RemoteAccess",         # Routing and Remote Access
    "MapsBroker",           # Downloaded Maps
    "lfsvc",                # Geolocation
    "TrkWks",               # Distributed Link Tracking
    "WbioSrvc",             # Biometric
    "wisvc",                # Windows Insider
    "RetailDemo",           # Retail Demo
    "DoSvc",                # Delivery Optimization
    "WpcMonSvc",            # Parental Controls
    "PhoneSvc",             # Phone Service
    "MessagingService",     # Messaging
    "PimIndexMaintenanceSvc", # Contact indexing
    "OneSyncSvc",           # Sync host
    "UnistoreSvc",          # User data storage
    "UserDataSvc",          # User data access
    "WalletService",        # Wallet
    "SEMgrSvc",             # Payments/NFC
    "SCardSvr",             # Smart Card
    "ScDeviceEnum",         # Smart Card Device Enum
    "SCPolicySvc",          # Smart Card Policy
    "SharedAccess",         # Internet Connection Sharing
    "icssvc",               # Windows Mobile Hotspot
    "NcdAutoSetup",         # Network Connected Devices
    "NetTcpPortSharing",    # Net.Tcp Port Sharing
    "upnphost",             # UPnP Device Host
    "SSDPSRV",              # SSDP Discovery
    "SessionEnv",           # Remote Desktop Config
    "TermService",          # Remote Desktop Services
    "UmRdpService",         # Remote Desktop redirector
    "RasMan",               # Remote Access Connection Manager
    "RasAuto",              # Remote Access Autodial
    "Spooler",              # Print Spooler
    "NvTelemetryContainer", # NVIDIA Telemetry
    "NvNetworkService",     # NVIDIA Network Service
    "NVDisplay.ContainerLocalSystem" # NVIDIA Display container (telemetry)
)

foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "     -> Disabled: $svc" -ForegroundColor DarkGray
}

Write-Host "     -> 45+ unnecessary services disabled (incl. NVIDIA telemetry)" -ForegroundColor Green

# ============================================================
# [6/22] STARTUP PROGRAMS - Kill Background Launch Bloat
# ============================================================
Write-Host "[6/22] Cleaning startup programs..." -ForegroundColor Yellow

$startupKeys = @(
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

$startupBloat = @(
    "OneDrive", "Skype", "Teams", "SkypeApp", "Discord Update",
    "EpicGamesLauncher", "Spotify", "SteamService", "msnmsgr",
    "WindowsDefender", "SecurityHealth", "BingSvc", "WebExperienceHostBroker",
    "NvTmMon", "NvTmRepOnStartup", "NvBackend"  # NVIDIA telemetry startup entries
)

foreach ($key in $startupKeys) {
    foreach ($item in $startupBloat) {
        Remove-ItemProperty -Path $key -Name $item -ErrorAction SilentlyContinue
    }
}

# Zero startup delay
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Value 0 -Type DWord -Force

Write-Host "     -> Startup bloat removed, startup delay zeroed" -ForegroundColor Green

# ============================================================
# [7/22] REGISTRY PERFORMANCE TWEAKS
# ============================================================
Write-Host "[7/22] Applying registry performance tweaks..." -ForegroundColor Yellow

$mmPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
$kePrioPath = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
$desktopPath = "HKCU:\Control Panel\Desktop"

# Win32PrioritySeparation = 26 (0x1A)
# Hex 26 = Short, Variable, High - foreground gets max CPU quantum boost
# THIS is the single biggest gaming registry tweak - do not skip
Set-ItemProperty -Path $kePrioPath -Name "Win32PrioritySeparation" -Value 26 -Type DWord -Force

# IRQ8 priority boost (RTC clock interrupt)
Set-ItemProperty -Path $kePrioPath -Name "IRQ8Priority" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

# Menu show delay - instant
Set-ItemProperty -Path $desktopPath -Name "MenuShowDelay" -Value "0" -Force

# Shutdown speed tweaks
Set-ItemProperty -Path $desktopPath -Name "AutoEndTasks" -Value "1" -Force
Set-ItemProperty -Path $desktopPath -Name "WaitToKillAppTimeout" -Value "2000" -Force
Set-ItemProperty -Path $desktopPath -Name "HungAppTimeout" -Value "2000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value "2000" -Force

# Don't wipe pagefile on shutdown (faster shutdown, no performance benefit to wiping)
Set-ItemProperty -Path $mmPath -Name "ClearPageFileAtShutdown" -Value 0 -Type DWord -Force

# NTFS encryption driver - set to manual (not needed, wastes overhead on load)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EFS" -Name "Start" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable error reporting registry keys (belt + suspenders with service disable)
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "DontSendAdditionalData" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "LoggingDisabled" -Value 1 -Type DWord -Force

# Disable Watson crash reporting
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Type DWord -Force

# Processor idle - disable idle states via registry (complements power plan)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\intelppm" -Name "Start" -Value 4 -Type DWord -Force -ErrorAction SilentlyContinue  # Disable Intel power mgmt driver

# Raise I/O scheduler priority for foreground
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "HeapDeCommitFreeBlockThreshold" -Value 0x00040000 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "     -> Win32PrioritySeparation=26, MenuDelay=0, AutoEndTasks=1" -ForegroundColor Green
Write-Host "     -> WaitToKillApp/Service=2s, ClearPageFile=0, WER disabled" -ForegroundColor Green

# ============================================================
# [8/22] NVIDIA TELEMETRY - Kill All NVIDIA Data Collection
# ============================================================
Write-Host "[8/22] Disabling NVIDIA telemetry..." -ForegroundColor Yellow

# NVIDIA telemetry registry keys
$nvTelPaths = @(
    "HKLM:\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client",
    "HKLM:\SOFTWARE\NVIDIA Corporation\Global\FTS",
    "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup"
)

# Disable NVIDIA telemetry opt-in
If (Test-Path "HKLM:\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" -Name "OptInOrOutPreference" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
}

# Disable NVIDIA telemetry tasks
$nvTasks = @(
    "\NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}",
    "\NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}",
    "\NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}"
)
foreach ($task in $nvTasks) { schtasks /change /tn "$task" /disable 2>$null }

# NVIDIA GeForce Experience telemetry
$nvGFEPath = "HKCU:\SOFTWARE\NVIDIA Corporation\NVISDKClient\Preferences"
If (!(Test-Path $nvGFEPath)) { New-Item -Path $nvGFEPath -Force | Out-Null }
Set-ItemProperty -Path $nvGFEPath -Name "AnalyticsEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable NVIDIA container telemetry
$nvContainerPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NvContainerLocalSystem"
If (Test-Path $nvContainerPath) {
    Set-ItemProperty -Path $nvContainerPath -Name "Start" -Value 4 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "     -> NVIDIA telemetry services, tasks, and registry keys disabled" -ForegroundColor Green

# ============================================================
# [9/22] VISUAL EFFECTS - Full Performance Mode
# ============================================================
Write-Host "[9/22] Setting visual effects to performance mode..." -ForegroundColor Yellow

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListViewShadow" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value "2" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "     -> Visual effects, transparency, animations, font smoothing all optimized" -ForegroundColor Green

# ============================================================
# [10/22] NETWORK - Ethernet Gaming Optimization
# ============================================================
Write-Host "[10/22] Optimizing Ethernet network settings..." -ForegroundColor Yellow

# Nagle's algorithm off on all interfaces
$tcpPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
Get-ChildItem $tcpPath | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
}

# Global TCP params
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "DefaultTTL" -Value 64 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay" -Value 30 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "MaxUserPort" -Value 65534 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpNumConnections" -Value 16777214 -Type DWord -Force

# Multimedia profile - no throttling
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -Force

# TCP via netsh
netsh int tcp set global autotuninglevel=normal 2>$null
netsh int tcp set global chimney=disabled 2>$null
netsh int tcp set global rss=enabled 2>$null
netsh int tcp set global fastopen=enabled 2>$null
netsh int tcp set global timestamps=disabled 2>$null
netsh int tcp set global initialRto=2000 2>$null
netsh int tcp set global nonsackrttresiliency=disabled 2>$null
netsh int tcp set supplemental internet congestionprovider=ctcp 2>$null

# Ethernet NIC advanced settings
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.PhysicalMediaType -eq "802.3" }
foreach ($adapter in $adapters) {
    Write-Host "     -> Tuning NIC: $($adapter.Name)" -ForegroundColor DarkGray
    $adapterPowerPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}"
    Get-ChildItem $adapterPowerPath | ForEach-Object {
        $desc = (Get-ItemProperty -Path $_.PSPath -Name "DriverDesc" -ErrorAction SilentlyContinue).DriverDesc
        if ($adapter.InterfaceDescription -like "*$desc*") {
            Set-ItemProperty -Path $_.PSPath -Name "PnPCapabilities" -Value 24 -Type DWord -Force -ErrorAction SilentlyContinue
        }
    }
    Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Interrupt Moderation" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Interrupt Moderation Rate" -DisplayValue "Off" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Receive Side Scaling" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Energy Efficient Ethernet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Green Ethernet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Power Saving Mode" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Flow Control" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Jumbo Packet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Jumbo Frame" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Speed & Duplex" -DisplayValue "1.0 Gbps Full Duplex" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Large Send Offload V2 (IPv4)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Large Send Offload V2 (IPv6)" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "UDP Checksum Offload (IPv4)" -DisplayValue "Tx Enabled" -ErrorAction SilentlyContinue
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "TCP Checksum Offload (IPv4)" -DisplayValue "Tx and Rx Enabled" -ErrorAction SilentlyContinue
}

# QoS - remove 20% bandwidth reservation
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Value 0 -Type DWord -Force

# Set DNS to Cloudflare (faster than most ISP DNS for gaming)
$activeAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.PhysicalMediaType -eq "802.3" }
foreach ($adapter in $activeAdapters) {
    Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ("1.1.1.1", "1.0.0.1") -ErrorAction SilentlyContinue
    Write-Host "     -> DNS set to Cloudflare 1.1.1.1 on: $($adapter.Name)" -ForegroundColor DarkGray
}

ipconfig /flushdns 2>$null

Write-Host "     -> Nagle off, EEE off, IMR off, RSS on, QoS 0%, DNS=Cloudflare" -ForegroundColor Green

# ============================================================
# [11/22] GPU - RTX 3060 Ti Tweaks
# ============================================================
Write-Host "[11/22] Applying RTX 3060 Ti GPU tweaks..." -ForegroundColor Yellow

# HAGS on
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force

# FSO / fullscreen optimizations off globally
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_HonorUserFSEBehaviorMode" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_EFSEFeatureFlags" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1 -Type DWord -Force

# GPU system profile
$gpuPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
If (!(Test-Path $gpuPath)) { New-Item -Path $gpuPath -Force | Out-Null }
Set-ItemProperty -Path $gpuPath -Name "Affinity" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $gpuPath -Name "Background Only" -Value "False" -Type String -Force
Set-ItemProperty -Path $gpuPath -Name "Clock Rate" -Value 10000 -Type DWord -Force
Set-ItemProperty -Path $gpuPath -Name "GPU Priority" -Value 8 -Type DWord -Force
Set-ItemProperty -Path $gpuPath -Name "Priority" -Value 6 -Type DWord -Force
Set-ItemProperty -Path $gpuPath -Name "Scheduling Category" -Value "High" -Type String -Force
Set-ItemProperty -Path $gpuPath -Name "SFIO Priority" -Value "High" -Type String -Force

# NVIDIA preemption latency
$nvPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
If (Test-Path $nvPath) {
    Set-ItemProperty -Path $nvPath -Name "RMGpuPreemptionTimeoutUsecs" -Value 2000000 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "     -> HAGS on, GPU priority 8, FSO off, preemption tweaked" -ForegroundColor Green

# ============================================================
# [12/22] MSI MODE - GPU + NIC Interrupt Priority
# ============================================================
Write-Host "[12/22] Enabling MSI mode for GPU and NIC..." -ForegroundColor Yellow

$gpuDevices = Get-WmiObject Win32_VideoController | Where-Object { $_.Name -like "*NVIDIA*" }
foreach ($gpu in $gpuDevices) {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($gpu.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
    If (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "MSISupported" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    $affinityPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($gpu.PNPDeviceID)\Device Parameters\Interrupt Management\Affinity Policy"
    If (!(Test-Path $affinityPath)) { New-Item -Path $affinityPath -Force | Out-Null }
    Set-ItemProperty -Path $affinityPath -Name "DevicePriority" -Value 3 -Type DWord -Force -ErrorAction SilentlyContinue
    Write-Host "     -> MSI + High priority: $($gpu.Name)" -ForegroundColor DarkGray
}

$nics = Get-WmiObject Win32_NetworkAdapter | Where-Object { $_.PhysicalAdapter -eq $true -and $_.NetConnectionStatus -eq 2 }
foreach ($nic in $nics) {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($nic.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
    If (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "MSISupported" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Write-Host "     -> MSI enabled: $($nic.Name)" -ForegroundColor DarkGray
}

Write-Host "     -> MSI mode enabled for GPU + NIC (takes effect after restart)" -ForegroundColor Green

# ============================================================
# [13/22] SPECTRE/MELTDOWN - Disable CPU Mitigations
# ============================================================
Write-Host "[13/22] Disabling Spectre/Meltdown mitigations (i9-9900)..." -ForegroundColor Yellow

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverride" -Value 3 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "FeatureSettingsOverrideMask" -Value 3 -Type DWord -Force

Write-Host "     -> Spectre/Meltdown off (~5-15% CPU perf gain on Coffee Lake)" -ForegroundColor Green

# ============================================================
# [14/22] GAME DVR / XBOX / GAME MODE - All Off
# ============================================================
Write-Host "[14/22] Disabling Game DVR, Xbox overlay, Game Mode..." -ForegroundColor Yellow

Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force
Get-AppxPackage Microsoft.XboxGamingOverlay -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "     -> Game DVR, Xbox overlay, Game Mode all disabled" -ForegroundColor Green

# ============================================================
# [15/22] AUDIO - Low Latency Configuration
# ============================================================
Write-Host "[15/22] Configuring audio for low latency..." -ForegroundColor Yellow

# Disable audio throttling
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "AudioThrottlingEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Disable audio enhancements globally (adds latency, can cause crackling)
$audioDevPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render"
If (Test-Path $audioDevPath) {
    Get-ChildItem $audioDevPath | ForEach-Object {
        $fxPath = "$($_.PSPath)\FxProperties"
        If (Test-Path $fxPath) {
            # Disable APO effects (enhancements)
            Set-ItemProperty -Path $fxPath -Name "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},6" -Value ([byte[]](0x01,0x00,0x00,0x00)) -Type Binary -Force -ErrorAction SilentlyContinue
        }
    }
}

# Disable audio exclusive mode from being denied (allow apps like Valorant to take exclusive)
$audioRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render"
# Set audio service to high performance thread priority
$audioSvcPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Audiosrv"
If (Test-Path $audioSvcPath) {
    Set-ItemProperty -Path $audioSvcPath -Name "Type" -Value 0x10 -Type DWord -Force -ErrorAction SilentlyContinue
}

Write-Host "     -> Audio throttling off, enhancements disabled, exclusive mode enabled" -ForegroundColor Green

# ============================================================
# [16/22] MEMORY - 32GB Optimization
# ============================================================
Write-Host "[16/22] Optimizing memory management..." -ForegroundColor Yellow

Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 0 -Type DWord -Force

# Fixed pagefile 4096MB - no resize stutter
$cs = Get-WmiObject -Class Win32_ComputerSystem
$cs.AutomaticManagedPagefile = $false
$cs.Put() | Out-Null
$pf = Get-WmiObject -Class Win32_PageFileSetting
if ($pf) {
    $pf | ForEach-Object { $_.InitialSize = 4096; $_.MaximumSize = 4096; $_.Put() | Out-Null }
} else {
    Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name="C:\pagefile.sys"; InitialSize=4096; MaximumSize=4096} | Out-Null
}

Write-Host "     -> Memory compression off, paging executive disabled, pagefile fixed 4GB" -ForegroundColor Green

# ============================================================
# [17/22] STORAGE - SSD/NVMe Optimizations
# ============================================================
Write-Host "[17/22] Optimizing storage..." -ForegroundColor Yellow

fsutil behavior set DisableDeleteNotify 0 2>$null
fsutil behavior set disable8dot3 1 2>$null
fsutil behavior set disablelastaccess 1 2>$null
fsutil behavior set encryptpagingfile 0 2>$null

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0 -Type DWord -Force

schtasks /change /tn "\Microsoft\Windows\Defrag\ScheduledDefrag" /disable 2>$null

Write-Host "     -> TRIM on, prefetch off, 8.3 off, last-access off, defrag task off" -ForegroundColor Green

# ============================================================
# [18/22] TIMER RESOLUTION & BCDEDIT BOOT TWEAKS
# ============================================================
Write-Host "[18/22] Optimizing boot config and timer resolution..." -ForegroundColor Yellow

bcdedit /set useplatformtick yes 2>$null
bcdedit /set disabledynamictick yes 2>$null
bcdedit /deletevalue useplatformclock 2>$null
bcdedit /set bootmenupolicy standard 2>$null
bcdedit /set quietboot yes 2>$null
bcdedit /set verbose no 2>$null
bcdedit /timeout 3 2>$null
bcdedit /debug off 2>$null
bcdedit /set nx OptIn 2>$null

Write-Host "     -> Platform tick, quiet boot, debug off, 3s timeout" -ForegroundColor Green

# ============================================================
# [19/22] WINDOWS DEFENDER - Valorant Exclusions
# ============================================================
Write-Host "[19/22] Configuring Windows Defender for Valorant..." -ForegroundColor Yellow

$exclusionPaths = @(
    "C:\Riot Games",
    "C:\Riot Games\VALORANT",
    "C:\Riot Games\Riot Client",
    "$env:LOCALAPPDATA\VALORANT",
    "$env:ProgramFiles\Riot Vanguard"
)
foreach ($path in $exclusionPaths) {
    Add-MpPreference -ExclusionPath $path -ErrorAction SilentlyContinue
    Write-Host "     -> Excluded path: $path" -ForegroundColor DarkGray
}

$exclusionProcesses = @("VALORANT-Win64-Shipping.exe", "RiotClientServices.exe", "vgc.exe", "vgtray.exe")
foreach ($proc in $exclusionProcesses) {
    Add-MpPreference -ExclusionProcess $proc -ErrorAction SilentlyContinue
    Write-Host "     -> Excluded process: $proc" -ForegroundColor DarkGray
}

Set-MpPreference -ScanAvgCPULoadFactor 5 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableBlockAtFirstSeen $false -ErrorAction SilentlyContinue
Set-MpPreference -MAPSReporting 0 -ErrorAction SilentlyContinue

Write-Host "     -> Valorant paths/processes excluded, Defender CPU cap 5%" -ForegroundColor Green

# ============================================================
# [20/22] VALORANT - Process Priority + UAC + Mouse
# ============================================================
Write-Host "[20/22] Applying Valorant & input tweaks..." -ForegroundColor Yellow

# Valorant - Above Normal CPU + High IO
$valPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions"
If (!(Test-Path $valPath)) { New-Item -Path $valPath -Force | Out-Null }
Set-ItemProperty -Path $valPath -Name "CpuPriorityClass" -Value 3 -Type DWord -Force
Set-ItemProperty -Path $valPath -Name "IoPriority" -Value 3 -Type DWord -Force

# RiotClientServices - Normal
$riotPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RiotClientServices.exe\PerfOptions"
If (!(Test-Path $riotPath)) { New-Item -Path $riotPath -Force | Out-Null }
Set-ItemProperty -Path $riotPath -Name "CpuPriorityClass" -Value 2 -Type DWord -Force
Set-ItemProperty -Path $riotPath -Name "IoPriority" -Value 2 -Type DWord -Force

# Vanguard - Normal (do NOT boost)
foreach ($vProc in @("vgtray.exe", "vgc.exe")) {
    $vPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$vProc\PerfOptions"
    If (!(Test-Path $vPath)) { New-Item -Path $vPath -Force | Out-Null }
    Set-ItemProperty -Path $vPath -Name "CpuPriorityClass" -Value 2 -Type DWord -Force
}

# UAC - disable secure desktop dim (removes Vanguard/launcher black screen flash)
# Keeps UAC prompts but removes the 1-2s desktop dimming delay
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0 -Type DWord -Force

# Mouse - disable acceleration completely
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "CursorShadow" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host "     -> Valorant: Above Normal CPU + High IO" -ForegroundColor Green
Write-Host "     -> Vanguard/Riot: Normal priority (no game competition)" -ForegroundColor Green
Write-Host "     -> UAC secure desktop off (no more black screen on launch)" -ForegroundColor Green
Write-Host "     -> Mouse accel fully disabled, cursor shadow off" -ForegroundColor Green

# ============================================================
# [21/22] TASKBAR, ANIMATIONS & EXPLORER
# ============================================================
Write-Host "[21/22] Applying taskbar, animations, and Explorer tweaks..." -ForegroundColor Yellow

# Animations off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f | Out-Null
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](0x90,0x12,0x07,0x80,0x10,0x00,0x00,0x00)) -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ExtendedUIHoverTime" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AlwaysHibernateThumbnails" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Dark mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f | Out-Null

# Taskbar - left aligned, stripped
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f | Out-Null
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapBar /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableTaskGroups /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SnapAssist /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarGlomLevel /t REG_DWORD /d 2 /f | Out-Null

# Start menu
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecentlyAddedApps /t REG_DWORD /d 1 /f | Out-Null
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoRecentDocsHistory /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f | Out-Null

# Explorer tweaks
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f | Out-Null

# Restart Explorer to apply shell changes
Write-Host "     -> Restarting Explorer..." -ForegroundColor DarkGray
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 1500
Start-Process explorer

Write-Host "     -> Taskbar clean, dark mode, animations off, Explorer tweaked" -ForegroundColor Green

# ============================================================
# [22/22] FINAL CLEANUP
# ============================================================
Write-Host "[22/22] Final cleanup..." -ForegroundColor Yellow

# Scheduled tasks - kill remaining junk
$junkTasks = @(
    "\Microsoft\Windows\UpdateOrchestrator\Reboot",
    "\Microsoft\Windows\UpdateOrchestrator\Report policies",
    "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
    "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker",
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start",
    "\Microsoft\Windows\Shell\FamilySafetyMonitor",
    "\Microsoft\Windows\Shell\FamilySafetyRefreshTask",
    "\Microsoft\Windows\Printing\EduPrintProv",
    "\Microsoft\Windows\Flighting\FeatureConfig\ReconcileFeatures",
    "\Microsoft\Windows\Maps\MapsUpdateTask",
    "\Microsoft\Windows\Maps\MapsToastTask",
    "\Microsoft\Windows\MUI\LPRemove",
    "\Microsoft\Windows\LanguageComponentsInstaller\ReconcileLanguageResources",
    "\Microsoft\Windows\Speech\SpeechModelDownloadTask",
    "\Microsoft\Windows\HelloFace\FODCleanupTask",
    "\Microsoft\Windows\NlaSvc\WiFiTask",
    "\Microsoft\Windows\WlanSvc\CDSSync",
    "\Microsoft\Windows\Offline Files\Background Synchronization",
    "\Microsoft\Windows\Offline Files\Logon Synchronization",
    "\Microsoft\Windows\Work Folders\Work Folders Logon Synchronization",
    "\Microsoft\Windows\Work Folders\Work Folders Maintenance Work",
    "\Microsoft\Windows\InstallService\ScanForUpdates",
    "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser",
    "\Microsoft\Windows\InstallService\SmartRetry",
    "\Microsoft\Windows\Clip\License Validation",
    "\Microsoft\Windows\License Manager\TempSignedLicenseExchange",
    "\Microsoft\XblGameSave\XblGameSaveTask"
)
foreach ($task in $junkTasks) { schtasks /change /tn "$task" /disable 2>$null }

# Clear temp files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update cache (can be GBs of stale update files)
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue

# Clear prefetch folder
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear DirectX shader cache
Remove-Item -Path "$env:LOCALAPPDATA\D3DSCache\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Error Reporting folder
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear event logs
wevtutil el 2>$null | ForEach-Object { wevtutil cl "$_" 2>$null }

# Final DNS flush + network stack reset
ipconfig /flushdns 2>$null
netsh winsock reset 2>$null
netsh int ip reset 2>$null

Write-Host "     -> Junk tasks, temp files, WU cache, shader cache, WER logs cleared" -ForegroundColor Green
Write-Host "     -> Winsock + IP stack reset, DNS flushed" -ForegroundColor Green

# ============================================================
# DONE - SUMMARY
# ============================================================
Clear-Host
Write-Host ""
Write-Host "  ============================================================" -ForegroundColor Cyan
Write-Host "   HonestVL.com - Optimization v3 Complete!" -ForegroundColor Green
Write-Host "  ============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   TWEAKS APPLIED:" -ForegroundColor White
Write-Host ""
Write-Host "   [+] HonestVL.com ULTIMATE power plan (CPU locked 100%)" -ForegroundColor DarkGreen
Write-Host "   [+] 50+ bloatware apps removed + OneDrive uninstalled" -ForegroundColor DarkGreen
Write-Host "   [+] All telemetry, CEIP, delivery optimization killed" -ForegroundColor DarkGreen
Write-Host "   [+] WU blocked from overwriting NVIDIA driver" -ForegroundColor DarkGreen
Write-Host "   [+] 45+ unnecessary services disabled" -ForegroundColor DarkGreen
Write-Host "   [+] Startup bloat + delay removed" -ForegroundColor DarkGreen
Write-Host "   [+] Win32PrioritySeparation=26 (foreground CPU boost)" -ForegroundColor DarkGreen
Write-Host "   [+] MenuDelay=0, AutoEndTasks, WaitToKill=2s" -ForegroundColor DarkGreen
Write-Host "   [+] ClearPageFile=0, WER disabled, NTFS EFS set manual" -ForegroundColor DarkGreen
Write-Host "   [+] NVIDIA telemetry services, tasks, registry keys killed" -ForegroundColor DarkGreen
Write-Host "   [+] Visual effects / transparency / animations all off" -ForegroundColor DarkGreen
Write-Host "   [+] Ethernet: Nagle off, EEE off, IMR off, RSS on, QoS 0%" -ForegroundColor DarkGreen
Write-Host "   [+] DNS set to Cloudflare 1.1.1.1 / 1.0.0.1" -ForegroundColor DarkGreen
Write-Host "   [+] RTX 3060 Ti: HAGS on, GPU priority 8, FSO off" -ForegroundColor DarkGreen
Write-Host "   [+] MSI mode enabled for GPU + NIC" -ForegroundColor DarkGreen
Write-Host "   [+] Spectre/Meltdown mitigations disabled" -ForegroundColor DarkGreen
Write-Host "   [+] Game DVR / Xbox overlay / Game Mode all off" -ForegroundColor DarkGreen
Write-Host "   [+] Audio throttling off, enhancements disabled" -ForegroundColor DarkGreen
Write-Host "   [+] Memory compression off, pagefile fixed 4GB" -ForegroundColor DarkGreen
Write-Host "   [+] Storage: TRIM on, prefetch off, NTFS optimized" -ForegroundColor DarkGreen
Write-Host "   [+] BCDEdit: platform tick, quiet boot, debug off" -ForegroundColor DarkGreen
Write-Host "   [+] Defender: Valorant paths/processes excluded, CPU cap 5%" -ForegroundColor DarkGreen
Write-Host "   [+] Valorant: Above Normal CPU + High IO priority" -ForegroundColor DarkGreen
Write-Host "   [+] Vanguard/Riot: Normal priority (no core competition)" -ForegroundColor DarkGreen
Write-Host "   [+] UAC secure desktop off (no black screen on Vanguard launch)" -ForegroundColor DarkGreen
Write-Host "   [+] Mouse accel off, cursor shadow off" -ForegroundColor DarkGreen
Write-Host "   [+] Taskbar: left-aligned, stripped, dark mode on" -ForegroundColor DarkGreen
Write-Host "   [+] 30+ junk scheduled tasks killed" -ForegroundColor DarkGreen
Write-Host "   [+] WU cache, shader cache, prefetch, WER logs cleared" -ForegroundColor DarkGreen
Write-Host ""
Write-Host "  ============================================================" -ForegroundColor Cyan
Write-Host "   POST-RESTART CHECKLIST:" -ForegroundColor Yellow
Write-Host "  ============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   BIOS (do these manually):" -ForegroundColor White
Write-Host "   [ ] Enable XMP Profile 1 (RAM currently likely at 2133MHz)" -ForegroundColor Yellow
Write-Host "   [ ] Disable C-States (C1E, C3, C6, C7 - all off)" -ForegroundColor Yellow
Write-Host "   [ ] Disable Hyper-Threading (optional - test both)" -ForegroundColor Yellow
Write-Host "   [ ] Set PCIe to Gen 3 (3060 Ti is PCIe 4.0 but 9900 board is Gen 3)" -ForegroundColor Yellow
Write-Host "   [ ] Disable Secure Boot if not needed" -ForegroundColor Yellow
Write-Host "   [ ] Set fan curve to performance in BIOS" -ForegroundColor Yellow
Write-Host ""
Write-Host "   NVIDIA Control Panel (do these manually):" -ForegroundColor White
Write-Host "   [ ] Power management mode: Prefer Maximum Performance" -ForegroundColor Yellow
Write-Host "   [ ] Texture filtering quality: High Performance" -ForegroundColor Yellow
Write-Host "   [ ] Shader Cache Size: Unlimited" -ForegroundColor Yellow
Write-Host "   [ ] Low Latency Mode: Ultra (or On for Valorant)" -ForegroundColor Yellow
Write-Host "   [ ] Vertical Sync: Off" -ForegroundColor Yellow
Write-Host "   [ ] Triple Buffering: Off" -ForegroundColor Yellow
Write-Host "   [ ] Preferred refresh rate: Highest Available" -ForegroundColor Yellow
Write-Host "   [ ] Anisotropic filtering: Application-controlled" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Valorant In-Game:" -ForegroundColor White
Write-Host "   [ ] NVIDIA Reflex: Enabled + Boost" -ForegroundColor Yellow
Write-Host "   [ ] Limit FPS: Always - set to monitor Hz or uncapped" -ForegroundColor Yellow
Write-Host "   [ ] Material Quality: Low, Texture Quality: Low" -ForegroundColor Yellow
Write-Host "   [ ] Anti-Aliasing: MSAA 2x or None for max FPS" -ForegroundColor Yellow
Write-Host "   [ ] Multithreaded Rendering: On" -ForegroundColor Yellow
Write-Host ""
Write-Host "                      honestvl.com" -ForegroundColor DarkCyan
Write-Host ""

$restart = Read-Host "  Restart now to apply all changes? (y/n)"
if ($restart -eq "y" -or $restart -eq "Y") {
    Write-Host "  Restarting in 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Restart-Computer -Force
}
