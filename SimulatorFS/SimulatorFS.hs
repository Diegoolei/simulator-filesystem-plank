module SimulatorFS where

import FileSystem
import Control.Monad.Trans.State
import Control.Monad.Trans
import Control.Monad

type MFS = StateT FileSystem IO ()

add :: File -> MFS
add f =
  lift (putStrLn $ "> add " ++ show f) >>
  get >>= \fs ->
  maybe (lift $ putStrLn "Error: File already exists")
        put (addFS f fs)

addD :: Directory -> MFS
addD d =
  lift (putStrLn $ "> addD " ++ show d) >>
  get >>= \fs ->
  maybe (lift $ putStrLn "Error: Directory already exists")
        put (addDFS d fs)

cd :: Directory -> MFS
cd d =
  lift (putStrLn $ "> cd " ++ show d) >>
  get >>= \fs ->
  maybe (lift $ putStrLn "Error: Directory doesn't exist")
        put (cdFS d fs)

cdup :: MFS
cdup =
  lift (putStrLn "> cdup") >>
  get >>= \fs ->
  maybe (lift $ putStrLn "Error: Root has no parent")
        put (cdupFS fs)

pwd :: MFS
pwd =
  lift (putStrLn "> pwd") >>
  get >>= lift . putStrLn . pwdFS

find :: Name -> MFS
find n =
  lift (putStrLn $ "> find " ++ show n) >>
  get >>= \fs ->
  maybe (lift $ putStrLn "File not found")
        (lift . putStrLn . pwdFS . chPath fs) (findFS n fs)

ls :: MFS
ls =
  lift (putStrLn "> ls") >>
  get >>= \fs -> return (listFiles fs) >>= \files ->
  return (listDirs fs) >>= \dirs ->
  lift $ putStrLn $ foldl (\s d -> s ++ " " ++ d) ""
       (map show files ++ map (\d -> show d ++ "*") dirs)

runSimulator :: MFS -> IO ()
runSimulator code =
  void (putStrLn "" >> runStateT code initFileSystem)
