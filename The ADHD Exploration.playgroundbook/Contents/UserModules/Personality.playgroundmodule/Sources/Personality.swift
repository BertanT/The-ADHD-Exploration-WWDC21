
// Creating an enum for all personality traits
public enum PersonalityTrait: String, CaseIterable, Codable { case openness, conscientiousness, extraversion, agreeableness, neuroticism }

// Creating an enum for percentile range, etiher above or below 50%
public enum PercentileRange: String, Codable { case below50, above50 }

// Creating a cutom data type to hold the MBTI type
public struct Personality: Codable {
    // A dictionary to hold trait scores. Scores are between 0 and 1
    // Example: [PersonalityTrait.openness: 0.67]
    private let traitScores: [PersonalityTrait: Double]
    
    // Initilizing
    public init(traitScores: [PersonalityTrait: Double]) {
        self.traitScores = traitScores
    }
    
    // A method to get score of the provided tarit
    public func traitScore(for trait: PersonalityTrait) -> Double {
        return traitScores[trait] ?? 0
    }
    
    // A method that calculates the percentile range of provided trait, either above or below 50%
    public func traitScorePercentile(for trait: PersonalityTrait) -> PercentileRange {
        if (traitScores[trait] ?? 0) > 0.5 {
            return  .above50
        }else {
            return .below50
        }
    }
}


