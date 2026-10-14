[CmdletBinding()]
param (
    [switch]$StatusOnly,
    [switch]$EnableAll,
    [switch]$RestartExplorer
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Language Detection Engine (TR / EN)
$script:isTR = (Get-UICulture).TwoLetterISOLanguageName -eq 'tr'

# Language Dictionary
$script:i18n = if ($script:isTR) {
    @{
        HeaderTitle          = "Windows Reklam ve Oneri Ayarlari Yoneticisi (Moduler CLI)"
        IsAdmin              = "Yonetici Yetkisi"
        CreatingRestorePoint = "Sistem Geri Yukleme Noktasi olusturuluyor..."
        RestorePointSuccess  = "Sistem Geri Yukleme Noktasi basariyla olusturuldu.`n"
        RestorePointFailed   = "Geri Yukleme Noktasi olusturulamadi (Sistem Geri Yukleme kapali olabilir).`n"
        SkippedAdmin         = "Atlandi: '{0}' icin Yonetici yetkisi gerekiyor."
        RestartingExplorer   = "Degisikliklerin uygulanmasi icin explorer.exe yeniden baslatiliyor..."
        SettingFailed       = "Ayar uygulanamadi: '{0}'. Hata: {1}"
        InvalidChoice       = "Gecersiz secim. Lutfen 1-4 arasinda bir secim yapin."
        LegacyEdgeCleanup   = "Onceki surumun Edge widget ayari kaldiriliyor..."
        LegacyEdgeSetting   = "Onceki surumden kalan Edge WebWidget ilkesi"
        MenuTitle            = "Windows Reklam ve Oneri Yoneticisi"
        Opt1                 = "Yonetilen reklam ve onerileri KAPAT"
        Opt2                 = "Mevcut Durumu Kontrol Et"
        Opt3                 = "Tum Ayarlari Varsayilana Geri AC"
        Opt4                 = "Cikis"
        PromptChoice         = "Seciminiz (1-4)"
        DonePressEnter       = "Islem tamamlandi! Devam etmek icin Enter'a basin..."
        PressEnter           = "Devam etmek icin Enter'a basin..."
        ResetPressEnter      = "Varsayilan ayarlar yuklendi! Devam etmek icin Enter'a basin..."
    }
} else {
    @{
        HeaderTitle          = "Windows Ad & Suggestion Settings Manager (Modular CLI)"
        IsAdmin              = "Is Administrator"
        CreatingRestorePoint = "Creating System Restore Point..."
        RestorePointSuccess  = "System Restore Point created successfully.`n"
        RestorePointFailed   = "Could not create System Restore Point (System Restore might be disabled).`n"
        SkippedAdmin         = "Skipped: '{0}' requires Administrator privileges."
        RestartingExplorer   = "Restarting explorer.exe to apply changes..."
        SettingFailed       = "Could not apply setting '{0}'. Error: {1}"
        InvalidChoice       = "Invalid selection. Please choose a number from 1 to 4."
        LegacyEdgeCleanup   = "Removing the Edge widget policy left by a previous version..."
        LegacyEdgeSetting   = "Legacy Edge WebWidget policy"
        MenuTitle            = "Windows Ads & Suggestions Manager"
        Opt1                 = "Disable Managed Ads & Suggestions"
        Opt2                 = "Check Current Status"
        Opt3                 = "Restore All Settings to Default"
        Opt4                 = "Exit"
        PromptChoice         = "Your Choice (1-4)"
        DonePressEnter       = "Process completed! Press Enter to continue..."
        PressEnter           = "Press Enter to continue..."
        ResetPressEnter      = "Default settings restored! Press Enter to continue..."
    }
}

# 1. Administrator Privilege Check
function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 2. Restore Point Service
function New-DeBloatRestorePoint {
    if (-not (Test-IsAdmin)) { return }

    Write-Host $script:i18n.CreatingRestorePoint -ForegroundColor Yellow
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Before WindowsDeBloat Settings" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Host $script:i18n.RestorePointSuccess -ForegroundColor Green
    } catch {
        Write-Warning $script:i18n.RestorePointFailed
    }
}

# 3. Data Layer: Declarative Repository (Dynamic Localization)
function Get-AdSettingDefinitions {
    $cur_ver = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
    $isTR =$script:isTR

    return @(
        @{
            Id            = "explorer_sync_notifications"
            Category      = if ($isTR) { "Dosya Gezgini" } else { "File Explorer" }
            Description   = if ($isTR) { "Dosya Gezgini senkronizasyon bildirimleri" } else { "Sync provider notifications in File Explorer" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\Explorer\Advanced"; Name = "ShowSyncProviderNotifications"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "lockscreen_ads"
            Category      = if ($isTR) { "Kilit Ekrani" } else { "Lock Screen" }
            Description   = if ($isTR) { "Kilit ekrani ipuclari ve onerileri" } else { "Fun facts, tips, and tricks on lock screen" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "RotatingLockScreenOverlayEnabled"; DisabledValue = 0 },
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-338387Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "settings_suggestions"
            Category      = if ($isTR) { "Ayarlar Uygulamasi" } else { "Settings App" }
            Description   = if ($isTR) { "Ayarlar uygulamasindaki onerilen icerikler" } else { "Suggested content in Settings app" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-338393Enabled"; DisabledValue = 0 },
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-353694Enabled"; DisabledValue = 0 },
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-353696Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "windows_tips"
            Category      = if ($isTR) { "Windows Ipuclari" } else { "Windows Tips" }
            Description   = if ($isTR) { "Windows kullanim ipuclari ve onerileri" } else { "Tips and suggestions when using Windows" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-338389Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "scoobe_suggestions"
            Category      = if ($isTR) { "Cihaz Kurulumu" } else { "Device Setup" }
            Description   = if ($isTR) { "Cihaz kurulumunu tamamlama ve kurulum onerileri" } else { "Suggestions to get the most out of Windows and finish setup" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\UserProfileEngagement"; Name = "ScoobeSystemSettingEnabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "welcome_experience"
            Category      = if ($isTR) { "Karsilama Ekrani" } else { "Welcome Experience" }
            Description   = if ($isTR) { "Guncelleme sonrasi karsilama ekrani gosterimi" } else { "Windows welcome experience after updates" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\ContentDeliveryManager"; Name = "SubscribedContent-310093Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "advertising_id"
            Category      = if ($isTR) { "Gizlilik" } else { "Privacy" }
            Description   = if ($isTR) { "Kisisellestirilmis reklam kimligi kullanimi" } else { "Personalized ads using advertising ID" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\AdvertisingInfo"; Name = "Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "tailored_experiences"
            Category      = if ($isTR) { "Gizlilik" } else { "Privacy" }
            Description   = if ($isTR) { "Kisisellestirilmis deneyimler ve teshis verileri" } else { "Tailored experiences with diagnostic data" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\Privacy"; Name = "TailoredExperiencesWithDiagnosticDataEnabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "start_iris_recommendations"
            Category      = if ($isTR) { "Baslat Menusu" } else { "Start Menu" }
            Description   = if ($isTR) { "Baslat menusu ipucu, kisayol ve uygulama onerileri" } else { "Recommendations for tips, shortcuts, and new apps on Start" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\Explorer\Advanced"; Name = "Start_IrisRecommendations"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "smart_opt_out_notifications"
            Category      = if ($isTR) { "Bildirimler" } else { "Notifications" }
            Description   = if ($isTR) { "Kullanilmayan uygulama bildirim kapatma uyarisi" } else { "Unused app notification opt-out suggestions" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "$cur_ver\Notifications\Settings\Windows.ActionCenter.SmartOptOut"; Name = "Enabled"; DisabledValue = 0 }
            )
        },
        @{
            Id            = "search_bing_suggestions"
            Category      = if ($isTR) { "Windows Arama" } else { "Windows Search" }
            Description   = if ($isTR) { "Arama cubugunda Bing web sonuclari ve onerileri" } else { "Bing results and search suggestions in Windows Search" }
            RequiresAdmin = $false
            Targets       = @(
                @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"; Name = "DisableSearchBoxSuggestions"; DisabledValue = 1 },
                @{ Path = "$cur_ver\Search"; Name = "BingSearchEnabled"; DisabledValue = 0 }
            )
        }
    )
}

# 4. Status Evaluator Service
function Get-AdSettingStatus {
    param ([hashtable]$Setting)

    foreach ($target in $Setting.Targets) {
        if (-not (Test-Path -Path $target.Path)) { return "Enabled" }
        
        $properties = Get-ItemProperty -Path $target.Path -ErrorAction Stop
        $property = $properties.PSObject.Properties[$target.Name]
        if ($null -eq $property -or $property.Value -ne $target.DisabledValue) {
            return "Enabled"
        }
    }
    return "Disabled"
}

# 5. State Mutator Service
function Set-AdSettingState {
    [CmdletBinding()]
    param (
        [hashtable]$Setting,
        [bool]$Disable =$true
    )

    $isAdmin = Test-IsAdmin
    if ($Setting.RequiresAdmin -and -not$isAdmin) {
        Write-Warning ($script:i18n.SkippedAdmin -f$Setting.Description)
        return
    }

    foreach ($target in $Setting.Targets) {
        if ($Disable) {
            if (-not (Test-Path -Path $target.Path)) {
                New-Item -Path $target.Path -Force -ErrorAction Stop | Out-Null
            }
            New-ItemProperty -Path $target.Path -Name $target.Name -Value $target.DisabledValue -PropertyType DWord -Force -ErrorAction Stop | Out-Null
        } elseif (Test-Path -Path $target.Path) {
            $properties = Get-ItemProperty -Path $target.Path -ErrorAction Stop
            if ($properties.PSObject.Properties[$target.Name]) {
                Remove-ItemProperty -Path $target.Path -Name $target.Name -ErrorAction Stop
            }
        }
    }
}

function Remove-LegacyEdgeWebWidgetPolicy {
    [CmdletBinding()]
    param (
        [string]$Path = "HKCU:\Software\Policies\Microsoft\Edge"
    )

    if (-not (Test-Path -Path $Path)) {
        return
    }

    $legacyPolicy = Get-ItemProperty -Path $Path -Name "WebWidgetAllowed" -ErrorAction SilentlyContinue
    if ($null -ne $legacyPolicy -and $legacyPolicy.WebWidgetAllowed -eq 0) {
        Write-Host $script:i18n.LegacyEdgeCleanup -ForegroundColor Yellow
        Remove-ItemProperty -Path $Path -Name "WebWidgetAllowed" -ErrorAction Stop
    }
}

# 6. Main Orchestrator (CLI Architecture)
function Invoke-WindowsDeBloat {
    [CmdletBinding()]
    param (
        [switch]$StatusOnly,
        [switch]$EnableAll,
        [switch]$RestartExplorer
    )

    $settings = Get-AdSettingDefinitions
    $isAdmin = Test-IsAdmin

    if (-not $StatusOnly) {
        New-DeBloatRestorePoint

        try {
            Remove-LegacyEdgeWebWidgetPolicy
        } catch {
            Write-Warning ($script:i18n.SettingFailed -f $script:i18n.LegacyEdgeSetting, $_.Exception.Message)
        }
    }

    Write-Host "`n============================================================" -ForegroundColor Cyan
    Write-Host " $($script:i18n.HeaderTitle)" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "$($script:i18n.IsAdmin): $isAdmin`n" -ForegroundColor Yellow

    foreach ($setting in $settings) {
        if ($StatusOnly) {
            $status = Get-AdSettingStatus -Setting$setting
            $statusColor = if ($status -eq "Disabled") { "Green" } else { "Red" }
            Write-Host ("[{0,-8}] {1,-18} - {2}" -f $status,$setting.Category, $setting.Description) -ForegroundColor $statusColor
        } else {
            $targetDisable = -not$EnableAll
            try {
                Set-AdSettingState -Setting $setting -Disable $targetDisable -ErrorAction Stop
            } catch {
                Write-Warning ($script:i18n.SettingFailed -f $setting.Description, $_.Exception.Message)
            }
            
            $newStatus = Get-AdSettingStatus -Setting$setting
            $newStatusColor = if ($newStatus -eq "Disabled") { "Green" } else { "Red" }
            Write-Host ("[{0,-8}] {1,-18} - {2}" -f $newStatus,$setting.Category, $setting.Description) -ForegroundColor $newStatusColor
        }
    }

    if (-not $StatusOnly -and$RestartExplorer) {
        Write-Host "`n$($script:i18n.RestartingExplorer)" -ForegroundColor Yellow
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Process explorer.exe
    }
}

# 7. Script entry point and interactive menu
$isDotSourced = $MyInvocation.InvocationName -eq '.'
if (-not $isDotSourced -and $PSBoundParameters.Count -gt 0) {
    Invoke-WindowsDeBloat @PSBoundParameters
} elseif (-not $isDotSourced) {
    do {
        Clear-Host
        Write-Host "============================================================" -ForegroundColor Cyan
        Write-Host "         $($script:i18n.MenuTitle)                          " -ForegroundColor Cyan
        Write-Host "============================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  [1] $($script:i18n.Opt1)" -ForegroundColor Green
        Write-Host "  [2] $($script:i18n.Opt2)" -ForegroundColor Yellow
        Write-Host "  [3] $($script:i18n.Opt3)" -ForegroundColor Red
        Write-Host "  [4] $($script:i18n.Opt4)" -ForegroundColor White
        Write-Host ""
        $choice = Read-Host $script:i18n.PromptChoice

        switch ($choice) {
            "1" {
                Invoke-WindowsDeBloat -RestartExplorer
                Write-Host "`n$($script:i18n.DonePressEnter)" -ForegroundColor Yellow
                [void][System.Console]::ReadLine()
            }
            "2" {
                Invoke-WindowsDeBloat -StatusOnly
                Write-Host "`n$($script:i18n.PressEnter)" -ForegroundColor Yellow
                [void][System.Console]::ReadLine()
            }
            "3" {
                Invoke-WindowsDeBloat -EnableAll -RestartExplorer
                Write-Host "`n$($script:i18n.ResetPressEnter)" -ForegroundColor Yellow
                [void][System.Console]::ReadLine()
            }
            { $_ -notin @("1", "2", "3", "4") } {
                Write-Warning $script:i18n.InvalidChoice
                [void][System.Console]::ReadLine()
            }
        }
    } while ($choice -ne "4")
}