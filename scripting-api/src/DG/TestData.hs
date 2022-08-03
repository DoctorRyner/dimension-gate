module DG.TestData where
import DG.Types (UIO)
import DG.App (runDG)

startDGTest :: IO ()
startDGTest = runDG testInit

testInit :: UIO ()
testInit = pure ()