module DG.Types where

import Control.Monad.Trans.Reader
import Network.WebSockets
import Data.Aeson
import GHC.Generics



data Network = Network
    { connection :: Connection
    }

type UIO = ReaderT Network IO

data V2 = V2 {x, y :: Float} deriving (Show, Generic, ToJSON, FromJSON)

data V3 = V3 {x, y, z :: Float} deriving (Show, Generic, ToJSON, FromJSON)

class Vector vector where
    zero :: vector

instance Vector V2 where
    zero = V2 0 0

instance Vector V3 where
    zero = V3 0 0 0

data Unit = Unit
    { id   :: String
    , name :: String
    } deriving (Show, Generic, ToJSON, FromJSON)

data Camera = Camera
    { pos    :: V2
    , height :: Float
    } deriving (Show, Generic, ToJSON, FromJSON)

data Player = Player
    { name :: String
    , team :: Team
    } deriving (Show, Generic, ToJSON, FromJSON)

data Team
    = Red
    | Blue
    | Teal
    | Purple
    | Yellow
    | Orange
    | Green
    | Pink
    | Gray
    | LightBlue
    | DarkGreen
    | Brown
    | Neutral
    | Hostile
    deriving (Show, Generic, ToJSON, FromJSON)

-- Events

data Key = Q | W | E | R

data KeyEvent = Pressed DG.Types.Key

data Event = KeyEvent

-- Server

data UnityMessage = UnityMessage
    { name :: String
    , body :: Maybe String
    , id   :: Maybe String
    } deriving (Show, Generic, ToJSON, FromJSON)
