{-# OPTIONS_GHC -Wno-name-shadowing #-}
module DG.App where

import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import Network.WebSockets
-- import qualified Data.Text as T
import DG.Types
import DG.UnityMessage
import Control.Concurrent.Async.Lifted (async)
-- import DG.Camera (getCameraPos)
-- import Data.Aeson (encode)
-- import Data.ByteString.Lazy.Char8 (unpack)
import Control.Concurrent (forkIO)

messageHandler :: UnityMessage -> UIO ()
messageHandler message = case message.name of
    _ -> pure ()

getDgUrl :: IO String
getDgUrl = pure $ "localhost"

messageReceiver :: UIO () -> UIO ()
messageReceiver init = do
    network <- ask

    -- camPos <- getCameraPos

    -- sendUnityMessage $ UnityMessage "setCameraPos" (Just . unpack . encode $ V2 (camPos.x + 5) (camPos.y + 5)) Nothing


    void . forever $ do
        message :: Maybe UnityMessage <- receiveUnityMessage
        async $ case message of 
            Just mes -> messageHandler mes
            Nothing  -> pure ()

        let fromMaybe (Just a) = show a
            fromMaybe Nothing  = "Nothing"
        liftIO . putStrLn $ "Got a message from the Unity: " ++ fromMaybe message
    -- liftIO $ sendClose network.connection (T.pack "Bye!")

appHandler :: UIO () -> String -> ClientApp ()
appHandler init dgUrl connection = do
    let network = Network { connection }

    putStrLn $ "Connected to the '" ++ dgUrl ++ "'"

    runReaderT (messageReceiver init) network

runDG :: UIO () -> IO ()
runDG init = do
    dgUrl <- getDgUrl
    runClient dgUrl 1234 "/" (appHandler init dgUrl)
