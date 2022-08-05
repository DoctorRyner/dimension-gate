{-# OPTIONS_GHC -Wno-name-shadowing #-}
module DG.App where

import Control.Monad
import Control.Monad.IO.Class
import Network.WebSockets
import qualified Data.Text as T
import DG.Types
import DG.UnityMessage
import Control.Concurrent.Async.Lifted (async)
import Data.UUID.V4 (nextRandom)
import Data.UUID (toString)
import Data.HashMap
import Data.Aeson (encode)
import Data.ByteString.Lazy.Char8 (unpack)
import Control.Monad.Trans.State (StateT (runStateT), get, put)



registerEvent :: Event -> UIO () -> UIO ()
registerEvent event handler = do
    state <- get

    id <- toString <$> liftIO nextRandom
    let eventJson = unpack $ encode event

    put $ state { events = insert id handler state.events }

    liftIO . print $ Prelude.map fst (toList state.events)

    sendUnityMessage $ UnityMessage "registerEvent" (Just eventJson) (Just id)

messageHandler :: UnityMessage -> UIO ()
messageHandler message =
    case message.name of
        _ -> pure ()

getDgUrl :: IO String
getDgUrl = pure $ "localhost"

messageReceiver :: UIO () -> UIO ()
messageReceiver init = do
    state <- get

    async init

    void . forever $ do
        message :: Maybe UnityMessage <- receiveUnityMessage
        async $ case message of
            Just mes -> messageHandler mes
            Nothing  -> pure ()

        let fromMaybe (Just a) = show a
            fromMaybe Nothing  = "Nothing"
        liftIO . putStrLn $ "Got a message from the Unity: " ++ fromMaybe message

    liftIO $ sendClose state.connection (T.pack "Bye!")

appHandler :: UIO () -> String -> ClientApp ()
appHandler init dgUrl connection = do
    let state = State { connection = connection, events = empty }

    putStrLn $ "Connected to the '" ++ dgUrl ++ "'"

    runStateT (messageReceiver init) state

    pure ()

runDG :: UIO () -> IO ()
runDG init = do
    dgUrl <- getDgUrl
    runClient dgUrl 1234 "/" (appHandler init dgUrl)
