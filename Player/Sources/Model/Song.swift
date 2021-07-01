//
//  Song.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation

struct Song {
    static let unknown = "Unknown"
    
    let title: String
    let url: NSURL?
    let trackNumber: NSNumber
}
