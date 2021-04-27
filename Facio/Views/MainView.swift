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
//                    Rectangle()
//                        .frame(width: UIScreen.main.bounds.size.height, height: 80, alignment: .top)
//                        .foregroundColor(.yellow)
                    
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.size.height, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        HStack(spacing: 15) {
                            Button(action: { self.showingImagePicker.toggle() }, label: {
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 2)
                                    Text("Image")
                                        .font(.system(size: 12, weight: .bold, design: .default))
                                        .foregroundColor(.black)
                                }
                            })
                            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                            }
                            NavigationLink(destination: DrawingView().preferredColorScheme(.light)) {
                                VStack {
                                    Image(systemName: "scribble")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 2)
                                    Text("Drawing")
                                        .font(.system(size: 12, weight: .bold, design: .default))
                                        .foregroundColor(.black)
                                }
                                .accentColor(.black)
                            }
                            Circle()
//                                .strokeBorder(
//                                    LinearGradient(gradient: Gradient(colors: [.yellow, .pink]), startPoint: .top, endPoint: .bottom),lineWidth: 8)
                                .strokeBorder(Color.yellow,lineWidth: 6)
                                .background(Circle().foregroundColor(Color.yellow).frame(width: 60, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                                .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                            
                            VStack {
                                Image(systemName: "textformat.alt")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 2)
                                Text("Text")
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                            .accentColor(.black)
                            VStack {
                                Image(systemName: "wand.and.stars.inverse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .padding(.bottom, 2)
                                Text("Beauty")
                                    .font(.system(size: 12, weight: .bold, design: .default))
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
