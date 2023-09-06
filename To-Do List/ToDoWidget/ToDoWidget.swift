//
//  ToDoWidget.swift
//  ToDoWidget
//
//  Created by ChicMic on 25/08/23.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation
struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: nil)
    }
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        createTimeLineEntry(date: Date(), Configuration: configuration, completion: completion)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        createTimeLineEntry(date: Date(), Configuration: configuration, completion: completion)
    }
    
    func createTimeLineEntry(date:Date, Configuration: ConfigurationIntent,  completion: @escaping (SimpleEntry) -> ()){
        if let sharedUserDefaults = UserDefaults(suiteName: "group.com.ios.mylist") {
            if let storedData = sharedUserDefaults.data(forKey: "WidgetData")  {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([Task].self, from: storedData) {
                    let data = decodedData
                    let filterData = data.filter ({$0.isCompleted == false})
                    let firstThreeElements = Array(filterData.prefix(3))
                    let entry = SimpleEntry(date: date, data: firstThreeElements)
                    completion(entry)
                }
            }
        }
    }
    func createTimeLineEntry(date:Date, Configuration: ConfigurationIntent,  completion: @escaping (Timeline<Entry>) -> ()){
        if let sharedUserDefaults = UserDefaults(suiteName: "group.com.ios.mylist") {
            if let storedData = sharedUserDefaults.data(forKey: "WidgetData"){
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([Task].self, from: storedData) {
                    let data = decodedData
                    let filterData = data.filter ({$0.isCompleted == false})
                    let firstThreeElements = Array(filterData.prefix(3))
                    let entry = SimpleEntry(date: date, data: firstThreeElements)
                    let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 1, to: Date())
                    let timeLine = Timeline(entries: [entry], policy: .after(nextUpdateDate ?? Date()))
                    completion(timeLine)
                }
            }
        }
    }
    static func reloadWidgetData(completion: @escaping (String) -> Void) {
         // Listen for the "WidgetDataUpdated" notification
         NotificationCenter.default.addObserver(forName: NSNotification.Name("WidgetDataUpdated"), object: nil, queue: .main) { _ in
             if let sharedUserDefaults = UserDefaults(suiteName: "group.com.ios.mylist") {
                 if let sharedData = sharedUserDefaults.string(forKey: "WidgetData") {
                     completion(sharedData)
                 }
             }
         }
     }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: [Task]?
}

struct ToDoWidgetEntryView : View {
    var entry: Provider.Entry
    @ViewBuilder func todaysTaskListCell(title: String, time: String, date: String)-> some View{
        Rectangle()
            .fill(.gray)
            .frame(height: 1)
        HStack(alignment: .center){
           
            Rectangle()
                .fill(.green.opacity(0.3))
                .frame(width: 4,height: 50)
                .padding(.leading)
     
            Image(systemName: "square")
                .resizable()
                .frame(width: 25,height: 25)
                .padding(.leading)
            VStack(alignment: .leading){
                Text("\(title)")
                    .font(.system(size: 15,weight: .bold))
                    .frame(alignment: .leading)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom,5)
            
                Text("\(time)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
            }
            .padding(.leading)
            Spacer()
            Text("\(date)")
                .font(.system(size: 12))
                .padding(.trailing)
        }.unredacted()
      
    }
    
    var body: some View {
            VStack{
                ZStack(alignment: .top){
                    HStack{
                        Text("Today's Task")
                            .font(.system(size: 30,weight: .bold))
                            .padding(.leading)
                            Spacer()
                    }
                }
                ForEach(entry.data ?? [] , id: \.self) { val in
                    todaysTaskListCell(title: val.title, time: val.time, date: val.date)
            }
            }.frame(height: 500)
            .onAppear(){
                Provider.reloadWidgetData { data in
                    print(data)
                }
            }
    }
}

struct ToDoWidget: Widget {
    let kind: String = "ToDoWidget"
 
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ToDoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
}

struct ToDoWidget_Previews: PreviewProvider {
    static var previews: some View {
        ToDoWidgetEntryView(entry: SimpleEntry(date: Date(), data: []))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
