# fedsafe

![GitHub All Releases](https://img.shields.io/github/downloads/ritschmaster/fedsafe/total)

Easy security for new and novice Fedora users

## Features

1. Disposable sandboxes for applications that might require disposable sandboxes
    1. Those should behave similarly to the Disposable Virtual Machine feature present in Qubes OS but much more lightweight.
    2. The following applications are available: 
      1. Firefox
      2. Evince
      3. Libreoffice Writer
      4. Libreoffice Calc 
    3. Disposable sandboxes for arbitary applications are a low priority TODO
2. Sandboxes for important applications
    1. Those are heavily restricted applications still utilizing the local filesystem. They are a balance of running an application in a disposable sandbox and running them without any restrictions at all.
    2. The following applications are available: 
      1. Firefox
      2. Telegram
      3. Hexchat
3. Setup sane security defaults
    1. Setup to actually allow using sandboxes by SELinux
      1. Currently only available as description
    2. `hidepid=2`
      1. Currently only available as description

fedsafe does not aim to replace the use case of Qubes OS. Instead it enables its ideas on a plain Fedora (like) system. That way it allows usability-friendly features like suspend-to-disk, accessing all files at once in a secure way.

## Dependencies 

### Runtime

    dnf install -y bash sed xdpyinfo xprop xsel xdotool fail2ban

### Development

    dnf install -y autoconf automake make 
    
    # stuff mentioned in the hard mode
    
    vi src/main.in.sh # and so on
    
### Packaging

    dnf install -y rpm-build
    
    # stuff mentioned in the hard mode
    
    make rpm
    

## Installation

### Easy mode

1. Head over to the [Release](https://github.com/ritschmaster/fedsafe/releases) page and download the latest RPM or DEB file.
2. ???
3. Profit!

### Hard mode

After fetching the source compile the source by executing

    ./autogen.sh
    ./configure
    make
    sudo make install

## Usage

Use `man fedsafe.1`to get more information on what applications and operations are available.

Generally you will want to setup the following on your system:
1. A keyboard shortcut performing `fedsafe box clipboard_copy` (e.g. on <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>C</kbd>)
2. A keyboard shortcut performing `fedsafe box clipboard_paste` (e.g. on <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>)

## Author

Richard Bäck <richard.baeck@mailbox.org>

## License

MIT License

## Donations

Show me that you really like it by donating something. Thanks for any amount!

My Bitcoin address: 3DF2eTL9KSndqbuQTokWvTbUpDNQ6RuwxU
