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
        let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

func getData(str: String, today: Int) -> String {
    var result = ""
    let tasks = str.components(separatedBy: "\n")
    tasks.forEach {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let taskDateStr = $0.components(separatedBy: "\t\t")[1]
        let taskDate = (dateFormatter.date(from: taskDateStr))
        if today == 1 {
            if (taskDate! <= dateFormatter.date(from:dateFormatter.string(from: Date()))!) {
                result +=  $0  + "\n"
            }
        }
        else if today == 2{
            if (taskDate! < dateFormatter.date(from:dateFormatter.string(from: Date()))!) {
                result +=  $0  + "\n"
            }
        }
        else if today == 3{
            if (taskDate! == dateFormatter.date(from:dateFormatter.string(from: Date()))!) {
                result +=  $0  + "\n"
            }
        }
        else{
            result +=  $0  + "\n"
        }
    }
    return result
}

struct CurrentTaskView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        HStack(alignment: .top){
            VStack(alignment: .center){
                Text("Current Tasks").font(.largeTitle).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Text(getData(str: entry.flutterData!.text, today: 1)).font(.headline).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Spacer()
            }
        }
    }
    
    private var NoDataView: some View {
        Text("All Done")
    }
    
    var body: some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
}

struct PreviewTaskView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        HStack(alignment: .top){
            VStack(alignment: .center){
                Text("Check It Off Pro").font(.largeTitle).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Text("Tasks\t\tDate Due")
                Spacer()
            }
        }
    }
    
    var body: some View {
        FlutterDataView
    }
}

struct TodayTaskView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        HStack(alignment: .top){
            VStack(alignment: .center){
                Text("Today's Tasks").font(.largeTitle).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Text(getData(str: entry.flutterData!.text, today: 3)).font(.headline).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Spacer()
            }
        }
    }
    
    private var NoDataView: some View {
        Text("All Done")
    }
    
    var body: some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
}

struct AllTaskView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        HStack(alignment: .top){
            VStack(alignment: .center){
                Text("All Tasks").font(.largeTitle).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Text(getData(str: entry.flutterData!.text, today: 4)).font(.headline).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Spacer()
            }
        }
    }
    
    private var NoDataView: some View {
        Text("All Done")
    }
    
    var body: some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
}


struct PastDueTaskView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        HStack(alignment: .top){
            VStack(alignment: .center){
                Text("Past Due Tasks").font(.largeTitle).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Text(getData(str: entry.flutterData!.text, today: 2)).font(.headline).multilineTextAlignment(.center)
                    .foregroundColor((Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 255)))
                Spacer()
            }
        }
    }
    
    private var NoDataView: some View {
        Text("All Done")
    }
    
    var body: some View {
        if(entry.flutterData == nil) {
            NoDataView
        } else {
            FlutterDataView
        }
    }
}

struct CurrentTaskWidget: Widget {
    let kind: String = "CurrentTaskWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CurrentTaskView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("Check It Off Pro")
        .description("Current Tasks for Today and Tasks that are Past Due")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct CurrentTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTaskView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium)).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct TodayTaskWidget: Widget {
    let kind: String = "TodayTaskWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodayTaskView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("Check It Off Pro")
        .description("Tasks that are Due Today (Hides Past Due Tasks)")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct TodayTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTaskView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium)).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct PastDueWidget: Widget {
    let kind: String = "PastDueWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PastDueTaskView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("Check It Off Pro")
        .description("Tasks that are Past Due")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct PastDueWidget_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTaskView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium)).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct AllTaskWidget: Widget {
    let kind: String = "AllTaskWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            AllTaskView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("Check It Off Pro")
        .description("All Tasks")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct AllTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTaskView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium)).previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

@main
struct TaskWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CurrentTaskWidget()
        TodayTaskWidget()
        PastDueWidget()
        AllTaskWidget()
    }
}

