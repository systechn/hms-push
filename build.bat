@echo off
REM echo %HOMEPATH%
setlocal

SET CGO_ENABLED=0
SET LDFLAGS=-ldflags "-s -w -extldflags \"-static\""

SET GOPATH=%GOPATH%
SET PWD=%CD%
SET OUTPUT_DIR=%PWD%\output

SET GO111MODULE=on
SET GOPROXY=https://goproxy.io

SET MODULE=github.com/systechn/hms-push

if "%1%"=="build" (
    %PWD%\build.bat send_data_message
) else if "%1%"=="vendor" (
	if not exist %HOMEPATH%\go\src (
		md %HOMEPATH%\go\src
	)
	go mod tidy && go mod vendor && xcopy /E/Y/Q .\vendor %HOMEPATH%\go\src\
	rd /S/Q vendor
    if not exist %HOMEPATH%\go\src\%MODULE% (
		md %HOMEPATH%\go\src\%MODULE%
	)
	xcopy /E/Y/Q . %HOMEPATH%\go\src\%MODULE%\
) else if "%1%"=="send_data_message" (
	@REM SET GOOS=darwin
	cd %PWD%\examples\send_data_message && go build -o %OUTPUT_DIR%\send_data_message.exe
) else if "%1%"=="init" (
	go mod init %MODULE%
) else (
    echo %0% init, vendor, build, send_data_message
)

endlocal
