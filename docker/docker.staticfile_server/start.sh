#!/bin/sh

# entrypoint
echo [starting] :: `date` :: static_server

# run 
/file_server  '/data'  > /tmp/server.lan_fileServer.log



