//
//  PlayerViewController.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit
import SnapKit

final class PlayerViewController: UIViewController {

    struct Constant {
        static let playerHeight: CGFloat = 50
        static let topOffset: CGFloat = 100
    }
    
    private var backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        $0.isHidden = true
    }
    
    private var isPresented = false
    private var heightConstraint: Constraint!
    private let playerView = PlayerView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width,
                                                                                  height: UIScreen.main.bounds.height - 90)))
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        addStageVC()
        view.addSubview(backgroundView)
        view.addSubview(playerView)
        configureConstraint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(presentView))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    private func addStageVC() {
        let navigation = UINavigationController(rootViewController: StageViewController())
        navigation.navigationBar.tintColor = .black
        navigation.navigationBar.shadowImage = UIImage()
        
        addChild(navigation)
        navigation.view.frame = CGRect(origin: .zero,
                                       size: CGSize(width: view.bounds.width,
                                                    height: view.bounds.height - 70))
        view.addSubview(navigation.view)
        navigation.didMove(toParent: self)
    }
    
    private func configureConstraint() {
        playerView.snp.makeConstraints { make in
            heightConstraint = make.top.equalTo(view.snp.top).offset(UIScreen.main.bounds.height - Constant.playerHeight).constraint
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.bounds.height - 90)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(playerView.snp.top).offset(20)
        }
    }
    
    @objc
    private func presentView() {
        if isPresented {
            isPresented = false
            
            heightConstraint.update(offset: UIScreen.main.bounds.height - Constant.playerHeight)
            
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                self?.backgroundView.alpha = 0
            
            }, completion: { [weak self] _ in
                self?.backgroundView.isHidden = true
            })
            
        } else {
            isPresented = true
            backgroundView.isHidden = false
            backgroundView.alpha = 0
            heightConstraint.update(offset: Constant.topOffset)
            
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                self?.backgroundView.alpha = 1
            
            })
        }
        
        
    }
}
