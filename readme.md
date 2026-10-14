# 🛡️ Windows DeBloat & Ad Remover / Windows Reklam ve Öneri Kapatıcı

[English](#english) | [Türkçe](#türkçe)


---

<a name="english"></a>
## 🇬🇧 English

A lightweight, modular, data-driven PowerShell script designed to disable selected Windows 10/11 advertising, suggestions, and web-search integrations.

Inspired by open-source debloat projects like **OFGB**, completely refactored into a clean, zero-dependency PowerShell architecture.

---

### ✨ Features

* **Modular Architecture:** Separates registry definitions, status evaluators, and state mutators. Adding new settings is as simple as adding a hashtable definition.
* **Safety First:** Attempts to create a **System Restore Point** before changing settings (requires Administrator privileges and System Restore support).
* **One-Click Execution:** Includes a `Disable-Ads.bat` launcher that automatically requests Administrator privileges and bypasses execution policies.
* **Interactive CLI Menu:** User-friendly menu for non-technical users, alongside advanced command-line parameters for sysadmins.
* **Reversible to Defaults:** Removes the registry values managed by this tool so Windows defaults can apply. This does not restore custom values that existed before the tool was run.

---

### 🚀 Quick Start (For End Users — No Build Required)

1. Download **`WindowsDeBloat-v1.0.0.zip`** from the [latest release](https://github.com/modestustr/RemoveAdsWin11ByPowerShell/releases/latest).
2. Extract the ZIP file.
3. Double-click **`Disable-Ads.bat`**.
4. Grant Administrator permissions when prompted.
5. Select **`[1] Disable Managed Ads & Suggestions`** from the menu.

You do **not** need Visual Studio, the .NET SDK, or to compile source code. The release ZIP contains everything needed to run the tool.

---

### 💻 Advanced Usage (CLI for Power Users)

You can load the script functions into your active PowerShell session:

```powershell
. .\WindowsDeBloat.ps1
```

#### Available Parameters

The script can also be run directly with these parameters:

```powershell
.\WindowsDeBloat.ps1 -StatusOnly
.\WindowsDeBloat.ps1 -EnableAll
.\WindowsDeBloat.ps1 -RestartExplorer
```

| Parameter | Description |
| :--- | :--- |
| `Invoke-WindowsDeBloat -StatusOnly` | Checks and reports the current status without making changes. |
| `Invoke-WindowsDeBloat -RestartExplorer` | Applies debloat settings and automatically restarts `explorer.exe`. |
| `Invoke-WindowsDeBloat -EnableAll` | Removes the managed registry values to return those settings to Windows defaults. |

---

### 📋 Managed Windows Settings

* **File Explorer:** Sync provider notifications
* **Lock Screen:** Fun facts, tips, tricks, and lock screen overlays
* **Settings App:** Suggested content and promotional recommendations
* **Windows Tips:** In-system tips and suggestion banners
* **Device Setup:** Windows Welcome Experience & "Finish setup" reminders
* **Privacy:** Personalized ads using Advertising ID & Tailored Diagnostic Data
* **Start Menu:** Recommended apps, tips, and shortcuts
* **Windows Search:** Bing search results and web suggestions in the search bar

The Edge Web Widget policy is intentionally not managed: setting it can make Edge report that it is managed by an organization. When applying settings or restoring defaults, the script removes the `WebWidgetAllowed` value only when it is `0`, the value written by earlier versions of this script.

---

<a name="türkçe"></a>
## 🇹🇷 Türkçe

Windows 10/11 üzerindeki belirli reklamları, önerileri ve web arama entegrasyonlarını kapatmak için geliştirilmiş modüler ve hafif PowerShell betiği.

**OFGB** gibi açık kaynaklı projelerden esinlenilmiş, bağımsız ve sürdürülebilir bir PowerShell mimarisine dönüştürülmüştür.

---

### ✨ Özellikler

* **Modüler Mimarisi:** Kayıt defteri tanımlarını, durum kontrollerini ve işlem motorunu birbirinden ayırır.
* **Önce Güvenlik:** Ayarları değiştirmeden önce **Sistem Geri Yükleme Noktası** oluşturmayı dener (Yönetici yetkisi ve Sistem Geri Yükleme desteği gerekir).
* **Tek Tıkla Çalıştırma:** Yönetici yetkisini otomatik isteyen ve politika engellerini aşan `Disable-Ads.bat` başlatıcısı içerir.
* **İnteraktif Menü:** Son kullanıcılar için pratik konsol menüsü ve sistem yöneticileri için komut satırı parametreleri sunar.
* **Varsayılana Döndürülebilir:** Betiğin yönettiği kayıt defteri değerlerini silerek Windows varsayılanlarının uygulanmasını sağlar. Betik çalıştırılmadan önce var olan özel değerleri saklayıp geri yüklemez.

---

### 🚀 Hızlı Başlangıç (Son Kullanıcılar İçin — Derleme Gerekmez)

1. **`WindowsDeBloat-v1.0.0.zip`** dosyasını [son sürüm sayfasından](https://github.com/modestustr/RemoveAdsWin11ByPowerShell/releases/latest) indirin.
2. ZIP dosyasını çıkarın.
3. **`Disable-Ads.bat`** dosyasına çift tıklayın.
4. Çıkan ekranda Yönetici iznini onaylayın.
5. Açılan menüden **`[1]`** seçeneğini seçip **Enter** tuşuna basın.

Visual Studio'ya, .NET SDK'ya veya kaynak kodu derlemeye **gerek yoktur**. Sürüm ZIP'i programı çalıştırmak için gereken dosyaları içerir.

---

### 💻 Gelişmiş Kullanım (Güçlü Kullanıcılar ve CLI)

Betiği doğrudan PowerShell oturumunuza yükleyebilirsiniz:

```powershell
. .\WindowsDeBloat.ps1
```

#### Kullanılabilir Komutlar

Betiği aşağıdaki parametrelerle doğrudan da çalıştırabilirsiniz:

```powershell
.\WindowsDeBloat.ps1 -StatusOnly
.\WindowsDeBloat.ps1 -EnableAll
.\WindowsDeBloat.ps1 -RestartExplorer
```

| Komut / Parametre | Açıklama |
| :--- | :--- |
| `Invoke-WindowsDeBloat -StatusOnly` | Hiçbir değişiklik yapmadan mevcut kayıt defteri durumlarını raporlar. |
| `Invoke-WindowsDeBloat -RestartExplorer` | Ayarları uygular ve değişikliklerin anında etkinleşmesi için Gezgini (`explorer.exe`) yeniden başlatır. |
| `Invoke-WindowsDeBloat -EnableAll` | Yönetilen kayıt defteri değerlerini silerek ilgili ayarları Windows varsayılanlarına döndürür. |

---

### 📋 Yönetilen Windows Ayarları

* **Dosya Gezgini:** Senkronizasyon bildirimleri
* **Kilit Ekranı:** İpuçları, öneriler ve arka plan bilgileri
* **Ayarlar Uygulaması:** Önerilen içerikler ve reklamlar
* **Windows İpuçları:** Sistem içi kullanım ipuçları
* **Cihaz Kurulumu:** Güncelleme sonrası karşılama ekranları ve "Kurulumu tamamlayın" uyarıları
* **Gizlilik:** Reklam Kimliği ve Teşhis Verileri ile kişiselleştirilmiş deneyimler
* **Başlat Menüsü:** Önerilen uygulamalar, kısayollar ve ipuçları
* **Windows Arama:** Başlat/Arama çubuğundaki Bing web sonuçları

Edge Web Widget ilkesi artık betik tarafından yönetilmez; bu ilke Edge'in kuruluş tarafından yönetildiğini göstermesine neden olabilir. Ayarlar uygulanırken veya varsayılanlara dönülürken betik, yalnızca önceki sürümlerin yazdığı `0` değerini bulursa `WebWidgetAllowed` kaydını siler.

---

### ⚠️ Disclaimer / Sorumluluk Reddi

This script modifies selected registry values under `HKCU`. Use it at your own risk. A restore point is attempted before changes when run as Administrator and when System Restore is available.

Bu betik `HKCU` altındaki belirli kayıt defteri değerlerini değiştirir. Kullanım sorumluluğu kullanıcıya aittir. Yönetici olarak çalıştırıldığında ve Sistem Geri Yükleme kullanılabiliyorsa değişiklik öncesinde geri yükleme noktası oluşturmayı dener.

---

### 📜 License / Lisans

Distributed under the MIT License. See `LICENSE` for more information.