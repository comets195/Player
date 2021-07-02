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
    var requestMPAuthorization: State<Void> { get }
}

protocol StageOutput {
    typealias AlbumTray = (album: Album, songs: [MPMediaItem])
    var authorized: State<Void> { get }
    var denied: State<Void> { get }
    var pushSongList: State<AlbumTray> { get }
    var reload: State<Void> { get }
}

final class StageViewModel: StageViewModelType {
    struct Input: StageInput {
        var queryAlbums = State<Void>(nil)
        var requestSongList = State<IndexPath>(nil)
        var requestMPAuthorization = State<Void>(nil)
    }
    
    struct Output: StageOutput {
        var authorized = State<Void>(nil)
        var denied = State<Void>(nil)
        var pushSongList = State<AlbumTray>(nil)
        var reload = State<Void>(nil)
    }
    
    var input: StageInput = Input()
    var output: StageOutput = Output()
    var albums: [MPMediaItemCollection]?
    
    private let repository: MediaRepositoryType
    
    init(repository: MediaRepositoryType = MediaRepository()) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        input.queryAlbums.bind { [weak self] _ in
            self?.albums = self?.repository.requestMedia()
            self?.output.reload.value = ()
        }
        
        input.requestSongList.bind { [weak self] indexPath in
            guard let row = indexPath?.row else { return }
            guard let album = self?.albums?[row].album() else { return }
            guard let songs = self?.albums?[row].items else { return }
            self?.output.pushSongList.value = StageOutput.AlbumTray(album: album, songs: songs)
        }
        
        input.requestMPAuthorization.bind { [weak self] _ in
            MPMediaLibrary.requestAuthorization { status in
                switch status {
                case .authorized: self?.output.authorized.value = ()
                case .denied: self?.output.denied.value = ()
                default: ()
                }
            }
        }
    }
}
