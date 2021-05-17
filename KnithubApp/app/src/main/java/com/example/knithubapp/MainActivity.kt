package com.example.knithubapp

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import kotlinx.coroutines.async
import android.text.method.ScrollingMovementMethod
import android.view.View
import android.widget.*
import kotlinx.coroutines.GlobalScope
import org.json.JSONObject


class MainActivity : AppCompatActivity() {
    var resultView: TextView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)
        val buttonReadingApi = findViewById<Button>(R.id.buttonReadingApi)
        buttonReadingApi.setOnClickListener{openNodeOptions()
        }
        val buttonWrittingApi = findViewById<Button>(R.id.buttonWrittingApi)
        buttonWrittingApi.setOnClickListener{openJavaOptions()
        }
    }
    fun openNodeOptions(){
        val intent = Intent (this, ReadingActivity::class.java)
        startActivity(intent)
    }
    fun openJavaOptions(){
        val intent = Intent (this, WritingActivity::class.java)
        startActivity(intent)
    }

}