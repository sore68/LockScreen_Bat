@echo off
title ���ȭ�� �����
mode con cols=70 lines=25
echo		
echo		                 ���ȭ��  �����ϱ�                  
echo		
echo.

echo ---- ��������
set LockScreenNowDir=%cd%
set LockScreen=%USERPROFILE%\Desktop\LockScreen
set LockScreenImage=%USERPROFILE%\Desktop\LockScreen\Image
set LockScreenTemp=%USERPROFILE%\Desktop\LockScreen\temp
set LockScreenOrg=%LocalAppData%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
echo -- ���� �Ϸ�
echo.
REM pause

echo ---- �⺻���� ���� Ȯ��
if exist %LockScreen% (
	echo -- �⺻���� Ȯ�ε�
	if not %LockScreenNowDir% == %LockScreen% (
		cd /d %LockScreen%
		echo -- �۾�â �̵�
		echo.
	)
) else (
	echo -- �⺻���� ����
	echo -- ����ȭ������ ���� ����
	mkdir %LockScreen%
	xcopy /s /q %LockScreenNowDir% %LockScreen%
	cd /d %LockScreen%
	echo -- ���� �Ϸ�
	echo.
)
REM pause

echo ---- ���� ����
if not exist %LockScreenImage% mkdir %LockScreenImage%
mkdir %LockScreenTemp%
echo -- ���� �Ϸ�
echo.
REM pause

echo ---- ���ȭ�� ���� ����
xcopy /q %LockScreenOrg% %LockScreenTemp%
echo -- ���� �Ϸ�
echo.
REM pause

echo ---- ������ �̹��� �۾� ����
ren %LockScreenTemp%\*.* *.jpg
xcopy /q %LockScreen%\tools %LockScreenTemp%
echo -- ���� �Ϸ�
echo.
REM pause

echo ---- ���ػ� �̹��� ����
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
echo -- ���� �Ϸ�
echo.
REM pause

echo ---- �̹��� �̵�
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
echo -- �̵� �Ϸ�
echo.

echo ---- list.txt �����
xcopy /y /q %LockScreenTemp%\list.txt %LockScreen%\tools\
echo -- ����� �Ϸ�
echo.
REM pause

echo ---- �ӽ����� ����
cd %LockScreen%
rmdir /s /q %LockScreenTemp%
echo -- ���� �Ϸ�
echo.
pause