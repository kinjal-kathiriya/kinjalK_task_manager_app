# KinjalK Task Manager - SwiftUI Application

## Technical Documentation

### 1. Application Overview
A modern task management iOS app built with SwiftUI that demonstrates:

- Core SwiftUI concepts
- Data persistence
- Clean architecture
- Memory safety
- Responsive UI

**Key Statistics**:
- 4 interconnected views
- 8+ SwiftUI controls implemented
- 100% programmatic UI
- Supports iOS 15+

### 2. Architectural Design

#### Component Diagram
```mermaid
classDiagram
    class TaskManager {
        <<ObservableObject>>
        -tasks: [Task]
        +addTask(Task)
        +deleteTask(IndexSet)
        +toggleCompletion(Task)
        +saveTasks()
        +loadTasks()
    }
    
    class Task {
        <<ValueType>>
        +id: UUID
        +title: String
        +description: String
        +isCompleted: Bool
        +priority: Int
        +dueDate: Date
    }
    
    TaskManager "1" *-- "many" Task




