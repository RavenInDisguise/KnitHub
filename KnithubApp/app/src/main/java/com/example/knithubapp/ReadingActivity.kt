package com.example.knithubapp

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class ReadingActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_reading)
        val buttonPatsVenta = findViewById<Button>(R.id.buttonPatsVenta)
        buttonPatsVenta.setOnClickListener {openPatronesVenta()
        }
        val buttonResCompraPats = findViewById<Button>(R.id.buttonResCompraPats)
        buttonResCompraPats.setOnClickListener {openCompraPatrones()
        }
        val buttonResCompraPlans = findViewById<Button>(R.id.buttonResCompraPlans)
        buttonResCompraPlans.setOnClickListener {openCompraPlanes()
        }
        val buttonCronProj = findViewById<Button>(R.id.buttonCronProj)
        buttonCronProj.setOnClickListener {openCronometraje()
        }

    }


    private  fun openPatronesVenta(){
        val intent = Intent (this, PatronesVenta::class.java)
        startActivity(intent)
    }
    private fun openCompraPatrones(){
        val intent = Intent (this, CompraPatrones::class.java)
        startActivity(intent)
    }
    private fun openCompraPlanes(){
        val intent = Intent (this, CompraPlanes::class.java)
        startActivity(intent)
    }
    private fun openCronometraje(){
        val intent = Intent (this, CronometrajeProyectos::class.java)
        startActivity(intent)
    }
}