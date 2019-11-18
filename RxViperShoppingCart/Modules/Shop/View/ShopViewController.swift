//
//  ShopViewController.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShopViewController: UIViewController, ShopViewProtocol {
	// MARK: - Dependencies
	var presenter: ShopPresenterObservablesForViewProvider! {
		didSet {
//			observePresenter()
		}
	}

	// MARK: - IBOutlets
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var totalCostLabel: UILabel!

	// Nav bar
	@IBOutlet private weak var cartButton: UIBarButtonItem!
	@IBOutlet private weak var emptyCartButton: UIBarButtonItem!

	// MARK: - Subjects for observables for presenter
	private let viewDidLoadSubject = PublishSubject<Void>()
	private let cartButtonTapSubject = PublishSubject<Void>()
	private let emptyCartButtonTapSubject = PublishSubject<Void>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private let CellIdentifier = "CellIdentifier"
}

// MARK: - View Life Cycle
extension ShopViewController {
	override func viewDidLoad() {
        super.viewDidLoad()

		setUpTableView()
		observePresenter()
		sendInputsToPresenter()

		viewDidLoadSubject.onCompleted()
    }
}

// MARK: - Setup
private extension ShopViewController {
	func setUpTableView() {
		tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
	}

	func sendInputsToPresenter() {
		cartButton.rx.tap
			.subscribe(cartButtonTapSubject)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(emptyCartButtonTapSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopViewProtocol
extension ShopViewController {
	func observePresenter() {
		let presenterObservables = presenter.observablesForView!
		presenterObservables
			.tableViewDriver
			.drive(tableView.rx.items(cellIdentifier: CellIdentifier, cellType: ItemTableViewCell.self)) { _, cellInfo, cell in
				ItemTableViewCellRouter.configure(cell, for: cellInfo.item, cart: cellInfo.cart)
			}
			.disposed(by: disposeBag)

		presenterObservables
			.cartButtonTitleDriver
			.drive(cartButton.rx.title)
			.disposed(by: disposeBag)

		presenterObservables
			.cartButtonIsEnabledDriver
			.debug("My debug")
			.drive(cartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		presenterObservables
			.totalCostLabelTextDriver
			.drive(totalCostLabel.rx.text)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopViewObservablesForPresenterProvider
extension ShopViewController {
	var observablesForPresenter: ShopViewObservablesForPresenter! {
		ShopViewObservablesForPresenter(
			viewDidLoadObservable: viewDidLoadSubject,
			cartButtonTapObservable: cartButtonTapSubject,
			emptyCartButtonTapObservable: emptyCartButtonTapSubject
		)
	}
}
