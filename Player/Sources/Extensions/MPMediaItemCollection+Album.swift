//
//  MPMediaItemCollection+Album.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import MediaPlayer

extension MPMediaItemCollection {
    func album() -> Album {
        let title = self.items.first?.albumTitle ?? Album.unknown
        let artist = self.items.first?.artist ?? Album.unknown
        let artwork = self.items.first?.artwork?.image(at: CGSize(width: 300, height: 300))
        
        return Album(title: title, artist: artist, artwork: artwork)
    }
}
