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
}