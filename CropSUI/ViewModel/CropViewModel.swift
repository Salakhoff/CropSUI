import SwiftUI

@MainActor
final class CropViewModel: ObservableObject {
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    @Published var offset: CGSize = .zero
    @Published var lastStoredOffset: CGSize = .zero

    // MARK: Snapshot Generation
    
    func generateSnapshot<T: View>(
        content: T,
        size: CGSize,
        completion: @escaping (UIImage?, Bool) -> Void
    ) {
        Task {
            let renderer = ImageRenderer(
                content: content,
                size: size
            )
            let image = renderer.uiImage
            
            DispatchQueue.main.async {
                completion(image, true)
            }
        }
    }

    // MARK: Interaction Handlers
    
    func handleDragChange(translation: CGSize) {
        offset = CGSize(
            width: translation.width + lastStoredOffset.width,
            height: translation.height + lastStoredOffset.height
        )
    }
    
    func handleDragEnd() {
        lastStoredOffset = offset
    }

    func handleMagnificationChange(value: CGFloat) {
        let newScale = value + lastScale
        scale = max(newScale, 1)
    }

    func handleMagnificationEnd() {
        if scale < 1 {
            scale = 1
            lastScale = 0
        } else {
            lastScale = scale - 1
        }
    }
    
    // MARK: - Boundary Checking
    
    func handleBoundaryCheck(rect: CGRect, containerSize: CGSize) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if rect.minX > 0 {
                offset.width -= rect.minX
            }
            
            if rect.minY > 0 {
                offset.height -= rect.minY
            }
            
            if rect.maxX < containerSize.width {
                offset.width += (containerSize.width - rect.maxX)
            }
            
            if rect.maxY < containerSize.height {
                offset.height += (containerSize.height - rect.maxY)
            }
        }
    }
}
