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
	private let viewWillAppearSubject = PublishSubject<Void>()
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
		bindInputs()
		bindOutputs()

//		viewDidLoadSubject.onCompleted()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

//		viewWillAppearSubject.onNext(())
		viewDidLoadSubject.onNext(())
	}
}

// MARK: - Setup
private extension ShopViewController {
	func setUpTableView() {
		tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
	}

	func bindInputs() {
		tableViewDriverSubject
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(cellIdentifier: CellIdentifier, cellType: ItemTableViewCell.self)) { _, cellInfo, cell in
				ItemTableViewCellRouter.configure(cell, for: cellInfo.item, cart: cellInfo.cart)
			}
			.disposed(by: disposeBag)

		cartButtonTitleDriverSubject
//			.asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, String> in
//				assertionFailure(error.l)
//			})
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

	func bindOutputs() {
		cartButton.rx.tap
			.subscribe(cartButtonTapSubject)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(emptyCartButtonTapSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - Inputs
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

// MARK: - Outputs
extension ShopViewController {
	var viewDidLoadObservable: Observable<Void> {
		viewDidLoadSubject
	}

	var viewWillAppearObservable: Observable<Void> {
		viewWillAppearSubject
	}

	var cartButtonTapObservable: Observable<Void> {
		cartButtonTapSubject
	}

	var emptyCartButtonTapObservable: Observable<Void> {
		emptyCartButtonTapSubject
	}
}
