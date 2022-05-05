//
//  model.swift
//  Decoder_assignment
//
//  Created by Consultant on 5/3/22.
//

import Foundation

struct Pokemon_Class{
    var damage_relations: Damage_Relations
    var game_indices: [Game_Index]
    var generation: basic_data
    var id: Int
    var move_damage_class: basic_data
    var moves: [basic_data]
    var name: String
    var pokemon: [Pokemon]
    
}

struct Damage_Relations{
    var damage_relations: [basic_data]
    var double_damage_to: [basic_data]
    var half_damage_from: [basic_data]
    var half_damage_to: [basic_data]
    var no_damage_from: [basic_data]
    var no_damage_to: [basic_data]
}

struct Game_Index{
    var game_index: Int
    var generation: basic_data
}

struct Pokemon{
    var pokemon: basic_data
    var slot: Int
}

struct basic_data {
    var name: String
    var url: String
}
