
import SwiftUI

public struct CustomTextField: View {
    @Binding public var text: String
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        TextField("Your response", text: $text)
            .padding(30)
            .foregroundColor(Color.white.opacity(0.8))
            .font(.system(size: 33))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.2), radius: 5, x: -5 , y: -5)
                    .foregroundColor(Color.darkEnd)
            )
            

    }
    
}
