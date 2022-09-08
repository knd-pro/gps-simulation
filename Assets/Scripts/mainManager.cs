using UnityEngine;

[ExecuteAlways]
public class mainManager : MonoBehaviour
{
    [SerializeField] private GameObject _gpsGo, _earthGo, _mainHUDGo;
    [SerializeField] [Range(-90, 90)] private float _latitude;
    [SerializeField] [Range(-180, 180)] private float _longitude;
    [SerializeField] [Range(0, 100000)] private float _altitude;

    private void Update()
    {
        var latitude = _mainHUDGo.GetComponent<mainHUD>().Latitude;
        var longitude = _mainHUDGo.GetComponent<mainHUD>().Longitude;
        var earthRadius = _earthGo.GetComponent<earthSizer>().radius;

        _gpsGo.transform.GetChild(0).localPosition = new Vector3(earthRadius + (_altitude / 100000), 0, 0);
        _gpsGo.transform.rotation = Quaternion.Euler(0, longitude, latitude);

        if (Application.isPlaying) return;
        _mainHUDGo.GetComponent<mainHUD>().Latitude = _latitude;
        _mainHUDGo.GetComponent<mainHUD>().Longitude = _longitude;
    }
}