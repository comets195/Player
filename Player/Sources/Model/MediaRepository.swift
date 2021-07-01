//
//  MediaRepository.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation
import MediaPlayer

protocol MediaRepositoryType {
    func requestMedia() -> [MPMediaItemCollection]?
}

struct MediaRepository: MediaRepositoryType {
    func requestMedia() -> [MPMediaItemCollection]? {
        MPMediaQuery.albums().collections
    }
}
