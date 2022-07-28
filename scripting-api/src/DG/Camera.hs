module DG.Camera where

import DG.Types

setCameraPos :: V2 -> UIO ()
setCameraPos _pos = pure ()

getCameraPos :: UIO V2
getCameraPos = pure zero

getCamera :: UIO Camera
getCamera = pure $ Camera
    { pos    = zero
    , height = 0
    }

