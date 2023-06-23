New-Item -ItemType Directory -Path plugins\goversion -Force
New-Item -ItemType Directory -Path plugins\cargo-auditable -Force
New-Item -ItemType Directory -Path plugins\osquery -Force

Invoke-WebRequest -Uri https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-win64.zip -UseBasicParsing -OutFile upx-4.0.2-win64.zip
Expand-Archive -Path upx-4.0.2-win64.zip -DestinationPath . -Force

Invoke-WebRequest -Uri https://github.com/osquery/osquery/releases/download/5.8.2/osquery-5.8.2.windows_x86_64.zip -UseBasicParsing -OutFile osquery-5.8.2.windows_x86_64.zip
Expand-Archive -Path osquery-5.8.2.windows_x86_64.zip -DestinationPath . -Force
copy "osquery-5.8.2.windows_x86_64\Program Files\osquery\osqueryi.exe" plugins\osquery\osqueryi-windows-amd64.exe
upx-4.0.2-win64\upx.exe -1 plugins\osquery\osqueryi-windows-amd64.exe

set CGO_ENABLED=0
set GOOS=windows
set GOARCH=amd64
New-Item -ItemType Directory -Path plugins\goversion -Force
cd thirdparty\goversion
go build -ldflags "-H=windowsgui -s -w" -o build\goversion-windows-amd64.exe
..\..\upx-4.0.2-win64\upx.exe -1 build\goversion-windows-amd64.exe
copy build\* ..\..\plugins\goversion\
Remove-Item build -Recurse -Force
cd ..\..

New-Item -ItemType Directory -Path plugins\cargo-auditable -Force
cd thirdparty\cargo-auditable
go build -ldflags "-H=windowsgui -s -w" -o build\cargo-auditable-windows-amd64.exe
..\..\upx-4.0.2-win64\upx.exe -1 build\cargo-auditable-windows-amd64.exe
copy build\* ..\..\plugins\cargo-auditable\
Remove-Item build -Recurse -Force
cd ..\..

Remove-Item osquery-5.8.2.windows_x86_64 -Recurse -Force
Remove-Item osquery-5.8.2.windows_x86_64.zip -Recurse -Force
Remove-Item upx-4.0.2-win64 -Recurse -Force
Remove-Item upx-4.0.2-win64.zip -Recurse -Force
