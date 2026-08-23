-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

--------------------------
---- MONITORS MODULES ----
--------------------------

require("modules.monitors")

---------------------
---- MY PROGRAMS ----
---------------------

require("modules.programs")

-------------------
---- AUTOSTART ----
-------------------

require("modules.autostart")


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
require("modules.environment")

-----------------------
----- PERMISSIONS -----
-----------------------
require("modules.permissions")


-----------------------
---- LOOK AND FEEL ----
-----------------------
require("modules.decoration")

require("modules.animations")

require("modules.layout")

----------------
----  MISC  ----
----------------
require("modules.misc")

---------------
---- INPUT ----
---------------
require("modules.input")

---------------------
---- KEYBINDINGS ----
---------------------
require("modules.keybinds")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
require("modules.windowrules")
