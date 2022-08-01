module DG.Camera where

import DG.Types
import Control.Monad.IO.Class (MonadIO(liftIO))
import Data.UUID.V4 (nextRandom)
import Data.UUID (toString)
import DG.UnityMessage (sendUnityMessage, receiveUnityMessage)
import Data.Aeson
import Data.Maybe (fromJust)
import Data.ByteString.Lazy.Char8

setCameraPos :: V2 -> UIO ()
setCameraPos _pos = pure ()

getCameraPos :: UIO V2
getCameraPos = do 
    uid <- toString <$> liftIO nextRandom

    let textData = UnityMessage "getCameraPos" Nothing (Just uid)

    sendUnityMessage textData

    let loop = do
            Just message <- receiveUnityMessage
            case (message.id, message.body) of
                (Just id_, Just body_) ->
                    if id_ == uid
                        then do
                            let v2 :: V2 = fromJust $ decode $ pack body_
                            pure v2

                        else loop
                _ -> loop

    loop


getCamera :: UIO Camera
getCamera = pure $ Camera
    { pos    = zero
    , height = 0
    }

