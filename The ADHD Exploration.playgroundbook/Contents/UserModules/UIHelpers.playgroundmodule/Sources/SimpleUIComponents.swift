
import SwiftUI
import Combine

// Pre-configured rounded rectangle with shadow. Here for cleaner code and faster customization!
public struct RectanglePod: View {
    public init() { }
    public var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundColor(Color(UIColor.systemGray5))
    }
}

// A Title&subtitle view with a dismiss button. Here for cleaner code!
public struct TitleWithDismissButton: View {
    @Environment(\.presentationMode) private var presentationMode
    private let title: String?
    private let subtitle: String?
    private let gradient: Gradient
    
    public init(title: String? = nil, subtitle: String? = nil, gradient: Gradient = .purpleGradient) {
        self.title = title
        self.subtitle = subtitle
        self.gradient = gradient
    }
    
    public var body: some View {
        VStack {
            ZStack{
                if let t = title {
                    Text(t)
                        .bold()
                        .largeRoundedFont(.largeTitle)
                        .gradientBackground(gradient: .purpleGradient)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle")
                            .largeRoundedFont(.title1)
                    }.padding()
                }.buttonStyle(GradientButton(gradient: .redGradient))
            }
            if let sub = subtitle {
                Text(sub)
                    .multilineTextAlignment(.center)
                    .largeRoundedFont(.title2)
            }
        }
    }
}

// Pretty self explanatory :))
// A weaving hand emoji emoji that cycles between skin colors. #BlackLivesMatter
public struct InclusiveGreeting: View {
    @State private var currentHand = ""
    private var greetingMessage: String
    private let gradient: Gradient
    private let cycleDelay: Double
    private let hands = ["👋", "👋🏻", "👋🏼", "👋🏽", "👋🏾", "👋🏿"]
    // This timer will make sure hands will switch periodically
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public init(greetingMessage: String, gradient: Gradient, cycleDelay: Double = 3) {
        self.greetingMessage = greetingMessage
        self.gradient = gradient
        self.cycleDelay = cycleDelay
        timer = Timer.publish(every: cycleDelay, on: .main, in: .common).autoconnect()
    }
    
    public var body: some View {
        HStack {
            Text(greetingMessage)
                .bold()
                .largeRoundedFont(.largeTitle)
                .gradientBackground(gradient: gradient)
            Text(currentHand)
                .largeRoundedFont(.largeTitle)
                .glow()
                .transition(.opacity)
                .id(currentHand)
        }
        // Choose a random hand as soon as the view appears
        .onAppear {
            currentHand = hands.randomElement()!
        }
        // Switch to another weaving hand emoji when the timer fires, making sure it's a different one
        // Animation duration is equal to cycleDelay so that it can looks like a continuous cycle
        .onReceive(timer) { _ in
            withAnimation(.easeIn(duration: cycleDelay)) {
                currentHand = hands.filter { $0 != currentHand }.randomElement()!
            }
        }
    }
}

// My favourite part of my Playground :))
// This is used in the GreetingView to iterate over diferent Memojis
public struct ImageIterator: View {
    @State private var currentImageIndex = 0
    // Array containing image literal resource names!
    private let imageNames: [String]
    // This timer will make sure that Memojis iterate periodically
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public init(imageNames: [String], iterationInterval: Double = 1.5) {
        self.imageNames = imageNames
        timer = Timer.publish(every: iterationInterval, on: .main, in: .common).autoconnect()
    }
    
    public var body: some View {
        Image(uiImage: UIImage(imageLiteralResourceName: imageNames[currentImageIndex]))
            .resizable()
            .scaledToFit()
            .glow(radius: 10)
            .transition(.opacity)
            .id(currentImageIndex.description)
            // Switch to the next image on the array if there is one, switch back to the first one if there isn't
            .onReceive(timer) { _ in 
                if currentImageIndex < imageNames.endIndex - 1 {
                    withAnimation { currentImageIndex += 1 }
                }else {
                    withAnimation { currentImageIndex = 0 }
                }
            }
    }
}

// A Gradient text field that glows when editing, has a submit button, has white space filtering and a submit action closure!
public struct GradientTextField: View {
    @Binding private var text: String
    @State private var textValid = false
    @State private var isEditing = false
    private let placeholder: String
    private let contentType: UITextContentType?
    private let submitButtonTitle: String
    private let gradient: Gradient
    private let onSubmit: () -> Void
    
    public init(text: Binding<String>, placeholder: String = "", contentType: UITextContentType?, submitButtonTitle: String = "Submit", graident: Gradient, onSubmit: @escaping () -> Void) {
        self._text = text
        self.placeholder = placeholder
        self.contentType = contentType
        self.submitButtonTitle = submitButtonTitle
        self.gradient = graident
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(spacing: nil) {
            HStack {
                TextField(placeholder, text: $text
                ) { isEditing in
                    withAnimation { self.isEditing = isEditing }
                } onCommit: {
                    // After submitting the text, call the onSubmit closure if the text is valid, clear the text if not
                    if textValid {
                        onSubmit()
                    }else {
                        text = ""
                    }
                }
                .textContentType(contentType)
                .largeRoundedFont(.title2)
                Button(action: { onSubmit() }) {
                    HStack {
                        Text(submitButtonTitle)
                        Image(systemName: "chevron.right.circle")
                    }
                }.buttonStyle(GradientButton(gradient: gradient, disabled: !textValid))
                .disabled(!textValid)
            }
            Capsule()
                .frame(height: 4)
                .gradientBackground(gradient: .indigoGradient, effectRadius: isEditing ? 10 : 0)
        }
        // Filter whitespaces and set textValid ever time the input value changes
        .onChange(of: text) { _ in 
            if text.trimmingCharacters(in: .whitespaces).isEmpty {
                textValid = false
            }else  {
                textValid = true
            }
        }
    }
}

// Countdown to WWDC!
public struct DubDubCountdown: View {
    private let dubDubDate: Date
    private let gradient: Gradient
    
    public init(gradient: Gradient = .indigoGradient) {
        let dateString = "07/06/2021 10:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        formatter.timeZone = TimeZone(abbreviation: "PDT")
        dubDubDate = formatter.date(from: dateString) ?? Date()
        
        self.gradient = gradient
    }
    
    public var body: some View {
        (Text("See you in ") + Text(dubDubDate, style: .relative) + Text(" at WWDC!"))
            .largeRoundedFont(.largeTitle)
            .gradientBackground(gradient: gradient)
    }
}
