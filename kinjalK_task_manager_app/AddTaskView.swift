import SwiftUI

struct AddTaskView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var description: String
    @State private var priority: Int
    @State private var dueDate: Date
    @State private var showAlert = false
    
    // Initializer for creating a new task
    init(taskManager: TaskManager) {
        self.taskManager = taskManager
        _title = State(initialValue: "")
        _description = State(initialValue: "")
        _priority = State(initialValue: 1)
        _dueDate = State(initialValue: Date())
    }
    
    // Initializer for editing an existing task
    init(taskManager: TaskManager, editingTask: TaskManager.Task) {
        self.taskManager = taskManager
        _title = State(initialValue: editingTask.title)
        _description = State(initialValue: editingTask.description)
        _priority = State(initialValue: editingTask.priority)
        _dueDate = State(initialValue: editingTask.dueDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Priority")) {
                    Stepper(value: $priority, in: 1...5) {
                        HStack {
                            Text("Priority: \(priority)")
                            Spacer()
                            PriorityView(priority: priority)
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle(title.isEmpty ? "Add New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if !title.isEmpty || !description.isEmpty {
                            showAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let task = TaskManager.Task(
                            title: title,
                            description: description,
                            priority: priority,
                            dueDate: dueDate
                        )
                        taskManager.addTask(task)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Discard Changes?"),
                    message: Text("Are you sure you want to discard this task?"),
                    primaryButton: .destructive(Text("Discard")) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
