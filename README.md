# CropView for SwiftUI

`CropView` is a customizable image cropping component built with **SwiftUI** and designed to work on **iOS 15** and above. It integrates seamlessly into any SwiftUI-based project, providing an intuitive interface for dragging, scaling, and cropping images.

## 📱 Requirements

- **iOS 15** or later
- **SwiftUI** for building the interface

## 🔧 Key Features

- **Image Cropping**: Allows users to drag and scale images with real-time visual feedback.
- **Gesture Support**: Uses `DragGesture` and `MagnificationGesture` for interactive image manipulation.
- **Smooth Animations**: Provides smooth animations when adjusting the image position and enforcing boundary constraints.
- **Boundary Enforcement**: Automatically ensures the image stays within the cropping bounds.
- **Easy Integration**: Simple to integrate into existing SwiftUI projects and customizable for various use cases.

## 🚀 How to Use

1. Import the component into your project.
2. Create an instance of `CropView` and pass in the image you want to crop, along with a completion handler:

```swift
struct ContentView: View {
    @State private var croppedImage: UIImage? = nil

    var body: some View {
        CropView(image: UIImage(named: "example")) { image, success in
            if success, let croppedImage = image {
                // Handle the cropped image
                self.croppedImage = croppedImage
            }
        }
    }
}


![Simulator Screen Recording - iPhone X - 2024-10-11 at 17 18 57](https://github.com/user-attachments/assets/7bc3cb17-79d0-4297-9876-4f3ca4d759d8)
