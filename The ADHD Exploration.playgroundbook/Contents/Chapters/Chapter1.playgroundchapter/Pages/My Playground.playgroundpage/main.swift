import PlaygroundSupport
import SwiftUI

// Hi there!

// A full screen disclaimer warning about the playground
struct DisclaimerView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var userName: String
    let onAccepted: () -> Void
    var body: some View {
        GeometryReader { geoReader in
            // Centering the view is a must since we're using GeometryReader
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    RectanglePod()
                        .overlay(
                            VStack {
                                TitleWithDismissButton()
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .scaledToFit()
                                    .gradientBackground(gradient: .orangeGradient)
                                    .frame(width: geoReader.size.width / 8 )
                                    .padding()
                                Text("An Important Disclaimer")
                                    .largeRoundedFont(.title1)
                                    .gradientBackground(gradient: .orangeGradient)
                                    .padding(.top)
                                Text("It's great meeting you, \(userName.capitalized)! Before welcoming you into my playground, there is something crucial that you need to know. This playground was built only for education, experimentation, and most importantly, for fun! It is not a medical diagnosis nor a treatment tool. Test accuracy may also vary. If you have or think you have ADHD, speak to a medical professional to get proper help. Though the information here may be helpful, please take it with a grain of salt.")
                                    .multilineTextAlignment(.center)
                                    .largeRoundedFont(.title3)
                                    .allowsTightening(true)
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                    onAccepted()
                                }) {
                                    HStack {
                                        Text("I Understand")
                                        Image(systemName: "hand.thumbsup")
                                    }
                                }
                                .buttonStyle(GradientButton(gradient: .tealGradient))
                                .padding()
                            }.padding()
                        )
                        .frame(width: geoReader.size.width / 2, height: geoReader.size.height / 1.5, alignment: .center)
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

// The view that welcomes you when you launch the playground!
struct GreetingView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var userData = UserData()
    @ObservedObject private var resources: PlaygroundResources
    @State private var userName = ""
    @State private var showingDisclaimer = false
    @State private var navigationActive = false
    
    // Initialize the resources! - The JSON file's contents, saved user settings, Memojis
    init() {
        do {
            resources = try PlaygroundResources()
        }catch {
            // Stop execution if resources are missing
            fatalError("Thre was an error initializing necessary resources. Here is the debug description: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            // An invisible navigtion link connected to the profile view
            NavigationLink(
                destination: ProfileView()
                    .environmentObject(userData)
                    .environmentObject(resources), 
                isActive: $navigationActive) { EmptyView() }
            InclusiveGreeting(greetingMessage: "Welcome to the ADHD Exploration!", gradient: .sixColorGradient())
                .padding(.top)
            Text("We are all unique. So are our needs. This Playground will help you manage your ADHD, depending on your personality.")
                .multilineTextAlignment(.center)
                .largeRoundedFont(.title2)
            Spacer()
            // Iterating the Memojis!
            ImageIterator(imageNames: resources.randomEligableMemojImageNames)
                .frame(height: UIScreen.main.bounds.height / 2.5)
            Spacer()
            // A small piece of advice from me :)
            if colorScheme == .light {
                Text("Best enjoyed in dark mode - in my opinion :)")
                    .largeRoundedFont(.title2)
                    .padding()
            }
            HStack {
                Spacer()
                // Show a text field if no saved suername was found, and show a small greeting message if username was found. Both navigate to the profle view
                if let userName = userData.name {
                    Button(action: { navigationActive.toggle() }) {
                        HStack {
                            Text("Welcome back, \(userName.capitalized)! Click to see your profile")
                            Image(systemName: "chevron.right.circle")
                        }
                    }
                    .buttonStyle(GradientButton(gradient: .indigoGradient))
                    .padding()
                }else {
                    GradientTextField(text: $userName, placeholder: "Please enter your name", contentType: .name, submitButtonTitle: "Get Started!", graident: .indigoGradient, onSubmit: {
                        showingDisclaimer.toggle()
                    })
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingDisclaimer) {
            DisclaimerView(userName: $userName, onAccepted: {
                userData.name = userName
                navigationActive.toggle()
            })
        }
    }
}

// The Personality Test
struct TestView: View {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject private var resources: PlaygroundResources
    @Environment(\.presentationMode) private var presentationMode
    @State private var testCompletion: Float = 0
    var body: some View {
        GeometryReader { geoReader in
            VStack {
                ProgressView(value: testCompletion, total: 1)
                    .gradientBackground(gradient: .tealGradient)
                TitleWithDismissButton(title: "Time to Discover Yourself!", subtitle: "Complete the sentences based on yourself - please be honest for an accurate result :)")
                Spacer()
                RectanglePod()
                    .overlay(
                        PersonalityTestView(test: resources.test, testProgress: $testCompletion) { result in
                            userData.personality = result
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                    .frame(width: geoReader.size.width / 2, height: geoReader.size.height / 1.5)
                Spacer()
            }.navigationBarHidden(true)
        }
    }
}

// Primer info view that pops up when the user first run the playground - kind of like an onboarding screen. Can also be navigated to through the more menu
struct InformationView: View {
    var body: some View {
        VStack {
            TitleWithDismissButton(title: "Let's get Geeky!")
            HStack(spacing: 0) {
                Text("""
                            \tAttention deficit hyperactivity disorder (ADHD) is a neurodevelopmental disorder involving inattentiveness, hyperactivity and, problems with executive function and emotions. It's often diagnosed during childhood and related to genetics. Scientific origins of ADHD are considered the lectures of British Paediatrician Sir George Fredric Still in 1902, where he discussed “…an abnormal defect of moral control in children”. It was first defined in the revised DSM-II in 1968 as the hyperkinetic reaction of childhood. The definition of ADHD would not come until 1987 with the revised DSM-III.

                            \tThough individuals with ADHD sometimes have a hard time in everyday tasks, they are often exceptionally creative, passionate about what they love, have a bright personality, and a very unique, outside-of-the-box mind.
                            """)
                    .largeRoundedFont(.title3)
                    .allowsTightening(true)
                Spacer()
                VStack {
                    // A memoji representation of George Fredric Still
                    Image(uiImage: UIImage(imageLiteralResourceName: "memoji_georgeFredricStill"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 8)
                        .glow()
                    Text("George Fredric Still")
                        .largeRoundedFont(.headline)
                        .gradientBackground(gradient: .indigoGradient)
                }
            }.padding(.bottom)
            Text("""
                        \tThe simple personality test used here is based on the five-factor personality model, which splits personality into five key traits: openness, conscientiousness, extraversion, agreeableness and, neuroticism. Your scores on each trait help determine your overall preferences. For example, if you score higher than 50% in extraversion, chances are you are a talkative and outgoing person. Please remember that professional personality tests are much more complex and, accuracy may vary. 

                        \tPersonality traits often have an impact on ADHD symptoms. This playground aims to give the most relevant advice for each person, depending on their personality. Please also note that the advice here is mainly focused on adults ADHDers.
                 """)
                .largeRoundedFont(.title3)
                .allowsTightening(true)
            Spacer()
        }.padding(.horizontal, 25)
    }
}

// Credits! Pretty self explanatory :)
struct CreditsView: View {
    @EnvironmentObject private var resources: PlaygroundResources
    var body: some View {
        VStack {
            TitleWithDismissButton(title: "Credits", subtitle: "Made with love and passion. Behind the Mac.")
            GeometryReader { geoReader in
                VStack {
                    HStack {
                        RectanglePod()
                            .frame(width: geoReader.size.width / 2, height: geoReader.size.height / 2)
                            .overlay(
                                VStack {
                                    Text("Thanks!")
                                        .bold()
                                        .largeRoundedFont(.title1)
                                        .gradientBackground(gradient: .purpleGradient)
                                        .multilineTextAlignment(.leading)
                                    HStack {
                                        Text("The Majority of Memojis used here weren’t related to someone in particular; however, I thought adding some of my friends' Memojis would be pretty cool. Huge thanks to these friends for being super awesome and letting me use theirs in my Playground!\n" + resources.memojiContributors.getList())
                                            .largeRoundedFont(.title3)
                                        Spacer()
                                    }
                                    Spacer()
                                }.padding()
                            )
                        RectanglePod()
                            .frame(width: geoReader.size.width / 2, height: geoReader.size.height / 2)
                            .overlay(
                                VStack {
                                    Spacer()
                                    Text("""
                                    A Playground by Bertan Tarakçıoğlu. I hope you enjoyed using it as much as I had fun building it.

                                    A Playground built for WWDC, in my opinion, wouldn't be quite complete without a countdown. So here you go, and I wish you a great Dub Dub!
                                    """)
                                        .largeRoundedFont(.title3)
                                    Spacer()
                                    DubDubCountdown()
                                    Spacer()
                                }.padding()
                            )
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color(UIColor.systemGray5))
                        .shadow(radius: 5)
                        .frame(height: geoReader.size.height / 2)
                        .overlay(
                            VStack {
                                Text("Citations")
                                    .bold()
                                    .largeRoundedFont(.title1)
                                    .gradientBackground(gradient: .purpleGradient)
                                HStack {
                                    Text(resources.citaitons.getList())
                                        .largeRoundedFont(.title3)
                                    Spacer()
                                }
                                Spacer()
                            }.padding()
                        )
                    Spacer()
                }
            }.padding()
            Spacer()
        }
    }
}

// The user profile!
struct ProfileView: View {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject private var resources: PlaygroundResources
    @State private var showingResetAlert = false
    @State private var currentModal: Modal?
    
    // Multiple full screen covers aren’t supported below iOS/iPad OS 14.5, here is a quick fix for using one full screen cover with multiple views!
    enum Modal: Identifiable {
        case info, test, credits, imagePicker
        var id: Int { hashValue }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text("Here's Your Profile, \(userData.name!.capitalized)")
                    .bold()
                    .largeRoundedFont(.largeTitle)
                    .gradientBackground(gradient: .sixColorGradient())
                HStack {
                    Spacer()
                    // The more options menu! SF Symbols aren’t rendered in macOS, but still adding them for iPadOS optimization in the future.
                    Menu {
                        // Take or retake the test, it depends! :)
                        Button(action: { currentModal = .test }) {
                            Label(userData.personality == nil ? "Take the Test": "Retake the Test", systemImage: "pencil.circle")
                        }
                        // The poor info view that is now optional
                        Button(action: { currentModal = .info }) {
                            Label("Learn More", systemImage: "info.circle")
                        }
                        // Credits! Thanks to all my awesome friends for helping out with the Memojis!
                        Button(action: { currentModal = .credits }) {
                            Label("Show Credits", systemImage: "heart.circle")
                        }
                        // More options, theese are pretty self explanotory
                        Menu("Settings") {
                            Button(action: { currentModal = .imagePicker }) {
                                Label(userData.profilePicture == nil ? "Set Profile Picture" : "Change Profile Picture", systemImage: "person.crop.circle.badge.plus")
                            }.disabled(userData.personality == nil)
                            Button(action: { withAnimation { userData.profilePicture = nil } }) {
                                Label("Remove Profile Picture", systemImage: "person.crop.circle.badge.xmark")
                            }.disabled(userData.profilePicture == nil)
                            Button(action: { showingResetAlert.toggle() }) {
                                Label("Delete My Data", systemImage: "trash.cicrle")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .largeRoundedFont(.title1)
                            .gradientBackground(gradient: .indigoGradient)
                    }
                }.padding(.trailing)
            }.padding(.top)
            Spacer()
            
            if let userPersonality = userData.personality {
                GeometryReader { geoReader in
                    HStack {
                        VStack {
                            // The advice!
                            ForEach(Array(zip((1...5), PersonalityTrait.allCases)), id: \.0) { (index, trait) in
                                RectanglePod()
                                    .overlay(
                                        HStack {
                                            Text(index.description + ".")
                                                .bold()
                                                .font(.system(size: 65, weight: .regular, design: .rounded))
                                                .gradientBackground(gradient: .sixColorGradient(colorRange:  index - 1 ... index ))
                                            Text(resources.adhdAdvice.adviceDescription(forTrait: trait, forPerecntile: userPersonality.traitScorePercentile(for: trait)))
                                                .allowsTightening(true)
                                                .largeRoundedFont(.title3)
                                                .padding(.leading)
                                            Spacer()
                                        }.padding()
                                    )
                            }
                        }
                        VStack {
                            // Show the user a prompt to set a profile if they haven’t already; If they have, show them their profile picture
                            VStack {
                                if let profilePicture = userData.profilePicture {
                                    Image(uiImage: profilePicture)
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFit()
                                        .glow()
                                }else {
                                    // Chose a random Memoji from resources and dsiplay it as a profile picture preview
                                    Image(uiImage: resources.getRandomMemoji() )
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(UIColor.systemGray4))
                                    Text("It looks like you didn't choose a profile picture yet. Tip: Choose a Memoji sticker saved to photos for the best looks!")
                                        .multilineTextAlignment(.center)
                                        .largeRoundedFont(.headline)
                                        .padding()
                                    Button(action: { currentModal = .imagePicker }) {
                                        HStack {
                                            Text("Choose Now!")
                                            Image(systemName: "photo.on.rectangle.angled")
                                        }.largeRoundedFont(.headline)
                                    }
                                    .buttonStyle(GradientButton(gradient: .indigoGradient))
                                }
                            }
                            .padding()
                            .frame(height: geoReader.size.height / 2.5)
                            Spacer()
                            // Display the user's scores on each trait
                            VStack {
                                Text("Your Traits")
                                    .bold()
                                    .largeRoundedFont(.title1)
                                    .gradientBackground(gradient: .purpleGradient)
                                ForEach(Array(zip(PersonalityTrait.allCases, 0...4)), id: \.0) { (trait, index) in
                                    ProgressView(trait.rawValue.capitalized, value: userPersonality.traitScore(for: trait), total: 1)
                                        .largeRoundedFont(.title3)
                                        .gradientBackground(gradient: .sixColorGradient(colorRange: (index ... index + 1) ))
                                        .glow()
                                }.padding()
                            }
                            Spacer()
                        }
                        .frame(width: geoReader.size.width / 3, height: geoReader.size.height)
                        .background(RectanglePod())
                    }
                }.padding()
            }else {
                VStack {
                    Text("You didn't take the personality test yet.")
                        .largeRoundedFont(.title1)
                    Button(action: {
                        currentModal = .test
                    }) {
                        HStack {
                            Text("Take the test now!")
                            Image(systemName: "pencil")
                        }
                    }
                }.buttonStyle(GradientButton(gradient: .indigoGradient))
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showingResetAlert) {
            // An alert for preventing accidential data deletion, always good to have
            Alert(
                title: Text("Do you want to delete all your data?"),
                message: Text("All of your data on this Playground, including your personality test results, will be deleted and cannot be recovered. The playground will stop running after your data is erased."),
                primaryButton: .destructive(Text("Delete My Data")) { userData.resetUserData() },
                secondaryButton: .cancel()
            )
        }
        .fullScreenCover(item: $currentModal) { modal in
            switch modal {
            case .info:
                InformationView()
            case .test:
                EmptyView()
                TestView()
                    .environmentObject(userData)
                    .environmentObject(resources)
            case .credits:
                CreditsView()
                    .environmentObject(resources)
            case .imagePicker:
                // I think I found a bug where the mouse click seems to be registered slightly above where the mouse poiter acually is while using the PHPickerView. I am guessing this may also be the case with other UIViewControllerRepresentables since I faced the exact same issue after trying the UIImagePicker. A workaround I found that works most of the time is wrapping the view inside a GeometryReader. The workaround does not work if the picker is in a sheet instead of fullScreenCover though. I faced this issue on Swift Playgrounds 3.4.1 running on macOS 11.2.3, and was never able to regenerate it on the same version of Swift Playgrounds running on iPasOS 14.4.2. I will be filing a bug report to Apple.
                GeometryReader { _ in
                    ImagePicker(imageChosen: $userData.profilePicture)
                }
            }
        }
        // The automatic pop up of the InformationView on first run. The onAppear modifier was commented in my submission due to the 3 minute limit.
        .onAppear {
            if !userData.didReadFacts {
                currentModal = .info
                // Adding a five second delay before marking it as read to make sure the user didn't accidentally dismiss the full screen cover.
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    userData.didReadFacts = true
                }
                
            }
        }
    }
}

// The root navigation view neatly wrapped inside the root view :)
struct MainView: View {
    var body: some View {
        NavigationView {
            GreetingView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// Making sure that the playground is running on full screen, as the split sceen mode is way too small for a good experience with my playground
PlaygroundPage.current.wantsFullScreenLiveView = true

// Setting it all up, let's go!
PlaygroundPage.current.setLiveView(MainView())
