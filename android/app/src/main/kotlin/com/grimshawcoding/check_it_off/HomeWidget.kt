package com.grimshawcoding.check_it_off

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidget : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout).apply {
                //Open App on Widget Click
                setOnClickPendingIntent(R.id.widget_container,
                        PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java), 0))
                setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                        ?: "Due Today")
                setTextViewText(R.id.widget_message, widgetData.getString("message", null)
                        ?: "Nothing to do or waiting to load.")
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}