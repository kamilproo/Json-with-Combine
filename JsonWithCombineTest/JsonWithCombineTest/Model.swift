//
//  Model.swift
//  PokemonList
//
//  Created by kamil on 13.07.2021.
//

import SwiftUI


struct Post: Decodable {
    let userId: Int
    var id: Int
    var title:String
    var body: String
}
    

struct Comment: Decodable {
    
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
}

struct Albums: Decodable  {
    let userID: Int
    let id: Int
    let title:String
}

struct Photos: Decodable  {
    let albumId: Int
    let id: Int
    let title:String
    let url: String
    let thumbnailUrl: String
}

struct Todos: Decodable  {
    let userID: Int
    let id: Int
    let title:String
    let completed: Bool
}

struct Users: Decodable  {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: [Address]
}

struct Address: Decodable  {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: [Geo]
}

struct Geo: Decodable  {
    let lag: Double
    let log: Double
}
