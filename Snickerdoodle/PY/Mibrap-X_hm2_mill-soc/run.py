#!/usr/bin/python

import sys
import os
import subprocess
import time
from machinekit import launcher


#launcher.register_exit_handler()

def check_mklaucher():
    try:
        subprocess.check_output(['pgrep', 'mklauncher'])
        return True
    except subprocess.CalledProcessError:
        return False

os.chdir(os.path.dirname(os.path.realpath(__file__)))

try:
    launcher.check_installation()
    launcher.cleanup_session()
    launcher.register_exit_handler()  # needs to executed after HAL files

    nc_path = os.path.expanduser('~/nc_files')
    if not os.path.exists(nc_path):
        os.mkdir(nc_path)

    if not check_mklaucher():  # start mklauncher if not running to make things easier
        launcher.start_process('mklauncher ~/Hm2-soc_FDM/Cramps/PY/Mibrap-X_hm2_mill-soc')

    launcher.start_process("configserver -n mibrap-x_hm2-soc-mill ~/Cetus/")
    launcher.start_process('machinekit mibrap-x_mill.ini')
    while True:
        launcher.check_processes()
        time.sleep(1)
except subprocess.CalledProcessError:
    launcher.end_session()
    sys.exit(1)

sys.exit(0)
