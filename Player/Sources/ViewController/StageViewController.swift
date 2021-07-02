//
//  ViewController.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import UIKit

final class StageViewController: UIViewController {
    
    struct Constant {
        static let cellHeightRatio: CGFloat = 1.1
        static let itemOutSpacing: CGFloat = 14.0
        static let insetSpacing: CGFloat = 14.0
    }
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        
        $0.collectionViewLayout = layer
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets(top: Constant.insetSpacing,
                                       left: Constant.insetSpacing,
                                       bottom: Constant.insetSpacing,
                                       right: Constant.insetSpacing)
    }
    
    private var viewModel: StageViewModelType = StageViewModel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .gray
        configureUI()
        configureConstraints()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.requestMPAuthorization.value = ()
        collectionView.dataSource = self
        collectionView.delegate = self
        title = "Library"
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
    private func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func bind() {
        viewModel.output.authorized.bind { [weak self] _ in
            self?.viewModel.input.queryAlbums.value = ()
        }
        
        viewModel.output.denied.bind { [weak self] _ in }
        
        viewModel.output.pushSongList.bind { [weak self] album in
            print(album)
        }
        
        viewModel.output.reload.bind { [weak self] _ in
            DispatchQueue.main.async { self?.collectionView.reloadData() }
        }
    }
}

// MARK: - DataSource Methods.
extension StageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
        cell.configureCell(viewModel.albums?[indexPath.row].album())
        return cell
    }
    

}

// MARK: - Delegate Methods.
extension StageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
//        viewModel.input.requestSongList.value = indexPath
        navigationController?.pushViewController(AlbumViewController(), animated: true)
    }
}


// MARK: - FlowLayout Methods.
extension StageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AlbumCollectionViewCell.Constant.width,
                      height: AlbumCollectionViewCell.Constant.width * Constant.cellHeightRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.itemOutSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.itemOutSpacing
    }
}
