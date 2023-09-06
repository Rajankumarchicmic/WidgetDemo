//
//  ContentView.swift
//  To-Do List
//
//  Created by ChicMic on 25/08/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var selectedDate = Date()
    @ObservedObject var todaysTaskList: ViewModel = ViewModel()
    @State var refresh: Bool = false

    var body: some View {
            VStack{
                HStack{
                    Image(systemName: "person.circle.fill")
                    .resizable()
                    .padding(.leading,20)
                   .frame(width: 80,height: 60)
                    Text("Your name")
                        .padding()
                        .font(.system(size: 20,weight: .bold))
                    Spacer()
                }
                Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
           
                ScrollView{
                HStack{
                    Text("Today's Task")
                        .font(.system(size: 30,weight: .bold))
                        .padding(.leading)
                        Spacer()
                    Button {
            
                  var task = Task(title: "New title", description: "google search", time: "5:30", date: "24/12/2023", isCompleted: false)
                        todaysTaskList.taskList.append(task)
                 let _ =   todaysTaskList.appendData(data: task)
                        WidgetCenter.shared.reloadTimelines(ofKind: "My Widget")

                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                }
                    ForEach(todaysTaskList.taskList) { task in
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 1)
                        HStack(alignment: .center){
                           
                            Rectangle()
                                .fill(.green.opacity(0.3))
                                .frame(width: 6,height: 80)
                                .padding(.leading)
                     
                            Button {
                                if let index = todaysTaskList.taskList.firstIndex(where: { $0.id == task.id }) {
                                                             withAnimation {
                                                                 todaysTaskList.taskList[index].isCompleted.toggle()
                                                                 let _ =    todaysTaskList.updateAtIndex(task:     todaysTaskList.taskList[index],index: index)
                                                                 WidgetCenter.shared.reloadTimelines(ofKind: "My Widget")
                                                             }
                                                         }
                               
                                
                            } label: {
                                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .padding(.leading)
                                    .tint(Color.black)
                            }

                            VStack(alignment: .leading){
                                Text("\(task.title)")
                                    .font(.system(size: 18,weight: .bold))
                                    .frame(alignment: .leading)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom,5)
                            
                                Text("\(task.time)")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                
                            }
                            .padding(.leading)
                            Spacer()
                            Text("\(task.date)")
                                .font(.system(size: 15))
                                .padding(.trailing)
                        }
                        }
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
            }

            }.onAppear(){
                WidgetCenter.shared.reloadTimelines(ofKind: "My Widget")
            }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
