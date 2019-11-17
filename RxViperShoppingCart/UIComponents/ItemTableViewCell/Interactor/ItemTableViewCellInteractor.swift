//
//  ItemTableViewCellInteractor.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 15/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class ItemTableViewCellInteractor: ItemTableViewCellInteractorObservablesForPresenterProvider {
	// MARK: - Dependencies
	private let cart: CartService

	var presenter: ItemTableViewCellPresenterObservablesForInteractorProvider! {
		didSet {
			observePresenter()
		}
	}

	// MARK: - Subjects for presenter
	private let shopItemSubject: BehaviorSubject<ShopItem>
	private let numberOfItemsInCartSubject: BehaviorSubject<Int>

	// MARK: - Initializers
	init(shopItem: ShopItem, cart: CartService) {
		self.cart = cart

		shopItemSubject = BehaviorSubject<ShopItem>(value: shopItem)
		numberOfItemsInCartSubject = BehaviorSubject<Int>(value: cart.count(of: shopItem))
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()

	func observePresenter() {
		let presenterObservables = presenter.observablesForInteractor!

		presenterObservables
			.addItemToCartObservable
			.subscribe(
				onNext: { [weak self] in
					guard let self = self else { return }
					self.cart.add(self.shopItem)
					self.numberOfItemsInCartSubject.onNext(self.cart.count(of: self.shopItem))
			})
			.disposed(by: disposeBag)

		presenterObservables
			.removeItemToCartObservable
			.subscribe(
				onNext: { [weak self] in
					guard let self = self else { return }
					self.cart.remove(self.shopItem)
					self.numberOfItemsInCartSubject.onNext(self.cart.count(of: self.shopItem))
			})
			.disposed(by: disposeBag)

		presenterObservables
			.dequedObservable
			.subscribe(onNext: { [weak self] shopItem in
				guard let self = self else { return }
				self.shopItemSubject.onNext(shopItem)
				self.numberOfItemsInCartSubject.onNext(self.cart.count(of: shopItem))
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - ItemTableViewCellInteractorObservablesForPresenterProvider
extension ItemTableViewCellInteractor {
	var observablesForPresenter: ItemTableViewCellInteractorObservablesForPresenter! {
		ItemTableViewCellInteractorObservablesForPresenter(
			shopItemObservable: shopItemSubject,
			numberOfItemsInCartObservable: numberOfItemsInCartSubject
		)
	}

	var shopItem: ShopItem {
		try! shopItemSubject.value()
	}
}
