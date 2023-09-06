//
//  UserToDoModel.swift
//  To-Do List
//
//  Created by ChicMic on 25/08/23.
//

import Foundation
import SwiftUI
struct User : Identifiable{
    var id: Int
    var name: String
    var age: String
}

class ViewModel: ObservableObject{
    @Published var taskList: [Task] = []
    
    init(){
        let data = getDataFromSharedContainer()
        if data.count == 0{
            self.taskList = addStaticdata()
        }else{
            self.taskList = getDataFromSharedContainer()
        }
        
    }
    
    func getDataFromSharedContainer()-> [Task]{
        if let sharedUserDefaults = UserDefaults(suiteName: "group.com.ios.mylist") {
            if let storedData = sharedUserDefaults.data(forKey: "WidgetData") {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([Task].self, from: storedData) {
                    return decodedData
                    
                }
            }
        }
        return []
    }
    
    func addStaticdata()-> [Task]{
        let data =  [Task(title: "complete project proposal", description: "send follow-up emails", time: "9:30 Am", date: "12/08/2023", isCompleted:
             false
                        ), Task( title: "Schedule client meeting", description: "", time: "10:30 Am", date: "12/08/2023", isCompleted:
            false
         ),Task( title: "Research new marketing strategies", description: "", time: "9:30 Am", date: "12/08/2023", isCompleted:
            true
        ), Task( title: "Review and revise presentation", description: "", time: "10:30 Am", date: "12/08/2023", isCompleted:
             true
         ),Task(title: "Pay bills", description: "", time: "9:30 Am", date: "12/08/2023", isCompleted:
         false
       ), Task( title: "Grocery shopping", description: "", time: "10:30 Am", date: "12/08/2023", isCompleted:
             true
        )]
        addDataToShareContainer(data: data)
        
        return getDataFromSharedContainer()
    }
    func addDataToShareContainer(data:[Task]){
        if let sharedDefaults = UserDefaults(suiteName: "group.com.ios.mylist") {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(data) {
                sharedDefaults.set(encodedData, forKey: "WidgetData")
               // sharedDefaults.synchronize()
            }
        }
    }
   
        func appendData(data: Task)->[Task]{
            var previousData = self.getDataFromSharedContainer()
            previousData.append(data)
            self.addDataToShareContainer(data: previousData)
            return self.getDataFromSharedContainer()
            
        }
    func updateAtIndex(task: Task, index: Int)->[Task]{
        var previousData = self.getDataFromSharedContainer()
        previousData[index] = task
        self.addDataToShareContainer(data: previousData)
        return self.getDataFromSharedContainer()
    }
    func singularBinding(forIndex index: Int) -> Binding<Bool> {
           Binding<Bool> { () -> Bool in
               self.taskList[index].isCompleted
           } set: { (newValue) in
               self.taskList = self.taskList.enumerated().map { itemIndex, item in
                   var itemCopy = item
                   if index == itemIndex {
                       itemCopy.isCompleted = newValue
                   } else {
                       //not the same index
                       if newValue {
                           itemCopy.isCompleted = false
                       }
                   }
                   return itemCopy
               }
           }
       }
}

struct Task: Identifiable,Encodable,Decodable{
    var id = UUID()
    var title: String
 var description: String
   var time: String
   var date: String
    var isCompleted:Bool
    

    enum CodingKeys: String, CodingKey {
    case title
    case description
     case time
     case date
    case isCompleted
     }
    public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(title, forKey: .title)
          try container.encode(description, forKey: .description)
          try container.encode(time, forKey: .time)
          try container.encode(date, forKey: .date)
        try container.encode(isCompleted, forKey: .isCompleted)
      }
 init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.time = try values.decode(String.self, forKey: .time)
        self.date = try values.decode(String.self, forKey: .date)
        self.isCompleted = try values.decode(Bool.self, forKey: .isCompleted)
    }
    
    init( title: String, description: String, time: String, date: String, isCompleted: Bool) {
        self.title = title
        self.description = description
        self.time = time
        self.date = date
        self.isCompleted = isCompleted
    }

    
}

extension Task: Hashable{
    var identifier: String {
          return UUID().uuidString
      }
      
      public func hash(into hasher: inout Hasher) {
          return hasher.combine(identifier)
      }
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

struct DateModel: Identifiable,Hashable{
    var id: Int  = UUID().hashValue
    var day: Int
    var dayname: String
    var month: Int
    var year: Int
}
