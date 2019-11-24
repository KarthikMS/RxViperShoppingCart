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
	var presenter: ShopPresenterProtocol!

	private let cart: CartService
	private let shopDataSource: ShopDataSource

	// MARK: - Properties
	let inputSocket = ShopInteractorInputSocketForPresenter()
	let outputSocket = ShopInteractorOutputSocketForPresenter()

	// MARK: - Initializers
	init(cart: CartService, shopDataSource: ShopDataSource) {
		self.cart = cart
		self.shopDataSource = shopDataSource

		outputSocket.cartObservable.onNext(cart)
		observerShopDataSource()
		observeCart()
		handleInputsFromPresenter()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Setup
private extension ShopInteractor {
	func observerShopDataSource() {
		shopDataSource
			.itemsObservable
			.subscribe(outputSocket.shopItemsObservable)
			.disposed(by: disposeBag)
	}

	func observeCart() {
		cart
			.itemsObservable
			.subscribe(outputSocket.cartItemsObservable)
			.disposed(by: disposeBag)

		cart
			.totalNumberOfItemsObservable
			.subscribe(outputSocket.totalNumberOfItemsInCartObservable)
			.disposed(by: disposeBag)

		cart
			.totalCostObservable
			.subscribe(outputSocket.totalCostOfItemsInCartObservable)
			.disposed(by: disposeBag)
	}

	func handleInputsFromPresenter() {
		inputSocket
			.fetchShopItemsObserver
			.subscribe(onNext: { [weak self] in
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)

		inputSocket
			.emptyCartObserver
			.subscribe(onNext: { [weak self] in
				self?.cart.empty()
				self?.shopDataSource.fetchItems()
			})
			.disposed(by: disposeBag)
	}
}
