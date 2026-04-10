@echo off
setlocal enabledelayedexpansion

:: 1. Dein Hauptordner
set BASE_DIR=D:\ICL-Scans
set OUT_DIR=%BASE_DIR%\Voxel_Output

:: Erstelle den Sammelordner
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

echo Starte automatische Voxelization...
echo Alle fertigen Modelle landen in: %OUT_DIR%
echo ----------------------------------------------------

:: 2. Gehe durch alle Unterordner
for /d %%D in ("%BASE_DIR%\*") do (
    set "SCAN_NAME=%%~nxD"
    
    if not "!SCAN_NAME!"=="Voxel_Output" (

        :: 3. Pfade zusammenbauen
        set "PLY_PATH1=%%~fD\point_cloud\iteration_100\point_cloud.ply"
        set "PLY_PATH2=%%~fD\point_cloud\iteration_100\point_cloud1.ply"
        set "PLY_PATH3=%%~fD\output_PLY\point_cloud\iteration_100\point_cloud.ply"
        set "PLY_PATH4=%%~fD\output_PLY\point_cloud\iteration_100\point_cloud1.ply"
        set "TARGET_PLY="

        :: 4. Pruefen, welche Datei existiert
        if exist "!PLY_PATH1!" (
            set "TARGET_PLY=!PLY_PATH1!"
        ) else if exist "!PLY_PATH2!" (
            set "TARGET_PLY=!PLY_PATH2!"
        ) else if exist "!PLY_PATH3!" (
            set "TARGET_PLY=!PLY_PATH3!"
        ) else if exist "!PLY_PATH4!" (
            set "TARGET_PLY=!PLY_PATH4!"
        )

        :: 5. Voxelization starten
        if defined TARGET_PLY (
            echo.
            echo Verarbeite Ordner: !SCAN_NAME!
            echo Datei gefunden: !TARGET_PLY!
            
            :: DER BEFEHL OHNE EXTRAS - Einfach nur Input und Output
            call splat-transform "!TARGET_PLY!" "%OUT_DIR%\!SCAN_NAME!.voxel.glb"
            
            :: ECHTE FEHLERKONTROLLE
            if !ERRORLEVEL! NEQ 0 (
                echo [FEHLER] Konvertierung abgebrochen fuer: !SCAN_NAME!
            ) else (
                echo [ERFOLG] !SCAN_NAME!.voxel.glb wurde erfolgreich erstellt!
            )
        ) else (
            echo.
            echo [UEBERSPRUNGEN] !SCAN_NAME!: Keine .ply gefunden.
        )
    )
)

echo.
echo ----------------------------------------------------
echo Vorgang abgeschlossen! 
pause