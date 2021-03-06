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
        static let playerHeight: CGFloat = 70
        static let topOffset: CGFloat = 100
    }
    
    private var backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        $0.isHidden = true
    }
    
    private var isPresented = false
    private var heightConstraint: Constraint!
    private let playerView = PlayerView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width,
                                                                                  height: UIScreen.main.bounds.height - Constant.playerHeight)))
    
    let viewModel: PlayerViewModelType = PlayerViewModel()
    
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
        addTapGesture()
        addButtonTarget()
        bind()
    }
    
    private func bind() {
        viewModel.output.selectedSong.bind { [weak self] item in
            guard let item = item else { return }
            self?.playerView.title.text = item.song.title
            self?.playerView.artistAndAlbumTitle.text = "\(item.album.artist) - \(item.album.title)"
            self?.playerView.artwork.image = item.album.artwork
            self?.playerView.playControlButton.isSelected = true
        }
        
        viewModel.output.currentTime.bind { [weak self] time in
            self?.playerView.currentTime.text = time
        }
        
        viewModel.output.durationTime.bind { [weak self] time in
            self?.playerView.remainTime.text = time
        }
        
        viewModel.output.progressRatio.bind { [weak self] ratio in
            guard let ratio = ratio else { return }
            self?.playerView.progressView.setProgress(ratio, animated: false)
        }
        
        viewModel.output.stopPlayer.bind { [weak self] _ in
            self?.playerView.playControlButton.isSelected = false
        }
        
        viewModel.output.shuffleSelected.bind { [weak self] isSelected in
            guard let self = self else { return }
            self.playerView.shuffleButton.isSelected = isSelected ?? false
            self.setButtonTintColorState(self.playerView.shuffleButton)
        }
    }
    
    private func addStageVC() {
        let navigation = UINavigationController(rootViewController: StageViewController())
        navigation.navigationBar.prefersLargeTitles = true
        navigation.navigationBar.tintColor = .black
        navigation.navigationBar.shadowImage = UIImage()
        
        addChild(navigation)
        navigation.view.frame = CGRect(origin: .zero,
                                       size: CGSize(width: view.bounds.width,
                                                    height: view.bounds.height - Constant.playerHeight))
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
    
    private func addButtonTarget() {
        playerView.playControlButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        playerView.repeatButton.addTarget(self, action: #selector(repeatAlbum), for: .touchUpInside)
        playerView.shuffleButton.addTarget(self, action: #selector(shuffle), for: .touchUpInside)
        playerView.fastForwardButton.addTarget(self, action: #selector(fastForward), for: .touchUpInside)
        playerView.rewindButton.addTarget(self, action: #selector(rewind), for: .touchUpInside)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(presentView))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func presentView() {
        if isPresented {
            playerView.didmissView()
            isPresented = false
            
            heightConstraint.update(offset: UIScreen.main.bounds.height - Constant.playerHeight)
            
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                self?.backgroundView.alpha = 0
            
            }, completion: { [weak self] _ in
                self?.backgroundView.isHidden = true
            })
            
        } else {
            playerView.presentView()
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

// MARK: - Input Actions.
extension PlayerViewController {
    @objc
    private func pause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.input.pause.value = sender.isSelected
    }
    
    @objc
    private func rewind() {
        viewModel.input.rewind.value = ()
    }
    
    @objc
    private func fastForward() {
        viewModel.input.fastFoward.value = ()
    }
    
    @objc
    private func repeatAlbum(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.input.repeatAlbum.value = sender.isSelected
        
        setButtonTintColorState(sender)
    }
    
    @objc
    private func shuffle(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.input.playShuffle.value = sender.isSelected
        
        setButtonTintColorState(sender)
    }
    
    private func setButtonTintColorState(_ sender: UIButton) {
        if sender.isSelected {
            sender.tintColor = .black
        } else {
            sender.tintColor = .gray
        }
    }
}
