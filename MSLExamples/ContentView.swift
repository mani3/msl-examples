//
//  ContentView.swift
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var menuList = MenuList()

  var body: some View {
    NavigationView {
      List(menuList.menus) { menuin
        NavigationLink(destination: PictureView(converter: menu.converter)) {
          Text(menu.title)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          HStack {
            Text("MSL Examples").font(.headline)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
