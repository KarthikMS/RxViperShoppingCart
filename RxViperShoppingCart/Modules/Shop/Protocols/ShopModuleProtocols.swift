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

// MARK: - Definition Protocols
protocol ShopViewProtocol: ShopViewObservablesForPresenterProvider {
	var presenter: ShopPresenterObservablesForViewProvider! { get set }
	var navigationController: UINavigationController? { get }
	func observePresenter()
}

protocol ShopInteractorProtocol: ShopInteractorObservablesForPresenterProvider {
	var presenter: ShopPresenterObservablesForInteractorProvider! { get set }
	func observePresenter()
}

protocol ShopPresenterProtocol: ShopPresenterObservablesForViewProvider, ShopPresenterObservablesForInteractorProvider, ShopPresenterObservablesForRouterProvider {
	var view: ShopViewObservablesForPresenterProvider! { get set }
	var interactor: ShopInteractorObservablesForPresenterProvider! { get set }
	var router: ShopRouterProtocol! { get set }
	func observeView()
	func observeInteractor()
}

protocol ShopRouterProtocol {
	static func createModule() -> UIViewController
	var presenter: ShopPresenterObservablesForRouterProvider! { get set }
	var navController: UINavigationController! { get set }
	func observePresenter()
}

// MARK: - Communication Protocols
// TODO: Try removing optionals
protocol ShopViewObservablesForPresenterProvider {
	var observablesForPresenter: ShopViewObservablesForPresenter! { get }
}

protocol ShopPresenterObservablesForViewProvider {
	var observablesForView: ShopPresenterObservablesForView! { get }
}

protocol ShopInteractorObservablesForPresenterProvider {
	var observablesForPresenter: ShopInteractorObservablesForPresenter! { get }
}

protocol ShopPresenterObservablesForInteractorProvider {
	var observablesForInteractor: ShopPresenterObservablesForInteractor! { get }
}

protocol ShopPresenterObservablesForRouterProvider {
	var observablesForRouter: ShopPresenterObservablesForRouter! { get }
}

// MARK: - Models
struct ShopViewObservablesForPresenter {
	let viewDidLoadObservable: Observable<Void>
	let cartButtonTapObservable: Observable<Void>
	let emptyCartButtonTapObservable: Observable<Void>
}

struct ShopPresenterObservablesForView {
	let tableViewDriver: Driver<[(item: ShopItem, cart: CartService)]>
	let cartButtonIsEnabledDriver: Driver<Bool>
	let cartButtonTitleDriver: Driver<String>
	let totalCostLabelTextDriver: Driver<String>
	let emptyCartButtonIsEnabledDriver: Driver<Bool>
}

struct ShopInteractorObservablesForPresenter {
	let cart: CartService
	let shopItemsObservable: Observable<[ShopItem]>
	let cartItemsObservable: Observable<[CartItem]>
	let totalNumberOfItemsInCartObservable: Observable<Int>
	let totalCostOfItemsInCartObservable: Observable<Int>
}

struct ShopPresenterObservablesForInteractor {
	let fetchShopItemsObservable: Observable<Void>
	let emptyCartObservable: Observable<Void>
}

struct ShopPresenterObservablesForRouter {
	let cartButtonTapObservable: Observable<Void>
}
