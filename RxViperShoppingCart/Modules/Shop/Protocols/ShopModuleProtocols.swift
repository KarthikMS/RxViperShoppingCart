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

	func observePresenter()
}

protocol ShopInteractorProtocol: ShopInteractorObservablesForPresenterProvider {
	var presenter: ShopPresenterObservablesForInteractorProvider! { get set }
}

protocol ShopPresenterProtocol: ShopPresenterObservablesForViewProvider, ShopPresenterObservablesForInteractorProvider {
	var view: ShopViewObservablesForPresenterProvider! { get set }
	var interactor: ShopInteractorObservablesForPresenterProvider! { get set }
	var router: ShopPresenterToRouterProtocol! { get set }

	func observeView()
}

protocol ShopRouterProtocol: ShopPresenterToRouterProtocol {
	static func createModule() -> UIViewController
//	var presenter: ShopPresenterToRouterProtocol! { get set }
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

protocol ShopPresenterToRouterProtocol {

}

// MARK: - Models
struct ShopViewObservablesForPresenter {
	let viewDidLoadObservable: Observable<Void>
	let cartButtonTapObservable: Observable<Void>
}

struct ShopPresenterObservablesForView {
	let tableViewDriver: Driver<[(item: ShopItem, cart: CartService)]>
	let cartButtonIsEnabledDriver: Driver<Bool>
	let cartButtonTitleDriver: Driver<String>
	let totalCostLabelTextDriver: Driver<String>
}

struct ShopInteractorObservablesForPresenter {
	let cart: CartService
	let shopItemsObservable: Observable<[ShopItem]>
	let cartItemsObservable: Observable<[CartItem]>
}

struct ShopPresenterObservablesForInteractor {
	let fetchShopItemsObservable: Observable<Void>
	let emptyCartObservable: Observable<Void>
}
