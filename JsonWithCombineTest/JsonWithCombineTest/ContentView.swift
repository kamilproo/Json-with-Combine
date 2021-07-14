//
//  ContentView.swift
//  JsonWithCombineTest
//
//  Created by kamil on 14.07.2021.
//

import SwiftUI




struct ContentView: View {
    @ObservedObject var model = JsonPlaceHolderModelView()
    var body: some View {
        VStack {
            List(model.post, id: \.id) { post in
                Text(post.body)
                // -> withOut NavigationLink and other buttons, just make api combine testing fetching data)
            }.onAppear {
                self.model.fetchPost()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

