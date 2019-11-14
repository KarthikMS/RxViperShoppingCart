//
//  ShopModuleProtocols.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - Definition Protocols
protocol ShopViewProtocol: ShopViewObservablesForPresenterProvider {
	var presenter: ShopViewToPresenterProtocol! { get set }
}

protocol ShopInteractorProtocol: ShopPresenterToInteractorProtocol {
	var presenter: ShopInteractorToPresenterProtocol! { get set }
}

protocol ShopPresenterProtocol: ShopViewToPresenterProtocol, ShopInteractorToPresenterProtocol {
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

protocol ShopViewToPresenterProtocol {

}

protocol ShopInteractorToPresenterProtocol {

}

protocol ShopPresenterToInteractorProtocol {

}

protocol ShopPresenterToRouterProtocol {

}

struct ShopViewObservablesForPresenter {
	let cartButtonObservable: Observable<Void>
}
