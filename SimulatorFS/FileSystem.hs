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
fstFiles (FST dir fst files) = files

-- | Returns the list of sub file system trees at current directory
subdirs :: FSTree -> [FSTree]
subdirs (FST dir fst files) = fst

-- | Returns the root directory
topDir :: FSTree -> Directory
topDir (FST dir fst files) = dir

-- | Initial File System Tree
initFSTree :: FSTree
initFSTree = FST "/" [] []

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
validPath _ Stop = True
validPath (FST _ [] _) (Down _ _) = False
validPath (FST _ (x:xs) _) (Down directory path) = (topDir x == directory && validPath x path) || validPath (FST "" xs []) path

-- | Given a FSTree fs and a FSPath path, returns the FSTree which is the
--   result of navigate fs with path.
--   PRE: validPath fst p
goPath :: FSTree -> FSPath -> FSTree
goPath fst Stop = fst
goPath (FST _ (x:xs) _) (Down directory path) | topDir x == directory = goPath x path
                                              | otherwise = goPath (FST "" xs []) path

-- | Given a directory and a path, returns
--   the path which is the result of adding a
--   "Down" instruction at the bottom with the specified
--   directory.
downPath :: Directory -> FSPath -> FSPath
downPath dir Stop = Down dir Stop
downPath dir (Down origin path) = Down origin (downPath dir path)

-- | Given a path, returns
--   the path which is the result of
--   deleting the "Down" instruction which is at the bottom.
isNextStop :: FSPath -> Bool
isNextStop (Down _ _) = False
isNextStop Stop = True

upPath :: FSPath -> Maybe FSPath
upPath Stop = Nothing
upPath (Down origin path) | isNextStop path = Just Stop
                          | otherwise = Just (Down origin (fromJust (upPath path)))
                          
-- | Given a file, a file system and a path,
--   returns the file system which is the result of
--   adding the file at the level indicated by path.
--   PRE: validPath fs p
addFile :: File -> FSTree -> FSPath -> FSTree
addFile file (FST dir fst files) Stop = FST dir fst (file:files)
addFile file (FST directory (x:xs) files) (Down origin path) 
            | topDir x == origin = (FST directory ((addFile file x path):xs) files)
            | otherwise = (FST directory (x:(subdirs (addFile file (FST "" xs []) path))) files)

-- | Given a directory, a file system and a path,
--   returns the file system which is the result of
--   adding the directory at the level indicated by path.
--   PRE: validPath fs p
addDir :: Directory -> FSTree -> FSPath -> FSTree
addDir dir (FST directory xs files) Stop = (FST directory ((FST dir [] []):xs) files)
addDir dir (FST directory (x:xs) files) (Down origin path)
            | topDir x == origin = (FST directory ((addDir dir x path):xs) files)
            | otherwise = (FST directory (x:(subdirs (addDir dir (FST "" xs []) path))) files)

{- | A File System is a pair of a FSTree and
     a path indicating current position.
-}
type FileSystem = (FSTree,FSPath)

initFileSystem :: FileSystem
initFileSystem = (initFSTree,Stop)

-- | Given a file system fs and a path p, changes
--   the path in fs by p.
chPath :: FileSystem -> FSPath -> FileSystem
chPath (fst, path) p = (fst, p) 

{- All next function assumes and preserves the invariant:
   Forall FileSystem (fs,p), (validPath fs p) holds -}

-- | Returns the list of all files at current position.
listFiles :: FileSystem -> [File]
listFiles (fst, path) = fstFiles (goPath fst path)

-- | Returns the list of all directories at current position.
listDirs :: FileSystem -> [Directory]
listDirs (fst, path) = map topDir (subdirs (goPath fst path))

-- | Changes current position to the subdirectory d, if the
--   resulting path is valid. Otherwise returns Nothing.
cdFS :: Directory -> FileSystem -> Maybe FileSystem
cdFS directory (fst, path) 
    | validPath fst (downPath directory path) = Just (fst, downPath directory path)
    | otherwise = Nothing

-- | Adds a file at current position. If the file already exists
--   it returns Nothing.
fileExists :: File -> FileSystem -> Bool
fileExists file fs = file `elem` listFiles fs

addFS :: File -> FileSystem -> Maybe FileSystem
addFS file (fst, path) 
    | not (fileExists file (fst, path)) = Just (addFile file fst path, path)
    | otherwise = Nothing

-- | Adds a directory at current position. If the directory already exists
--   it returns Nothing.
dirExists :: Directory -> FileSystem -> Bool
dirExists dir fs = dir `elem` listDirs fs

addDFS :: Directory -> FileSystem -> Maybe FileSystem
addDFS dir (fst, path)
    | not (dirExists dir (fst, path)) = Just (addDir dir fst path, path)
    | otherwise = Nothing

-- | Changes current position to the upper directory. If current
--   directory is the root, it returns Nothing.
isRoot :: FileSystem -> Bool
isRoot (_, path) = isNextStop path
                   

cdupFS :: FileSystem -> Maybe FileSystem
cdupFS (fst, path)     
    | not (isRoot (fst, path)) = Just (fst, fromJust(upPath path))
    | otherwise = Nothing

-- | Prints the path of the current position.
pwdFS :: FileSystem -> String
pwdFS (_, Stop) = ""
pwdFS (fst, Down d p) = topDir fst ++ d ++ pwdFS (fst, p)

-- | Given a name and a file system, returns
--   the path where this name is located, if it exists in
--   the file system. Otherwise returns Nothing.

findFS :: Name -> FileSystem -> Maybe FSPath
findFS _ (_, Stop) = Just Stop
findFS name ((FST dir (x:xs) files), (Down d path))
    | fileExists name ((FST dir (x:xs) files), (Down d path)) || dirExists name ((FST dir (x:xs) files), (Down d path)) = Just path
    | otherwise = Just (fromJust (findFS name (x, path)))
