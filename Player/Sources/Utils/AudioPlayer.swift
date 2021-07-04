//
//  AudioPlayer.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/03.
//

import Foundation
import AVFoundation

protocol AudioPlayerType {
    func rewind() -> Bool
    func play(at url: URL)
    func pause(_ isContiue: Bool)
    
    var currentTime: State<String> { get }
    var remainTime: State<String> { get }
    var durationTime: State<TimeInterval> { get }
    var progressRatio: State<Float> { get }
    var finishPlaying: State<Void> { get }
}

final class AudioPlayer: NSObject, AudioPlayerType {
    struct Constant {
        static let rewindMinimum = 10.0
    }
    
    private var timer: Timer!
    private var player: AVAudioPlayer?
    var currentTime = State<String>(nil)
    var remainTime = State<String>(nil)
    var durationTime = State<TimeInterval>(nil)
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
        durationTime.value = player!.duration
        
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }
    
    func pause(_ isPaused: Bool) {
        if isPaused, !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
            player?.play()
        } else if isPaused {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func rewind() -> Bool {
        guard let player = player else { return false }
        if player.currentTime >= Constant.rewindMinimum {
            player.currentTime = 0.0
            return false
            
        } else {
            player.stop()
            return true
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
