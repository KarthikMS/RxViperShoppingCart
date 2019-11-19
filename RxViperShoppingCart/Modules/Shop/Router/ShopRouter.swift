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
	// MARK: - Properties
	var presenter: ShopPresenterObservablesForRouterProvider! {
		didSet {
			observePresenter()
		}
	}

	var navController: UINavigationController!

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - ShopRouterProtocol
extension ShopRouter {
	static func createModule() -> UIViewController {
		guard let navController = mainStoryboard.instantiateInitialViewController() as? UINavigationController,
			let view = navController.children.first as? ShopViewController else {
				assertionFailure()
				return UINavigationController()
		}

		let presenter = ShopPresenter()
		let interactor = ShopInteractorAssembler.createInstance()
		let router = ShopRouter()
		router.navController = navController

		view.presenter = presenter
		presenter.view = view
		interactor.presenter = presenter
		presenter.interactor = interactor
		router.presenter = presenter
		presenter.router = router

		return navController
	}

	func observePresenter() {
		presenter.observablesForRouter
			.cartButtonTapObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				let cartViewController = CartRouter.createModule()
				self?.navController.pushViewController(cartViewController, animated: true)
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Util
private extension ShopRouter {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
