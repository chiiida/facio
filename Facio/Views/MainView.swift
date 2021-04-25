//
//  MainView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 22/4/2564 BE.
//

import SwiftUI

struct MainView: View {
    @State var showFaceMesh: Bool = false
    @State var image: Image?
    @State private var showingImagePicker = false
    @State var inputImage: UIImage?
        
    var body: some View {
        NavigationView {
            ZStack {
                ARViewIndicator(showFaceMesh: $showFaceMesh, inputImage: $inputImage)
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.size.height, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        HStack(spacing: 15) {
                            Button(action: { self.showingImagePicker.toggle() }, label: {
                                VStack {
                                    Image(systemName: "photo")
                                    Text("Image")
                                }
                            })
                            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                            }
                            NavigationLink(destination: DrawingView().preferredColorScheme(.light)) {
                                VStack {
                                    Image(systemName: "square.and.pencil")
                                    Text("Drawing")
                                }
                                .accentColor(.black)
                            }
                            Circle()
                                .strokeBorder(THEME_YELLOW,lineWidth: 8)
                                .background(Circle().foregroundColor(Color.white))
                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            VStack {
                                Image(systemName: "text.cursor")
                                Text("Text")
                            }
                            .accentColor(.black)
                            VStack {
                                Image(systemName: "square.and.pencil")
                                Text("Beauty")
                            }
                            .accentColor(.black)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
//    var body: some View {
//        TabView {
//            NavigationView {
//               DrawingView()
//            }
//            .tabItem {
//                Image(systemName: "square.and.pencil")
//                Text("Drawing")
//            }
//        }
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
