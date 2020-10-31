//
//  check_it_off_pro_widget.swift
//  check_it_off_pro_widget
//
//  Created by Paul Patrick Boyd on 10/30/20.
//

import WidgetKit
import SwiftUI
import Intents

struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: FlutterData(text: "Welcome To Check Off It Off Pro"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: FlutterData(text: "Welcome To Check Off It Off Pro"))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.grimshawcoding.checkitoff")
        var flutterData: FlutterData? = nil
        
        if(sharedDefaults != nil) {
            do {
              let shared = sharedDefaults?.string(forKey: "widgetData")
              if(shared != nil){
                let decoder = JSONDecoder()
                flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
       
        VStack{
            Text("Tasks - Due Date\n_____________").font(.title2).multilineTextAlignment(.center)
            Text(entry.flutterData!.text).multilineTextAlignment(.center)
            
        }
    }
    
    private var NoDataView: some View {
      Text("All caught up.\nOpen the App to add more tasks or initialize the widget.")
    }
    
    var body: some View {
      if(entry.flutterData == nil) {
        NoDataView
      } else {
        FlutterDataView
      }
    }
}


@main
struct FlutterWidget: Widget {
    let kind: String = "FlutterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlutterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Check It Off Pro")
        .description("Provides task data from Check It Off Pro.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct FlutterWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlutterWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium)).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
