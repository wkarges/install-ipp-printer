# Deploy a virtual printer to Windows

This solution heavily depends on the Windows Subsystem for Linux (WSL).  Make sure your Windows machine supports WSL before proceeding.

## About

This is a setup tutorial for deploying and using an IPP printer on a Windows device using the [IPP Sample Software](https://github.com/istopwg/ippsample).  This allows me to simulate adding printers to end user devices using [Aisera's](https://aisera.com/) RPA tool.

## Installing WSL

1.  The easiest way to install WSL is to simply open command line and execute the command `wsl --install`.

Alternatively, you can navigate to *Windows Settings -> For Developers -> **[Toggle On]** Developer Mode*.  Then open *Add or Remove Programs* and check **Windows Subsystem for Linux**.

![turnOnWSL.png](screenshots/turnOnWSL.png)

Once you've turned on WSL, you'll need to reboot your machine to complete setup.

2.	After restarting your machine a command prompt should auto-start and you can follow the prompts to create your username and password for WSL.

Once your credentials have been created, you can start WSL anytime by typing `wsl` into command line or powershell.

#### Configure User Admin [Optional]

If you want to automate the IPP startup process, you'll need to make sure your WSL user account has adequate permissions to run bash scripts automatically without requiring credentials.

In order to do so I just gave my WSL user full root permissions.  If you want to follow a lesser privilege approach, you can find online tutorials for modifying the sudoers file using `visudo`.

1.  Inside WSL, type `sudo -i` to access the root user.

2.  (*Optional*) you may want to create a backup of your sudoers file.  To do so, simply type and execute `cp /etc/sudoers /root/sudoers.bak`

3.  Type `visudo` to access the sudoers file editor.

4.  Navigate to the section titled, "Allow memebers of a group sudo to execute any command" and type `%your_username ALL=(ALL) ALL`.  *(Note) the % sign might not be needed depending on your Linx distribution*

5.  Press `ctrl + x` then `y` to save and exit the file.

![visudo.png](screenshots/visudo.png)

## Install and Configure IPP

The [IPP Sample Software](https://github.com/istopwg/ippsample) leverages [Apple's Bonjour Print Service](https://developer.apple.com/bonjour/) so you'll need to [download and install](https://support.apple.com/kb/dl999?locale=en_US) it on your machine.  Once installed, confirm the Bonjour Service is running and set to Automatic Start.

![bonjour.png](screenshots/bonjour.png)

### Download and [Install IPP](https://stackoverflow.com/questions/10115876/how-to-simulate-an-ipp-printer)

1.  Within WSL, type and execute `wget https://github.com/KurtPfeifle/ippsample/releases/download/continuous/ippsample-x86_64.AppImage`

2.  After the ippsample appimage finishes installing, execute the following commands:

*  `chmod a+x ippsample-x86_64.AppImage`

*  `mv ippsample-x86_64.AppImage ippsample`

3.  Finally, install cups: `sudo apt install cups-ipp-utils`

#### Configure Systemd

For some reason, WSL doesn't use System, even if it's the distribution default.  We'll have to run a few commands to configure systemd support.  If you want to learn more about this, feel free to read this answer on [Ask Ubuntu](https://askubuntu.com/questions/1379425/system-has-not-been-booted-with-systemd-as-init-system-pid-1-cant-operate).

```
  sudo apt install avahi-daemon
  sudo -b unshare --pid --fork --mount-proc /lib/systemd/systemd --system-unit=basic.target
  sudo -E nsenter --all -t $(pgrep -xo systemd) runuser -P -l $USER -c "exec $SHELL"
  sudo systemctl start avahi-daemon
  sudo systemctl enable avahi-daemon
```

## Using IPP Sample

Having installed IPP and configured Systemd, we're now ready to create a print server emulator.