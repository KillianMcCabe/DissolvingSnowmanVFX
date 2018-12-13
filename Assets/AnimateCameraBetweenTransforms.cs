using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateCameraBetweenTransforms : MonoBehaviour {

	public Transform from;
	public Transform to;
	public Transform lookTarget;
	public float time = 5;

	float t = 0;
	
	// Update is called once per frame
	void Update () {
		t += Time.deltaTime;
		transform.position = Vector3.Lerp(from.position, to.position, t/time);
		transform.LookAt(lookTarget);
	}
}
