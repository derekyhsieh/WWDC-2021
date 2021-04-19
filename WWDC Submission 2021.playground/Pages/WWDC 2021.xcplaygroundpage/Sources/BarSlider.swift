
import SwiftUI

public struct BarSlider: View {
    @Binding var sliderNumber: Double
    public init(slideNumber: Binding<Double>) {
        self._sliderNumber = slideNumber
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                
                if sliderNumber >= 0.75 {
                    Capsule()
                        .fill(LinearGradient(gradient:  Gradient(colors: [Color.yellow, Color.orange]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 30)
                    
                    Text("😃")
                        .font(.system(size: 60))
                        .foregroundColor(.black)
                        .offset(
                            //                                    x: CGFloat(-geo.size.width/2)
                            //                                    x: geo.size.width/2
                            // full end = geo.size.width/2
                            // full start = -geo.size.width/2
                            // center is nil
                            
                                                            x: (geo.size.width/2) * 0.33 * CGFloat(sliderNumber)
                            
                        )
                } else if sliderNumber < 0.75 && sliderNumber > -0.75 {
                    Capsule()
                        .fill(Color.gray)
                        .frame(height: 30)
                    
                    Text("😐")
                        .font(.system(size: 60))
                        .foregroundColor(.black)
                        .offset(
                            //                                    x: CGFloat(-geo.size.width/2)
                            //                                    x: geo.size.width/2
                            // full end = geo.size.width/2
                            // full start = -geo.size.width/2
                            // center is nil
                            
                            x: (geo.size.width/2) * 0.33 * CGFloat(sliderNumber)
                        )
                } else {
                    Capsule()
                        .fill(LinearGradient(gradient:  Gradient(colors: [Color.blue, Color.darkBlue]), startPoint: .leading, endPoint: .trailing))
                        .frame(height: 30)
                    
                    Text("😔")
                        .font(.system(size: 60))
                        .foregroundColor(.black)
                        .offset(
                            //                                    x: CGFloat(-geo.size.width/2)
                            //                                    x: geo.size.width/2
                            // full end = geo.size.width/2
                            // full start = -geo.size.width/2
                            // center is nil
                            
                            x: (geo.size.width/2) * 0.33 * CGFloat(sliderNumber)
                        )
                }
                
                
            }
        }
        .padding()
    }
}
