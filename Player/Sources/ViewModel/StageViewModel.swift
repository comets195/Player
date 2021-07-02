//
//  StageViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation
import MediaPlayer

typealias AlbumTray = (album: Album, songs: [MPMediaItem])
protocol StageViewModelType {
    var input: StageViewModelInput { get }
    var output: StageViewModelOutput { get }
    
    var albums: [MPMediaItemCollection]? { get }
}

protocol StageViewModelInput {
    var queryAlbums: State<Void> { get }
    var requestSongList: State<IndexPath> { get }
    var requestMPAuthorization: State<Void> { get }
}

protocol StageViewModelOutput {
    var authorized: State<Void> { get }
    var denied: State<Void> { get }
    var pushSongList: State<AlbumTray> { get }
    var reload: State<Void> { get }
}

final class StageViewModel: StageViewModelType {
    struct Input: StageViewModelInput {
        var queryAlbums = State<Void>(nil)
        var requestSongList = State<IndexPath>(nil)
        var requestMPAuthorization = State<Void>(nil)
    }
    
    struct Output: StageViewModelOutput {
        var authorized = State<Void>(nil)
        var denied = State<Void>(nil)
        var pushSongList = State<AlbumTray>(nil)
        var reload = State<Void>(nil)
    }
    
    var input: StageViewModelInput = Input()
    var output: StageViewModelOutput = Output()
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
            self?.output.pushSongList.value = AlbumTray(album: album, songs: songs)
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
