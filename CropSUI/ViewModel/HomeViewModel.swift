import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var isShowImagePicker: Bool = false
    @Published var selectetImage: UIImage?
    @Published var croppedImage: UIImage?
}
