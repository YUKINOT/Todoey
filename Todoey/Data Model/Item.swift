//
//  Item.swift
//  Todoey
//
//  Created by 冨樫由城乃 on 2019/06/08.
//  Copyright © 2019 Yukino Togashi. All rights reserved.
//

import Foundation

class Item :Codable { //Encodable, Decodable と同じ意味
    var title: String = ""
    var done: Bool = false
    
}
