@ECHO OFF

SET WALLPAPER_PATH="%HOME%\wallpaper.jpg"

ECHO %WALLPAPER_PATH%

#reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "C:\[LOCATION OF WALLPAPER HERE]" /f 
#reg delete "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v WallpaperStyle /f
#reg add "HKCU\control panel\desktop" /v WallpaperStyle /t REG_SZ /d 2 /f
#RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 
exit