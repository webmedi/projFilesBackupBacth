@echo off
rem https://itpc.blog.fc2.com/blog-entry-193.html
chcp 65001

rem variable
set currentDir=%~dp0
set logName=backup
set backupDir=E:\ITEM\BackUp

rem main
call :LogCreate %logName% %currentDir% ---
call :LogLf %logName% %currentDir%
call :LogCreate %logName% %currentDir% "batch process begin : %date% %time%"
cd /d %currentDir%

call :FileCreate %backupDir% "ThunderbirdPortable"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "thunderbard mail data backup process begin"
	call :FileCopy E:\root\app\ThunderbirdPortable %backupDir%\ThunderbirdPortable
	call :LogCreate %logName% %currentDir% "thunderbard mail data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% ".atom"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "atom data backup process begin"
	call :FileCopy %USERPROFILE%\.atom %backupDir%\.atom\
	call :LogCreate %logName% %currentDir% "atom data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% ".vscode"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "vs code data backup process begin"
	call :FileCopy %USERPROFILE%\.vscode %backupDir%\.vscode\
	call :LogCreate %logName% %currentDir% "vs code data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% "WorkSpace"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "WorkSpace data backup process begin"
	call :FileCopy E:\ITEM\WorkSpace %backupDir%\WorkSpace\
	call :LogCreate %logName% %currentDir% "WorkSpace data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% "スタートアップ"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "スタートアップ data backup process begin"
	call :FileCopy "C:\Users\ushiyama\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" %backupDir%\スタートアップ\
	call :LogCreate %logName% %currentDir% "スタートアップ data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% "お気に入り"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "お気に入り data backup process begin"
	call :FileCopy C:\Users\ushiyama\Favorites %backupDir%\お気に入り\
	call :LogCreate %logName% %currentDir% "お気に入り data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% "WindowsHostsFile"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "WindowsHostsFile data backup process begin"
	call :FileCopy C:\Windows\System32\drivers\etc %backupDir%\WindowsHostsFile\
	call :LogCreate %logName% %currentDir% "WindowsHostsFile data backup process end"

)

echo "Init 前 : "%returnBool%
call :Init
echo "Init 後 : "%returnBool%

call :FileCreate %backupDir% "clibor"

if %returnBool% == true (
	call :LogCreate %logName% %currentDir% "clibor data backup process begin"
	call :FileCopy E:\root\app\clibor %backupDir%\clibor\
	call :LogCreate %logName% %currentDir% "clibor data backup process end"

)

if %returnBool% == true (
	call :7zPress E:\ITEM\%logName%.7z %backupDir%

)

call :LogLf %logName% %currentDir%
call :LogCreate %logName% %currentDir% "batch process end : %date% %time%"
call :LogLf %logName% %currentDir%
call :LogLf %logName% %currentDir%

exit /b

rem FileCreate( pass, name )
:FileCreate

	call :LogLf %logName% %currentDir%

	if exist %1\%2 (
		call :LogCreate %logName% %currentDir% "フォルダ, %2 は, すでに存在しています。"
		rem call :LogLf %logName% %currentDir%
		set returnBool=true

	) else (
		mkdir %1\%2
		if %ERRORLEVEL% == 0 (
			call :LogCreate %logName% %currentDir% " { %2 }フォルダを作成しました。"
			set returnBool=true

		) else (
			call :LogCreate %logName% %currentDir% "FileCreate function failed エラーレベルは : { %ERRORLEVEL% } です。"
			exit /b

		)

	)

	call :LogLf %logName% % currentDir%

exit /b

rem LogCreate( logName, createPass, logMessage )
:LogCreate
	echo %3 >> %2\%1.log
exit /b

rem LogLf( logName, createPass )
:LogLf
	echo; >> %2\%1.log
exit /b

rem Init( void )
:Init
	set returnBool=false
exit /b

rem FileCopy( copyOriginalDir, copyDirTo )
:FileCopy
	rem 引数のパスの最後に \ をつけないようにする

	call :LogLf %logName% %currentDir%

	if exist %1 (
		rem xcopy /e /d /s /r /y /i /k /c /h %1 %2 >> %currentDir%\%logName%.log 2>>&1
		rem robocopy manual : http://www.atmarkit.co.jp/ait/articles/1404/30/news110.html
		robocopy /S /COPY:DAT /PURGE /MON:0 /R:1 /W:1 /Z %1 %2 >> %currentDir%\%logName%.log 2>>&1
		echo "FileCopy Function Failed : %ERRORLEVEL%"
		call :LogCreate %logName% %currentDir% " { %1 } から { %2 } へコピーしました。"

	) else (
		call :LogCreate %logName% %currentDir% "FileCopy function failed : コピー元 { %1 } フォルダがありません。"
		call :LogLf %logName% %currentDir%
		exit /b

	)

	call :LogLf %logName% %currentDir%

exit /b

rem 7zPress( resultOutDirName, inPressDir )
rem example : ( E:\ITEM\test.7z, E:\ITEM\test )
:7zPress
	call :LogCreate %logName% %currentDir% "-----------------------------------------------------------------------------"
	call :LogLf %logName% %currentDir%
	if exist %2 (
		rem すでにバックアップファイルが存在する場合は, 削除を行う
		if exist %1 (
			del /q %1
			rem マルチスレッドオプション有効化, 上書き書き込み, 圧縮レベル 9 ( 最高 )
			7z a -mmt=on -mx=9 %1 %2 >> %currentDir%\%logName%.log 2>>&1
			echo %ERRORLEVEL%
			if NOT %ERRORLEVEL% == 0 (
				call :LogCreate %logName% %currentDir% "7z failed : 7z 圧縮プログラムでエラーが発生しました。"

			)

		) else (
			call :LogCreate %logName% %currentDir% "7z failed : { %1 } ディレクトリがありません。圧縮先保存ディレクトリがあるか確認して下さい。"

		)

	) else (
		call :LogCreate %logName% %currentDir% "7z failed : 圧縮元 { %2 } フォルダがありません。"

	)
	call :LogLf %logName% %currentDir%
	call :LogCreate %logName% %currentDir% "-----------------------------------------------------------------------------"

exit /b

rem 7zUnPress( resultOutDir, inPressedFilePath )
rem example : ( E:\ITEM\unpress, E:\ITEM\test.7z )
:7zUnPress
	call :LogCreate %logName% %currentDir% "-----------------------------------------------------------------------------"
	7z x -o%1 %2 >> %currentDir%\%logName%.log 2>>&1
	call :LogLf %logName% %currentDir%
	call :LogCreate %logName% %currentDir% "-----------------------------------------------------------------------------"

exit /b
