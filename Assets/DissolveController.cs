using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class DissolveController : MonoBehaviour {

	private float _value = 1.0f;
	private bool _isRunning = false;
	private Material _dissolveMaterial = null;
	public float timeScale = 0.5f;

	void Start()
	{
        Material material = GetComponent<MeshRenderer>().materials[0];

		// calculate height of mesh
        float maxVal = 0.0f;
		_dissolveMaterial = GetComponent<Renderer>().material;
		var verts = GetComponent<MeshFilter>().mesh.vertices;
		for (int i = 0; i < verts.Length; i++)
		{
			var v1 = verts[i];
			for (int j = 0; j < verts.Length; j++)
			{
				if (j == i) continue;
				var v2 = verts[j];
				float mag = (v1-v2).magnitude;
				if ( mag > maxVal ) maxVal = mag;
				
			}
		}
        _dissolveMaterial.SetFloat("_LargestVal", maxVal * 0.5f);

		StartCoroutine(Dissolve());
	}

	IEnumerator Dissolve()
	{
		_value = 1;

		while (_value > 0)
		{
			_value -= Time.deltaTime * timeScale;
			_dissolveMaterial.SetFloat("_DissolveValue", _value);
			yield return null;
		}

		yield return new WaitForSeconds(1);

		while (_value < 1)
		{
			_value += Time.deltaTime * timeScale;
			_dissolveMaterial.SetFloat("_DissolveValue", _value);
			yield return null;
		}
	}
}