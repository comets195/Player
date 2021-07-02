//
//  AlbumViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/02.
//

import Foundation
import MediaPlayer

typealias PlaySongTray = (row: Int, song: MPMediaItem?)
protocol AlbumViewModelType {
    var input: AlbumViewModelInput { get }
    var output: AlbumViewModelOutput { get }
    
    var album: Album? { get }
    var songs: [MPMediaItem]? { get }
}

protocol AlbumViewModelInput {
    var headerViewAlbum: State<Void> { get }
    var didSelectedSong: State<Int> { get }
}

protocol AlbumViewModelOutput {
    
}

final class AlbumViewModel: AlbumViewModelType {
    struct Input: AlbumViewModelInput {
        var headerViewAlbum = State<Void>(nil)
        var didSelectedSong = State<Int>(nil)
    }
    
    struct Output: AlbumViewModelOutput {
        
    }
    
    var input: AlbumViewModelInput = Input()
    var output: AlbumViewModelOutput = Output()
    var album: Album?
    var songs: [MPMediaItem]?
    
    private var player: PlayerViewModelInput?
    
    init(album: Album,
         songs: [MPMediaItem],
         playerInput: PlayerViewModelInput?) {
        self.album = album
        self.songs = songs
        self.player = playerInput
        bind()
    }
    
    private func bind() {
        input.didSelectedSong.bind { [weak self] row in
            guard let row = row else { return }
            self?.player?.playSong.value = PlaySongTray(row: row, song: self?.songs?[row])
        }
    }
}
