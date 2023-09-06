//
//  CalenderView.swift
//  To-Do List
//
//  Created by ChicMic on 25/08/23.
//

import SwiftUI

struct CalenderView: View {
    var setectedDate:  Date = Date()
    var VM = CalenderVM()
    var body: some View {
      ScrollView(.horizontal){
            HStack(spacing: 20){
               ForEach(VM.date, id: \.self) { date in
                   VStack(spacing:10){
                       Text("\(date.day)")
                           .foregroundColor(.black)
                       Text("\(date.dayname)")
                           .foregroundColor(.black)
                   }
                   .clipShape(RoundedRectangle(cornerSize: CGSize(width: 60, height: 60)))
                   .shadow(radius: 10)
                }
             }
       }

    }
}
struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}
