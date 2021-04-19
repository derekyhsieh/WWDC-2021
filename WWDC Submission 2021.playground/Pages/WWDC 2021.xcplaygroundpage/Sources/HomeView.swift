import SwiftUI
import AVFoundation

public struct HomeView: View {
    public init() {}
    public var synthesizer = AVSpeechSynthesizer()
    @StateObject var sentimentPrediction = SentimentPrediction()
    @ObservedObject var therapistQuestions = TherpaistQuestions()
    @State var sentimentArray = [String]()
    @State var text = ""
    @State var posNegDoubleAverageArray: [Double] = []
    @State var showText = true
    @State var userInput: String = ""
    @State private var phase = 0.0
    @State private var strength = 50.0
    @State private var sentimentSlider: Double = 0.0
    //      @State private var synthIsSpeaking = false
    @State private var showTherapistScreen = false
    @State private var showStartText = false
    @State private var showWave = true
    @State private var showDetailsView = false
    @State private var startCircleAnimation = false
    @State private var showCircle = true
    @State private var questionCounter = 0
    @ObservedObject var pieChartViewModel = PieChartViewModel()
    @State private var showWelcomeScreen = false
    
    public var body: some View {
        if showTherapistScreen { 
            
            if showDetailsView {
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Text("Overall")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            
                            
                            Circle()
                                .trim(from: 0.0, to: startCircleAnimation ? 1 : 0)
                                .rotation(.degrees(270))
                                .stroke(Color.white,lineWidth: 4)
                                .opacity(showCircle ? 1 : 0)
                                .frame(width: 150, height: 150)
                                .animation(.easeInOut)
                                
                                .overlay(
                                    Text("\(sentimentSlider.returnEmoji())")
                                        .font(.system(size: 75))
                                )
                        }
                        .padding(60)
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 0) {
                            Text("Breakdown of Feelings")
                                .font(.system(size: 45, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.bottom)
                            
                            Text("click portions of the pie chart to get percentages, tap again to deselect")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                        }
                        
                        
                        PieChart(viewModel: pieChartViewModel)
                            .frame(width: 400, height: 400)
                        
                        Spacer()
                    }
                    .padding(.vertical, 50)
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } else {
                
            
            ZStack(alignment: .bottom ) {
                Color.darkEnd
                
                VStack(spacing: 0) {
                    
                    if !showDetailsView {
                        BarSlider(slideNumber: $sentimentSlider)
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 30)
                            .animation(.linear)
                    }
                    
                    
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text(therapistQuestions.question)
                            .foregroundColor(.white)
                            .font(.system(size: 60, design: .rounded))
                            .bold()
                            .padding(.top)
                            .padding()
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                        
                        ZStack {
                            ForEach(0..<3) {
                                i in
                                Wave(strength: strength, frequency: 25, phase: phase) // phase: phase
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(Double(i)/3), Color.purple.opacity(Double(i)/3)]), startPoint: .leading, endPoint: .trailing), lineWidth: 5)
                                    .offset(y: CGFloat(i) * 10)
                                    .frame(maxWidth: 400)
                            }
                        }
                        .frame(height: 150)
                        .opacity(showWave ? 1 : 0)
                    }
                    .padding()
                    
                    
                    
                    
                    
                    Spacer(minLength: 0)
                    
                    
                }
                HStack {
                    CustomTextField(text: $userInput)
                    Button(action: {
                        if userInput != "" {
                            // speak text
                            
                            
                            
                            if questionCounter > 6 {
                                
                                therapistQuestions.tokenize(for: userInput.lowercased())
                                
                                posNegDoubleAverageArray.append(Double(sentimentPrediction.predictFromString(label: userInput)))
                                
                                sentimentSlider = Double(posNegDoubleAverageArray.reduce(0, +))/Double(posNegDoubleAverageArray.count)
                                print(sentimentSlider)
                                sentimentArray.append(                            sentimentPrediction.predictFeelingFromString(label: userInput))
                                
                                pieChartViewModel.updatePercantages(sentimentArray: self.sentimentArray)
                                
                                print("showing deatils view")
                                withAnimation(.spring()) {
                                    showDetailsView = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        startCircleAnimation = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            showCircle = false
                                        }
                                        
                                    }
                                }
                            }
                            else {
                                questionCounter += 1
                                print("counter went up one")
                                withAnimation(Animation.linear) {
                                    self.showWave = true
                                }
                                print("phase: \(phase)")
                                
                                
                                therapistQuestions.tokenize(for: userInput.lowercased())
                                
                                posNegDoubleAverageArray.append(Double(sentimentPrediction.predictFromString(label: userInput)))
                                
                                sentimentSlider = Double(posNegDoubleAverageArray.reduce(0, +))/Double(posNegDoubleAverageArray.count)
                                print(sentimentSlider)
                                sentimentArray.append(                            sentimentPrediction.predictFeelingFromString(label: userInput))
                                
                                
                                
                                let speech = AVSpeechUtterance(string: therapistQuestions.question)
                                speech.voice = AVSpeechSynthesisVoice(language: "en-US")
                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(speech)
                                let words = therapistQuestions.question.split { !$0.isLetter }
                                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(210 * words.count)) {
                                    withAnimation(.linear(duration: 1)) {
                                        self.showWave = false
                                    }
                                }
                                
                                userInput = ""
                                
                            }
                            
                            
                            
                        }
                        
                    }) {
                        FinishedButton()
                            .opacity(userInput == "" ? 0.6 : 1)
                    }
                    
                }
                .padding()
                .padding(.bottom)
                .padding(.horizontal)
                

                
                
                
            }
            
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.phase = .pi * 3.5
                }
                
                let speech = AVSpeechUtterance(string: therapistQuestions.question)
                speech.voice = AVSpeechSynthesisVoice(language: "en-US")
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(speech)
                let words = therapistQuestions.question.split { !$0.isLetter }
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(210 * words.count)) {
                    withAnimation(.linear(duration: 1)) {
                        self.showWave = false
                    }
                }
                
                
            }
            .opacity(showTherapistScreen ? 1 : 0)
        }
        }
        else {
            
            if !showWelcomeScreen {
                ZStack {
                    
                    Color.darkEnd
                    
                    Text("Tap Anywhere To Begin")
                        .font(.system(size: 50, design: .rounded))
                        .bold()
                        .opacity(showStartText ? 1 : 0)
                        .onTapGesture {
                            withAnimation {
                                showWelcomeScreen = true
                            }
                        }
                }
                .onTapGesture {
                    withAnimation {
                        showWelcomeScreen = true
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.linear(duration: 2.0)) {
                            showStartText = true
                        }
                    }
                    
                    
                }
            } else {
                ZStack {
                    
                    Color.darkEnd
                    
                    Text("Hi, my name is Galaxy, your personal therapist for today")
                        .font(.system(size: 50, design: .rounded))
                        .bold()
                        .multilineTextAlignment(.center)
                        .opacity(showStartText ? 1 : 0)
                    
                }
                .onAppear {
                    print("speaking")
                    let speech = AVSpeechUtterance(string: "Hi, my name is Galaxy, your personal therapist for today")
                    speech.voice = AVSpeechSynthesisVoice(language: "en-US")
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(speech)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        withAnimation {
                            showTherapistScreen = true
                        }
                    }
                }
            }
            
            
        }
        
    }
}




