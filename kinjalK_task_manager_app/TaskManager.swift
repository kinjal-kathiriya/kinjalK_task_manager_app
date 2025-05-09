//
//  TaskManager.swift
//  kinjalK_task_manager_app
//
//  Created by kinjal kathiriya  on 5/6/25.
//


import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var showCompletedTasks: Bool = true
    @Published var fontSize: Double = 16.0
    
    struct Task: Identifiable, Codable {
        let id: UUID
        var title: String
        var description: String
        var isCompleted: Bool
        var priority: Int
        var dueDate: Date
        
        init(id: UUID = UUID(), title: String, description: String = "", isCompleted: Bool = false, priority: Int = 1, dueDate: Date = Date()) {
            self.id = id
            self.title = title
            self.description = description
            self.isCompleted = isCompleted
            self.priority = priority
            self.dueDate = dueDate
        }
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func deleteTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func saveTasks() {  // Removed 'private' keyword
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "savedTasks")
        }
    }
    
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "savedTasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
