@echo on
cmd /c "npm install --GTK_Root=%LIBRARY_PREFIX% canvas"
if errorlevel 1 exit 1

pushd packages\vega-cli

cmd /c "npm pack"
if errorlevel 1 exit 1

md %LIBRARY_PREFIX%\share\vega-cli
pushd %LIBRARY_PREFIX%\share\vega-cli

md node_modules
cmd /c "npm install --GTK_Root=%LIBRARY_PREFIX% canvas"
if errorlevel 1 exit 1

for %%i in (%SRC_DIR%\packages\vega-cli\vega-cli-*) do (
  cmd /c "npm install --save %%i"
)
if errorlevel 1 exit 1

pushd %LIBRARY_PREFIX%\bin
for %%c in (vg2pdf vg2png vg2svg) do (
  echo @echo on >> %%c.bat
  echo node %LIBRARY_PREFIX%\share\vega-cli\node_modules\vega-cli\bin\%%c "%%*" >> %%c.bat
)
