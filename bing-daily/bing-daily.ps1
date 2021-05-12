$wallpaperPath = "$HOME\wallpaper.jpg"
$today = Get-Date -Format "yyyy-MM-dd"

if (Test-Path $wallpaperPath) {
  $fileDate = (Get-Item $wallpaperPath).LastWriteTime.ToString("yyyy-MM-dd")
  
  if($today -eq $fileDate) {
    Write-Host "No need to update"
    exit
  }
}

Write-Host "Downloading Bing Daily Wallpaper"

$baseUrl = "https://cn.bing.com"
$xmlUrl = "$baseUrl/HPImageArchive.aspx?format=xml&idx=0&n=1&uhd=1&uhdwidth=3840&uhdheight=2592"
$imgUrl = ([xml](Invoke-WebRequest $xmlUrl).Content).SelectNodes("/images/image[1]/urlBase") | Select-Object -Expand "#text"
$wallpaperUri = "$baseUrl$imgUrl" + "_UHD.jpg&w=3840&h=2592&rs=1&c=1&pid=hp"
Invoke-WebRequest $wallpaperUri -OutFile $wallpaperPath

$src = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(20, 0, path, 0x01 | 0x02);
  }
}
"@
Add-Type -TypeDefinition $src
[Wallpaper]::SetWallpaper($wallpaperPath)



