package com.example.knithubapp

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import org.json.JSONArray
import org.json.JSONObject
import java.lang.Exception

class CronometrajeProyectos : AppCompatActivity() {
    private var nameP : String  = " "
    private var project : String  = " "
    private var time : String  = " "
    private var changed = false;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_cronometraje_proyectos)
        val buttonCronProj = findViewById<Button>(R.id.buttonCronProj)
        buttonCronProj.setOnClickListener {
            val macEntry = findViewById<EditText>(R.id.macAddressEntry)
            val nameEntry = findViewById<EditText>(R.id.nameEntry)
            val lastNameEntry = findViewById<EditText>(R.id.lastNameEntry)
            val projName = findViewById<EditText>(R.id.tittleEntry)
            GlobalScope.async { getProjCrom(macEntry.text.toString(),nameEntry.text.toString(),lastNameEntry.text.toString(),projName.text.toString()) }
            while(!changed){}
            printLabels()
        }
    }
    private  fun printLabels(){
        val nombre : TextView = findViewById<TextView>(R.id.NombreComprador3)
        nombre.visibility = View.VISIBLE
        nombre.text = "Nombre del usuario: $nameP"
        val proyecto : TextView = findViewById<TextView>(R.id.nombrePlan3)
        proyecto.visibility = View.VISIBLE
        proyecto.text = "Nombre del proyecto: $project"
        val tiempo : TextView = findViewById<TextView>(R.id.tiempoTrans3)
        tiempo.visibility = View.VISIBLE
        tiempo.text = "Tiempo usado: $time"
    }
    private fun getProjCrom(
        mac: String,
        name: String,
        lName: String,
        title: String) {
        val url = "http://192.168.8.102:8080/cronometrajeProyectos"
        val client = OkHttpClient()
        val json = "application/json; charset=utf-8".toMediaType()
        val jsonString = ("{\"macaddress\":\"$mac\",\"username\":\"$name\",\"userlastname\":\"$lName\",\"projectName\":\"$title\"}")
        val body = RequestBody.create(json,jsonString)
        val request = Request.Builder().url(url).post(body).build()
        val  response = client . newCall (request).execute()
        val responseBody = response.body!!.string()
        Log.i("JSON",responseBody)
        val resultJson = JSONObject(responseBody)
        try {
            var data = resultJson.optJSONArray("data")
            data = data[0] as JSONArray?
            Log.i("Prueba: ", data.toString())
            var finalData = data[0] as JSONObject
            Log.i("Data: ",data.toString())

            nameP =  finalData.optString("PersonName")
            project =  finalData.optString("ProjectName")
            time = finalData.optString("ProjectTime")

        }
        catch (IOException : Exception){

        }
        changed = true
    }
}