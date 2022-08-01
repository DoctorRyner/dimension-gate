module DG.App where

import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import Network.WebSockets
import qualified Data.Text as T
import DG.Types
import DG.UnityMessage
import DG.Camera (getCameraPos)
import Data.Aeson (encode)
import Data.ByteString.Lazy.Char8 (unpack)

getDgUrl :: IO String
getDgUrl =  pure $ "localhost"

gameHandler :: UIO ()
gameHandler = do
    state <- ask

    camPos <- getCameraPos

    sendUnityMessage $ UnityMessage "setCameraPos" (Just . unpack . encode $ V2 (camPos.x + 5) (camPos.y + 5)) Nothing

    void . forever $ do
        message :: Maybe UnityMessage <- receiveUnityMessage
        let fromMaybe (Just a) = show a
            fromMaybe Nothing  = "Nothing"
        liftIO . putStrLn $ "Got a message from the Unity: " ++ fromMaybe message

    liftIO $ sendClose state.connection (T.pack "Bye!")

appHandler :: String -> ClientApp ()
appHandler dgUrl connection = do
    let state = State {connection}

    putStrLn $ "Connected to the '" ++ dgUrl ++ "'"

    runReaderT gameHandler state

runDG :: IO ()
runDG = do 
    dgUrl <- getDgUrl
    runClient dgUrl 1234 "/" (appHandler dgUrl)

