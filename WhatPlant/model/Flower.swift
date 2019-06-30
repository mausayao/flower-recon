//
//  Flower.swift
//  WhatPlant
//
//  Created by Maurício de Freitas Sayão on 30/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import Foundation

class Flower {
    let name: String
    let description: String
    let imageUrl: String
    
    init(name: String, description: String, imageUrl: String) {
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
    }
}
