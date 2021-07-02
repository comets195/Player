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
    
    var viewModel: AlbumViewModelType!
    
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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
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
        viewModel.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let song = viewModel.songs?[indexPath.row].song() else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier) as! SongTableViewCell
        cell.configureCell(trackNumber: song.trackNumber.stringValue, title: song.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let album = viewModel.album else { return nil }
        let header = AlbumHeaderView(frame: .zero)
        header.configureHeader(album)
        
        return header
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        Constant.headerHeight
    }
}

// MARK: - Delegate Methods.
extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectedSong.value = indexPath.row
    }
}
