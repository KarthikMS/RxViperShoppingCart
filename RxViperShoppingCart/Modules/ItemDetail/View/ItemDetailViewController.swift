//
//  ItemDetailViewController.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 24/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift

class ItemDetailViewController: UIViewController, ItemDetailViewProtocol {
	// MARK: - Dependencies
	var presenter: ItemDetailViewToPresenterProtocol!

	// MARK: - IBOutlets
	@IBOutlet private weak var itemNameLabel: UILabel!
	@IBOutlet private weak var itemCostLabel: UILabel!

	// MARK: - Properties
	let inputFromPresenter = ItemDetailViewInputFromPresenter()
}

// MARK: - View Life Cycle
extension ItemDetailViewController {
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}
