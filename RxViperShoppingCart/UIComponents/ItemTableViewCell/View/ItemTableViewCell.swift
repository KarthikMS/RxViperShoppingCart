//
//  ItemTableViewCell.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ItemTableViewCellRouter {
	static func configure(_ view: ItemTableViewCell, for item: ShopItem, cart: CartService) {
		let interactor = ItemTableViewCellInteractor(item: item, cart: cart)
		let presenter = ItemTableViewCellPresenter()

		view.presenter = presenter
		presenter.view = view

		interactor.presenter = presenter
		presenter.interactor = interactor
	}
}

protocol ItemTableViewCellObservablesForPresenterProvider {
	var observablesForPresenter: ItemTableViewCellObservablesForPresenter! { get }
}

struct ItemTableViewCellObservablesForPresenter {
	let addToCartButtonTapObservable: Observable<Void>
	let removeFromCartButtonTapObservable: Observable<Void>
}

class ItemTableViewCell: UITableViewCell, ItemTableViewCellObservablesForPresenterProvider {
	// MARK: - Dependencies
	var presenter: ItemTableViewCellPresenterObservablesForViewProvider! {
		didSet {
			observerPresenter()
		}
	}

	// MARK: - IBOutlets
	@IBOutlet private weak var itemNameLabel: UILabel!
	@IBOutlet private weak var itemCostLabel: UILabel!
	@IBOutlet private weak var addToCartButton: UIButton!
	@IBOutlet private weak var removeFromCartButton: UIButton!
	@IBOutlet private weak var itemCountLabel: UILabel!

	// MARK: - Subjects for observables for presenter
	private let addToCartButtonTapSubject = PublishSubject<Void>()
	private let removeFromCartButtonTapSubject = PublishSubject<Void>()

	// MARK: - Util
	private var disposeBag = DisposeBag()
}

// MARK: - Initialization functions
extension ItemTableViewCell {
	func configure() {
		disposeBag = DisposeBag()
	}

	func observerPresenter() {
		presenter.observablesForView
			.nameLabelDriver
			.drive(itemNameLabel.rx.text)
			.disposed(by: disposeBag)

		presenter.observablesForView
			.costLabelDriver
			.drive(itemCostLabel.rx.text)
			.disposed(by: disposeBag)

		presenter.observablesForView
			.addToCartButtonIsEnabledDriver
			.drive(addToCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		presenter.observablesForView
			.removeFromCartButtonIsEnabledDriver
			.drive(removeFromCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		presenter.observablesForView
			.itemCountLabelDriver
			.drive(itemCountLabel.rx.text)
			.disposed(by: disposeBag)
	}
}

// MARK: - ItemTableViewCellObservablesForPresenterProvider
extension ItemTableViewCell {
	var observablesForPresenter: ItemTableViewCellObservablesForPresenter! {
		ItemTableViewCellObservablesForPresenter(
			addToCartButtonTapObservable: addToCartButtonTapSubject,
			removeFromCartButtonTapObservable: removeFromCartButtonTapSubject
		)
	}
}

