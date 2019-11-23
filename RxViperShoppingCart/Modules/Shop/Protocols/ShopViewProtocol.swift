//
//  ShopViewProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 22/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol ShopViewProtocol {
	var presenter: ShopPresenterProtocol! { get set }
	var inputSocket: ShopViewInputSocketForPresenter { get }
	var outputSocket: ShopViewOutputSocketForPresenter { get }
}

struct ShopViewInputSocketForPresenter {
	let tableViewDriverSubject = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	let cartButtonIsEnabledDriverSubject = PublishSubject<Bool>()
	let cartButtonTitleDriverSubject = PublishSubject<String>()
	let totalCostLabelTextDriverSubject = PublishSubject<String>()
	let emptyCartButtonIsEnabledDriverSubject = PublishSubject<Bool>()
}

struct ShopViewOutputSocketForPresenter {
	let cartButtonTapObservable = PublishSubject<Void>()
	let viewWillAppearObservable = PublishSubject<Void>()
	let emptyCartButtonTapObservable = PublishSubject<Void>()
}
