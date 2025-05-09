import SwiftUI

struct TaskDetailView: View {
    let task: TaskManager.Task
    @ObservedObject var taskManager: TaskManager
    
    @State private var showingEditView = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.title)
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.body)
                }
            }
            
            Divider()
            
            HStack {
                Text("Priority:")
                Spacer()
                PriorityView(priority: task.priority)
            }
            
            HStack {
                Text("Due Date:")
                Spacer()
                Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
            }
            
            Toggle("Completed", isOn: Binding(
                get: { task.isCompleted },
                set: { newValue in
                    if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                        taskManager.tasks[index].isCompleted = newValue
                        taskManager.saveTasks()
                    }
                }
            ))
            
            Spacer()
            
            Button(action: { showDeleteAlert = true }) {
                HStack {
                    Spacer()
                    Text("Delete Task")
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Task Details")
        .toolbar {
            Button("Edit") {
                showingEditView = true
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddTaskView(taskManager: taskManager, editingTask: task)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this task?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                        taskManager.tasks.remove(at: index)
                        taskManager.saveTasks()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
