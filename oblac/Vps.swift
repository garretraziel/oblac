//
//  Vps.swift
//  oblac
//
//  Created by Radka Mokrá on 24.10.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import Foundation

class Vps {
    var vpsName: String = ""
    var id: Int
    var distro: String
    var server: String
    init (name: String, id: Int, distro: String, server: String) {
        self.vpsName = name
        self.id = id
        self.distro = distro
        self.server = server
    }
    
}