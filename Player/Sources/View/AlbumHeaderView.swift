//
//  AlbumHeaderView.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class AlbumHeaderView: UIView {
    static let identifier = String(describing: type(of: self))
    
    struct Constant {
        static let titlePadding: CGFloat = 14.0
        static let leftPadding: CGFloat = 14.0
        static let rightPadding: CGFloat = -14.0
        static let imageWidth: CGFloat = 90.0
        static let titleLeftPadding: CGFloat = 8.0
        static let titleBottomPadding: CGFloat = 4.0
        static let seperatorHeight: CGFloat = 1.0
        static let cornerRadius = 6.0
    }
    
    private var artwork = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = Constant.cornerRadius
    }
    
    private var title = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20.0)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Album Title"
    }
    
    private var artist = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15.0)
        $0.textColor = .gray
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Artist"
    }
    
    private var seperator = UIView().then {
        $0.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 0.7)
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = Constant.titlePadding
    }
    
    private(set) var playButton = UIButton().then {
        $0.setImage(UIImage(systemName: "play"), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.layer.cornerRadius = Constant.cornerRadius
    }
    
    private(set) var shuffleButton = UIButton().then {
        $0.setImage(UIImage(systemName: "shuffle"), for: .normal)
        $0.tintColor = .black
        $0.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.layer.cornerRadius = Constant.cornerRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        backgroundColor = .white
        
        addSubview(artwork)
        addSubview(title)
        addSubview(artist)
        addSubview(seperator)
        addSubview(stackView)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(shuffleButton)
        configureConstraints()
    }
    
    private func configureConstraints() {
        artwork.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(Constant.titlePadding)
            make.left.equalTo(snp.left).offset(Constant.leftPadding)
            make.width.equalTo(Constant.imageWidth)
            make.height.equalTo(artwork.snp.width)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(artwork.snp.top)
            make.left.equalTo(artwork.snp.right).offset(Constant.titleLeftPadding)
            make.right.equalTo(snp.right).offset(Constant.rightPadding)
        }
        
        artist.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constant.titleBottomPadding)
            make.left.equalTo(title)
            make.right.equalTo(title)
        }
        
        seperator.snp.makeConstraints { make in
            make.top.equalTo(artwork.snp.bottom).offset(Constant.titleLeftPadding)
            make.height.equalTo(Constant.seperatorHeight)
            make.left.equalTo(Constant.leftPadding)
            make.right.equalTo(Constant.rightPadding)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(Constant.titleLeftPadding)
            make.left.equalTo(snp.left).offset(Constant.leftPadding)
            make.right.equalTo(snp.right).offset(Constant.rightPadding)
            make.bottom.equalTo(snp.bottom).offset(Constant.rightPadding)
        }
    }
}
