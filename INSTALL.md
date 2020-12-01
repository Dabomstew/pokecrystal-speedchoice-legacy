The source files are assembled into a rom using [**rgbds**](https://github.com/bentley/rgbds).
These instructions explain how to set up the tools required to build.

If you run into trouble, ask on irc ([**freenode#pret**](https://kiwiirc.com/client/irc.freenode.net/?#pret)).


# Linux

Python 2.7 and Python 3 are required.

```bash
sudo apt-get install make gcc bison git python python3 libpng-dev flex

wget https://github.com/gbdev/rgbds/releases/download/v0.4.1/rgbds-0.4.1.tar.gz
tar -xvf rgbds-0.4.1.tar.gz
cd rgbds
sudo make install
cd ..

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice-legacy
cd pokecrystal-speedchoice
```

To build **crystal-speedchoice.gbc**:

```bash
make
```


# Mac

In **Terminal**, run:

```bash
xcode-select --install

wget https://github.com/rednex/rgbds/releases/download/v0.3.9/rgbds-0.3.9.tar.gz
tar -xvf rgbds-0.3.9.tar.gz
cd rgbds-0.3.9
sudo make install
cd ..

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice-legacy
cd pokecrystal-speedchoice
```

To build **crystal-speedchoice.gbc**:

```bash
make
```


# Windows

To build on Windows, install [**Cygwin**](http://cygwin.com/install.html) with the default settings.

In the installer, select the following packages: `make` `git` `python` `gettext` `python3`

Then get version 0.3.9 of [**rgbds**](https://github.com/rednex/rgbds/releases/).
Extract the archive and put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin64\usr\local\bin`.

In the **Cygwin terminal**:

```bash

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice-legacy
cd pokecrystal-speedchoice
```

To build **crystal-speedchoice.gbc**:

```bash
make
```

## notes

- If `gettext` no longer exists, grab `libsasl2-3` `ca-certificates`.

