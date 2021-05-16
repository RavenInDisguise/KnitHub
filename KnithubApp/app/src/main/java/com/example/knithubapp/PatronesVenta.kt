package com.example.knithubapp

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.ListView
import example.javatpoint.com.kotlincustomlistview.MyListAdapter
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import android.widget.Toast
import okhttp3.OkHttpClient
import okhttp3.Request


class PatronesVenta : AppCompatActivity() {
    private val titulos = arrayOf<String>()
    private val creadores = arrayOf<String>()
    private val categorias = arrayOf<String>()
    private val precio = arrayOf<Int>()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_patrones_venta)
        GlobalScope.async {
            getPatsVent()

        }
        val myListAdapter = MyListAdapter(this,titulos,creadores,categorias,precio)
        val listView : ListView = findViewById(R.id.listView)
        listView.adapter = myListAdapter


    }
    private fun getPatsVent() {
        var result: String? = ""
        val url = "http://192.168.8.102:8080/patronesVenta"
        val client = OkHttpClient()
        val request = Request.Builder().url(url).build()
        val  response = client . newCall (request).execute()
        println(response.request)
        println(response.body!!.string())
    }
}