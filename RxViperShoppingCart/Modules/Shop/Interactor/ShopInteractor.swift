//
//  ShopInteractor.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class ShopInteractor: ShopInteractorProtocol {
	// MARK: - Dependencies
	var presenter: ShopPresenterObservablesForInteractorProvider! {
		didSet {
			observePresenter()
		}
	}

	private let cart: CartService
	private let shopDataSource: ShopDataSource

	// MARK: - Initializers
	init(cart: CartService, shopDataSource: ShopDataSource) {
		self.cart = cart
		self.shopDataSource = shopDataSource
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()

	func observePresenter() {
		let presenterObservables = presenter.observablesForInteractor!

		presenterObservables
			.fetchShopItemsObservable
			.subscribe(onNext: { [weak self] in
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)

		presenterObservables
			.emptyCartObservable
			.subscribe(onNext: { [weak self] in
				self?.cart.empty()
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopInteractorObservablesForPresenterProvider
extension ShopInteractor {
	var observablesForPresenter: ShopInteractorObservablesForPresenter! {
		ShopInteractorObservablesForPresenter(
			cart: cart,
			shopItemsObservable: shopDataSource.itemsObservable,
			cartItemsObservable: cart.itemsObservable,
			totalNumberOfItemsInCartObservable: cart.totalNumberOfItemsObsercable,
			totalCostOfItemsInCartObservable: cart.totalCostObservable
		)
	}
}
