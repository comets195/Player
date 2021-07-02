//
//  PlayerView.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class PlayerView: UIView {

    private var progressView = UIProgressView().then {
        $0.tintColor = .black
        $0.progress = 0.5
    }
    
    private var artwork = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8.0
        $0.backgroundColor = .black
    }
    
    private var title = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12.0)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Album Title"
        $0.textAlignment = .center
    }
    
    private var artistAndSong = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10.0)
        $0.textColor = .gray
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Song - Artist"
        $0.textAlignment = .center
    }
    
    private var playControlButton = UIButton().then {
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.setImage(UIImage(systemName: "pause"), for: .selected)
        $0.tintColor = .black
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

        addSubview(visualEffect)
        clipsToBounds = true
        
        addSubview(progressView)
        addSubview(artwork)
        addSubview(title)
        addSubview(artistAndSong)
        addSubview(playControlButton)
    }
    
    private func configureConstraint() {
        progressView.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(4)
        }
        
        artwork.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15)
            make.right.equalTo(snp.right).offset(-8)
            make.width.equalTo(50)
            make.height.equalTo(artwork.snp.width)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.right.equalTo(artwork.snp.left).offset(-15)
            make.left.equalTo(playControlButton.snp.right).offset(15)
        }
        
        artistAndSong.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(title.snp.left)
            make.right.equalTo(title.snp.right)
        }
        
        playControlButton.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(15)
            make.top.equalTo(snp.top).offset(15)
            make.width.equalTo(30)
            make.height.equalTo(playControlButton.snp.width)
        }
    }
}
