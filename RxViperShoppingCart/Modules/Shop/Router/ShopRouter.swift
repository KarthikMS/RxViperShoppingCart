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
	let presenter: ShopPresenterProtocol
	let navController: UINavigationController?

	// MARK: - Properties
	let inputSocketForPresenter = ShopRouterInputSocketForPresenter()

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
		inputSocketForPresenter
			.presentCartViewObserver
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				guard let navController = self?.navController else { return }
				let cartViewController = CartRouter.createModule(navController: navController)
				navController.pushViewController(cartViewController, animated: true)
			})
			.disposed(by: disposeBag)
	}
}
