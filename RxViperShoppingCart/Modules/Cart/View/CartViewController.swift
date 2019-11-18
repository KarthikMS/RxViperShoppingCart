//
//  CartModuleViewController.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController, CartViewProtocol {
	// MARK: - Dependencies
	var presenter: CartPresenterDriversForViewProvider!

	// MARK: - IBOutlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalCostLabel: UILabel!
	@IBOutlet weak var buyButton: UIButton!
	@IBOutlet weak var emptyCartButton: UIButton!

	// MARK: - Subjects for presenter
	private static let buyButtonTapSubject = PublishSubject<Void>()
	private static let emptyCartButtonTapSubject = PublishSubject<Void>()
	
	// MARK: - Properties
	private let disposeBag = DisposeBag()
	private let CellIdentifier = "CellIdentifier"

	static let sharedObservablesForPresenter = CartViewObservablesForPresenter(
		buyButtonTapObservable: buyButtonTapSubject,
		emptyCartButtonTapObservable: emptyCartButtonTapSubject
	)
}

// MARK: - View Life Cycle
extension CartViewController {
	override func viewDidLoad() {
        super.viewDidLoad()

		setUpTableView()
		observePresenter()
		sendInputsToPresenter()
    }
}

// MARK: - Setup
private extension CartViewController {
	func setUpTableView() {
		tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
	}

	func sendInputsToPresenter() {
		buyButton.rx.tap
			.subscribe(CartViewController.buyButtonTapSubject)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(CartViewController.emptyCartButtonTapSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - CartViewProtocol
extension CartViewController {
	func observePresenter() {
		let presenterDrivers = presenter.driversForView

		presenterDrivers
			.tableViewDriver
			.drive(tableView.rx.items(cellIdentifier: CellIdentifier, cellType: ItemTableViewCell.self)) { _, cellInfo, cell in
				ItemTableViewCellRouter.configure(cell, for: cellInfo.shopItem, cart: cellInfo.cart)
			}
			.disposed(by: disposeBag)

		presenterDrivers
			.totalCostLabelDriver
			.drive(totalCostLabel.rx.text)
			.disposed(by: disposeBag)

		presenterDrivers
			.buyButtonTitleDriver
			.drive(buyButton.rx.title())
			.disposed(by: disposeBag)
	}
}

// MARK: - CartViewObservablesForPresenterProvider
extension CartViewController {
	var observablesForPresenter: CartViewObservablesForPresenter {
		CartViewController.sharedObservablesForPresenter
	}
}
