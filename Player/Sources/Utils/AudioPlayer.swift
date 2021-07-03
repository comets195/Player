//
//  AudioPlayer.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/03.
//

import Foundation
import AVFoundation

protocol AudioPlayerType {
    func play(at url: URL)
    func pause(_ isContiue: Bool)
    var currentTime: State<String> { get }
    var remainTime: State<String> { get }
    var progressRatio: State<Float> { get }
    var finishPlaying: State<Void> { get }
}

final class AudioPlayer: NSObject, AudioPlayerType {
    private var timer: Timer!
    private var player: AVAudioPlayer?
    var currentTime = State<String>(nil)
    var remainTime = State<String>(nil)
    var progressRatio = State<Float>(nil)
    var finishPlaying = State<Void>(nil)
    
    override init() {
        super.init()
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playback,
                                 mode: .default,
                                 policy: .longFormAudio,
                                 options: [])
        try? session.setActive(true)
    }
    
    func play(at url: URL) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }
    
    func pause(_ isContiue: Bool) {
        if isContiue, !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
            player?.play()
        } else if isContiue {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    @objc
    private func updateCurrentTime() {
        guard let player = player else { return }
        let progressRatio = player.currentTime / player.duration
        if progressRatio != 1.0 {
            self.progressRatio.value = Float(progressRatio)
        }
        currentTime.value = calculateTime(player.currentTime)
        remainTime.value = "-" + calculateTime(player.duration - player.currentTime)
        
//        if player.currentTime > 3.0 {
//            player.stop()
//            timer.invalidate()
//            finishPlaying.value = ()
//        }
    }
    
    private func calculateTime(_ time: TimeInterval) -> String {
        let minute = String(format: "%d", Int(time / 60))
        let seconds = String(format: "%02d", Int(time) % 60)
        
        return "\(minute):\(seconds)"
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        timer.invalidate()
        finishPlaying.value = ()
    }
}
