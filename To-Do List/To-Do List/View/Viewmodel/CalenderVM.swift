//
//  CalenderVM.swift
//  To-Do List
//
//  Created by ChicMic on 25/08/23.
//

import Foundation

class CalenderVM: ObservableObject{
    
    var date: [DateModel] = []
    init(){
        getAllDate()
    }
     func getAllDate(){
        let calendar = Calendar.current
        let startDate = DateComponents(year: 2000, month: 1, day: 1)
        let currentDate = Date()
         let date = calendar.date(from: startDate)
        guard var date = date else{return}
        while date <= currentDate {
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let weekday = calendar.component(.weekday, from: date)
            let weekdayName = calendar.shortWeekdaySymbols[weekday - 1]
            self.date.append(DateModel(day: day, dayname: weekdayName, month: month, year: year))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }}
}
