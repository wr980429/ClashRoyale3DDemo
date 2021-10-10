using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;

public class LoadTest : MonoBehaviour
{
	public AssetReference[] refs;

	private void OnGUI()
	{
		if (GUILayout.Button("加载一个角色"))
		{
			Addressables.InstantiateAsync(refs[Random.Range(0, refs.Length)], Random.onUnitSphere*5, Quaternion.Euler(0,180,0));
		}
	}
}
