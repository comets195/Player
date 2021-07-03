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
    private var isShuffled: Bool = false
    private var isRepeated: Bool = false
    private var playSequenceIndex = [Int]()
    private var currentPlayingSongIndex: Int!
    private var player: AudioPlayerType = AudioPlayer()
    
    init() {
        input.insertAlbum.bind { [weak self] songs in
            guard let self = self else { return }
            self.songs = songs
            self.playSequenceIndex = self.songs.enumerated().map { $0.offset }
        }
        
        input.playSong.bind { [weak self] item in
            guard let self = self else { return }
            guard let album = item?.song?.collection()?.album() else { return }
            self.album = album
            self.currentPlayingSongIndex = item?.row
            self.playSong(row: self.currentPlayingSongIndex)
        }
        
        input.repeatAlbum.bind { [weak self] isRepeated in
            self?.isRepeated = isRepeated ?? false
        }
        
        input.playShuffle.bind { [weak self] isShuffle in
            guard let self = self else { return }
            self.isShuffled = isShuffle ?? false
            var candidateNum = self.songs.enumerated().map { $0.offset }.filter { (self.currentPlayingSongIndex ?? 0) != $0 }
            candidateNum.shuffle()
            candidateNum.insert(self.currentPlayingSongIndex, at: 0)
            
            self.currentPlayingSongIndex = 0
            self.playSequenceIndex = candidateNum
        }
        
        input.pause.bind { [weak self] isContinue in
            guard let isContinue = isContinue else { return }
            self?.player.pause(isContinue)
        }
        
        input.fastFoward.bind { [weak self] _ in
            guard let self = self else { return }
            if self.isShuffled {
                self.playShuffledNextSong()
            } else {
                self.playNextSong()
            }
        }
        
        input.rewind.bind { [weak self] _ in
            guard let self = self else { return }
            guard self.player.rewind() else { return }
            self.rewindSong()
        }
        
        playerOutputBind()
    }
        
    private func playerOutputBind() {
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
            if self.isShuffled {
                self.playShuffledNextSong()
            } else {
                self.playNextSong()
            }
        }
    }
    
    private func rewindSong() {
        let beforeIndex = max(0, currentPlayingSongIndex - 1)
        currentPlayingSongIndex = beforeIndex
        playSong(row: beforeIndex)
    }
    
    private func playShuffledNextSong() {
        if songs.count > 1, currentPlayingSongIndex != (songs.count - 1) {
            currentPlayingSongIndex += 1
            playSong(row: playSequenceIndex[currentPlayingSongIndex])
            return
        }

        
        if isRepeated {
            currentPlayingSongIndex = 0
            playSong(row: playSequenceIndex[currentPlayingSongIndex])
            return
        }
        
        if currentPlayingSongIndex == playSequenceIndex.count - 1 {
            return
        }
        
        output.stopPlayer.value = ()
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
