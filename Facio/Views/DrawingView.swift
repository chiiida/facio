//
//  DrawingView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 22/4/2564 BE.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var canvas: PKCanvasView = PKCanvasView()
    @State var rendition: DrawingRendition?
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
        Image(systemName: "xmark")
            .aspectRatio(contentMode: .fit)
        }
    }
    
    var body: some View {
        CanvasView(canvas: $canvas, onSaved: self.saveDrawing)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: backButton,
                trailing:
                    HStack {
                        Button(action: { undoDrawing() }, label: {
                            Image(systemName: "arrow.uturn.backward")
                        })
                        Button(action: { clearCanvas() }, label: {
                            Image(systemName: "trash")
                        })
                    }
            )
    }
}

private extension DrawingView {
    func saveDrawing() {
        let image = canvas.drawing.image(
          from: canvas.bounds, scale: UIScreen.main.scale)
        let rendition = DrawingRendition(drawing: canvas.drawing, image: image)
        self.rendition = rendition
    }
    
    func clearCanvas() {
        self.canvas.drawing = PKDrawing()
    }
    
    func undoDrawing() {
        if let rendition = self.rendition {
            canvas.drawing = rendition.drawing
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
