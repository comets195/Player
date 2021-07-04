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
    
    var album: Album? { get }
    var songs: [MPMediaItem]? { get }
}

protocol AlbumViewModelInput {
    var headerViewAlbum: State<Void> { get }
    var didSelectedSong: State<Int> { get }
    var playSong: State<Void> { get }
    var shuffledPlay: State<Void> { get }
}

final class AlbumViewModel: AlbumViewModelType {
    struct Input: AlbumViewModelInput {
        var headerViewAlbum = State<Void>(nil)
        var didSelectedSong = State<Int>(nil)
        var playSong = State<Void>(nil)
        var shuffledPlay = State<Void>(nil)
    }
    
    var input: AlbumViewModelInput = Input()
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
            self?.playSong(at: row)
        }
        
        input.playSong.bind { [weak self] _ in
            self?.playSong(at: 0)
        }
        
        input.shuffledPlay.bind { [weak self] _ in
            self?.playSong(at: 0)
            self?.player?.playShuffle.value = true
        }
    }
    
    private func playSong(at index: Int) {
        player?.insertAlbum.value = songs?.compactMap { $0.song() }
        player?.playSong.value = PlaySongTray(row: index, song: songs?[index])
    }
}
