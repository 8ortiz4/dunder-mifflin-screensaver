import AppKit
import ScreenSaver

class CustomScreenSaverView: ScreenSaverView {
    var myImage: NSImage?
    var imageRect: NSRect = .zero
    var deltaX: CGFloat = 0.5
    var deltaY: CGFloat = 0.5
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        if let imagePath = Bundle(for: CustomScreenSaverView.self).path(forResource: "dunder-mifflin", ofType: "png") {
            myImage = NSImage(contentsOfFile: imagePath)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimation() {
        super.startAnimation()
        
        if let image = myImage {
            let imageSize = image.size
            
            imageRect = NSRect(origin: NSPoint(x: bounds.midX - imageSize.width/2, y: bounds.midY - imageSize.height/2), size: imageSize)
            
            animateImage()
        }
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        if let image = myImage {
            image.draw(in: imageRect)
        }
    }
    
    func animateImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0167) {
            [weak self] in guard let self = self else {
                return
            }
            
            let boundsRect = self.bounds
            
            self.imageRect.origin.x += self.deltaX
            self.imageRect.origin.y += self.deltaY
            
            if self.imageRect.maxX >= boundsRect.maxX || self.imageRect.minX <= boundsRect.minX {
                self.deltaX = -self.deltaX
            }
            
            if self.imageRect.maxY >= boundsRect.maxY || self.imageRect.minY <= boundsRect.minY {
                self.deltaY = -self.deltaY
            }
            
            self.setNeedsDisplay(self.bounds)
            self.animateImage()
        }
    }
}
