//
//  ShopPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

class ShopPresenter: ShopPresenterProtocol {
	// MARK: - Dependencies
	var view: ShopViewProtocol!
	var interactor: ShopInteractorProtocol!
	var router: ShopRouterProtocol!

	// MARK: - Presenter -> View
	private var tableViewSubject = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	private var cartButtonIsEnabledSubject = PublishSubject<Bool>()
	private var cartButtonTitleSubject = PublishSubject<String>()
	private var totalCostLabelTextSubject = PublishSubject<String>()
	private let emptyCartButtonIsEnabledSubject = PublishSubject<Bool>()

	// MARK: - Presenter -> Interactor
	private let fetchShopItemsSubject = PublishSubject<Void>()
	private let emptyCartSubject = PublishSubject<Void>()

	// MARK: - Presenter -> Router
	private let goToCartScreenSubject = PublishSubject<Void>()

	// MARK: - View -> Presenter
	private let viewDidLoadSub = PublishSubject<Void>()
	private let cartButtonTapSub = PublishSubject<Void>()
	private let emptyCartButtonTapSub = PublishSubject<Void>()

	let interactorShopItemsObservable = PublishSubject<[ShopItem]>()
	let interactorCartItemsSubject = PublishSubject<[CartItem]>()
	let interactorTotalNumberOfItemsInCartSubject = PublishSubject<Int>()
	let interactorTotalCostOfItemsInCartSubject = PublishSubject<Int>()

	// MARK: - Initializations
	init() {
		setUpSubscriptions()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

private extension ShopPresenter {
	func setUpSubscriptions() {
		viewDidLoadSub
			.subscribe(fetchShopItemsSubject)
			.disposed(by: disposeBag)

		cartButtonTapSub
			.subscribe(goToCartScreenSubject)
			.disposed(by: disposeBag)

		emptyCartButtonTapSub
			.subscribe(emptyCartSubject)
			.disposed(by: disposeBag)

		interactorShopItemsObservable
			.map { shopItems in
				shopItems.map { [weak self] shopItem in
					guard let self = self else { return (shopItem, Cart()) }
					return (shopItem, self.interactor.cart)
				}
			}
			.subscribe(tableViewSubject)
			.disposed(by: disposeBag)

		interactorTotalNumberOfItemsInCartSubject
			.map { String($0) }
			.subscribe(cartButtonTitleSubject)
			.disposed(by: disposeBag)

		interactorTotalNumberOfItemsInCartSubject
			.map { $0 != 0 }
			.subscribe(cartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		interactorTotalCostOfItemsInCartSubject
			.map { "Total Cost: Rs.\($0)" }
			.subscribe(totalCostLabelTextSubject)
			.disposed(by: disposeBag)

		interactorTotalNumberOfItemsInCartSubject
			.map { $0 != 0 }
			.subscribe(emptyCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - NEW
// MARK: View -> Presenter
extension ShopPresenter {
	var cartButtonTapSubject: PublishSubject<Void> {
		cartButtonTapSub
	}

	var viewDidLoadSubject: PublishSubject<Void> {
		viewDidLoadSub
	}

	var emptyCartButtonTapSubject: PublishSubject<Void> {
		emptyCartButtonTapSub
	}
}

// MARK: - Presenter -> View
extension ShopPresenter {
	var tableViewDriverSubject: PublishSubject<[(item: ShopItem, cart: CartService)]> {
		tableViewSubject
	}

	var cartButtonIsEnabledDriverSubject: PublishSubject<Bool> {
		cartButtonIsEnabledSubject
	}

	var cartButtonTitleDriverSubject: PublishSubject<String> {
		cartButtonTitleSubject
	}

	var totalCostLabelTextDriverSubject: PublishSubject<String> {
		totalCostLabelTextSubject
	}

	var emptyCartButtonIsEnabledDriverSubject: PublishSubject<Bool> {
		emptyCartButtonIsEnabledSubject
	}
}

// MARK: - Presenter -> Interactor
extension ShopPresenter {
	var fetchShopItemsObservable: Observable<Void> {
		fetchShopItemsSubject
	}

	var emptyCartObservable: Observable<Void> {
		emptyCartSubject
	}
}

// MARK: - Presenter -> Rotuer
extension ShopPresenter {
	var goToCartScreenObservable: PublishSubject<Void> {
		goToCartScreenSubject
	}
}
