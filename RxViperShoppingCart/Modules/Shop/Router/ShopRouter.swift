//
//  ShopRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift

class ShopRouter: ShopRouterProtocol {
	// MARK: - Dependencies
//	var presenter: ShopRouterInputsFromPresenterProvider!
	let presenter: ShopPresenterProtocol
	let navController: UINavigationController?

	let goToCartSubject = PublishSubject<Void>()
	var goToCartObserver: PublishSubject<Void> {
		goToCartSubject
	}

	required init(presenter: ShopPresenterProtocol, navController: UINavigationController?) {
		self.presenter = presenter
		self.navController = navController

		bindWithPresenter()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Setup
private extension ShopRouter {
	func bindWithPresenter() {
		presenter
			.goToCartScreenObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				guard let navController = self?.navController else { return }
				let cartViewController = CartRouter.createModule(navController: navController)
				navController.pushViewController(cartViewController, animated: true)
			})
			.disposed(by: disposeBag)
	}
}
//	func observePresenter() {
//		presenter.observablesForRouter
//			.cartButtonTapObservable
//			.observeOn(MainScheduler.instance)
//			.subscribe(onNext: { [weak self] in
//				guard let self = self else { return }
//				let cartViewController = CartRouter.createModule(navController: self.navController)
//				self.navController.pushViewController(cartViewController, animated: true)
//			})
//			.disposed(by: disposeBag)
//	}

// MARK: - ShopRouterProtocol
extension ShopRouter {

}

extension ShopRouter {
	var presentCartViewObserver: PublishSubject<Void> {
		PublishSubject<Void>()
	}
}
