package com.example.knithubapp

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class WritingActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_writing)
        val agregarPatron = findViewById<Button>(R.id.agregarPatron)
        agregarPatron.setOnClickListener{openAddPattern() }
        val agregarProyecto = findViewById<Button>(R.id.agregarProyecto)
        agregarProyecto.setOnClickListener{openAddProject()}
    }

    private fun openAddProject() {
        val intent = Intent (this, AgregarProyecto::class.java)
        startActivity(intent)
    }

    private fun openAddPattern() {
        val intent = Intent (this, AgregarPatron::class.java)
        startActivity(intent)
    }
}