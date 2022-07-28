using UnityEngine;
using WebSocketSharp;
using WebSocketSharp.Server;

public class DimensionGateServer : WebSocketBehavior {
    public static DimensionGateServer inst;
    public static WebSocketServer wssv;

    protected override void OnMessage(MessageEventArgs e) {
        Debug.Log("GOT MSG: " + e.Data);

        if (e.Data == "Set camera to 0, 0") {
			UnityMainThreadDispatcher.Instance().Enqueue(() => {
                PlayerCamera.inst.setPosition(new Vector2(0, 0));
            });
        }

		if (e.Data == "Set camera to 5, 5") {
			UnityMainThreadDispatcher.Instance().Enqueue(() => {
                PlayerCamera.inst.setPosition(new Vector2(5, 5));
            });
        }

        if (e.Data == "Destroy terrain") {
            UnityMainThreadDispatcher.Instance().Enqueue(() => {
                PlayerCamera.inst.destroyTerrain();
            });
        }
    }

	public static void StartServer() {
		wssv = new WebSocketServer("ws://localhost:1234");

		wssv.AddWebSocketService<DimensionGateServer>("/");

		wssv.Start();
	}

    protected override void OnOpen () {
        inst = this;
    }

    public void send(string data) {
        Send(data);
    }

	void OnDestroy() {
		wssv.Stop();
	}
}
