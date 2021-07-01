//
//  AlbumViewController.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class AlbumViewController: UIViewController {
    
    struct Constant {
        static let headerHeight: CGFloat = 171
    }
    
    private var tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureUI()
        configureConstraints()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureUI() {
        view.addSubview(tableView)
//        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func bind() {
       
    }
}

// MARK: - DataSource Methods.
extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        AlbumHeaderView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        Constant.headerHeight
    }
}

// MARK: - Delegate Methods.
extension AlbumViewController: UITableViewDelegate {
    
}
