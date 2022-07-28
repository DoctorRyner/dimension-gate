module DG.UnityMessage where

import DG.Types
import Data.Aeson
import Network.WebSockets
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader

sendUnityMessage :: (ToJSON json) => UnityMessage json -> UIO ()
sendUnityMessage msg = do
    state <- ask

    let textData = encode msg

    liftIO $ sendTextData state.connection textData

receiveUnityMessage :: FromJSON json => UIO (Maybe (UnityMessage json))
receiveUnityMessage = do
    state <- ask

    textData <- liftIO $ receiveData state.connection

    pure $ decode textData

data ResultWithID json = ResultWithID
    { id   :: String
    , body :: json
    }

requestUnityData :: (FromJSON json, FromJSON result) => UnityMessage json -> UIO (Maybe (ResultWithID result))
requestUnityData msg = do
    state <- ask

    let msgWithId = 

    liftIO $ sendUnityMessage state.connection msgWithId

    pure Nothing

setCameraPosMsg :: V2 -> UnityMessage V2
setCameraPosMsg body = UnityMessage
    { name = "setCameraPos"
    , body = Just body
    }

