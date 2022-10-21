//
//  Photos.swift
//  Flickr Client App
//
//  Created by Oğuzhan Erdem on 21.10.2022.
//

import Foundation

struct Photos:Codable {
    let page: Int?
    let pages: Int?
    let perpage:Int?
    let total:Int?
    let photo: [photo]?
}
