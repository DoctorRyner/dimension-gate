using UnityEngine;
// using WebSocketSharp;

public class DimensionGateClient : MonoBehaviour {
    void Awake() {
        DimensionGateServer.StartServer();
    }

    void Update () {
        if (Input.GetKeyDown(KeyCode.F)) {
            DimensionGateServer.inst.send("F");
        }
    }

    // public static WebSocket ws;

    // public static void StartClient() {
    //     ws = new WebSocket("ws://localhost:1234");

    //     ws.Connect();
    //     print("Start the DimensionGate Client");

    //     ws.OnMessage += (sender, e) => {
    //         Debug.Log(
    //             "Message Received from "
    //                 + ((WebSocket)sender).Url
    //                 + ", Data : "
    //                 + e.Data
    //         );

    //         if (e.Data == "F") {
    //             UnityMainThreadDispatcher.Instance().Enqueue(() => {
    //                 PlayerCamera.inst.setPosition(new Vector3(0, 3, 0));
    //             });
    //         }
    //     };
    // }

    // void Update() {
    //     if (Input.GetKeyDown(KeyCode.F)) {
    //         ws.Send("Hehe");
    //     }
    // }

    // void Start() {
    //     StartClient();
    //     // DimensionGateServer.StartServer();
    // }
}