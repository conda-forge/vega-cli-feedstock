@echo on
md %LIBRARY_PREFIX%\share\vega-cli
pushd %LIBRARY_PREFIX%\share\vega-cli

md node_modules
cmd /c "npm install --GTK_Root=%LIBRARY_PREFIX% canvas"
if errorlevel 1 exit 1

cmd /c "npm install --save vega-cli@%PKG_VERSION%"
if errorlevel 1 exit 1

pushd %LIBRARY_PREFIX%\bin
for %%c in (vg2pdf vg2png vg2svg) do (
  echo @echo on >> %%c.bat
  echo node %LIBRARY_PREFIX%\share\vega-cli\node_modules\vega-cli\bin\%%c "%%*" >> %%c.bat
)

copy %LIBRARY_PREFIX%\share\vega-cli\node_modules\vega-cli\LICENSE %SRC_DIR%
if errorlevel 1 exit 1
