import SwiftUI
import WidgetKit

struct AddTodoView: View {
    
    let icon: String
    let listName: String
    
    init(
        icon: String,
        listName: String
    ) {
        self.icon = icon
        self.listName = listName
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(listName)
            }
            Image(systemName: "plus")
                .font(.largeTitle)
            Text("Add todo")
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Color.blue)
    }
}
