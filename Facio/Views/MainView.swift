//
//  MainView.swift
//  Facio
//
//  Created by Chananchida Fuachai on 22/4/2564 BE.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
               DrawingView()
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Drawing")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
