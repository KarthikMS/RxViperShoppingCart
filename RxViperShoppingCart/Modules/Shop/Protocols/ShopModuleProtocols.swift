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

// try
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
	static func createModule() -> UIViewController

//	var presenter: ShopRouterInputsFromPresenterProvider! { get set }
	var presenter: ShopPresenterProtocol! { get set }
	var navController: UINavigationController! { get set }
}
// try

// MARK: - Definition Protocols
//protocol ShopViewProtocol: ShopViewObservablesForPresenterProvider {
//	var presenter: ShopPresenterObservablesForViewProvider! { get set }
//	var navigationController: UINavigationController? { get }
//	func observePresenter()
//}
//
//protocol ShopInteractorProtocol: ShopInteractorObservablesForPresenterProvider {
//	var presenter: ShopPresenterObservablesForInteractorProvider! { get set }
//	func observePresenter()
//}
//
//protocol ShopPresenterProtocol: ShopPresenterObservablesForViewProvider, ShopPresenterObservablesForInteractorProvider, ShopPresenterObservablesForRouterProvider {
//	var view: ShopViewObservablesForPresenterProvider! { get set }
//	var interactor: ShopInteractorObservablesForPresenterProvider! { get set }
//	var router: ShopRouterProtocol! { get set }
//	func observeView()
//	func observeInteractor()
//}
//
//protocol ShopRouterProtocol {
//	static func createModule() -> UIViewController
//	var presenter: ShopPresenterObservablesForRouterProvider! { get set }
//	var navController: UINavigationController! { get set }
//	func observePresenter()
//}
//
//// MARK: - Communication Protocols
//// TODO: Try removing optionals
//protocol ShopViewObservablesForPresenterProvider {
//	var observablesForPresenter: ShopViewObservablesForPresenter! { get }
//}
//
//protocol ShopPresenterObservablesForViewProvider {
//	var observablesForView: ShopPresenterObservablesForView! { get }
//}
//
//protocol ShopInteractorObservablesForPresenterProvider {
//	var observablesForPresenter: ShopInteractorObservablesForPresenter! { get }
//}
//
//protocol ShopPresenterObservablesForInteractorProvider {
//	var observablesForInteractor: ShopPresenterObservablesForInteractor! { get }
//}
//
//protocol ShopPresenterObservablesForRouterProvider {
//	var observablesForRouter: ShopPresenterObservablesForRouter! { get }
//}
//
//// MARK: - Models
//struct ShopViewObservablesForPresenter {
//	let viewDidLoadObservable: Observable<Void>
//	let cartButtonTapObservable: Observable<Void>
//	let emptyCartButtonTapObservable: Observable<Void>
//}
//
//struct ShopPresenterObservablesForView {
//	let tableViewDriver: Driver<[(item: ShopItem, cart: CartService)]>
//	let cartButtonIsEnabledDriver: Driver<Bool>
//	let cartButtonTitleDriver: Driver<String>
//	let totalCostLabelTextDriver: Driver<String>
//	let emptyCartButtonIsEnabledDriver: Driver<Bool>
//}
//
//struct ShopInteractorObservablesForPresenter {
//	let cart: CartService
//	let shopItemsObservable: Observable<[ShopItem]>
//	let cartItemsObservable: Observable<[CartItem]>
//	let totalNumberOfItemsInCartObservable: Observable<Int>
//	let totalCostOfItemsInCartObservable: Observable<Int>
//}
//
//struct ShopPresenterObservablesForInteractor {
//	let fetchShopItemsObservable: Observable<Void>
//	let emptyCartObservable: Observable<Void>
//}
//
//struct ShopPresenterObservablesForRouter {
//	let cartButtonTapObservable: Observable<Void>
//}
