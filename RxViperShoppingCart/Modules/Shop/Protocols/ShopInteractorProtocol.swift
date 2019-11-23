//
//  ShopInteractorProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 22/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol ShopInteractorProtocol {
	var presenter: ShopPresenterProtocol! { get set }
	var inputSocket: ShopInteractorInputSocketForPresenter { get }
	var outputSocket: ShopInteractorOutputSocketForPresenter { get }
}

// PRESENTER -> INTERACTOR
struct ShopInteractorInputSocketForPresenter {
	let fetchShopItemsObserver = PublishSubject<Void>()
	let emptyCartObserver = PublishSubject<Void>()
}

// INTERACTOR -> PRESENTER
struct ShopInteractorOutputSocketForPresenter {
	let cartObservable = BehaviorSubject<CartService?>(value: nil)
	let shopItemsObservable = PublishSubject<[ShopItem]>()
	let cartItemsObservable = PublishSubject<[CartItem]>()
	let totalNumberOfItemsInCartObservable = PublishSubject<Int>()
	let totalCostOfItemsInCartObservable = PublishSubject<Int>()
}
