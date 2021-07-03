//
//  AudioPlayer.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/03.
//

import Foundation
import AVFoundation

protocol AudioPlayerType {
    mutating func play(at url: URL)
    func pause(_ isContiue: Bool)
}

struct AudioPlayer: AudioPlayerType {
    private var player: AVAudioPlayer!
    
    init() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playback,
                                 mode: .default,
                                 policy: .longFormAudio,
                                 options: [])
        try? session.setActive(true)
    }
    
    mutating func play(at url: URL) {
        player = try? AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        player.play()
    }
    
    func pause(_ isContiue: Bool) {
        if isContiue {
            player.play()
        } else {
            player.pause()
        }
    }
}
