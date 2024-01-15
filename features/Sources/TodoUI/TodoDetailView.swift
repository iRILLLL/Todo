import SwiftUI
import TodoInterface
import SwiftData

public struct TodoDetailView: View {
    
    @State private var viewModel: ViewModel
    private let todo: Todo
    private var mutatedTodo: Todo
    
    public init(todo: Todo) {
        _viewModel = State(initialValue: ViewModel())
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
                
                if !viewModel.isPushNotificationAuthorized {
                    Button {
                        viewModel.askPushNotificationPermission()
                    } label: {
                        HStack {
                            Image(systemName: "bell")
                            Text("Remind Me")
                        }
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

extension TodoDetailView {
    
    @Observable
    final class ViewModel {
        
        private let center = UNUserNotificationCenter.current()
        
        private(set) var isPushNotificationAuthorized: Bool = false
        
        init() {
            self.checkPushNotificationPermission()
        }
        
        func checkPushNotificationPermission() {
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.isPushNotificationAuthorized = false
                case .denied:
                    self.isPushNotificationAuthorized = false
                case .authorized:
                    self.isPushNotificationAuthorized = true
                case .provisional:
                    self.isPushNotificationAuthorized = true
                case .ephemeral:
                    self.isPushNotificationAuthorized = true
                @unknown default:
                    self.isPushNotificationAuthorized = false
                }
            }
        }
        
        func askPushNotificationPermission() {
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if let error {
                    print(error)
                    return
                }
                
                self.isPushNotificationAuthorized = granted
            }
        }
    }
}
