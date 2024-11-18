# Purpose

I wish to be able to create a system build system in the GNU Guile
programming language. I already have a simple test script that I can
build off of. I will work on this while I get some more motivation for
the Vulkan Rendering Engine that I am working on.

This project will be a script and library project. It is a
library/script that runs a project file. It is greatly inspired by the
Meson build system. I just wanted something that I built myself. Not
just a script.

## TODO

- [ ] reorgnize the entire project to better fit GNU Guile project structure
- [x] turn into script that can be run
- [ ] single source files
  - [x] must add `-c` by default
- handle error from compiler and linker
- [x] files with the main function must be handled differently
  - fixed with removing linking stage from compile function
- [x] convert markdown readme to org mode
- [ ] check if there are multiple targets
- [ ] check if OBJ directory exists before placing object files there
- [ ] add support for noSTD
- [ ] add support for dynamic libaries and static libraries
- [ ] define targets as dependencies to link against(libraries)
- [ ] include paths
- [ ] add default variables of CFLAGS, CC, other useful flags
- [ ] add method for verifying that compiler is valid
- [ ] add way of counting how many targets there are
- [ ] add command arguments
  - [ ] `cbuild run`
  - [ ] `cbuild debug`
  - [ ] `cbuild build`
  - [ ] `cbuild release`
