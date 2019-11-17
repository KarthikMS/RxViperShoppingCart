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

class ItemTableViewCell: UITableViewCell, ItemTableViewCellObservablesForPresenterProvider {
	// MARK: - Dependencies
	var presenter: ItemTableViewCellPresenterObservablesForViewProvider! {
		didSet {
			observePresenter()
		}
	}

	// MARK: - IBOutlets
	@IBOutlet private weak var itemNameLabel: UILabel!
	@IBOutlet private weak var itemCostLabel: UILabel!
	@IBOutlet private weak var addToCartButton: UIButton!
	@IBOutlet private weak var removeFromCartButton: UIButton!
	@IBOutlet private weak var itemCountLabel: UILabel!

	// MARK: - Subjects for observables for presenter
	private let dequedSubject = PublishSubject<ShopItem>()

	// MARK: - Util
	private var disposeBag = DisposeBag()
}

// MARK: - Initialization functions
extension ItemTableViewCell {
	func configure(for item: ShopItem) {
//		disposeBag = DisposeBag()
		dequedSubject.onNext(item)
	}

	func observePresenter() {
		let presenterObservables = presenter.observablesForView!

		presenterObservables
			.nameLabelDriver
			.drive(itemNameLabel.rx.text)
			.disposed(by: disposeBag)

		presenterObservables
			.costLabelDriver
			.drive(itemCostLabel.rx.text)
			.disposed(by: disposeBag)

		presenterObservables
			.addToCartButtonIsEnabledDriver
			.drive(addToCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		presenterObservables
			.removeFromCartButtonIsEnabledDriver
			.drive(removeFromCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		presenterObservables
			.itemCountLabelDriver
			.drive(itemCountLabel.rx.text)
			.disposed(by: disposeBag)
	}
}

// MARK: - ItemTableViewCellObservablesForPresenterProvider
extension ItemTableViewCell {
	var observablesForPresenter: ItemTableViewCellObservablesForPresenter! {
		ItemTableViewCellObservablesForPresenter(
			dequedObservable: dequedSubject,
			addToCartButtonTapObservable: addToCartButton.rx.tap.asObservable(),
			removeFromCartButtonTapObservable: removeFromCartButton.rx.tap.asObservable()
		)
	}
}

