//
//  StageViewModel.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation
import MediaPlayer

protocol StageInput {
    var authorized: State<Void> { get }
    var denied: State<Void> { get }
    var queryAlbum: State<Void> { get }
}

struct StageViewModel: StageInput {
    var authorized = State<Void>(nil)
    var denied = State<Void>(nil)
    var queryAlbum = State<Void>(nil)
    
    init() {
        self.requestMPAuthorization()
    }
    
    private func requestMPAuthorization() {
        MPMediaLibrary.requestAuthorization { status in
            switch status {
            case .authorized: self.authorized.value = ()
            case .denied: self.denied.value = ()
            default: ()
            }
        }
    }
}
