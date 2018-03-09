import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce

import Data.List
import qualified XMonad.StackSet as W

import XMonad.Config.Desktop

import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowArranger
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.Circle
import XMonad.Layout.Gaps

import XMonad.Actions.CycleWS (prevWS, nextWS)
import System.IO

myWorkspaces    :: [String]
myWorkspaces    = click $ [ " PHOS ", " ETHE ", " ASTR ", " THEE ", " CRES "]
                  where click l = [ "^ca(1, xdotool key super+"
                                  ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                                  (i,ws) <- zip [1..] l,
                                  let n = i]

myManageHook = composeAll
        [ className =? "Steam"  --> doFloat
        , className =? "feh"   --> doFloat
        ]

mKeys = [ ((modm, xK_p), spawn "dmenu_run -b")
        , ((mod1Mask, xK_F4), kill)
        , ((modm, xK_Left), prevWS)
        , ((modm, xK_Right), nextWS)
        , ((modm .|. controlMask              , xK_s    ), sendMessage  Arrange         )
        , ((modm .|. controlMask .|. shiftMask, xK_s    ), sendMessage  DeArrange       )
        , ((modm .|. controlMask              , xK_Left ), sendMessage (MoveLeft      10))
        , ((modm .|. controlMask              , xK_Right), sendMessage (MoveRight     10))
        , ((modm .|. controlMask              , xK_Down ), sendMessage (MoveDown      10))
        , ((modm .|. controlMask              , xK_Up   ), sendMessage (MoveUp        10))
        , ((modm                 .|. shiftMask, xK_Left ), sendMessage (IncreaseLeft  10))
        , ((modm                 .|. shiftMask, xK_Right), sendMessage (IncreaseRight 10))
        , ((modm                 .|. shiftMask, xK_Down ), sendMessage (IncreaseDown  10))
        , ((modm                 .|. shiftMask, xK_Up   ), sendMessage (IncreaseUp    10))
        , ((modm .|. controlMask .|. shiftMask, xK_Left ), sendMessage (DecreaseLeft  10))
        , ((modm .|. controlMask .|. shiftMask, xK_Right), sendMessage (DecreaseRight 10))
        , ((modm .|. controlMask .|. shiftMask, xK_Down ), sendMessage (DecreaseDown  10))
        , ((modm .|. controlMask .|. shiftMask, xK_Up   ), sendMessage (DecreaseUp    10))
        , ((modm, xK_KP_Add), sequence_ [ sendMessage (IncreaseLeft 10)
                                        , sendMessage (IncreaseRight 10)
                                        , sendMessage (IncreaseUp 10)
                                        , sendMessage (IncreaseDown 10) 
                                        ])
        , ((modm, xK_KP_Subtract), sequence_ [ sendMessage (DecreaseLeft 10)
                                             , sendMessage (DecreaseRight 10)
                                             , sendMessage (DecreaseUp 10)
                                             , sendMessage (DecreaseDown 10) 
                                             ])
        ] where modm = mod4Mask

startUp :: X()
startUp = do
  spawn "compton -b"
  spawn "fehbg"
  spawn "rofi -key-run Alt+p"
  spawn "xsetroot -cursor_name left_ptr"
  spawn "xrdb -load .Xresources"
  setWMName "LG3D"

logbar h = do
        dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = def
        { ppOutput              = hPutStrLn h
        , ppCurrent             = dzenColor (fore) (blu1) . pad
        , ppVisible             = dzenColor (fore) (back) . pad
        , ppHidden              = dzenColor (fore) (back) . pad
        , ppHiddenNoWindows     = dzenColor (fore) (back) . pad
        , ppUrgent              = dzenColor (fore) (red1) . pad
        , ppOrder               = \(ws:l:t) -> [ws,l]
        , ppSep                 = ""
        , ppLayout              = dzenColor (fore) (red1) .
                                ( \t -> case t of
                                        "Spacing 2 ResizableTall" -> " " ++ i ++ "tile.xbm) TALL "
                                        "Full" -> " " ++ i ++ "dice1.xbm) FULL "
                                        "Circle" -> " " ++ i ++ "dice2.xbm) CIRC "
                                        _ -> " " ++ i ++ "tile.xbm) TALL "
                                )
        } where i = "^i(/home/je/.icons/stlarch/"

-- color --

blu1 = "#528588"
red1 = "#BA5E57"
fore = "#DEE3E0"
back = "#343C48"

-----------


-- layout --

res = ResizableTall 1 (2/100) (1/2) []
ful = noBorders (fullscreenFull Full)

   -- useless gap --

layout = avoidStruts $ spacing 5 $ res ||| Circle ||| ful 

------------

main = do
        bar <- spawnPipe panel
        info <- spawnPipe "conky | dzen2 -x 410 -y 10 -h 24 -w 1500 -p -ta r -e ''"
        xmonad $ docks desktopConfig
                { manageHook = myManageHook <+> manageHook def
                , layoutHook = windowArrange layout
                , startupHook = startUp
                , workspaces = myWorkspaces
                , modMask = mod4Mask
                , terminal = "urxvt"
                , borderWidth = 4
                , focusedBorderColor = "#6A555C" --"#404752"
                , normalBorderColor = "#404752" --"#343C48"
                , logHook = logbar bar
                } `additionalKeys` mKeys
                where panel = "dzen2 -ta l -p -w 400 -y 10 -x 10 -h 24 -e ''"
