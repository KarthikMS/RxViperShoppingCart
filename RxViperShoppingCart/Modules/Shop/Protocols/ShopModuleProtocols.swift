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

protocol ShopInteractorProtocol: ShopPresenterToInteractorProtocol {
	var presenter: ShopInteractorToPresenterProtocol! { get set }
}

protocol ShopPresenterProtocol: ShopPresenterObservablesForViewProvider, ShopInteractorToPresenterProtocol {
	var view: ShopViewObservablesForPresenterProvider! { get set }
	var interactor: ShopPresenterToInteractorProtocol! { get set }
	var router: ShopPresenterToRouterProtocol! { get set }

	func observeView()
}

protocol ShopRouterProtocol: ShopPresenterToRouterProtocol {
	static func createModule() -> UIViewController
//	var presenter: ShopPresenterToRouterProtocol! { get set }
}

// MARK: - Communication Protocols
protocol ShopViewObservablesForPresenterProvider {
	var observablesForPresenter: ShopViewObservablesForPresenter! { get }
}

protocol ShopPresenterObservablesForViewProvider {
	var observablesForView: ShopPresenterObservablesForView! { get }
}

protocol ShopInteractorToPresenterProtocol {

}

protocol ShopPresenterToInteractorProtocol {

}

protocol ShopPresenterToRouterProtocol {

}

// MARK: - Models
struct ShopViewObservablesForPresenter {
	let cartButtonTapObservable: Observable<Void>
}

struct ShopPresenterObservablesForView {
	let cartButtonIsEnabledDriver: Driver<Bool>
	let cartButtonTitleDriver: Driver<String>
}
