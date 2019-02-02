# mk [![GitHub release](https://img.shields.io/github/release/k1LoW/mk.svg)](https://github.com/k1LoW/mk/releases)

mk find Makefile by walking up parent directories and execute `make`.

## Usage

``` console
$ cat Makefile
hello:
        @echo "Hello make"
$ cd path/to/deep/
$ cat Makeflie
cat: Makefile: No such file or directory
$ make hello
make: *** No targets specified and no makefile found.  Stop.
$ mk hello
Hello make
```

## Installation

```console
$ go get github.com/k1LoW/mk
```

or

```console
$ brew install k1LoW/tap/mk
```
