import SwiftUI

struct CircularIconButton: View {
    let systemImage: String
    let backgroundColor: Color
    let action: () -> Void
    let size: CGFloat
    let borderColor: Color = .white
    let borderWidth: CGFloat = 2
    let iconSize: CGFloat = 20
    let iconWeight: Font.Weight = .bold
    let iconColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: iconWeight))
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
                .background(backgroundColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: borderWidth)
                )
        }
    }
}

