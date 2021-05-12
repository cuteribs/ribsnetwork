$wallpaperPath = "$HOME\wallpaper.jpg"
$today = Get-Date -Format "yyyy-MM-dd"
echo $today
$wallpaperUri = "https://r5ea.blob.core.windows.net/bingdaily/wallpapers/2021/05/2021-05-11.jpg"


$setWallpaperSrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;

  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setWallpaperSrc


# Invoke-WebRequest $wallpaperUri -OutFile $wallpaperPath

# [Wallpaper]::SetWallpaper($wallpaperPath)

[Windows.System.UserProfile.LockScreen,Windows.System.UserProfile,ContentType=WindowsRuntime]

$image = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($wallpaperPath)) ([Windows.Storage.StorageFile])
AwaitAction ([Windows.System.UserProfile.LockScreen]::SetImageFileAsync($image))







