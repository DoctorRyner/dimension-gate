using UnityEngine;
using WebSocketSharp;
using WebSocketSharp.Server;

public class UnityMessage {
  public string name;
  public string? body;
  public string? id;

  public UnityMessage(string name_, string? body_, string? id_) {
    name = name_;
    body = body_;
    id   = id_;
  }
}

public class DimensionGateServer : WebSocketBehavior {
  public static DimensionGateServer inst;
  public static WebSocketServer wssv;

  protected override void OnMessage(MessageEventArgs e) {
    Debug.Log("GOT MSG: " + e.Data);

    var data = JsonUtility.FromJson<UnityMessage>(e.Data);

    if (data.name == "getCameraPos") {
      UnityMainThreadDispatcher.Instance().Enqueue(() => {
        var body       = JsonUtility.ToJson(PlayerCamera.inst.getPosition());
        var camPos     = new UnityMessage(data.name, body, data.id);
        var camPosJson = JsonUtility.ToJson(camPos);

        DimensionGateServer.inst.send(camPosJson);
      });
    }

    if (data.name == "setCameraPos") {
      UnityMainThreadDispatcher.Instance().Enqueue(() => {
        var body   = JsonUtility.FromJson<Vector2>(data.body);
        PlayerCamera.inst.setPosition(body);
      });
    }

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
    var ip = "localhost";
    //  System.Environment.GetEnvironmentVariable("UNIP");

    // Debug.Log(ip);

    wssv = new WebSocketServer($"ws://{ip}:1234");

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
