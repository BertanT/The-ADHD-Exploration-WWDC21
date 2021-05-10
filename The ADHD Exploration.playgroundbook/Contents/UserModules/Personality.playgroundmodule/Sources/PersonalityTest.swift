import SwiftUI
import UIHelpers

// Custom errors to thow in case of PersonalityTest initialization failure
public enum QuestionError: Error {
    case insufficentOptionCount
    case answerWithPointIndexOutOfRange
}

// A custom data type for personality test questions

// Here are the rules for defining a value of PersonalityTestQuestion:
// * The questions are in the form of sentence completions
// * There must be a promt - or a sentence to complete
// * There must be at least two options
// * There must be one answer with point and its index on the options array must be specified
// * The question must be tied to a personality trait

// Here is an example:
// var  myQuestion = try! PersonalityTestQuestion(prompt: "I mostly spend my free time", options: ["By myself", "With my friends", indexOfAnswerWithPoint: 1, questionTrait: .extravesion]

// This method will currently return false as it isn't answered yet:
// myQuestion.answered() -> false

// Let's say the user prefers to spend time with their friends, this method will be called to set the answer:
// - The value "With my friends" has the index 1 -
// myQuestion.setAnswer(optionIndex: 1)

// Now that the question is answered and answer with the index of 1 is eligable for point, theese two methods will both return true:
// myQuestion.answered() -> true
// myQuestion.eligableForPoint() -> true

public struct PersonalityTestQuestion: Decodable {
    let prompt: String
    let options: [String]
    let indexOfAnswerWithPoint: Int
    let questionTrait: PersonalityTrait
    private(set) var userAnswerIndex: Int?
    
    // Check if the question was answered and return a boolean
    var answered: Bool {
        return userAnswerIndex != nil
    }
    
    // Check if the user answer is eligable for a point and return the result as a boolean
    var eligableForPoint: Bool {
        return userAnswerIndex == indexOfAnswerWithPoint
    }
    
    // Try to initilize publicly, throw an error when not conformed to the rules above
    public init(prompt: String, options: [String], indexOfAnswerWithPoint: Int, questionTrait: PersonalityTrait) throws {
        if options.count >= 2 {
            self.options = options
        }else {
            throw QuestionError.insufficentOptionCount
        }
        if options.indices.contains(indexOfAnswerWithPoint) {
            self.indexOfAnswerWithPoint = indexOfAnswerWithPoint
        }else {
            throw QuestionError.answerWithPointIndexOutOfRange
        }
        self.prompt = prompt
        self.questionTrait = questionTrait
    }
    
    // The method for setting the answer
    mutating func setAnswer(optionIndex: Int?) {
        // Check if the provded option index is in the range of available options.
        // If the index provided is nil, us the default value of 0 to allow the answer to be cleared. There is always an option with an index of zero since the struct wouldn't have initialized otherwise :)
        if (options.indices).contains(optionIndex ?? 0) {
            userAnswerIndex = optionIndex
        }
    }
}

// Custom errors to thow in case of PersonalityTest initialization failure
public enum PersonalityTestError: Error {
    case invalidQuestionArray
}

// A custom data type for the five factor personality test

// Here are the rules for defining a value of PersonalityTest
// * Each of the questions provided must also conform to the rules of defining a value of PersonalityTestQuestion
// * There must be at least 3 questions for each of the five factor personality scale (3 * 5)
// * The number of questions provided for each trait must be odd since we want to avoid a score of 50%
// * You can add a different number of questions for each trait

public struct PersonalityTest {
    // An array for storing questions
    var questions = [PersonalityTestQuestion]()
    
    // Try to initilize publicly, throw an error when not conformed to the rules above
    public init(questions: [PersonalityTestQuestion]) throws {
        for trait in PersonalityTrait.allCases {
            let traitQuestions = questions.filter {$0.questionTrait == trait}
            if traitQuestions.count >= 3, traitQuestions.count % 2 == 1 {
                self.questions.append(contentsOf: traitQuestions)
            }else {
                throw PersonalityTestError.invalidQuestionArray
            }
        }
        self.questions.shuffle()
    }
    
    // These methods are here for encapsulation ;)
    // Set the answer of question with the question index provided
    mutating public func answerQuestion(questionIndex: Int, optionIndex: Int?) {
        if (0..<questions.count).contains(questionIndex) {
            questions[questionIndex].setAnswer(optionIndex: optionIndex)
        }
    }
    
    // Clear anwers of all questions - Not used in this playground, but I'm still keeping it since it may come in handy later
    //      public mutating func clearAnswers() {
    //          for i in questions.indices {
    //              questions[i].setAnswer(optionIndex: nil)
    //          }
    //      }
    
    // This method calculates the score for each trait and returns a value of type Personality if all questions are answered. If not, it returns nil.
    func calculateResult() -> Personality? {
        if questions.allSatisfy({ $0.answered }) {
            // Decleare variables to keep count of points for each trait
            var opennessPoints = 0
            var conscientiousnessPoints = 0
            var extraversionPoints = 0
            var agreeablenessPoints = 0
            var neuroticismPoints = 0
            
            // A dictionary holding trait scores, to be used to initilize personality
            var scores = [ PersonalityTrait: Double]()
            
            // Repeating for each personlity trait
            for trait in PersonalityTrait.allCases {
                // Divide point eligable trait questions into the total number of trait questions to generate a score between 0 and 1
                // Put the score into the dictionary
                scores[trait] = Double (questions.filter { $0.eligableForPoint && $0.questionTrait == trait }.count) / Double(questions.filter { $0.questionTrait == trait }.count)
            }
            
            // Create and return a value of Personality using personality traits decleared above
            return Personality(traitScores: scores)
        }
        // Return nil if all questions aren't answered
        return nil
    }
}



