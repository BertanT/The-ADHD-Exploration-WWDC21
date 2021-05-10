import SwiftUI
import PhotosUI

// This is the UIViewControllerRepresentable for using the PHPickerViewController with SwiftUI.
// I think I found a bug wih this that is only present Swift Playgrounds running on macOS. I explained it with more detail towards the end of ProfileView - the switch case with the modal paameter - on the The ADHD Exploration's main code. Though it fails sometimes, It seems to work OK with a workaround. I will be filing a bug report.

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageChosen: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    public init(imageChosen: Binding<UIImage?>) {
        self._imageChosen = imageChosen
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        private let imagePicker: ImagePicker
        
        init(_ imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                let result = results[0]
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let e = error {
                            print("An unexpected error occured while loading the image. Here is the debug description: \(e)")
                        }else {
                            self.imagePicker.imageChosen = image as! UIImage
                        }
                    }
                }
            }
            imagePicker.presentationMode.wrappedValue.dismiss()
        }
    }
}


