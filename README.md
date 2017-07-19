# abs-build
Utilities for testing and building of the [ABS - Advanced Batch System](https://github.com/kulhanek/abs) package.

## ABS Features:
* alternative front-end for (PBSPro)[http://pbspro.org/]
* integration with [AMS - Advanced Module System](https://github.com/kulhanek/ams)

## Testing Mode
```bash
$ git clone --recursive https://github.com/kulhanek/abs-build.git
$ cd abs-build
$ ./build-utils/00.init-links.sh
$ ./01.pull-code.sh
$ ./04.build-inline.sh      # build the code inline in src/
```

## Production Build into the Infinity software repository
```bash
$ git clone --recursive https://github.com/kulhanek/abs-build.git
$ cd abs-build
$ ./build-utils/00.init-links.sh
$ ./01.pull-code.sh
$ ./10.build-final.sh
```

