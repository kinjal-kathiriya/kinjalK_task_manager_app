//
//  TaskListView.swift
//  kinjalK_task_manager_app
//
//  Created by kinjal kathiriya  on 5/6/25.
//


import SwiftUI

struct TaskListView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var showingAddTask = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Show Completed Tasks", isOn: $taskManager.showCompletedTasks)
                    .padding(.vertical, 8)
                
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task, taskManager: taskManager)) {
                        TaskRowView(task: task)
                            .font(.system(size: taskManager.fontSize))
                    }
                }
                .onDelete(perform: taskManager.deleteTask)
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(taskManager: taskManager)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(taskManager: taskManager)
            }
            .onAppear {
                taskManager.loadTasks()
            }
        }
    }
    
    private var filteredTasks: [TaskManager.Task] {
        taskManager.tasks.filter { task in
            taskManager.showCompletedTasks || !task.isCompleted
        }
        .sorted { $0.priority > $1.priority }
    }
}

struct TaskRowView: View {
    let task: TaskManager.Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
            }
            Spacer()
            PriorityView(priority: task.priority)
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
        }
        .padding(.vertical, 8)
    }
}

struct PriorityView: View {
    let priority: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: "exclamationmark")
                    .foregroundColor(i <= priority ? .red : .gray)
                    .font(.system(size: 10))
            }
        }
    }
}