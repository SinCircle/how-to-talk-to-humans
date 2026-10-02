# 构建《如何跟人类沟通：从入门到精通》PDF
# 用法（在本目录下）：
#   powershell -ExecutionPolicy Bypass -File build.ps1          # 编译
#   powershell -ExecutionPolicy Bypass -File build.ps1 -Clean   # 清理中间文件
#
# 说明：TeX Live 2026 的 latexmk 在本目录（路径含中文与全角冒号）下可直接
# 工作，无需把源文件复制到纯 ASCII 目录。若换用较旧的 TeX 发行版报路径错误，
# 可把整个 latex 目录复制到纯 ASCII 路径（例如 C:\Temp\book-latex）再编译。

param([switch]$Clean)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

if ($Clean) {
    latexmk -C -outdir=build main.tex
    Write-Host '已清理中间文件。'
    exit 0
}

latexmk -xelatex -interaction=nonstopmode -halt-on-error -outdir=build main.tex
if ($LASTEXITCODE -ne 0) { throw "编译失败，见 build/main.log" }

Write-Host ''
Write-Host "构建完成：$PWD\build\main.pdf"
