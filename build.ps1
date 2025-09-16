New-Item -ItemType Directory -Path plugins\osquery -Force
New-Item -ItemType Directory -Path plugins\dosai -Force
New-Item -ItemType Directory -Path plugins\trivy -Force

Invoke-WebRequest -Uri https://github.com/upx/upx/releases/download/v5.0.2/upx-5.0.2-win64.zip -UseBasicParsing -OutFile upx-5.0.2-win64.zip
Expand-Archive -Path upx-5.0.2-win64.zip -DestinationPath . -Force

Invoke-WebRequest -Uri https://github.com/osquery/osquery/releases/download/5.19.0/osquery-5.19.0.windows_x86_64.zip -UseBasicParsing -OutFile osquery-5.19.0.windows_x86_64.zip
Expand-Archive -Path osquery-5.19.0.windows_x86_64.zip -DestinationPath . -Force
copy "osquery-5.19.0.windows_x86_64\Program Files\osquery\osqueryi.exe" plugins\osquery\osqueryi-windows-amd64.exe
upx-5.0.2-win64\upx.exe -9 --lzma plugins\osquery\osqueryi-windows-amd64.exe
plugins\osquery\osqueryi-windows-amd64.exe --help

Invoke-WebRequest -Uri https://github.com/owasp-dep-scan/dosai/releases/latest/download/Dosai.exe -UseBasicParsing -OutFile plugins/dosai/dosai-windows-amd64.exe

cd thirdparty\trivy
go build -ldflags "-H=windowsgui -s -w" -o build\trivy-windows-amd64.exe
..\..\upx-5.0.2-win64\upx.exe -9 --lzma build\trivy-windows-amd64.exe
copy build\* ..\..\plugins\trivy\
Remove-Item build -Recurse -Force
cd ..\..

Remove-Item osquery-5.19.0.windows_x86_64 -Recurse -Force
Remove-Item osquery-5.19.0.windows_x86_64.zip -Recurse -Force
Remove-Item upx-5.0.2-win64 -Recurse -Force
Remove-Item upx-5.0.2-win64.zip -Recurse -Force
