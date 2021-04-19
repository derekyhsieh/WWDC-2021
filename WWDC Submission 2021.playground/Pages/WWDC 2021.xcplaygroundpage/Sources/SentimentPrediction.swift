import CoreML
import NaturalLanguage

public class SentimentPrediction: ObservableObject {
    let mlModel: MLModel
    let sentimentPredictor: NLModel
    let textSentimentPostNegModel: MLModel
    let sentimentNegPosPredictor: NLModel
    
    init() {
        self.mlModel = try! MLModel(contentsOf: #fileLiteral(resourceName: "FeelingsClassifier 1.mlmodelc"))
        self.sentimentPredictor = try! NLModel(mlModel: mlModel)
        
        self.textSentimentPostNegModel = try! MLModel(contentsOf: #fileLiteral(resourceName: "TextSentimentPosNeg.mlmodelc"))
        self.sentimentNegPosPredictor = try! NLModel(mlModel: textSentimentPostNegModel)
    }
    
    public func predictFeelingFromString(label: String) -> String {
        print(sentimentPredictor.predictedLabel(for: label))
        return sentimentPredictor.predictedLabel(for: label) ?? ""
    }
    
    public func predictFromString(label: String) -> Double {
//          print("label: \(label) \(sentimentPredictor.predictedLabel(for: label)!)")
//          return Double(sentimentPredictor.predictedLabel(for: label) ?? "0") ?? 0
        var sentimentNum: Double = 0.0
        var mlModelPrediction = Double(sentimentNegPosPredictor.predictedLabel(for: label.lowercased()) ?? "0.0")
        
        print("sentiment neg pos predictor: \(mlModelPrediction)")
        if mlModelPrediction! > 3 {
            return 3
        } else if mlModelPrediction! < -3 {
            mlModelPrediction = -3
        }
        
        
        // feed it into the NaturalLanguage framework
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = label.lowercased()
        
        // ask for the results
        let (sentiment, _) = tagger.tag(at: label.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        // read the sentiment back and print it
        print(sentiment?.rawValue ?? 0)
        sentimentNum = (Double(sentiment!.rawValue) ?? 0) * 10
        print(sentimentNum)
        
        if sentimentNum > 3 {
            return (3.0 + mlModelPrediction!)/2
        } else if sentimentNum < -3 {
            return (-3.0 + mlModelPrediction!)/2
        } else if label.lowercased().contains("great") {
            // edge case with sentimentScore problem
            return mlModelPrediction!
        }
        else {
            return (sentimentNum + mlModelPrediction!)/2
        }
        return mlModelPrediction ?? 0.0
        
    }
    
}

