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
	var presenter: ShopPresenterProtocol!

	// MARK: - IBOutlets
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var totalCostLabel: UILabel!

	// Nav bar
	@IBOutlet private weak var cartButton: UIBarButtonItem!
	@IBOutlet private weak var emptyCartButton: UIBarButtonItem!

	// MARK: - Properties
	let inputSocket = ShopViewInputSocketForPresenter()
	let outputSocket = ShopViewOutputSocketForPresenter()

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private let CellIdentifier = "CellIdentifier"
}

// MARK: - View Life Cycle
extension ShopViewController {
	override func viewDidLoad() {
        super.viewDidLoad()

		setUpTableView()
		bindOutputs()
		handleInputsFromPresenter()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		outputSocket.viewWillAppearObservable.onNext(())
		// TODO: Try to remove output pins
//		presenter.inputSocketForView.viewWillAppearSubject.onNext(())
	}
}

// MARK: - Setup
private extension ShopViewController {
	func setUpTableView() {
		tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
	}

	func handleInputsFromPresenter() {
		inputSocket
			.tableViewDriverSubject
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(cellIdentifier: CellIdentifier, cellType: ItemTableViewCell.self)) { _, cellInfo, cell in
				ItemTableViewCellRouter.configure(cell, for: cellInfo.item, cart: cellInfo.cart)
			}
			.disposed(by: disposeBag)

		inputSocket
			.cartButtonTitleDriverSubject
			.asDriver(onErrorJustReturn: "0")
			.drive(cartButton.rx.title)
			.disposed(by: disposeBag)

		inputSocket
			.cartButtonIsEnabledDriverSubject
			.asDriver(onErrorJustReturn: false)
			.drive(cartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		inputSocket
			.totalCostLabelTextDriverSubject
			.asDriver(onErrorJustReturn: "Total cost: Rs.0")
			.drive(totalCostLabel.rx.text)
			.disposed(by: disposeBag)

		inputSocket
			.emptyCartButtonIsEnabledDriverSubject
			.asDriver(onErrorJustReturn: false)
			.drive(emptyCartButton.rx.isEnabled)
			.disposed(by: disposeBag)
	}

	func bindOutputs() {
		cartButton.rx.tap
			.subscribe(outputSocket.cartButtonTapObservable)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(outputSocket.emptyCartButtonTapObservable)
			.disposed(by: disposeBag)
	}
}
