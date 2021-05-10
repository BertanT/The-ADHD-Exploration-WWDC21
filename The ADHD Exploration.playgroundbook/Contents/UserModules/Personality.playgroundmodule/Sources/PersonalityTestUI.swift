
import SwiftUI
import UIHelpers

// A view containing a button for question options
fileprivate struct QuestionOptionButton: View {
    let text: String
    var selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: { action() } ) {
            HStack {
                Text(text)
                Spacer()
                // Show a checkmark if slsected, an empty circle if not
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(GradientButton(gradient: .purpleGradient))
            .foregroundColor(.white)
            .largeRoundedFont(.title3)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .gradientBackground(gradient: .purpleGradient)
            )
        }
    }
}

// A view for personality test questions
fileprivate struct QuestionView: View {
    @Binding var question: PersonalityTestQuestion
    var body: some View {
        VStack {
            // The prompt plus a blank text line :)
            Text(question.prompt + "  __________")
                .bold()
                .largeRoundedFont(.title1)
                .multilineTextAlignment(.center)
                .gradientBackground(gradient: .purpleGradient)
                .padding(.bottom)
            // Add a QuestionOptionButton for each option in the question provided
            ForEach(question.options.indices, id: \.self) { answerIndex in
                QuestionOptionButton(text: question.options[answerIndex], selected: question.userAnswerIndex == answerIndex, action: {
                    withAnimation {
                        question.setAnswer(optionIndex: answerIndex)
                    }
                }).padding(.horizontal)
            }
        }
    }
}

// A view for a complete personality test
public struct PersonalityTestView: View {
    @Binding var testProgress: Float
    @State private var test: PersonalityTest
    let onTestFinished: (_ result: Personality) -> Void
    
    // The current question and page index. Property observer keeps track of test progress every time the index changes
    @State private var currentQuestionIndex = 0 {
        didSet { updateProgress() }
    }
    
    // Computed properties to check if here are any previous or next questions.
    private var previousQuestionExists: Bool {
        return currentQuestionIndex > 0
    }
    private var nextQuestionExists: Bool {
        return currentQuestionIndex < test.questions.count - 1
    }
    
    public init(test: PersonalityTest, testProgress: Binding<Float>, onTestFinished: @escaping (_ result: Personality) -> Void) {
        self._testProgress = testProgress
        self._test = State(initialValue: test)
        self.onTestFinished = onTestFinished
        // Update the test progress after initializing all parameters
        updateProgress()
    }
    
    public var body: some View {
        TabView(selection: $currentQuestionIndex) {
            ForEach(test.questions.indices, id: \.self) { questionIndex in
                VStack {
                    Spacer()
                    QuestionView(question: $test.questions[questionIndex])
                    Spacer()
                    HStack {
                        // Show the previous button if there is a previous question
                        if previousQuestionExists {
                            Button(action: {
                                withAnimation { currentQuestionIndex -= 1 }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Previous")
                                }
                            }.buttonStyle(GradientButton(gradient: .indigoGradient))
                        }
                        
                        Spacer()
                        Button(action: {
                            // Navigate to next question if it exists, finish the test if not
                            if nextQuestionExists {
                                withAnimation { currentQuestionIndex += 1 }
                            }else {
                                // When the finish test button is pressed, all questions must have been answered. It is safe to force unwrap here!
                                onTestFinished(test.calculateResult()!)
                                
                            }
                        }) {
                            HStack {
                                // Show a next label if there is a next question, show a finish button if not
                                Text(nextQuestionExists ? "Next" : "Finish Test")
                                Image(systemName: nextQuestionExists ? "arrow.right" : "checkmark")
                            }
                        }
                        .buttonStyle(GradientButton(gradient: .tealGradient, disabled: !test.questions[questionIndex].answered))
                        .disabled(!test.questions[questionIndex].answered)
                    }.padding()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        // Using kind of a hack here ;)
        // Disabling scroll on all scroll views to prevent the user from swiping between questions. It's reenabled after the view disappears
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
        .onDisappear {
            UIScrollView.appearance().isScrollEnabled = true
        }
    }
    
    // A method for calculating the test progress
    private func updateProgress() {
        testProgress = Float(currentQuestionIndex + 1) / Float(test.questions.count)
    }
}


