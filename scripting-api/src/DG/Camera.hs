module DG.Camera where

import           Control.Concurrent.Async.Lifted (async)
import           Control.Monad.IO.Class          (MonadIO (liftIO))
import           DG.App                          (messageHandler)
import           DG.Types
import           DG.UnityMessage                 (receiveUnityMessage,
                                                  sendUnityMessage)
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8      as BSL
import           Data.Maybe                      (fromJust, fromMaybe)
import           Data.UUID                       (toString)
import           Data.UUID.V4                    (nextRandom)

setCameraPos :: V2 -> UIO ()
setCameraPos pos = do
    let msg = UnityMessage "setCameraPos" (Just $ BSL.unpack $ encode pos) Nothing

    sendUnityMessage msg
    pure ()

getCameraPos :: UIO V2
getCameraPos = do
    uid <- toString <$> liftIO nextRandom

    let textData = UnityMessage "getCameraPos" Nothing (Just uid)

    sendUnityMessage textData

    let loop = do
            Just message <- receiveUnityMessage

            liftIO . putStrLn $ "Got a message from the Unity: " ++ show message

            case (message.id, message.body) of
                (Just id_, Just body_) ->
                    if id_ == uid
                        then do
                            let v2 :: V2 = fromJust $ decode $ BSL.pack body_
                            pure v2

                        else do
                            async $ messageHandler message
                            loop
                _ -> loop

    loop


getCamera :: UIO Camera
getCamera = pure $ Camera
    { pos    = zero
    , height = 0
    }

