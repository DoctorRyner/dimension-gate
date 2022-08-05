module DG.TestData where
import DG.Types (UIO, Event (Event))
import DG.App (runDG, registerEvent)
import Control.Monad.IO.Class (MonadIO(liftIO))

startDGTest :: IO ()
startDGTest = runDG testInit

testHandler :: UIO ()
testHandler = do 
    liftIO $ putStrLn "space is pressed"
    pure ()

testInit :: UIO ()
testInit = do
    registerEvent (Event "keyDownSpace") testHandler
    pure ()