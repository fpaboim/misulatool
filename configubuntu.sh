#!/bin/bash

echo ' '
echo '  This script will configure the Tecgraf libraries in the system'
echo '  to be used from Lua. It was tested only in Ubuntu.'
echo ' '
echo '  The Run Time libraries must be already installed on the system.'
echo ' '
echo '  Must be run with "sudo", or install will fail,'
echo '  for example:'
echo '     sudo ./config_lua_module'
echo ' '
echo -n Press Enter to continue or Ctrl+C to abort...
read contscr
echo ' '

mkdir -p /usr/lib/lua/5.1
cd /usr/lib/lua/5.1

ln -fsv /usr/lib/libiuplua51.so iuplua.so
ln -fsv /usr/lib/libiupluacontrols51.so iupluacontrols.so
ln -fsv /usr/lib/libiupluacd51.so iupluacd.so
ln -fsv /usr/lib/libiupluagl51.so iupluagl.so
ln -fsv /usr/lib/libiuplua_pplot51.so iuplua_pplot.so
ln -fsv /usr/lib/libiupluaim51.so iupluaim.so
ln -fsv /usr/lib/libiupluaimglib51.so iupluaimglib.so
ln -fsv /usr/lib/libiupluatuio51.so iupluatuio.so

ln -fsv /usr/lib/libcdlua51.so cdlua51.so
ln -fsv /usr/lib/libcdluacontextplus51.so cdluacontextplus.so
ln -fsv /usr/lib/libcdluacairo51.so cdluacairo.so
ln -fsv /usr/lib/libcdluagl51.so cdluagl.so
ln -fsv /usr/lib/libcdluaim51.so cdluaim.so
ln -fsv /usr/lib/libcdluapdf51.so cdluapdf.so

ln -fsv /usr/lib/libluaglu51.so luaglu51.so
ln -fsv /usr/lib/libluaglu52.so luaglu52.so
ln -fsv /usr/lib/libluagl51.so luagl51.so
ln -fsv /usr/lib/libluagl52.so luagl52.so

# ln -fsv /usr/lib/libimlua51.so imlua.so
# ln -fsv /usr/lib/libimlua_process51.so imlua_process.so
# ln -fsv /usr/lib/libimlua_jp251.so imlua_jp2.so
# ln -fsv /usr/lib/libimlua_fftw51.so imlua_fftw.so
