using UnityEngine;
// using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class EventController : MonoBehaviour {
  public static EventController inst;
  public List<EventInstance> events = new List<EventInstance>();

  void Awake() {
    inst = this;
  }

  public void registerEvent(EventInstance event_) {
    events.Add(event_);
  }

  public void destroyEvent(string id) {
    events.Where(eve => eve.id != id);
  }

  public void runEvent(Event event_) {
    // trackers?
    if (event_.name.StartsWith("keyDown")) {
      var key_ = string.Join("", event_.name.Skip(7));
      events
        .Where(eve => eve.name == event_.name)
        .ToList()
        .ForEach(eve => {
          var body = JsonUtility.ToJson(new DGKey(key_));
          var message = new UnityMessage(eve.name, body, eve.id);
          var json = JsonUtility.ToJson(message);
          DimensionGateServer.inst.send(json);
        });
    }
  }
}