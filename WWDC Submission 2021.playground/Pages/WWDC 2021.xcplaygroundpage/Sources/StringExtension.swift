    
    import UIKit
    
    let conjugations = [
        "are": "am",
        "were": "was",
        "you": "i",
        "your": "my",
        "me": "you",
    ]
    

extension String {

    
    func conjugate() -> String {
        var result = "\(self)"
        
        // swap words (am -> are)
        for (conj1, conj2) in conjugations {
            if self == conj1 {
                return result.replacingOccurrences(of: conj1, with: conj2)
                break
            } else if self == conj2 {
                return result.replacingOccurrences(of: conj2, with: conj1)
                break
            } else {
                continue
            }
        }
        return result
    }
}
    extension Double {
        func returnEmoji() -> String {
            let sliderNumber = self
            
            if sliderNumber >= 0.75 {
                return "😃"
            } else if sliderNumber < 0.75 && sliderNumber > -0.75 {
                return ("😐")
            } else {
                return "😔"
            }
        }
    }
