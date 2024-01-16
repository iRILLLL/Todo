import XCTest
import SwiftData
@testable import TodoUI
@testable import TodoInterface

@MainActor
final class TodoTests: XCTestCase {

    var viewModel: TodoListView.ViewModel!
    
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Todo.self, Step.self, configurations: config)
        viewModel = TodoListView.ViewModel(modelContext: container.mainContext, sidebarMenu: .today)
    }
    
    func testAddNewTodo() {
        let id = viewModel.addNewTodo()
        XCTAssertTrue(viewModel.todos.contains(where: { $0.id == id }))
        XCTAssertTrue(viewModel.todos.count == 1)
    }
    
    func testDelete() throws {
        _ = viewModel.addNewTodo()
        XCTAssertTrue(viewModel.todos.count == 1)
        try viewModel.delete(todo: viewModel.todos.first!)
        print(viewModel.todos)
        XCTAssertTrue(viewModel.todos.count == 0)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
}
