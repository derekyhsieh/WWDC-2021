import SwiftUI

public struct FinishedButton: View {
    public init() {}
    public var body: some View {
        
                Image(systemName: "checkmark")
                    .font(.title)
                
            .padding()
            .foregroundColor(.white)
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)))
            .padding(.horizontal, 20)
    }
}
