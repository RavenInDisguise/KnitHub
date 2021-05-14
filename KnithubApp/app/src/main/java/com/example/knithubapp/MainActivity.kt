package com.example.knithubapp

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import android.text.method.ScrollingMovementMethod
import android.view.View
import android.widget.*
import org.json.JSONObject


class MainActivity : AppCompatActivity() {
    var resultView: TextView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val apiButton = findViewById<Button>(R.id.apiButton)
        apiButton.setOnClickListener{ connectToApi()
        }
    }
    fun connectToApi(){
        val url = URL("https://192.168.8.102:8080/patronesVenta")
        val connection = url.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        val `in` = connection.inputStream
        val reader = InputStreamReader(`in`)
        var data = reader.read()
    }

}