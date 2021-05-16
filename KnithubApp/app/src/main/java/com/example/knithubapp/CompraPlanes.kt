package com.example.knithubapp

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody

class CompraPlanes : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_compra_planes)
        val buttonCrompraPlan = findViewById<Button>(R.id.buttonCrompraPlan)
        buttonCrompraPlan.setOnClickListener {
            val macEntry = findViewById<EditText>(R.id.macAddressEntry)
            val nameEntry = findViewById<EditText>(R.id.nameEntry)
            val lastNameEntry = findViewById<EditText>(R.id.lastNameEntry)
            val projName = findViewById<EditText>(R.id.tittleEntry)
            GlobalScope.async {getPlanRes(macEntry.text.toString(),nameEntry.text.toString(),lastNameEntry.text.toString(),projName.text.toString())}
        }
    }

    private fun getPlanRes(
        mac: String,
        name: String,
        lName: String,
        title: String
    ) {
        val url = "http://192.168.8.102:8080/compraPlanes"
        val client = OkHttpClient()
        val json = "application/json; charset=utf-8".toMediaType()
        val jsonString = ("{\"macaddress\":\"$mac\",\"username\":\"$name\",\"userlastname\":\"$lName\",\"projectName\":\"$title\"}")
        val body = RequestBody.create(json,jsonString)
        val request = Request.Builder()
            .url(url).post(body)
            .build()
        val  response = client . newCall (request).execute()
        println(response.request)
        println(response.body!!.string())
    }
}