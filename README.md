# fedsafe

![GitHub All Releases](https://img.shields.io/github/downloads/ritschmaster/fedsafe/total)

Easy security for beginners and novice Fedora users

## Features

1. Enable disposable sandboxes for applications that might require disposable sandboxes
 1. Firefox
 2. Evince
 3. Libreoffice Writer
 4. Libreoffice Calc 
2. Enable disposable sandboxes for arbitary applications (TODO)
3. Enable sandboxes for important applications
 1. Firefox
 2. Evince
 3. Libreoffice Writer
 4. Libreoffice Calc
4. Supply sane security defaults
 1. `hidepid=2` (TODO)
 
## Dependencies 

### Runtime

    dnf install -y bash sed xdpyinfo xprop xsel fail2ban

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

See the `-h` option or use `man fedsafe.1`. (TODO)
