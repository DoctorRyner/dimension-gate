# Instructions

1. Run `stack repl`
2. Run `runDG` in the repl (Only works after you click *Play* because runDG connects to the Unity websocket engine on address `ws://localhost:1234`)

To run something that is `IO` in the `UIO` monad you must use the `liftIO` function from the `Control.Monad.IO.Class` like this - `liftIO (putStrLn "Some text")`.

The `UIO` monad is the IO monad with the `Reader` monad transformer, it means that you can use the `ask` function to get `state` like this `state <- ask`.

Right now there is only one field in the `state` it's the `connection` field, it contains the reference to the Websockets connection. We need it to send and receive data through the Websockets.

Use the `sendTextData` function to send data to unity and use the `receiveData` function to get data from the Unity.

The `forkIO` can be used to run something in an another thread so it's execution will not block the `IO`.

