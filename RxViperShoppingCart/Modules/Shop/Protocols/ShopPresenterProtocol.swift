//
//  ShopPresenterProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 22/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol ShopPresenterProtocol {
	var view: ShopViewProtocol! { get set }
	var interactor: ShopInteractorProtocol! { get set }
	var inputSocketForView: ShopPresenterInputSocketForView { get }
	var outputSocketForView: ShopPresenterOutputSocketForView { get }
	var inputSocketForInteractor: ShopPresenterInputSocketForInteractor { get }
	var outputSocketForInteractor: ShopPresenterOutputSocketForInteractor { get }
	var outputSocketForRouter: ShopPresenterOutputSocketForRouter { get }
}

struct ShopPresenterInputSocketForView {
	let cartButtonTapSubject = PublishSubject<Void>()
	let viewWillAppearSubject = PublishSubject<Void>()
	let emptyCartButtonTapSubject = PublishSubject<Void>()
}

struct ShopPresenterOutputSocketForView {
	let tableViewDriverSubject = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	let cartButtonIsEnabledDriverSubject = PublishSubject<Bool>()
	let cartButtonTitleDriverSubject = PublishSubject<String>()
	let totalCostLabelTextDriverSubject = PublishSubject<String>()
	let emptyCartButtonIsEnabledDriverSubject = PublishSubject<Bool>()
}

struct ShopPresenterInputSocketForInteractor {
	let cartSubject = BehaviorSubject<CartService?>(value: nil)
	let interactorShopItemsObservable = PublishSubject<[ShopItem]>()
	let interactorCartItemsSubject = PublishSubject<[CartItem]>()
	let interactorTotalNumberOfItemsInCartSubject = PublishSubject<Int>()
	let interactorTotalCostOfItemsInCartSubject = PublishSubject<Int>()
}

struct ShopPresenterOutputSocketForInteractor {
	let fetchShopItemsObservable = PublishSubject<Void>()
	let emptyCartObservable = PublishSubject<Void>()
}

struct ShopPresenterOutputSocketForRouter {
	let goToCartScreenObservable = PublishSubject<Void>()
}
