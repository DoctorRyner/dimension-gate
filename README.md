# Instructions

To start the Unity server click the *Play* button, it's running at the following address: `ws://localhost:1234`.

DimensionGate Websockets Server starts from the DimensionGateClient script which is placed on the *Core* object in the Scene hierarchy.

If you want to send something to the Haskell websocket client then use `DimensionGateServer.inst.send("A string that will go to the Haskell client");`

For example, in the DimensionGateClient there is the code bellow:
```C#
void Update () {
    if (Input.GetKeyDown(KeyCode.F)) {
        DimensionGateServer.inst.send("F");
    }
}
```

It means when we press *Play*, focus on the game window in the Unity editor and press the *F* button, then the `"F"` message is sent to the Haskell websockets client.

If you want to handle a message that Haskell websocket client sends, go to the `DimensionGateServer` class and and respond in the `OnMessage` function. BE CAREFUL, you can't just run Unity functions in the `OnMessage` callback because it's running not in the Unity thread, so to run something that uses `MonoBehaviour` or some another Unity API, use the next function:

```C#
UnityMainThreadDispatcher.Instance().Enqueue(() => {
    // Write some Unity code
})
```

For example, in the `OnMessage` function we have the following code:

```C#
if (e.Data == "Set camera to 0, 0") {
    UnityMainThreadDispatcher.Instance().Enqueue(() => {
        PlayerCamera.inst.setPosition(new Vector2(0, 0));
    });
}
```

It means that when Haskell websockets client sends to the Unity websockets server the message `Set camera to 0, 0` the function `PlayerCamera.inst.setPosition(new Vector2(0, 0));` is ran with the help of the `UnityMainThreadDispatcher.Instance().Enqueue(() => { ... })` function.

# Scripting API

Read the `scripting-api/README.md` file.

