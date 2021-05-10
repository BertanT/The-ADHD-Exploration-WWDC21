import PlaygroundSupport
import SwiftUI
import Personality

// This struct is an ObservableObject containg user data!
public final class UserData: ObservableObject {
    // PlaygroundKeyValueStore plus profile picture url keys assigned to constants... For easier debugging!
    let userNameKey = "userName"
    let userDidReadFactsKey = "userReadFacts"
    let userPersonalityKey = "userPersonality"
    private let profilePictureURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("profilePicture.png")
    
    // All the important data we need stored in theese published properties
    // The willSet property observers make sure the new values are saved to the PlaygroundKeyValue Store after our properties were assigned new values
    @Published public var name: String? {
        willSet {
            // If the new value is nil, remove the key from PlaygroundKeyValue store insead just of setting it to nil
            if let newName = newValue {
                PlaygroundKeyValueStore.current[userNameKey] = .string(newName)
            }else {
                PlaygroundKeyValueStore.current[userNameKey] = .none
            }
        }
    }
    @Published public var didReadFacts = false {
        willSet {
            PlaygroundKeyValueStore.current[userDidReadFactsKey] = .boolean(newValue)
        }
    }
    @Published public var personality: Personality? {
        willSet {
            if let newPersonality = newValue {
                let encoder = JSONEncoder()
                if let encodedPersonalityData = try? encoder.encode(newPersonality) {
                    PlaygroundKeyValueStore.current[userPersonalityKey] = .data(encodedPersonalityData)
                }
            }else {
                PlaygroundKeyValueStore.current[userPersonalityKey] = .none
            }
        }
    }
    
    // Save the newly set profile picture to the playground's documents directory in the sandbox.
    @Published public var profilePicture: UIImage? {
        willSet {
            // Make sure that the new value is not nil before saving. If it is nil, delete the profile picture.
            if let image = newValue {
                if let data = image.pngData() {
                    do {
                        try data.write(to: profilePictureURL)
                    }catch {
                        print("There was en error while saving the user's profile picture. Here is the debug description: \(error)")
                    }
                }else {
                    print("Cannot conver user profile picture to png data, the profile picture wasn't saved :(")
                }
            }else {
                // Only attempt deleting the saved profile picture if it existed in the first place
                if let _ = profilePicture {
                    do {
                        try FileManager.default.removeItem(at: profilePictureURL)
                    }catch {
                        print("Error deleting profile picture. Here's the debug description: \(error)")
                    }
                }
            }
        }
    }
    
    // Initializing publicly
    public init() {
        // Look for saved user name data in the Playground Key Value Store and initilize the userName property with it if found.
        if let keyValue = PlaygroundKeyValueStore.current[userNameKey],
           case .string(let savedUserName) = keyValue {
            name = savedUserName
        }
        
        // Look for saved user name data in the Playground Key Value Store and initilize the userName property with it if found.
        if let keyValue = PlaygroundKeyValueStore.current[userDidReadFactsKey],
           case .boolean(let didRead) = keyValue {
            didReadFacts = didRead
        }
        
        // Look for saved personality type data in the Playground Key Value Store and initilize the userPersonality property with it if found.
        // This requires decoding since Personality is a custom type
        if let keyValue = PlaygroundKeyValueStore.current[userPersonalityKey],
           case .data(let encodedPersonalityData) = keyValue {
            let decoder = JSONDecoder()
            if let savedPersonality = try? decoder.decode(Personality.self, from: encodedPersonalityData) {
                personality = savedPersonality
            }
        }
        
        // Look for a saved profile picture file and initilize the profilePicture property with it if found.
        if let savedProfilePictureData = try? Data(contentsOf: profilePictureURL) {
            if let image = UIImage(data: savedProfilePictureData) {
                profilePicture = image
            }else {
                print("An error occured while creting UIImage from saved profile picture file :(")
            }
        }
    }
    
    // Class method for reseting user data and stopping playground execution
    public func resetUserData() {
        name = nil
        profilePicture = nil
        PlaygroundKeyValueStore.current[userDidReadFactsKey] = .none
        personality = nil
        PlaygroundPage.current.finishExecution()
    }
}


