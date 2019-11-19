//
//  CartModuleProtocols.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

//play with static let. Check if static var returns the same instance

// MARK: - Definition Protocols
protocol CartViewProtocol: CartViewObservablesForPresenterProvider {
	var presenter: CartPresenterDriversForViewProvider! { get set }
	func observePresenter()
}

protocol CartInteractorProtocol: CartInteractorObservablesForPresenterProvider {
	var presenter: CartPresenterObservablesForInteractorProvider! { get set }
	func observePresenter()
}

protocol CartPresenterProtocol: CartPresenterDriversForViewProvider, CartPresenterObservablesForInteractorProvider, CartPresenterObservablesForRouterProvider {
	var view: CartViewObservablesForPresenterProvider! { get set }
	var interactor: CartInteractorObservablesForPresenterProvider! { get set }
	var router: CartRouterProtocol! { get set }
	func observeView()
	func observeInteractor()
}

protocol CartRouterProtocol {
	static func createModule(navController: UINavigationController) -> CartViewController
	var presenter: CartPresenterObservablesForRouterProvider! { get set }
	var navController: UINavigationController { get }
	func observePresenter()
}

// MARK: - Communication Protocols
protocol CartViewObservablesForPresenterProvider {
	var observablesForPresenter: CartViewObservablesForPresenter { get }
}

protocol CartPresenterDriversForViewProvider {
	var driversForView: CartPresenterDriversForView { get }
}

protocol CartInteractorObservablesForPresenterProvider {
	var observablesForPresenter: CartInteractorObservablesForPresenter { get }
}

protocol CartPresenterObservablesForInteractorProvider {
	var observablesForInteractor: CartPresenterObservablesForInteractor { get }
}

protocol CartPresenterObservablesForRouterProvider {
	var observablesForRouter: CartPresenterObservablesForRouter { get }
}

// MARK: - Models
struct CartViewObservablesForPresenter {
	let buyButtonTapObservable: Observable<Void>
	let emptyCartButtonTapObservable: Observable<Void>
}

struct CartPresenterDriversForView {
	let tableViewDriver: Driver<[(shopItem: ShopItem, cart: CartService)]>
	let totalCostLabelDriver: Driver<String>
	let buyButtonTitleDriver: Driver<String>
}

struct CartInteractorObservablesForPresenter {
	let cart: CartService
	let cartItemsObservable: Observable<[CartItem]>
	let totalNumberOfItemsInCartObservable: Observable<Int>
	let cartIsEmptyObservable: Observable<Void>
	let totalCostOfItemsInCartObservable: Observable<Int>
}

struct CartPresenterObservablesForInteractor {
	let buyItemsInCartObservable: Observable<Void>
	let emptyCartObservable: Observable<Void>
}

struct CartPresenterObservablesForRouter {
	let cartIsEmptyObservable: Observable<Void>
}
