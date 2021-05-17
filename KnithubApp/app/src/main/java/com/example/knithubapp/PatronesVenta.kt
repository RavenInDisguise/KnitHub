package com.example.knithubapp

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.ListView
import example.javatpoint.com.kotlincustomlistview.MyListAdapter
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.delay
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONArray
import org.json.JSONObject


class PatronesVenta : AppCompatActivity() {
    private var titulos = arrayOf<String>()
    private var creadores = arrayOf<String>()
    private var categorias = arrayOf<String>()
    private var precio = arrayOf<String>()
    private var changed = false;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_patrones_venta)
        GlobalScope.async {
            getPatsVent()
        }
        while(!changed){}
        val myListAdapter = MyListAdapter(this,titulos,creadores,categorias,precio)
        val listView : ListView = findViewById(R.id.listView)
        listView.adapter = myListAdapter
    }
    private fun append(arr: Array<String>, element: String): Array<String> {
        val list: MutableList<String> = arr.toMutableList()
        list.add(element)
        return list.toTypedArray()
    }
    private fun getPatsVent() {
        val url = "http://192.168.8.102:8080/patronesVenta"
        val client = OkHttpClient()
        val request = Request.Builder()
                .url(url)
                .get()
                .build()
        val response = client.newCall(request).execute()
        val responseBody = response.body!!.string()
        val resultJson = JSONObject(responseBody)
        var data = resultJson.optJSONArray("data")
        data = data[0] as JSONArray?
        for (pos in 0 until data.length()){
            Log.i("Ciclo: ",pos.toString())
            var currentData = data[pos].toString()
            var currentJason = JSONObject(currentData)
            creadores = append(creadores, currentJason.optString("PersonName"))
            titulos = append(titulos, currentJason.optString("PatternName"))
            categorias = append(categorias, currentJason.optString("PatternCategoryName"))
            precio = append(precio, currentJason.optString("Price"))
        }
        changed = true
    }
}