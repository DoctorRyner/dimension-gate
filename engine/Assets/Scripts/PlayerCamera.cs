using UnityEngine;

public class PlayerCamera : MonoBehaviour {
  public static PlayerCamera inst;

  public Vector2 getPosition() {
    return new Vector2(gameObject.transform.position.x, gameObject.transform.position.z);
  }

  public void setPosition(Vector2 pos) {
    gameObject.transform.position = new Vector3(
      pos.x,
      gameObject.transform.position.y,
      pos.y
    );
  }

  public void destroyTerrain() {
    var terrain = GameObject.Find("Terrain");

    Destroy(terrain);
  }

  void Awake() {
    inst = this;
    // setPosition(new Vector2(0, 0));
  }
}

