#! /bin/bash

# parse all log files for error messages
# print errors and warnings found to error.log
# WARNING: This will only work with english error messages!

errfile=$LOGDIR/error.log

# Define grep patterns. Do not start or end with an empty line!
globalerrorpatterns="error
fail
warn
 bad
bad 
no space
Couldn't stat
Cannot access
 conflict
is bigger than the limit
did not exist
non existent
not found
couldn't
can't
E: Sorry, broken packages
^E: 
operator expected
ambiguous redirect
No previous regular expression
No such
Device or resource busy
unknown option
[a-z]\+\.log:E:
No candidate version found
segfault
Couldn't find any package whose name or description matched
cannot create
The following packages have unmet dependencies"

globalignorepatterns="[a-z]\+\.log:#
Error: Driver 'pcspkr' is already registered, aborting
: bytes  packets  errors  dropped
:+ error=0
:+ trap error=
task_error_func=
STOP_ON_ERROR=
courier-webadmin
plugins-bad
Enabling conf localized-error-pages
ibwebadmin
kernel-patch-badram
kolab-webadmin
kolabadmin
gstreamer.\+-plugins-really-bad
liberrors.so
liberrors-samba
libsamba-errors
gsambad
libad
libtest-nowarnings-perl
libtest-warn-perl
libclass-errorhandler-perl
zope-ploneerrorreporting
libroxen-errormessage
liberror-perl
perl-Error
libgpg-error-dev
libgpg-error0
^fstab.\+errors=remount
Opts: errors=remount-ro
[RT]X packets:
WARNING: unexpected IO-APIC
warned about = ( )
daemon.warn
kern.warn
rw,errors=
Expect some cache
no error
failmsg
RPC call returned error 101
deverror.out
(floppy), sector 0
dev fd0, sector 0
floppy: error 10 while reading
mount version older than kernel
Can't locate module
Warning only .\+MB will be used.
hostname: Host name lookup failure
I can't tell the difference.
warning, not much extra random data, consider using the -rand option
confC._FILE
Warning: 3 database(s) sources
were not found, (but were created)
removing exim
The home dir you specified already exists.
No Rule for /usr/lib/ispell/default.hash.
/usr/sbin/update-fonts-.\+: warning: absolute path
hostname: Unknown server error
EXT2-fs warning: checktime reached
RPC: sendmsg returned error 101
can't print them to stdout. Define these classes
warning: downgrading
suppress emacs errors
echo Error:
Can't open dependencies file
documents in /usr/doc are no longer supported
if you have both a SCSI and an IDE CD-ROM
Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon
Monitoring disabled
Error: only one processor found.
Error Recovery Strategy:
sector 0 does not have an
syslogin_perform_logout: logout() returned an error
grub is not in an XFS filesystem.
grub-install: line 374:
grub-probe: error: Cannot open \`/boot/grub/device.map'
is harmless
not updating .\+ font directory data.
register_serial(): autoconfig failed
Fontconfig error: Cannot load default config file
asking for cache data failed
However, I can not read the target:
Warning: The partition table looks like it was made
task_error=0
task_local_error=0
^info: Trying to set
warning: /usr/lib/X11/fonts
can't read /etc/udev/rules.d/z25_persistent-net.rules
/cow': No such file or directory
Dummy start-stop-daemon called
X: bytes  packets  errors
ACPI Error
ACPI Warning
AE_NOT_FOUND
conflicts with ACPI region
cannot stat \`/etc/modprobe.d/\*.conf'
cdrom: open failed.
libgpg-error
process \`kudzu' used the deprecated sysctl system call
PM: Resume from disk failed
JBD: barrier-based sync failed
aufs: module is from the staging directory, the quality is unknown
warning: linuxlogo stop runlevel arguments (none) do not match
insserv: warning: script .\+ missing LSB tags and overrides
live-premount.\+ If this fails
cannot read table of mounted file systems
error: no alternatives for
ERST: Error Record Serialization Table (ERST) support is initialized
ERST: Table is not found
HEST: Table not found
failed to stat /dev/pts
Failed to connect to socket /var/run/dbus/system_bus_socket
fail to add MMCONFIG information
can't initialize iptables table
can't initialize ip6tables table
Authentication warning overridden
41-warning.sh
PCCT header not found
Download is performed unsandboxed as root as file
update-alternatives: warning: skip creation of
loop: module verification failed: signature
Warning: apt-key output should not be parsed
WARNING: Failed to connect to lvmetad. Falling back to device scanning
WARNING: apt does not have a stable CLI interface
Warning: The home dir /var/lib/usbmux you specified
diff: /var/lib/apparmor/profiles/.apparmor.md5sums: No such file or directory
error reporting disabled
Enabling Firmware First mode for corrected errors
errors: 0
 0 errors
Memory Error Correction:
Memory Controller 0 - Channel . Error
IIO RAS/Control Status/Global Errors
RAS: Correctable Errors collector initialized
__stack_chk_fail
grub.cfg.new: Directory nonexistent
can't derive routing for PCI INT A
failed to load isci/isci_firmware.bin
Direct firmware load for isci/isci_firmware.bin failed with error
Loading user firmware failed, using default values
stunnel4 you specified can't be accessed: No such file or directory
install-docs --verbose --check file_name' may give more details about the above errors
cannot open '/etc/ssl/certs/java/cacerts' for reading: No such file or directory
can't claim BAR
disabling ASPM
data block query control method not found
subprocess.py.\+RuntimeWarning: line buffering
Resource conflict.\+ found
os-prober will not be executed
/sys/bus/usb/devices/\*:\*/bInterface
_OSC evaluation for CPU failed, trying
unable to stat /usr/libexec/polkitd
SyntaxWarning: invalid escape sequence 
update-rc.d: warning: start and stop actions are no longer supported"

# add pattern on some conditions
if [ -n $FAI_ALLOW_UNSIGNED ] ; then
   globalignorepatterns="$globalignorepatterns
WARNING: untrusted versions
WARNING: The following packages cannot be authenticated
Ignoring these trust violations"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Here you can define your own patterns. Put one pattern in a line,
# do not create empty lines.
myerrorpatterns="X_X-X_XX"
myignorepatterns="X_X-X_XX"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The main routine
errorpatterns="$globalerrorpatterns
$myerrorpatterns"
ignorepatterns="$globalignorepatterns
$myignorepatterns"

cd $LOGDIR && if [ ! -s $errfile ]; then

    grep -i "$errorpatterns" *.log | grep -vi "$ignorepatterns" > $errfile
    if [ X$verbose = X1 ]; then
        egrep -v '^software.log:' $errfile > $LOGDIR/tempfile
        mv $LOGDIR/tempfile $errfile
    fi

    if [ -s $errfile ]; then
        echo "ERRORS found in log files. See $errfile" >&2
    else
        echo "Congratulations! No errors found in log files."
        #   export flag_reboot=1 # if you want to reboot if no errors are found
    fi
fi
