module DG.Debug where

import DG.Types
import Control.Monad.IO.Class

debugLog :: String -> UIO ()
debugLog = liftIO . putStrLn

