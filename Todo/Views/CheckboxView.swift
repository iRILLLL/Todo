import SwiftUI

struct CheckboxView: View {
    
    @Binding var isChecked: Bool
    
    private let size: CGFloat = 20
    
    var body: some View {
        Button {
            withAnimation(.default.speed(2)) {
                isChecked.toggle()
            }
        } label: {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(isChecked ? Color.accentColor : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(lineWidth: 3)
                        .foregroundColor(isChecked ? Color.accentColor : Color.secondary)
                )
                .overlay {
                    Image(systemName: "checkmark")
                        .resizable()
                        .padding(5)
                        .foregroundColor(.white)
                        .opacity(isChecked ? 1 : 0)
                }
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .shadow(radius: 3)
                        .opacity(isChecked ? 1 : 0)
                )
                .scaleEffect(isChecked ? 1 : 0.95)
                .frame(width: size, height: size)
        }
        .buttonStyle(CheckboxButtonStyle())
    }
}

private struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
