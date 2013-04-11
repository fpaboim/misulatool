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

ln -fsv /usr/lib/libimlua51.so imlua.so
ln -fsv /usr/lib/libimlua_process51.so imlua_process.so
ln -fsv /usr/lib/libimlua_jp251.so imlua_jp2.so
ln -fsv /usr/lib/libimlua_fftw51.so imlua_fftw.so
