import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.croppedImage != nil {
                    Image(uiImage: viewModel.croppedImage!)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No Image is Selected")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                            .foregroundStyle(.black)
                    }
                }
            }
            .cropImagePicker(
                isShowImagePicker: $viewModel.isShowImagePicker,
                croppedImage: $viewModel.croppedImage
            )
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    HomeView()
}
