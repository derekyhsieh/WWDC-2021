
import SwiftUI

struct SentimentPieData  {
    var name: String
    var percentage: Double
    var color: Color
}

public class PieChartViewModel: ObservableObject {
    
    @Published var data: [SentimentPieData] = []
    @Published var sentimentList: [String] = []
    
    var possibleColors = [
        Color.red,
        Color.blue,
        Color.orange,
        Color.green,
        Color.orange,
        Color.purple,
        Color.pink
        
    ]
    
    public func updatePercantages(sentimentArray: [String]) {
        let mappedItems = sentimentArray.map { ($0, 1) }
        let feelings = Dictionary(grouping: sentimentArray, by: { $0 }).mapValues { items in items.count }
        var newData: [SentimentPieData] = []
        
        for (feeling, occurance) in feelings {
            let randomIndex = Int.random(in: 0..<(possibleColors.count-1))
            newData.append(SentimentPieData(name: "\(feeling)", percentage: (Double(occurance)/Double(sentimentArray.count)), color: possibleColors[randomIndex]))
            possibleColors.remove(at: randomIndex)
            print(feeling + " " + "\((Double(occurance)/Double(sentimentArray.count)))")
        }
        
        data = newData
        
    }
    
}


public struct PieChart: View {
    @ObservedObject var viewModel: PieChartViewModel
    @State var selectedPieChartElement: Int? = nil
    
    public init(viewModel: PieChartViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack(spacing: 50) {
            
            if selectedPieChartElement != nil {
                Text(viewModel.data[selectedPieChartElement ?? 0].name + " \(viewModel.data[selectedPieChartElement ?? 0].percentage * 100)" + "%")
                    .font(.system(size: 17))
                    .bold()
            }
            
            
            ZStack {
                
                ForEach(0..<viewModel.data.count) { index in
                    let currentData = viewModel.data[index]
                    let currentEndDegree = currentData.percentage * 360
                    let lastDegree = viewModel.data.prefix(index).map { $0.percentage }.reduce(0, +) * 360
                    
                    ZStack {
                        PieceOfPie(startDegreee: lastDegree, endDegree: lastDegree + currentEndDegree)
                            .fill(currentData.color)
                            .scaleEffect(index == selectedPieChartElement ? 1.2 : 1.0)
                        
                        GeometryReader { geometry in
                            Text(currentData.name)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .position(getLabelCoordinate(in: geometry.size, for: lastDegree + (currentEndDegree/2)))
                        }
                        
                    }.onTapGesture {
                        withAnimation {
                            if index == selectedPieChartElement {
                                self.selectedPieChartElement = nil
                            } else {
                                print(index)
                                selectedPieChartElement = index
                            }
                        }
                    }
                }
                
                
            }
            
            
            
        }
    }
    
    
    private func getLabelCoordinate(in geoSize: CGSize, for degree: Double) -> CGPoint {
        let center = CGPoint(x: geoSize.width / 2, y: geoSize.height / 2)
        let radius = geoSize.width / 3
        let yCoordinate = radius * sin(CGFloat(degree) * (CGFloat.pi/180))
        let xCoordinate = radius * cos(CGFloat(degree) * (CGFloat.pi/180))
        
        return CGPoint(x: center.x + xCoordinate, y: center.y + yCoordinate)
    }
    
}


struct PieceOfPie: Shape {
    
    let startDegreee: Double
    let endDegree: Double
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            p.move(to: center)
            p.addArc(center: center, radius: rect.width/2, startAngle: Angle(degrees: startDegreee), endAngle: Angle(degrees: endDegree), clockwise: false)
            p.closeSubpath()
            
        }
    }
}

