import SwiftUI
import PhotosUI

// MARK: View Extension

extension View {
    
    @ViewBuilder
    func cropImagePicker(
        isShowImagePicker: Binding<Bool>,
        croppedImage: Binding<UIImage?>
    ) -> some View {
        CustomImagePicker(
            isShowImagePicker: isShowImagePicker,
            croppedImage: croppedImage) {
                self
            }
    }
    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    @State private var selectedImage: UIImage?
    @State private var isShowCropView: Bool = false
    
    @Binding var isShowImagePicker: Bool
    @Binding var croppedImage: UIImage?
    
    let cropSize = CGSize(width: 330, height: 190)
    
    var content: Content
    
    init(
        isShowImagePicker: Binding<Bool>,
        croppedImage: Binding<UIImage?>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
        self._isShowImagePicker = isShowImagePicker
        self._croppedImage = croppedImage
    }
    
    var body: some View {
        content
            .onChange(of: selectedImage) { newImage in
                if selectedImage != nil {
                    isShowImagePicker = false
                    isShowCropView.toggle()
                }
            }
            .sheet(isPresented: $isShowImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .fullScreenCover(isPresented: $isShowCropView, onDismiss: {
                selectedImage = nil
            }) {
                CropView(cropSize: cropSize, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
