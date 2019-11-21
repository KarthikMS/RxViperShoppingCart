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
//	var presenter: (ShopViewInputsFromPresenterProvider & ShopViewOutputsSink)!
	var presenter: ShopPresenterProtocol!

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

	private let tableViewDriver = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	private let cartButtonIsEnabledDriver = PublishSubject<Bool>()
	private let cartButtonTitleDriver = PublishSubject<String>()
	private let totalCostLabelTextDriver = PublishSubject<String>()
	private let emptyCartButtonIsEnabledDriver = PublishSubject<Bool>()
}

// MARK: - View Life Cycle
extension ShopViewController {
	override func viewDidLoad() {
        super.viewDidLoad()

		setUpTableView()
		bindInputsFromPresenter()
		bindOutputsToPresenter()

		viewDidLoadSubject.onCompleted()
    }
}

// MARK: - Setup
private extension ShopViewController {
	func setUpTableView() {
		tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
	}

	func bindOutputsToPresenter() {
		cartButton.rx.tap
			.subscribe(presenter.cartButtonTapSubject)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(emptyCartButtonTapSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopViewProtocol
extension ShopViewController {
	func bindInputsFromPresenter() {
		tableViewDriverSubject
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(cellIdentifier: CellIdentifier, cellType: ItemTableViewCell.self)) { _, cellInfo, cell in
				ItemTableViewCellRouter.configure(cell, for: cellInfo.item, cart: cellInfo.cart)
			}
			.disposed(by: disposeBag)

		cartButtonTitleDriverSubject
			.asDriver(onErrorJustReturn: "0")
			.drive(cartButton.rx.title)
			.disposed(by: disposeBag)

		cartButtonIsEnabledDriverSubject
			.asDriver(onErrorJustReturn: false)
			.drive(cartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		totalCostLabelTextDriverSubject
			.asDriver(onErrorJustReturn: "Total cost: Rs.0")
			.drive(totalCostLabel.rx.text)
			.disposed(by: disposeBag)

		emptyCartButtonIsEnabledDriverSubject
			.asDriver(onErrorJustReturn: false)
			.drive(emptyCartButton.rx.isEnabled)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopPresenterOutputsForViewSink
extension ShopViewController {
	var tableViewDriverSubject: PublishSubject<[(item: ShopItem, cart: CartService)]> {
		tableViewDriver
	}

	var cartButtonIsEnabledDriverSubject: PublishSubject<Bool> {
		cartButtonIsEnabledDriver
	}

	var cartButtonTitleDriverSubject: PublishSubject<String> {
		cartButtonTitleDriver
	}

	var totalCostLabelTextDriverSubject: PublishSubject<String> {
		totalCostLabelTextDriver
	}

	var emptyCartButtonIsEnabledDriverSubject: PublishSubject<Bool> {
		emptyCartButtonIsEnabledDriver
	}
}

// MARK: - ShopPresenterInputsFromViewProvider
extension ShopViewController {
	var cartButtonTapObservable: Observable<Void> {
		cartButtonTapSubject
	}

	var viewDidLoadObservable: Observable<Void> {
		viewDidLoadSubject
	}

	var emptyCartButtonTapObservable: Observable<Void> {
		emptyCartButtonTapSubject
	}
}
