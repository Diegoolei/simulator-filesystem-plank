module Examples  where

import SimulatorFS

code1 :: MFS
code1 =
  do
    add "hello.txt"
    addD "world"
    cd "world"
    add "foo.txt"
    add "foo.txt"
    -- throws error : file foo.txt is aleady present in this directory
    cdup
    pwd

code2 :: MFS
code2 =
  do
    add "file0.txt"
    addD "dir1"
    addD "dir2"
    cd "dir1"
    add "file1.txt"
    cdup
    cd "dir2"
    add "file2.txt"
    addD "dir3"
    cd "dir3"
    add "file3.txt"
    cdup
    find "file3.txt"
    cdup
    find "file0.txt"
    cd "dir1"
    find "file0.txt"
    cdup
    ls
