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
    var playShuffle: State<Bool> { get }
    var rewind: State<Void> { get }
    var fastFoward: State<Void> { get }
    var repeatAlbum: State<Bool> { get }
    var playSong: State<PlaySongTray> { get }
    var pause: State<Bool> { get }
}

protocol PlayerViewModelOutput {
    var stopPlayer: State<Void> { get }
    var selectedSong: State<PlayerTray> { get }
    var currentTime: State<String> { get }
    var durationTime: State<String> { get }
    var progressRatio: State<Float> { get }
}

final class PlayerViewModel: PlayerViewModelType {
    struct Input: PlayerViewModelInput {
        var insertAlbum = State<[Song]>(nil)
        var playShuffle = State<Bool>(nil)
        var rewind = State<Void>(nil)
        var fastFoward = State<Void>(nil)
        var repeatAlbum = State<Bool>(nil)
        var playSong = State<PlaySongTray>(nil)
        var pause = State<Bool>(nil)
    }
    
    struct Output: PlayerViewModelOutput {
        var stopPlayer = State<Void>(nil)
        var selectedSong = State<PlayerTray>(nil)
        var currentTime = State<String>(nil)
        var durationTime = State<String>(nil)
        var progressRatio = State<Float>(nil)
    }
    
    var input: PlayerViewModelInput = Input()
    var output: PlayerViewModelOutput = Output()
    
    private var album: Album!
    private var songs: [Song]!
    private var isRepeated: Bool = false
    private var playedSongIndex: Set<Int> = []
    private var currentPlayingSongIndex: Int!
    private var player: AudioPlayerType = AudioPlayer()
    
    init() {
        bind()
    }
        
    private func bind() {
        input.playSong.bind { [weak self] item in
            guard let self = self else { return }
            guard let album = item?.song?.collection()?.album() else { return }
            self.album = album
            self.currentPlayingSongIndex = item?.row
            self.playSong(row: self.currentPlayingSongIndex)
        }
        
        input.insertAlbum.bind { [weak self] songs in
            self?.songs = songs
        }
        
        input.repeatAlbum.bind { [weak self] isRepeated in
            self?.isRepeated = isRepeated ?? false
        }
        
        input.pause.bind { [weak self] isContinue in
            guard let isContinue = isContinue else { return }
            self?.player.pause(isContinue)
        }
        
        input.fastFoward.bind { [weak self] _ in
            self?.playNextSong()
        }
        
        input.rewind.bind { [weak self] _ in
            guard let self = self else { return }
            guard self.player.rewind() else { return }
            self.rewindSong()
        }
        
        player.currentTime.bind { [weak self] remainTime in
            self?.output.currentTime.value = remainTime
        }
        
        player.remainTime.bind { [weak self] durationTime in
            self?.output.durationTime.value = durationTime
        }
        
        player.progressRatio.bind { [weak self] ratio in
            self?.output.progressRatio.value = ratio
        }
        
        player.finishPlaying.bind { [weak self] _ in
            guard let self = self else { return }
            self.playNextSong()
        }
    }
    
    private func rewindSong() {
        let beforeIndex = max(0, currentPlayingSongIndex - 1)
        currentPlayingSongIndex = beforeIndex
        playSong(row: beforeIndex)
    }
    
    private func playNextSong() {
        if songs.count > 1, currentPlayingSongIndex != (songs.count - 1) {
            currentPlayingSongIndex += 1
            playSong(row: currentPlayingSongIndex)
            return
        }
        
        if isRepeated {
            currentPlayingSongIndex = 0
            playSong(row: currentPlayingSongIndex)
            return
        }
        
        if currentPlayingSongIndex == songs.count - 1 {
            return
        }
        
        output.stopPlayer.value = ()
    }
    
    private func playSong(row: Int) {
        let song = self.songs[row]
        guard let url = song.url?.absoluteURL else { return }
        self.output.selectedSong.value = PlayerTray(album: album, song: song)
        self.player.play(at: url)
    }
}
