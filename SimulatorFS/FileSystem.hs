module FileSystem
  (
  -- ^ Types
    FileSystem
  , File
  , Directory
  , Name
  -- ^ Smart constructors
  , initFileSystem
  -- ^ Operations
  , addFS
  , addDFS
  , cdFS
  , cdupFS
  , pwdFS
  , findFS
  , listFiles
  , listDirs
  -- ^ Other utils
  , chPath
  ) where

import Data.List
import Data.Maybe

type Name = String

type File = Name

type Directory = Name

{- | File System Tree.
     (FST dir fst files) represents a file system tree where root is
     dir, fst is a list of sub file system trees and files is a list
     of files located at the same level as dir.

   "/"
   └── SimulatorFS
       ├── Examples.hs
       ├── FileSystem.hs
       ├── FSInterpreter.hs
       └── README

   is represented by

   FST "/"
       [FST "SimulatorFS"
            []
            [ "Examples.hs"
            , "FileSystem.hs"
            , "SimulatorFS.hs"
            , "README"
            ]
       ]
       []

   Invariant : There is no two equal directories
               not equal files at the same level
-}
data FSTree = FST Directory [FSTree] [File]
  deriving Show

-- | Returns the list of files at current directory
fstFiles :: FSTree -> [File]
fstFiles = undefined

-- | Returns the list of sub file system trees at current directory
subdirs :: FSTree -> [FSTree]
subdirs = undefined

-- | Returns the root directory
topDir :: FSTree -> Directory
topDir = undefined

-- | Initial File System Tree
initFSTree :: FSTree
initFSTree = undefined

{- | FSPath indicates how to navigate a File System Tree.
     Stop means that you are in the right place.
     Down means that you have to move inside a sub file system tree.
-}
data FSPath = Stop | Down Directory FSPath
  deriving Show

{- | Given a FSTree and a FSPath returns True if
     the path is valid for this file system tree.
     Example:
     In the file system

   "/"
   └── SimulatorFS
       ├── Examples.hs
       ├── FileSystem.hs
       ├── FSInterpreter.hs
       └── README


   the path `Down "SimulatorFS" Stop` is valid
   but      `Down "SimulatorFS" (Down "something" Stop)` is not
-}
validPath :: FSTree -> FSPath -> Bool
validPath = undefined

-- | Given a FSTree fs and a FSPath path, returns the FSTree which is the
--   result of navigate fs with path.
--   PRE: validPath fst p
goPath :: FSTree -> FSPath -> FSTree
goPath = undefined

-- | Given a directory and a path, returns
--   the path which is the result of adding a
--   "Down" instruction at the bottom with the specified
--   directory.
downPath :: Directory -> FSPath -> FSPath
downPath = undefined

-- | Given a path, returns
--   the path which is the result of
--   deleting the "Down" instruction which is at the bottom.
upPath :: FSPath -> Maybe FSPath
upPath = undefined

-- | Given a file, a file system and a path,
--   returns the file system which is the result of
--   adding the file at the level indicated by path.
--   PRE: validPath fs p
addFile :: File -> FSTree -> FSPath -> FSTree
addFile = undefined

-- | Given a directory, a file system and a path,
--   returns the file system which is the result of
--   adding the directory at the level indicated by path.
--   PRE: validPath fs p
addDir :: Directory -> FSTree -> FSPath -> FSTree
addDir = undefined

{- | A File System is a pair of a FSTree and
     a path indicating current position.
-}
type FileSystem = (FSTree,FSPath)

initFileSystem :: FileSystem
initFileSystem = (initFSTree,Stop)

-- | Given a file system fs and a path p, changes
--   the path in fs by p.
chPath :: FileSystem -> FSPath -> FileSystem
chPath = undefined

{- All next function assumes and preserves the invariant:
   Forall FileSystem (fs,p), (validPath fs p) holds -}

-- | Returns the list of all files at current position.
listFiles :: FileSystem -> [File]
listFiles = undefined

-- | Returns the list of all directories at current position.
listDirs :: FileSystem -> [Directory]
listDirs = undefined

-- | Changes current position to the subdirectory d, if the
--   resulting path is valid. Otherwise returns Nothing.
cdFS :: Directory -> FileSystem -> Maybe FileSystem
cdFS = undefined

-- | Adds a file at current position. If the file already exists
--   it returns Nothing.
addFS :: File -> FileSystem -> Maybe FileSystem
addFS = undefined

-- | Adds a directory at current position. If the directory already exists
--   it returns Nothing.
addDFS :: Directory -> FileSystem -> Maybe FileSystem
addDFS = undefined

-- | Changes current position to the upper directory. If current
--   directory is the root, it returns Nothing.
cdupFS :: FileSystem -> Maybe FileSystem
cdupFS = undefined

-- | Prints the path of the current position.
pwdFS :: FileSystem -> String
pwdFS = undefined

-- | Given a name and a file system, returns
--   the path where this name is located, if it exists in
--   the file system. Otherwise returns Nothing.
findFS :: Name -> FileSystem -> Maybe FSPath
findFS = undefined
