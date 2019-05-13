using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateCamera : MonoBehaviour
{
    [SerializeField] private Transform subject;
    [SerializeField] private float speed = 2;

    private Vector3 targetPos = Vector3.zero;

    // Start is called before the first frame update
    void Start()
    {
        if (subject != null)
            targetPos = subject.position;
    }

    // Update is called once per frame
    void Update()
    {
        float shift = Input.GetAxis("Horizontal");
        if (shift != 0)
            transform.RotateAround(targetPos, Vector3.up, speed * 10 * Time.deltaTime * shift);
    }
}
