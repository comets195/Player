//
//  AlbumCollectionViewCell.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: type(of: self))
    
    struct Constant {
        static let leftPadding: CGFloat = 8
        static let rightPadding: CGFloat = -8
        static let width = (UIScreen.main.bounds.width - (StageViewController.Constant.insetSpacing * 3)) / 2
    }
    
    private var artwork = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private var title = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14.0)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Album Title"
    }
    
    private var artist = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12.0)
        $0.textColor = .gray
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.text = "Artist"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        backgroundColor = .clear
        contentView.addSubview(artwork)
        contentView.addSubview(title)
        contentView.addSubview(artist)
        configureConstraints()
    }
    
    private func configureConstraints() {
        artwork.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.width.equalTo(Constant.width)
            make.height.equalTo(artwork.snp.width).multipliedBy(0.8)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(artwork.snp.bottom).offset(6)
            make.left.equalTo(artwork).offset(Constant.leftPadding)
            make.right.equalTo(artwork).offset(Constant.rightPadding)
        }
        
        artist.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(4)
            make.left.equalTo(title)
            make.right.equalTo(title)
            make.bottom.equalTo(snp.bottom).offset(-4)
        }
    }
    
    func configureCell(_ album: Album?) {
        guard let album = album else { return }
        title.text = album.title
        artist.text = album.artist
        artwork.image = album.artwork
    }
}
