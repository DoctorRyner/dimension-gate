module DG.App where

import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import Network.WebSockets
import qualified Data.Text as T
import DG.Types

dgUrl :: String
dgUrl = "localhost"

gameHandler :: UIO ()
gameHandler = do
    state <- ask

    void . liftIO . forever $ do
        message :: T.Text <- receiveData state.connection
        putStrLn $ "Got a message from the Unity: " ++ T.unpack message
    
    liftIO $ sendClose state.connection (T.pack "Bye!")

appHandler :: ClientApp ()
appHandler connection = do
    let state = State {connection}

    putStrLn $ "Connected to the '" ++ dgUrl ++ "'"

    runReaderT gameHandler state

runDG :: IO ()
runDG = runClient dgUrl 1234 "/" appHandler

