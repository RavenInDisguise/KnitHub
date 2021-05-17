package com.example.knithubapp

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
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
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONArray
import org.json.JSONObject
import java.sql.DriverManager.println

class CompraPatrones : AppCompatActivity() {
    private var nameP : String  = " "
    private var monto : String  = " "
    private var fechaRealizacion : String  = " "
    private var tipo : String  = " "
    private var nombrePatron : String  = " "
    private var categoryName : String  = " "
    private var merchant : String  = " "
    private var estado : String  = " "
    private var changed = false;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_compra_patrones)
        val buttonCromPats = findViewById<Button>(R.id.buttonCromPats)
        buttonCromPats.setOnClickListener {
            val macEntry = findViewById<EditText>(R.id.macAddressEntry)
            val nameEntry = findViewById<EditText>(R.id.nameEntry)
            val lastNameEntry = findViewById<EditText>(R.id.lastNameEntry)
            val planName = findViewById<EditText>(R.id.tittleEntry)
            GlobalScope.async {getCompraRes(macEntry.text.toString(),nameEntry.text.toString(),lastNameEntry.text.toString(),planName.text.toString())}
            while(!changed){}
            printLabels()
        }
    }
   private  fun printLabels(){
        var textview : TextView = findViewById<TextView>(R.id.NombreComprador1)
        textview.visibility = View.VISIBLE
        textview.text = "Nombre del usuario: $nameP"

        textview = findViewById<TextView>(R.id.monto1)
        textview.visibility = View.VISIBLE
        textview.text = "Monto de la factura: $monto"

        textview = findViewById<TextView>(R.id.fechaTrans1)
        textview.visibility = View.VISIBLE
        textview.text = "Fecha de la compra: $fechaRealizacion"

        textview = findViewById<TextView>(R.id.tipoTrans1)
        textview.visibility = View.VISIBLE
        textview.text = "Tipo transacción: $tipo"

        textview = findViewById<TextView>(R.id.nombrePlan1)
        textview.visibility = View.VISIBLE
        textview.text = "Nombre del Patron: $nombrePatron"

        textview = findViewById<TextView>(R.id.category)
        textview.visibility = View.VISIBLE
        textview.text = "Categoria: $categoryName"

        textview = findViewById<TextView>(R.id.merchant1)
        textview.visibility = View.VISIBLE
        textview.text = "Pago por: $merchant"

        textview = findViewById<TextView>(R.id.status1)
        textview.visibility = View.VISIBLE
        textview.text = "Estado del pago: $estado"
    }
    private fun getCompraRes(
            mac: String,
            name: String,
            lName: String,
            title: String
    ) {
        val url = "http://192.168.8.102:8080/compraPatrones"
        val client = OkHttpClient()
        val json = "application/json; charset=utf-8".toMediaType()
        Log.i("Titulo: ",title)
        val jsonString = ("{\"macaddress\":\"$mac\",\"username\":\"$name\",\"userlastname\":\"$lName\",\"patterntitle\":\"$title\"}")
        val body = jsonString.toRequestBody(json)
        val request = Request.Builder().url(url).post(body).build()
        val  response = client . newCall (request).execute()
        val responseBody = response.body!!.string()
        Log.i("Prueba: ", responseBody)
        val resultJson = JSONObject(responseBody)
        try {
            var data = resultJson.optJSONArray("data")
            data = data[0] as JSONArray?
            Log.i("Prueba: ", data.toString())
            var finalData = data[0] as JSONObject
            Log.i("Data: ", finalData.toString())
            nameP = finalData.optString("PersonName")
            monto = finalData.optString("TransAmount")
            fechaRealizacion = finalData.optString("TransPosttime")
            tipo = finalData.optString("TransType")
            nombrePatron = finalData.optString("Title")
            categoryName = finalData.optString("Name")
            merchant = finalData.optString("MerchantName")
            estado = finalData.optString("PaymentStatus")
        }
        catch (IOException : Exception){

        }
        changed = true
    }
}