//
//  ShopModuleProtocols.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - VIEW
protocol ShopViewProtocol: ShopPresenterInputsFromViewProvider, ShopPresenterOutputsForViewSink {
//	var presenter: (ShopViewInputsFromPresenterProvider & ShopViewOutputsSink)! { get set }
	var presenter: ShopPresenterProtocol! { get set }
}

protocol ShopViewInputsFromPresenterProvider {
	var tableViewDriverSubject: PublishSubject<[(item: ShopItem, cart: CartService)]> { get }
	var cartButtonIsEnabledDriverSubject: PublishSubject<Bool> { get }
	var cartButtonTitleDriverSubject: PublishSubject<String> { get }
	var totalCostLabelTextDriverSubject: PublishSubject<String> { get }
	var emptyCartButtonIsEnabledDriverSubject: PublishSubject<Bool> { get }
}

protocol ShopViewOutputsSink {
	var cartButtonTapSubject: PublishSubject<Void> { get }
	var viewDidLoadSubject: PublishSubject<Void> { get }
	var emptyCartButtonTapSubject: PublishSubject<Void> { get }
}

// MARK: - PRESENTER
protocol ShopPresenterOutputsForViewSink: ShopViewInputsFromPresenterProvider {}

protocol ShopPresenterInputsFromViewProvider {
	var cartButtonTapObservable: Observable<Void> { get }
	var viewDidLoadObservable: Observable<Void> { get }
	var emptyCartButtonTapObservable: Observable<Void> { get }
}

protocol ShopPresenterProtocol: ShopViewOutputsSink {
	var view: ShopViewProtocol! { get set }
	var interactor: ShopInteractorProtocol! { get set }

	// Inputs for view
	var tableViewDriverSubject: PublishSubject<[(item: ShopItem, cart: CartService)]> { get }
	var cartButtonIsEnabledDriverSubject: PublishSubject<Bool> { get }
	var cartButtonTitleDriverSubject: PublishSubject<String> { get }
	var totalCostLabelTextDriverSubject: PublishSubject<String> { get }
	var emptyCartButtonIsEnabledDriverSubject: PublishSubject<Bool> { get }

	// Outputs for interactor
	var fetchShopItemsObservable: Observable<Void> { get }
	var emptyCartObservable: Observable<Void> { get }

	// Inputs from interactor
	var interactorShopItemsObservable: PublishSubject<[ShopItem]> { get }
	var interactorCartItemsSubject: PublishSubject<[CartItem]> { get }
	var interactorTotalNumberOfItemsInCartSubject: PublishSubject<Int> { get }
	var interactorTotalCostOfItemsInCartSubject: PublishSubject<Int> { get }

	// Inputs for router
	var goToCartScreenObservable: PublishSubject<Void> { get }
}

// MARK: - INTERACTOR
protocol ShopPresenterOutputsForInteractorSink {
	var fetchShopItemsObserver: PublishSubject<Void> { get }
	var emptyCartObserver: PublishSubject<Void> { get }
}

protocol ShopInteractorInputsFromPresenterProvider {
	var fetchShopItemsObservable: Observable<Void> { get }
	var emptyCartObservable: Observable<Void> { get }
}

protocol ShopInteractorOutputSink {
	var cart: CartService { get }
	var shopItemsObservable: Observable<[ShopItem]> { get }
	var cartItemsObservable: Observable<[CartItem]> { get }
	var totalNumberOfItemsInCartObservable: Observable<Int> { get }
	var totalCostOfItemsInCartObservable: Observable<Int> { get }
}

protocol ShopInteractorProtocol: ShopPresenterOutputsForInteractorSink  {
//	var presenter: (ShopInteractorOutputSink & ShopInteractorInputsFromPresenterProvider)! { get set }
	var presenter: ShopPresenterProtocol! { get set }

	var cart: CartService { get }
	var shopItemsObservable: Observable<[ShopItem]> { get }
	var cartItemsObservable: Observable<[CartItem]> { get }
	var totalNumberOfItemsInCartObservable: Observable<Int> { get }
	var totalCostOfItemsInCartObservable: Observable<Int> { get }
}

// MARK: - ROUTER
protocol ShopPresenterOutputsForRouterSink {
	var presentCartViewObserver: PublishSubject<Void> { get }
}

protocol ShopRouterInputsFromPresenterProvider {
	var presentCartViewObservable: Observable<Void> { get }
}

protocol ShopRouterProtocol: ShopPresenterOutputsForRouterSink {
//	var presenter: ShopRouterInputsFromPresenterProvider! { get set }
	init(presenter: ShopPresenterProtocol, navController: UINavigationController?)
//	var navController: UINavigationController! { get set }
}
