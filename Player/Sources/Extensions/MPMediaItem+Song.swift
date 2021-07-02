//
//  MPMediaItem+Song.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import MediaPlayer

extension MPMediaItem {
    func song() -> Song {
        let title = (self.value(forProperty: MPMediaItemPropertyTitle) as? String) ?? Song.unknown
        let url = (self.value(forProperty: MPMediaItemPropertyAssetURL) as? NSURL)
        let trackNumber = (self.value(forProperty: MPMediaItemPropertyAlbumTrackNumber) as? NSNumber) ?? 0
        return Song(title: title, url: url, trackNumber: trackNumber)
    }
    
    func collection() -> MPMediaItemCollection? {
        guard let albumTitle = self.albumTitle else { return nil }
        let query = MPMediaQuery(filterPredicates: Set([MPMediaPropertyPredicate(value: albumTitle,
                                                                            forProperty: MPMediaItemPropertyAlbumTitle,
                                                                            comparisonType: .equalTo)]))
        return query.collections?.first
    }
}
