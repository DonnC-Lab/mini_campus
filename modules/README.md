# MiniCampus Modules

This folder shows the different modules included in the MiniCampus app

Navigate through each module folder, check the `readme.md` file to know more about that module

Typo fixes and or contributions are welcome, each module has the sole owner of that module that can guide contributors on how to go about that module (contributions, code of conduct.. etc)

Each module operates as a standalone mini app within the **MC app** and seperates or decouples its functions as much as possible from the rest of the modules, if anything is related to other modules, its added in the `shared` folder for all modules to access it

The functionality of each module should be standalone with minimum interaction between other created modules to avoid nested functionality and hard-interconnected dependency

First, golden rule of every module is: 

**IF 1 MODULE FAILS TO WORK ON ANY LEVEL, IT SHOULD NOT AFFECT THE FUNCTIONALITY OF ANY OTHER MODULES***

** Only if that module is not the initiator of a shared resource!