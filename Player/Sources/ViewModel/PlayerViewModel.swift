//
//  PlayerViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/02.
//

import Foundation
import MediaPlayer

typealias PlayerTray = (album: Album, song: Song)
protocol PlayerViewModelType {
    var input: PlayerViewModelInput { get }
    var output: PlayerViewModelOutput { get }
}

protocol PlayerViewModelInput {
    var insertAlbum: State<[Song]> { get }
    var playShuffle: State<Void> { get }
    var rewind: State<Void> { get }
    var fastFoward: State<Void> { get }
    var loop: State<Void> { get }
    var playSong: State<PlaySongTray> { get }
    var pause: State<Bool> { get }
}

protocol PlayerViewModelOutput {
    var selectedSong: State<PlayerTray> { get }
}

final class PlayerViewModel: PlayerViewModelType {
    struct Input: PlayerViewModelInput {
        var insertAlbum = State<[Song]>(nil)
        var playShuffle = State<Void>(nil)
        var rewind = State<Void>(nil)
        var fastFoward = State<Void>(nil)
        var loop = State<Void>(nil)
        var playSong = State<PlaySongTray>(nil)
        var pause = State<Bool>(nil)
    }
    
    struct Output: PlayerViewModelOutput {
        var selectedSong = State<PlayerTray>(nil)
    }
    
    var input: PlayerViewModelInput = Input()
    var output: PlayerViewModelOutput = Output()
    
    private var album: Album!
    private var songs: [Song]!
    private var currentPlaySongIndex: Int!
    private var player: AudioPlayerType = AudioPlayer()
    
    init() {
        bind()
    }
        
    private func bind() {
        input.playSong.bind { [weak self] item in
            guard let collection = item?.song?.collection() else { return }
            guard let album = item?.song?.collection()?.album() else { return }
            self?.currentPlaySongIndex = item?.row
            self?.songs = collection.items.map { $0.song() }
            
            guard let row = self?.currentPlaySongIndex else { return }
            guard let song = self?.songs[row] else { return }
            guard let url = song.url?.absoluteURL else { return }
            
            self?.output.selectedSong.value = PlayerTray(album: album, song: song)
            self?.player.play(at: url)
        }
        
        input.pause.bind { [weak self] isContinue in
            guard let isContinue = isContinue else { return }
            self?.player.pause(isContinue)
        }
    }
}
