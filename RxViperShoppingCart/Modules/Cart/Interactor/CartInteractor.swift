//
//  CartModuleInteractor.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class CartInteractor: CartInteractorProtocol {
	// MARK: - Dependencies
	var presenter: CartPresenterObservablesForInteractorProvider! {
		didSet {
			observePresenter()
		}
	}

	private let shopDataSource: ShopDataSource
	private let cart: CartService
	private let purchaseService: PurchaseService

	// MARK: - Initializers
	init(shopDataSource: ShopDataSource, cart: CartService, purchaseService: PurchaseService) {
		self.shopDataSource = shopDataSource
		self.cart = cart
		self.purchaseService = purchaseService
	}

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - CartInteractorProtocol
extension CartInteractor {
	func observePresenter() {
		let presenterObservables = presenter.observablesForInteractor

		presenterObservables
			.buyItemsInCartObservable
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
				self.purchaseService.purchase(self.cart.items)
			})
			.disposed(by: disposeBag)

		presenterObservables
			.emptyCartObservable
			.subscribe(onNext: { [weak self] in
				self?.cart.empty()
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - CartInteractorObservablesForPresenterProvider
extension CartInteractor {
	var observablesForPresenter: CartInteractorObservablesForPresenter {
		CartInteractorObservablesForPresenter(
			cart: cart,
			cartItemsObservable: cart.itemsObservable,
			totalNumberOfItemsInCartObservable: cart.totalNumberOfItemsObsercable,
			totalCostOfItemsInCartObservable: cart.totalCostObservable
		)
	}
}
