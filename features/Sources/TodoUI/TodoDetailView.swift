import SwiftUI
import TodoInterface

public struct TodoDetailView: View {
    
    private let todo: Todo
    private var mutatedTodo: Todo
    
    public init(todo: Todo) {
        self.todo = todo
        self.mutatedTodo = todo
    }
    
    @State private var name: String = ""
    
    @State private var showDatePicker: Bool = false
    @State private var dueDate = Date()
    
    public var body: some View {
        Form {
            Section {
                TextField(todo.name, text: $name)
            }
            Section {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "bell")
                        Text("Remind Me")
                    }
                }
                Button {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "calendar")
                        
                        if let dueDate = mutatedTodo.dueAt {
                            HStack {
                                Text(dueDate.formatted())
                                Spacer()
                                Button {
                                    withAnimation {
                                        if showDatePicker {
                                            showDatePicker = false
                                        }
                                    }
                                    mutatedTodo.dueAt = nil
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.red)
                                }
                            }
                        } else {
                            Text("Add Due Date")
                        }
                    }
                }
                
                if showDatePicker {
                    DatePicker(
                        "Pick a date",
                        selection: $dueDate,
                        in: Date.now...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                }
            }
        }
        .onChange(of: dueDate) { _, newValue in
            mutatedTodo.dueAt = newValue
        }
        .toolbar(id: UUID().uuidString) {
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    
                } label: {
                    Image(systemName: "star")
                }
            }
            ToolbarItem(id: UUID().uuidString, placement: .primaryAction) {
                Button {
                    
                } label: {
                    Text("Save")
                }
                .disabled(mutatedTodo == todo)
            }
        }
        .navigationTitle("Add Todo")
        .onAppear {
            if todo.name != "Todo" {
                name = todo.name
            }
        }
    }
}
