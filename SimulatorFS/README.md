*** Simulator of a FileSystem ***

This simulator has been implemented in the Haskell language.

This development includes three Haskell files and a README.


** Haskell Files **

- FileSystem.hs :
Defines datatypes representing Files, Directories and the FileSystem.
Defines pure functions that manipulate the FileSystem.

- SimulatorFS.hs :
Defines functions for each command of the DSL inside a StateT monad
transformer with IO as inner monad:

  * add f  : Adds a file f to the FileSystem in current position.
  * addD d : Adds a directory d to the FileSystem in current position.
  * cd d   : Change the FileSystem's current position to the subdirectory d. If
             d doesn't exists at current position fails showing an error message.
  * cdup   : Change the FileSystem's current position to parent. If current position
             is Root fails showing an error message.
  * pwd    : Prints path of current position.
  * find f : Look for file f in current position and recursively in all subdirectories.
             If it finds the file prints complete path to it. Otherwise shows
  	         corresponding message.
  * ls     : Lists files and directories in current position. Directories are
             marked with *.

And it defines the main function

  * runSimulator code : Executes 'code' printing each command included in it and
                        its output.

- Examples.hs :
Defines two usage examples.

*** INSTALLATION AND USAGE ***

* Install Haskell platform:
In Ubuntu or Debian:
   $ sudo apt-get install haskell-platform

* Usage
1. Go to SimulatorFS folder

   $ cd SimulatorFS

2. Run ghci

   $ ghci

3. Load Examples.hs file

   Prelude> :l Examples.hs

4. Run an example

   *Examples> runSimulator code1
