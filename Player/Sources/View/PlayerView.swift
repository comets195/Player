//
//  PlayerView.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class PlayerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
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
    }
}
