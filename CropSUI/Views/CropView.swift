import SwiftUI

struct CropView: View {
    var cropSize: CGSize
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    @StateObject private var viewModel = CropViewModel()
    @GestureState private var isInteracting: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            backgroundView
            cropImageView()
            actionButtons
        }
    }
}

// MARK: - Private Views

private extension CropView {
    
    // MARK: BackgroundView
    
    var backgroundView: some View {
        Color.black
            .ignoresSafeArea()
    }
    
    // MARK: ActionButtons
    
    var actionButtons: some View {
        VStack {
            Spacer()
            HStack(spacing: 20) {
                iconButton("xmark", .red) { dismiss() }
                iconButton("checkmark", .green) {
                    viewModel.generateSnapshot(
                        content: cropImageView(true),
                        size: cropSize,
                        completion: onCrop
                    )
                    dismiss()
                }
            }
        }
    }
    
    // MARK: IconButton
    
    func iconButton(
        _ systemImage: String,
        _ backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        CircularIconButton(
            systemImage: systemImage,
            backgroundColor: backgroundColor,
            action: action,
            size: 50
        )
    }
    
    // NARK: BorderView
    
    var borderView: some View {
        Image(ImageResource.borderImg)
            .resizable()
            .scaledToFit()
            .frame(width: cropSize.width, height: cropSize.height)
    }
    
    // MARK: CropImageView
    
    @ViewBuilder
    func cropImageView(_ hideBorder: Bool = false) -> some View {
        GeometryReader { geometry in
            if let image {
                imageConfiguration(image, in: geometry)
            }
        }
        .scaleEffect(viewModel.scale)
        .offset(viewModel.offset)
        .overlay { if !hideBorder { borderView } }
        .coordinateSpace(name: "CROPVIEW")
        .gesture(dragGesture)
        .gesture(magnificationGesture)
        .frame(width: cropSize.width, height: cropSize.height)
        .cornerRadius(16)
    }
    
    // MARK: ImageConfiguration
    
    func imageConfiguration(
        _ image: UIImage,
        in geometry: GeometryProxy
    ) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .overlay {
                GeometryReader { proxy in
                    Color.clear.onChange(of: isInteracting) { newValue in
                        handleInteraction(
                            proxy: proxy,
                            containerSize: geometry.size,
                            isInteracting: newValue
                        )
                    }
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
    }
    
    // MARK: DragGesture
    
    var dragGesture: some Gesture {
        DragGesture()
            .updating($isInteracting) { _, out, _ in out = true }
            .onChanged { viewModel.handleDragChange(translation: $0.translation) }
            .onEnded { _ in viewModel.handleDragEnd() }
    }
    
    // MARK: MagnificationGesture
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($isInteracting) { _, out, _ in out = true }
            .onChanged { viewModel.handleMagnificationChange(value: $0) }
            .onEnded { _ in viewModel.handleMagnificationEnd() }
    }
    
    // MARK: HandleInteraction
    
    func handleInteraction(
        proxy: GeometryProxy,
        containerSize: CGSize,
        isInteracting: Bool
    ) {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.handleBoundaryCheck(
                rect: proxy.frame(in: .named("CROPVIEW")),
                containerSize: containerSize
            )
        }
        
        if !isInteracting {
            viewModel.lastStoredOffset = viewModel.offset
        }
    }
}
