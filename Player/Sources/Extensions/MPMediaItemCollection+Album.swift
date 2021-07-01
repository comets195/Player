//
//  MPMediaItemCollection+Album.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import MediaPlayer

extension MPMediaItemCollection {
    func album() -> Album {
        let title = (self.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String) ?? Album.unknown
        let artist = (self.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String) ?? Album.unknown
        let artwork = self.value(forProperty: MPMediaItemPropertyArtwork) as? UIImage
        
        return Album(title: title, artist: artist, artwork: artwork)
    }
}
