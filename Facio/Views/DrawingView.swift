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
    @Environment(\.undoManager) private var undoManager
    
    @State var canvas: PKCanvasView = PKCanvasView()
    @State var rendition: DrawingRendition?
    @State var drawingImage: UIImage?
    @Binding var pngImage: UIImage?
    
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
                .navigationBarItems(leading: backButton)
            HStack{
                Button(action: { undoDrawing() }, label: {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "arrow.uturn.backward")
                            .foregroundColor(.white)
                            .font(Font.system(size: 20).bold())
                    }
                })
                .offset(y:-90)
                Button(action: { redoDrawing() }, label: {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "arrow.uturn.forward")
                            .foregroundColor(.white)
                            .font(Font.system(size: 20).bold())
                    }
                })
                .offset(y:-90)
                Button(action: { getPngImage() }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.yellow)
                            .frame(width: 120, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        HStack{
                            Image(systemName: "arrow.down.to.line")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .foregroundColor(.white)
                                .font(Font.system(size: 40) .bold())
                            Text("Save")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                })
                .offset(y:-90)
                Button(action: { clearCanvas() }, label: {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(Font.system(size: 20).bold())
                    }
                })
                .offset(y:-90)
            }
                
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
        undoManager?.undo()
    }
    
    func redoDrawing() {
        undoManager?.redo()
    }
    
    func getPngImage() {
        drawingImage = canvas.drawing.image(
            from: canvas.bounds, scale: UIScreen.main.scale)
        
        let pngImage = UIImage(data: drawingImage!.pngData()!)
        
//        UIImageWriteToSavedPhotosAlbum(pngImage!, nil, nil, nil)
        self.pngImage = pngImage!
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DrawingViewPreviewContainer : View {
    @State var image: UIImage?

     var body: some View {
        DrawingView(pngImage: $image)
     }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingViewPreviewContainer()
    }
}
