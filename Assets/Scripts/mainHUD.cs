using UnityEngine;
using TMPro;

[ExecuteAlways]
public class mainHUD : MonoBehaviour
{
    [SerializeField] private GameObject _latitudeInputGo, _longitudeInputGo, 
        _latitudeSliderGo, _longitudeSliderGo;

    public float Latitude
    {
        get => float.Parse(_latitudeInputGo.GetComponent<TMP_InputField>().text);
        set => _latitudeInputGo.GetComponent<TMP_InputField>().text = value.ToString();
    }

    public float Longitude
    {
        get => float.Parse(_longitudeInputGo.GetComponent<TMP_InputField>().text);
        set => _longitudeInputGo.GetComponent<TMP_InputField>().text = value.ToString();
    }

    public void OnLatitudeUpdate(float val)
    {
        _latitudeInputGo.GetComponent<TMP_InputField>().text = val.ToString();
    }

    public void OnLatitudeTextUpdate(string val)
    {
        _latitudeSliderGo.GetComponent<UnityEngine.UI.Slider>().value = float.Parse(val);
    }

    public void OnLongitudeUpdate(float val)
    {
        _longitudeInputGo.GetComponent<TMP_InputField>().text = val.ToString();
    }

    public void OnLongitudeTextUpdate(string val)
    {
        _longitudeSliderGo.GetComponent<UnityEngine.UI.Slider>().value = float.Parse(val);
    }
}