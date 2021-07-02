//
//  PlayerView.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit
import MediaPlayer

final class PlayerView: UIView {

    struct Constant {
        static let progressHeight: CGFloat = 4
    }
    
    private(set) var progressView = UIProgressView().then {
        $0.tintColor = .black
        $0.progress = 0.5
    }
    
    private(set) var artwork = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8.0
        $0.clipsToBounds = true
    }
    
    private(set) var title = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12.0)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Album Title"
        $0.textAlignment = .center
    }
    
    private(set) var artistAndAlbumTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .gray
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Song - Artist"
        $0.textAlignment = .center
    }
    
    private(set) var playControlButton = UIButton().then {
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.setImage(UIImage(systemName: "pause"), for: .selected)
        $0.tintColor = .black
    }
    
    private(set) var loopButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
        $0.tintColor = .black
    }
    
    private(set) var shuffleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
        $0.tintColor = .black
        $0.isHidden = true
    }
    
    private(set) var rewindButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
        $0.tintColor = .black
        $0.isHidden = true
    }
    
    private(set) var fastForwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
        $0.tintColor = .black
        $0.isHidden = true
    }
    
    private(set) var volumeSlider = MPVolumeView().then {
        $0.tintColor = .black
        $0.isHidden = true
        guard let routeButton = $0.subviews.last as? UIButton else { return }
        let image = routeButton.currentImage?.withRenderingMode(.alwaysTemplate)
        $0.setRouteButtonImage(image, for: .normal)
    }
    
    private(set) var remainTime = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .gray
        $0.text = "00:00"
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureUI() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blurEffect)
        visualEffect.frame = bounds
        clipsToBounds = true
        
        addSubview(visualEffect)
        addSubview(progressView)
        addSubview(artwork)
        addSubview(title)
        addSubview(artistAndAlbumTitle)
        addSubview(playControlButton)
        addSubview(loopButton)
        addSubview(shuffleButton)
        addSubview(rewindButton)
        addSubview(fastForwardButton)
        addSubview(volumeSlider)
        addSubview(remainTime)
    }
    
    private func configureConstraint() {
        title.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15 + Constant.progressHeight)
            make.right.equalTo(snp.right).offset(-(15 + 50))
            make.left.equalTo(snp.left).offset(15 + 50)
        }
        
        artistAndAlbumTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(title.snp.left)
            make.right.equalTo(title.snp.right)
        }
        
        configureMiniPlayerLook()
    }
    
    private func configureMiniPlayerLook() {
        artwork.layer.cornerRadius = 8.0
        remainTime.isHidden = true
        loopButton.isHidden = true
        shuffleButton.isHidden = true
        rewindButton.isHidden = true
        fastForwardButton.isHidden = true
        volumeSlider.isHidden = true
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(Constant.progressHeight)
        }
        
        artwork.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15)
            make.right.equalTo(snp.right).offset(-8)
            make.width.equalTo(50)
            make.height.equalTo(artwork.snp.width)
        }
        
        playControlButton.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(15)
            make.top.equalTo(snp.top).offset(15)
            make.width.equalTo(30)
            make.height.equalTo(playControlButton.snp.width)
        }
        
        remainTime.snp.makeConstraints { make in
            make.right.equalTo(snp.right).offset(-10)
            make.bottom.equalTo(progressView.snp.top)
        }
    }
    
    private func configurePlayerLook() {
        artwork.layer.cornerRadius = 15.0
        remainTime.isHidden = false
        loopButton.isHidden = false
        shuffleButton.isHidden = false
        rewindButton.isHidden = false
        fastForwardButton.isHidden = false
        volumeSlider.isHidden = false

        artwork.snp.makeConstraints { make in
            make.top.equalTo(artistAndAlbumTitle.snp.bottom).offset(15)
            make.left.equalTo(snp.left).offset(15)
            make.right.equalTo(snp.right).offset(-15)
            make.height.equalTo(artwork.snp.width)
        }
        
        playControlButton.snp.makeConstraints { make in
            make.top.equalTo(artwork.snp.bottom).offset(50.0)
            make.width.equalTo(30)
            make.height.equalTo(playControlButton.snp.width)
            make.centerX.equalTo(snp.centerX)
        }
        
        rewindButton.snp.makeConstraints { make in
            make.top.equalTo(playControlButton.snp.top)
            make.width.equalTo(playControlButton.snp.width)
            make.height.equalTo(rewindButton.snp.width)
            make.right.equalTo(playControlButton.snp.left).offset(-20.0)
        }
        
        loopButton.snp.makeConstraints { make in
            make.top.equalTo(playControlButton.snp.top)
            make.width.equalTo(playControlButton.snp.width)
            make.height.equalTo(rewindButton.snp.width)
            make.right.equalTo(rewindButton.snp.left).offset(-20.0)
        }
        
        fastForwardButton.snp.makeConstraints { make in
            make.top.equalTo(playControlButton.snp.top)
            make.width.equalTo(playControlButton.snp.width)
            make.height.equalTo(rewindButton.snp.width)
            make.left.equalTo(playControlButton.snp.right).offset(20.0)
        }
        
        shuffleButton.snp.makeConstraints { make in
            make.top.equalTo(playControlButton.snp.top)
            make.width.equalTo(playControlButton.snp.width)
            make.height.equalTo(rewindButton.snp.width)
            make.left.equalTo(fastForwardButton.snp.right).offset(20.0)
        }
        
        progressView.snp.makeConstraints { make in
            make.bottom.equalTo(snp.bottomMargin)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(4)
        }
        
        volumeSlider.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.top.equalTo(playControlButton.snp.bottom).offset(20.0)
            make.height.equalTo(30)
        }
    }
    
    func presentView() {
        progressView.snp.removeConstraints()
        artwork.snp.removeConstraints()
        playControlButton.snp.removeConstraints()
        configurePlayerLook()
    }
    
    func didmissView() {
        progressView.snp.removeConstraints()
        artwork.snp.removeConstraints()
        playControlButton.snp.removeConstraints()
        configureMiniPlayerLook()
    }
}
