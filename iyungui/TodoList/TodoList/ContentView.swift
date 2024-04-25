//
//  ContentView.swift
//  TodoList
//
//  Created by 이융의 on 4/25/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var newTodoText: String = ""
    @State private var newPriority: Priority = .medium
    
    @Query var tasks: [Task]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(tasks, id: \.id) { task in
                        HStack(spacing: 20) {
                            Button(action: {
                                task.completed.toggle()
                            }) {
                                Image(systemName: task.completed ? "circle.inset.filled" : "circle")
                                    .imageScale(.large)
                            }
                            Text("\(task.content)")
                            
                            Image(systemName: task.priority.imageName)
                        }
                        .padding(.vertical, 8)
                    }
                }
                Spacer()
            }
            .navigationTitle("To do List")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        addTodo(text: newTodoText, priority: newPriority)
                        newTodoText = ""
                    }) {
                        Text("추가")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            
            Divider()
            
            Picker("우선순위", selection: $newPriority) {
                Image(systemName: "star.fill").tag(Priority.high)
                Image(systemName: "star.fill.left").tag(Priority.medium)
                Image(systemName: "star").tag(Priority.low)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("New Task", text: $newTodoText)
                .padding()
        }
    }
    func addTodo(text: String, priority: Priority) {
        let newTodo: Task = Task(completed: false, content: text, priority: priority)
        modelContext.insert(newTodo)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}