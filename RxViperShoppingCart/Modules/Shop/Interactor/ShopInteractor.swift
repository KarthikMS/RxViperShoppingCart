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
//	var presenter: (ShopInteractorInputsFromPresenterProvider & ShopInteractorOutputSink)!
	var presenter: ShopPresenterProtocol!

	private let cartService: CartService
	private let shopDataSource: ShopDataSource

	// MARK: - Initializers
	init(cart: CartService, shopDataSource: ShopDataSource) {
		self.cartService = cart
		self.shopDataSource = shopDataSource

		setUpServiceSubscriptions()
	}

	// MARK: - Properties
	private let fetchShopItemsSubject = PublishSubject<Void>()
	private let emptyCartSubject = PublishSubject<Void>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - ShopInteractorProtocol
extension ShopInteractor {
	func setUpServiceSubscriptions() {
		fetchShopItemsSubject
			.subscribe(onNext: { [weak self] in
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)

		emptyCartSubject
			.subscribe(onNext: { [weak self] in
				self?.cart.empty()
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)
	}
}


// MARK: - ShopPresenterOutputsForInteractorSink
extension ShopInteractor {
	var fetchShopItemsObserver: PublishSubject<Void> {
		fetchShopItemsSubject
	}

	var emptyCartObserver: PublishSubject<Void> {
		emptyCartSubject
	}
}

extension ShopInteractor {
	var cart: CartService {
		cartService
	}

	var shopItemsObservable: Observable<[ShopItem]> {
		shopDataSource.itemsObservable
	}

	var cartItemsObservable: Observable<[CartItem]> {
		cart.itemsObservable
	}

	var totalNumberOfItemsInCartObservable: Observable<Int> {
		cart.totalNumberOfItemsObservable
	}

	var totalCostOfItemsInCartObservable: Observable<Int> {
		cart.totalCostObservable
	}
}
