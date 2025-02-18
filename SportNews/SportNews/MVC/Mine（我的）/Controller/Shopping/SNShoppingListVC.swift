//
//  SNShoppingListVC.swift
//  SportNews
//
//  Created by yuhua on 2021/5/12.
//

import UIKit

class SNShoppingListVC: QMUICommonViewController {
    
    enum ViewType: Int {
        case all = 0
        case bastetball
        case football
        case calling
    }
    
    var viewType: ViewType?
    var collection: UICollectionView!
    var itemSelected: ((ViewType?)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorF7F7F7
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width-12*3)/2
        layout.itemSize = CGSize(width: width, height: width*3/2)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 6
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SNShoppingListCell.self, forCellWithReuseIdentifier: "Shopping")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = ColorF7F7F7
        view.addSubview(collection)
        collection.mas_makeConstraints {
            $0?.left.equalTo()(view)?.offset()(12)
            $0?.right.equalTo()(view)?.offset()(-12)
            $0?.top.equalTo()(view)?.offset()(6)
            $0?.bottom.equalTo()(view.mas_safeAreaLayoutGuideBottom)
        }
    }
}

extension SNShoppingListVC: JXCategoryListContentViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func listView() -> UIView! {
        return view
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Shopping", for: indexPath) as! SNShoppingListCell
        cell.changeItem(title: "商品\(indexPath.row)",
                        price: indexPath.row + 1000,
                        sale: 10,
                        spare: 10,
                        image: indexPath.row % 2 == 0 ? UIImage(named: "编组 9")! : UIImage(named: "编组 10")!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected?(viewType)
    }
}
