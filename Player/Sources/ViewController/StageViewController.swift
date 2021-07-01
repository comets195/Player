//
//  ViewController.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class StageViewController: UIViewController {

    private var viewModel: StageViewModelType = StageViewModel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .yellow
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        viewModel.output.authorized.bind { [weak self] _ in
            self?.viewModel.input.queryAlbums.value = ()
        }
        
        viewModel.output.denied.bind { [weak self] _ in }
        
        viewModel.output.pushSongList.bind { [weak self] album in
            print(album)
        }
    }
}
