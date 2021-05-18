package com.example.knithubapp

import android.content.DialogInterface
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.widget.Button
import android.widget.EditText
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

class AgregarPatron : AppCompatActivity() {
    var change = false
    var result = "Patrón creado con éxito"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_agregar_patron)
        val agregarDatosPatron = findViewById<Button>(R.id.agregarDatosPatron)
        agregarDatosPatron.setOnClickListener {
            val macEntry = findViewById<EditText>(R.id.entryMac)
            val nameEntry = findViewById<EditText>(R.id.entryName)
            val lastNameEntry = findViewById<EditText>(R.id.entryLastName)
            val patName = findViewById<EditText>(R.id.entryPatternName)
            val patCat = findViewById<EditText>(R.id.entryCategory)
            val patDesc = findViewById<EditText>(R.id.entryDescripcion)
            GlobalScope.async {registrarPatron(macEntry.text.toString(),nameEntry.text.toString(),lastNameEntry.text.toString(),patName.text.toString(),patCat.text.toString(),patDesc.text.toString())}
            while(!change){}
            val dialogBuilder = AlertDialog.Builder(this)
            dialogBuilder.setCancelable(false).setMessage(result).setPositiveButton("Ok", DialogInterface.OnClickListener { dialog, id -> finish()  })
            val alert = dialogBuilder.create()
            alert.setTitle("Resultado")
            alert.show()
        }

    }

    private fun registrarPatron(mac: String, name: String, lName: String, patName: String,patCat: String ,patDesc: String) {
        val url = "http://192.168.100.72:8081/knithub/add/patterns"
        val client = OkHttpClient()
        val json = "application/json; charset=utf-8".toMediaType()
        val jsonString = ("{\"macaddress\":\"$mac\",\"userName\":\"$name\",\"lastName\":\"$lName\",\"patternName\":\"$patName\",\"categoryName\":\"$patCat\",\"description\":\"$patDesc\"}")
        val body = jsonString.toRequestBody(json)
        val request = Request.Builder().url(url).post(body).build()
        try {
            var response = client . newCall (request).execute()
            if (!response.isSuccessful) {
                result = "No se pudo agregar, intentelo más tarde"
            }
        }
        catch (IOException : Exception){
            result = "Ocurrió un problema"
        }
        change = true
        }
}