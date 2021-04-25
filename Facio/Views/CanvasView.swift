//
//  DrawingView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 22/4/2564 BE.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @State var toolPicker = PKToolPicker()
    
    let onSaved: () -> Void
    
    func makeUIView(context: Context) -> PKCanvasView  {
        canvas.tool = PKInkingTool(.pen, color: .gray, width: 10)
        showToolPicker()
        
        #if targetEnvironment(simulator)
            canvas.drawingPolicy = .anyInput
        #endif
        
        canvas.delegate = context.coordinator
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvas: $canvas, onSaved: onSaved)
    }
}

private extension CanvasView {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
}

class Coordinator: NSObject {
    var canvas: Binding<PKCanvasView>
    let onSaved: () -> Void

    init(canvas: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvas = canvas
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        if !canvas.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
