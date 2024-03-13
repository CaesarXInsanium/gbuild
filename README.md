# Purpose

I wish to be able to create a system build system in the GNU Guile
programming language. I already have a simple test script that I can
build off of. I will work on this while I get some more motivation for
the Vulkan Rendering Engine that I am working one.

This project will be a script and library project. It is a
library/script that runs a project file. It is greatly inspired by the
Meson build system. I just wanted something that I built myself. Not
just a script.

It fucking works and that is good enough. I am now officially bored of this project.


## TODO

- [ ] single source files
  - must add `-c` by default
- handle error from compiler and linker
- [X] files with the main function must be handled differently
  - fixed with removing linking stage from compile function
- 
