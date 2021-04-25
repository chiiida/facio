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
    @State var image: UIImage?
    
    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
        Image(systemName: "xmark")
            .aspectRatio(contentMode: .fit)
        }
    }
    
    var body: some View {
        VStack {
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
            Button(action: { getPngImage() }, label: {
                ZStack {
                    Circle()
                        .strokeBorder(THEME_YELLOW,lineWidth: 5)
                        .background(Circle().foregroundColor(Color.white))
                        .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Image(systemName: "checkmark")
                }
            })
        }
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
    
    func getPngImage() {
        image = canvas.drawing.image(
            from: canvas.bounds, scale: UIScreen.main.scale)
        
        let pngImage = UIImage(data: image!.pngData()!)
        
        UIImageWriteToSavedPhotosAlbum(pngImage!, nil, nil, nil)
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
