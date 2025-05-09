import SwiftUI

struct SettingsView: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    Slider(
                        value: $taskManager.fontSize,
                        in: 12...24,
                        step: 1,
                        minimumValueLabel: Text("A"),
                        maximumValueLabel: Text("A"),
                        label: { Text("Font Size") }
                    )
                    
                    Text("Sample Text")
                        .font(.system(size: taskManager.fontSize))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section {
                    Button("Reset All Data") {
                        taskManager.tasks = []
                        taskManager.saveTasks()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
