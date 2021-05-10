import SwiftUI
import Personality

// A custom data type for advice, relative to traits and scores!
public struct RelativeAdvice: Decodable {
    // A dictionary that holds all the advice data, every piece of advice is tied to a trait and it's percentile score
    // Example -> [PersonalityTrait.extraversion: [PercentileRange.above50: "Advice for Extraverts!"] ]
    public let adviceStrings: [PersonalityTrait: [PercentileRange: String]]
    
    // A method that takes in a persoanlity trait and a score to return relevant advice. Takes care of unwrapping
    public func adviceDescription(forTrait trait: PersonalityTrait, forPerecntile percentile: PercentileRange) -> String {
        return adviceStrings[trait]?[percentile] ?? "Not Available :("
    }
}

// An Enum for PlaygroundResouurces initialization errors
public enum ResourceError: Error { case questionsFileNotFound, typeInformationFileNotFound }

// A class for storing playground resources: the personality test, advice, contibutors, citations, memoji filenames
public final class PlaygroundResources: ObservableObject {
    public let test: PersonalityTest
    public let adhdAdvice: RelativeAdvice 
    public let memojiContributors: [String]
    public let citaitons: [String]
    
    // Defining an array of Memoji Image filenames that are eligable for being selected randomly. To be eligable for random selection, the filename should start with "memojiR" and should have the extension "png"
    // This array does not hold the files itselves, only the names
    public let randomEligableMemojImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        .map { NSString(string: $0).lastPathComponent } 
        .filter { $0.contains("memojiR")}
        .shuffled()
    
    // The test is not stored on the JSON file, only the questions are. Defining a Coding Model that has an array of PersonalityTestQuestions instead of PersonalityTest
    private struct ResourcesModel: Decodable {
        let questions: [PersonalityTestQuestion]
        let adhdAdvice: RelativeAdvice
        let memojiContributors: [String]
        let citations: [String]
    }
    
    
    public init() throws {
        // Test questions, advice, citations and memoji contributors are stored inside a seperate JSON file for easier customization! Decoding and initializing it!
        // Check if the JSON file is is in the Playground "UserResources" directory. The file must be named: "PlaygroundResources.json".
        if let jsonURL = Bundle.main.url(forResource: "PlaygroundResources", withExtension: ".json") {
            // Try decoding the JSON according to ResourceModel struct above, the initilizer will throw if there's an error
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let decodedResources = try decoder.decode(ResourcesModel.self, from: jsonData)
            
            // Try initilizing the personality test parameter with the questions provided
            test = try PersonalityTest(questions: decodedResources.questions)
            
            // Initilize other parameters
            adhdAdvice = decodedResources.adhdAdvice
            memojiContributors = decodedResources.memojiContributors
            citaitons = decodedResources.citations
        }else {
            // Throw file not found error if PlaygroundResources.json isn't found
            throw ResourceError.questionsFileNotFound
        }
    }
    
    // Another handy method for getting a Memoji chosen randomly from random eligable Memojis!
    public func getRandomMemoji() -> UIImage {
        return UIImage(named: randomEligableMemojImageNames.randomElement()!) ?? UIImage()
    }
}

// A helper extension that can turn a string array to a bullet list string, used on the credits for listing people and citations
public extension Array where Element == String {
    public func getList() -> String {
        var list = ""
        for element in self {
            list += "\n• \(element)"
        }
        return list
    }
}


