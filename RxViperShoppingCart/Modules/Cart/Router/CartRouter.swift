//
//  CartRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

class CartRouter: CartRouterProtocol {
	// MARK: - Dependencies
	var presenter: CartPresenterObservablesForRouterProvider! {
		didSet {
			observePresenter()
		}
	}

	var navController: UINavigationController

	// MARK: - Initializers
	init(navController: UINavigationController) {
		self.navController = navController
	}

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - CartRouterProtocol
extension CartRouter {
	static func createModule(navController: UINavigationController) -> CartViewController {
		guard let view = mainStoryboard.instantiateViewController(identifier: "CartScreen") as? CartViewController else {
			assertionFailure()
			return CartViewController()
		}
		let presenter = CartPresenter()
		let interactor = CartInteractorAssembler.createInstance()
		let router = CartRouter(navController: navController)

		view.presenter = presenter
		presenter.view = view
		interactor.presenter = presenter
		presenter.interactor = interactor
		router.presenter = presenter
		presenter.router = router

		return view
	}

	func observePresenter() {
		presenter.observablesForRouter
			.cartIsEmptyObservable
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				self?.goBackToShop()
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Util
private extension CartRouter {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

	private func goBackToShop() {
		navController.popViewController(animated: true)
	}
}
