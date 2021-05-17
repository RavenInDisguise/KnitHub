package example.javatpoint.com.kotlincustomlistview

import android.annotation.SuppressLint
import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.example.knithubapp.R

class MyListAdapter(private val context: Activity, private val titulos: Array<String>, private val creadores: Array<String>, private val categorias: Array<String>, private val precios: Array<String>)
    : ArrayAdapter<String>(context, R.layout.custom_list, titulos) {

    @SuppressLint("ViewHolder")
    override fun getView(position: Int, view: View?, parent: ViewGroup): View {
        val inflater = context.layoutInflater
        val rowView = inflater.inflate(R.layout.custom_list, null, true)

        val titleText = rowView.findViewById(R.id.title) as TextView
        val creatorText = rowView.findViewById(R.id.creator) as TextView
        val cartegoryText = rowView.findViewById(R.id.categoria) as TextView
        val priceText = rowView.findViewById(R.id.price) as TextView

        titleText.text = titulos[position]
        creatorText.text = creadores[position]
        cartegoryText.text = categorias[position]
        priceText.text = precios[position].toString()
        return rowView
    }
}