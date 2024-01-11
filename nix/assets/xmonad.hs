import XMonad

import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

import XMonad.Hooks.ManageDocks

import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeys)

main = do {
  p1 <- spawnPipe "xmobar ~/.config/xmobar/.xmobarrc0"
; p2 <- spawnPipe "xmobar ~/.config/xmobar/.xmobarrc1 -x 1"
; runxm [p1, p2]
}

runxm procs = xmonad $ docks $ def
        { modMask = mod4Mask -- Use Super instead of Alt
        , terminal = "alacritty"
        , focusFollowsMouse = False
        , logHook = dynamicLogWithPP xmobarPP {
            ppOutput = \txt -> mapM_ ((flip hPutStrLn) txt) procs
          , ppTitle = shorten 50
          }
        , borderWidth = 0
        , layoutHook = spacingWithEdge 4 . avoidStruts $ emptyBSP
        , clickJustFocuses = False
        }
