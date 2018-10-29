@echo off
title 잠금화면 추출기
mode con cols=70 lines=25
echo		
echo		                 잠금화면  추출하기                  
echo		
echo.

echo ---- 변수지정
set LockScreenNowDir=%cd%
set LockScreen=%USERPROFILE%\Desktop\LockScreen
set LockScreenImage=%USERPROFILE%\Desktop\LockScreen\Image
set LockScreenTemp=%USERPROFILE%\Desktop\LockScreen\temp
set LockScreenOrg=%LocalAppData%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
echo -- 지정 완료
echo.
REM pause

echo ---- 기본폴더 유무 확인
if exist %LockScreen% (
	echo -- 기본폴더 확인됨
	if not %LockScreenNowDir% == %LockScreen% (
		cd /d %LockScreen%
		echo -- 작업창 이동
		echo.
	)
) else (
	echo -- 기본폴더 없음
	echo -- 바탕화면으로 폴더 복사
	mkdir %LockScreen%
	xcopy /s /q %LockScreenNowDir% %LockScreen%
	cd /d %LockScreen%
	echo -- 복사 완료
	echo.
)
REM pause

echo ---- 폴더 생성
if not exist %LockScreenImage% mkdir %LockScreenImage%
mkdir %LockScreenTemp%
echo -- 생성 완료
echo.
REM pause

echo ---- 잠금화면 폴더 복제
xcopy /q %LockScreenOrg% %LockScreenTemp%
echo -- 복제 완료
echo.
REM pause

echo ---- 복제된 이미지 작업 세팅
ren %LockScreenTemp%\*.* *.jpg
xcopy /q %LockScreen%\tools %LockScreenTemp%
echo -- 세팅 완료
echo.
REM pause

echo ---- 고해상도 이미지 선별
cd %LockScreenTemp%
(for /r %%a in (*.jpg) do (
    set width=
    set height=
    for /f "tokens=1*delims=:" %%b in ('"mediainfo --INFORM=Image;%%Width%%:%%Height%% "%%~a""') do (
		if %%~b geq 1920 (
			REM echo %%~a %%~b %%~c
		) else (
			del %%~a
		)
	)
))
echo -- 선별 완료
echo.
REM pause

echo ---- 이미지 이동
setlocal enabledelayedexpansion
set count=1
for /f "tokens=*" %%z in ('dir /b %LockScreenImage%\*.jpg') do (
	set /a count+=1
)
for /f "tokens=*" %%d in ('dir /b *.jpg') do (
	SET OVLcheck=2
	for /f %%y in (list.txt) do (
		REM echo %%y
		if %%d == %%y set /a OVLcheck=1
	)
	REM echo OVLcheck=!OVLcheck!
	if !OVLcheck! equ 1 (
		del %%d
	) else (
		echo %%d>>list.txt
		if !count! lss 1000 (
			if !count! lss 100 (
				if !count! lss 10 (
					ren %%d Image000!count!.jpg
					move Image000!count!.jpg %LockScreenImage%
				) else (
					ren %%d Image00!count!.jpg
					move Image00!count!.jpg %LockScreenImage%
				)
			) else (
				ren %%d Image0!count!.jpg
				move Image0!count!.jpg %LockScreenImage%
			)
		) else (
			ren %%d Image!count!.jpg
			move Image!count!.jpg %LockScreenImage%
		)
		set /a count+=1
	)
)
endlocal
echo -- 이동 완료
echo.

echo ---- list.txt 덮어쓰기
xcopy /y /q %LockScreenTemp%\list.txt %LockScreen%\tools\
echo -- 덮어쓰기 완료
echo.
REM pause

echo ---- 임시폴더 삭제
cd %LockScreen%
rmdir /s /q %LockScreenTemp%
echo -- 삭제 완료
echo.
pause