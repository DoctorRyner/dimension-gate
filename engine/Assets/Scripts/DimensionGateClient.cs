using UnityEngine;
// using WebSocketSharp;
// using System.Collections.Generic;
using System.Linq;

public class DimensionGateClient : MonoBehaviour {

  void Awake() {
    DimensionGateServer.StartServer();
  }

  void Update () {
    if (Input.GetKeyDown(KeyCode.F)) {
      // DimensionGateServer.inst.send("F");
      Debug.Log("F pressed");
      // Debug.Log("First: " + string.Join("", "SomeBodyOnceToldMe".Skip(7)));
      // Debug.Log("Second: " + "SomeBodyOnceToldMe".Skip(7).ToList().ToString());
    }
    if (Input.GetKeyDown(KeyCode.Space)) {
      DGEventController.inst.runEvent(new DGEvent1("keyDownSpace"));
    }
  }
}