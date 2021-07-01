//
//  ViewController.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class StageViewController: UIViewController {

    private var viewModel = StageViewModel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .yellow
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bind() {
        viewModel.authorized.bind { [weak self] _ in
            
        }
        
        viewModel.denied.bind { [weak self] _ in
            
        }
    }
}
