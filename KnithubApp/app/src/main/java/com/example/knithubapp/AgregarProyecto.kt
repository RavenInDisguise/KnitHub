package com.example.knithubapp

import android.content.DialogInterface
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.util.Log
import android.widget.Button
import android.widget.EditText
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

class AgregarProyecto : AppCompatActivity() {
    var change = false
    var result = "Proyecto creado con éxito"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_agregar_proyecto)
        val agregarDatosProyecto = findViewById<Button>(R.id.agregarDatosProyecto)
        agregarDatosProyecto.setOnClickListener {
            val macEntry = findViewById<EditText>(R.id.entryMac)
            val nameEntry = findViewById<EditText>(R.id.entryName)
            val lastNameEntry = findViewById<EditText>(R.id.entryLastName)
            val projName = findViewById<EditText>(R.id.entryProjectName)
            val projPat = findViewById<EditText>(R.id.entryPatternName)
            val pricePerHour = findViewById<EditText>(R.id.entryPricePerHour)
            GlobalScope.async {registrarPoyecto(macEntry.text.toString(),nameEntry.text.toString(),lastNameEntry.text.toString(),projName.text.toString(),projPat.text.toString(),pricePerHour.text.toString())}
            while(!change){}
            val dialogBuilder = AlertDialog.Builder(this)
            dialogBuilder.setCancelable(false).setMessage(result).setPositiveButton("Ok", DialogInterface.OnClickListener { dialog, id -> finish()  })
            val alert = dialogBuilder.create()
            alert.setTitle("Resultado")
            alert.show()
        }
    }

    private fun registrarPoyecto(macEntry: String, nameEntry: String, lastNameEntry: String, projName: String, projPat: String, pricePerHour: String){
        val url = "http://192.168.8.102:8080/knithub/add/projects"
        val client = OkHttpClient()
        val json = "application/json; charset=utf-8".toMediaType()
        val jsonString = ("{\"macaddress\":\"$macEntry\",\"userName\":\"$nameEntry\",\"lastName\":\"$lastNameEntry\",\"patternName\":\"$projPat\",\"projectName\":\"$projName\",\"pricePerHour\":\"$pricePerHour\"}")
        Log.i("JSON",jsonString)
        val body = jsonString.toRequestBody(json)
        val request = Request.Builder().url(url).post(body).build()
        try {
            var response = client . newCall (request).execute()
            if (!response.isSuccessful) {
                result = "No se pudo agregar, intentelo más tarde"
                Log.i("Response", response.toString())
            }
        }
        catch (IOException : Exception){
            result = "Ocurrió un problema"
        }
        change = true
    }
}