module DG.TestData where
import DG.Types (UIO, Event (Event), V2 (..))
import DG.App (runDG, registerEvent)
import DG.Camera (setCameraPos, getCameraPos)

startDGTest :: IO ()
startDGTest = runDG testInit

testHandler :: UIO ()
testHandler = do
    cameraPos <- getCameraPos

    setCameraPos $ V2 (cameraPos.x + 1) cameraPos.y 

testInit :: UIO ()
testInit = do
    registerEvent (Event "keyDownSpace") testHandler
    pure ()