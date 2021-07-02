//
//  SongTableViewCell.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/02.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    static let identifier = String(describing: type(of: self))
    
    private var trackNumber = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16.0)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.textAlignment = .center
    }
    
    private var title = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0)
        $0.textColor = .gray
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .white
        addSubview(trackNumber)
        addSubview(title)
        
        configureConstraint()
    }
    
    private func configureConstraint() {
        trackNumber.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left).offset(15)
            make.bottom.equalTo(snp.bottom)
            make.width.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(trackNumber.snp.top)
            make.left.equalTo(trackNumber.snp.right).offset(15)
            make.right.equalTo(snp.right).offset(-15)
            make.bottom.equalTo(trackNumber.snp.bottom)
        }
    }
    
    func configureCell(trackNumber: String, title: String) {
        self.trackNumber.text = trackNumber
        self.title.text = title
    }
}
