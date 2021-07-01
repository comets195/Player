//
//  StageViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation
import MediaPlayer

protocol StageViewModelType {
    var input: StageInput { get }
    var output: StageOutput { get }
    
    var albums: [MPMediaItemCollection]? { get }
}

protocol StageInput {
    var queryAlbums: State<Void> { get }
    var requestSongList: State<IndexPath> { get }
}

protocol StageOutput {
    typealias AlbumTray = (album: Album, songs: [MPMediaItem])
    var authorized: State<Void> { get }
    var denied: State<Void> { get }
    var pushSongList: State<AlbumTray> { get }
}

final class StageViewModel: StageViewModelType {
    struct Input: StageInput {
        var queryAlbums = State<Void>(nil)
        var requestSongList = State<IndexPath>(nil)
    }
    
    struct Output: StageOutput {
        var authorized = State<Void>(nil)
        var denied = State<Void>(nil)
        var pushSongList = State<AlbumTray>(nil)
    }
    
    var input: StageInput = Input()
    var output: StageOutput = Output()
    var albums: [MPMediaItemCollection]?
    
    private let repository: MediaRepositoryType
    
    init(repository: MediaRepositoryType = MediaRepository()) {
        self.repository = repository
        self.requestMPAuthorization()
        bind()
    }
    
    private func bind() {
        input.queryAlbums.bind { [weak self] _ in
            self?.albums = self?.repository.requestMedia()
        }
        
        input.requestSongList.bind { [weak self] indexPath in
            guard let row = indexPath?.row else { return }
            guard let album = self?.albums?[row].album() else { return }
            guard let songs = self?.albums?[row].items else { return }
            self?.output.pushSongList.value = StageOutput.AlbumTray(album: album, songs: songs)
        }
    }
    
    private func requestMPAuthorization() {
        MPMediaLibrary.requestAuthorization { status in
            switch status {
            case .authorized: self.output.authorized.value = ()
            case .denied: self.output.denied.value = ()
            default: ()
            }
        }
    }
}
