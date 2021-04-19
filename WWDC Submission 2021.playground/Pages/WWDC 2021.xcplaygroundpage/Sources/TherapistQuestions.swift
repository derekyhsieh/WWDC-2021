import SwiftUI
import NaturalLanguage
import Foundation

class TherpaistQuestions: ObservableObject {
    let sentiment = SentimentPrediction()
    @Published var question = "How are you doing today?"
    @Published var synthIsSpeaking = false
    private var isContinuation = false
    
    // constants
    let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0) 
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    let questionStarts = [
        "Hm... Ok, so tell me about your life",
        "Maybe your plans have something to do with this. Is that true?",
        "Ah... Tell me more",
        "I see... What makes you think this?",
        "Would you like to talk about your personal life?",
    ]
    
    
    
    let positiveQuestions = [
        "You seem quite positive, mind telling me what's been your highlights?",
        "You're seeming very happy, what's been up?"
    ]
    
    let positiveContinuations = [
        "Wow! That sound's great! Can you elaborate more on how ",
        "Excellent! Why is it that ",
    ]
    
    let negativeQuestions = [
        "Why the glum response? Why is it that ",
        "Oh no... Are you sure that ",
        "Oh no... Why is it that ",
        
    ]
    
    let negativeContinutations = [
        "Why the glum response? Why is it that "
    ]
    
    let questionContinuations = [
        "Why is it that ",
        "Can you elaborate more on how ",
        "Are you sure that ",
        "Why do you say ",
        "What do you mean by ",
    ]
    
    let textConversions = [
        "im": "i am",
        "i'm": "i am"
    ]
    
    private func returnQuestion(tokenizedString: String, isContinuation: Bool, previousQuestion: String) {
        if previousQuestion == "Hello, how are you doing?" {
            self.question = (self.questionContinuations.randomElement()!) + (tokenizedString)
            self.isContinuation = true
        } else if isContinuation {
            self.question = (
                self.questionStarts.randomElement()!)
            self.isContinuation  = false
        }else if !isContinuation {
            
            switch sentiment.predictFromString(label: tokenizedString) {
            case -3 ... -2:
                self.question = negativeContinutations.randomElement()! + tokenizedString
                self.isContinuation = true
            case 2...3:
                self.question = positiveContinuations.randomElement()! + tokenizedString
                self.isContinuation = true
                
            default:
                self.question = questionContinuations.randomElement()! + tokenizedString
                self.isContinuation = true
            }
            
            
            questionContinuations.randomElement()! + tokenizedString
        }
    }
    
    public func cleanText(text: String) -> String {
        var cleanedText = text
        var textArray = cleanedText.components(separatedBy: " ")
        
        for(conv1, conv2) in textConversions {
            if let index = textArray.firstIndex(of: conv1) {
                textArray[index] = conv2
            }
            
        }
        cleanedText = textArray.joined(separator: " ")
        print(cleanedText)
        return cleanedText
    }
    
    public func changeText(userReponse: String) {
        var cleanedText = cleanText(text: userReponse.lowercased())
        tagger.string = cleanedText
        let range = NSRange(location: 0, length: cleanedText.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (cleanedText as NSString).substring(with: tokenRange)
                print("\(word): \(tag.rawValue)")
                
                if tag.rawValue == "Pronoun" || tag.rawValue == "Verb" {
                    print(word.conjugate())
                    cleanedText = cleanedText.replacingOccurrences(of: word, with: word.conjugate())
                }
                
            }
        }
        print(cleanedText)
    }
    
    public func tokenize(for text: String) {
        let previousQuestion = self.question
        var input = cleanText(text: text.lowercased())
        var inputArray = input.components(separatedBy: " ")
        for (index, word) in inputArray.enumerated() {
            print("word: \(word), conjugated: \(word.conjugate())")
            inputArray[index] = word.conjugate()
        }
        input = inputArray.joined(separator: " ")
        input.append("?")
        
        returnQuestion(tokenizedString: input, isContinuation: self.isContinuation, previousQuestion: previousQuestion)
    }
}


