//
//  AlbumViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/02.
//

import Foundation
import MediaPlayer

protocol AlbumViewModelType {
    var input: AlbumViewModelInput { get }
    var output: AlbumViewModelOutput { get }
    
    var album: Album? { get }
    var songs: [MPMediaItem]? { get }
}

protocol AlbumViewModelInput {
    var headerViewAlbum: State<Void> { get }
}

protocol AlbumViewModelOutput {
    
}

final class AlbumViewModel: AlbumViewModelType {
    struct Input: AlbumViewModelInput {
        var headerViewAlbum = State<Void>(nil)
    }
    
    struct Output: AlbumViewModelOutput {
        
    }
    
    var input: AlbumViewModelInput = Input()
    var output: AlbumViewModelOutput = Output()
    var album: Album?
    var songs: [MPMediaItem]?
    
    init(album: Album, songs: [MPMediaItem]) {
        self.album = album
        self.songs = songs
        bind()
    }
    
    private func bind() {
        
    }
}
