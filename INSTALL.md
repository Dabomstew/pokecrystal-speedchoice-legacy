The source files are assembled into a rom using [**rgbds**](https://github.com/bentley/rgbds).
These instructions explain how to set up the tools required to build.

If you run into trouble, ask on irc ([**freenode#pret**](https://kiwiirc.com/client/irc.freenode.net/?#pret)).


# Linux

Python 2.7 is required.

```bash
sudo apt-get install make gcc bison git python

wget https://github.com/rednex/rgbds/releases/download/v0.2.5/rgbds-0.2.5.tar.gz
tar -xvf rgbds-0.2.5.tar.gz
cd rgbds-0.2.5
sudo make install
cd ..

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice
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

wget https://github.com/rednex/rgbds/releases/download/v0.2.5/rgbds-0.2.5.tar.gz
tar -xvf rgbds-0.2.5.tar.gz
cd rgbds-0.2.5
sudo make install
cd ..

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice
cd pokecrystal-speedchoice
```

To build **crystal-speedchoice.gbc**:

```bash
make
```


# Windows

To build on Windows, install [**Cygwin**](http://cygwin.com/install.html) with the default settings.

In the installer, select the following packages: `make` `git` `python` `gettext`

Then get version 0.2.5 of [**rgbds**](https://github.com/bentley/rgbds/releases/).
Extract the archive and put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin64\usr\local\bin`.

In the **Cygwin terminal**:

```bash

git clone --recursive https://github.com/dabomstew/pokecrystal-speedchoice
cd pokecrystal-speedchoice
```

To build **crystal-speedchoice.gbc**:

```bash
make
```

## notes

- If `gettext` no longer exists, grab `libsasl2-3` `ca-certificates`.

# Notes for all OSes

RGBDS after v0.2.5 will not build this project, and v0.2.5 will not build projects that require RGBDS versions after v0.2.5.  If you want to have both versions installed, you can install v0.2.5 in a custom directory as such:

```bash
sudo make install PREFIX=/path/you/want
```

To use this version of RGBDS to build **crystal-speedchoice.gbc**:

```bash
make RGBDS=/path/you/want/bin
```
