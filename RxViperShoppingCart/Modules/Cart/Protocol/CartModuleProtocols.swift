//
//  CartModuleProtocols.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

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
	func observeView()
	func observeInteractor()
}

protocol CartRouterProtocol {
	static func createModule(shopDataSource: ShopDataSource, cart: CartService) -> CartViewController
	var presenter: CartPresenterObservablesForRouterProvider! { get set }
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

}

struct CartPresenterDriversForView {

}

struct CartInteractorObservablesForPresenter {

}

struct CartPresenterObservablesForInteractor {

}

struct CartPresenterObservablesForRouter {

}
