//
//  ShopRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit

class ShopRouter: ShopRouterProtocol {
	// MARK: - Properties
	var presenter: ShopPresenterToRouterProtocol!
}

// MARK: - ShopRouterProtocol
extension ShopRouter {
	static func createModule() -> UIViewController {
		guard let navController = mainStoryboard.instantiateInitialViewController(),
			let view = navController.children.first as? ShopViewController else {
				assertionFailure()
				return UINavigationController()
		}
		let presenter = ShopPresenter()
		let interactor = ShopInteractorAssembler.createInstance()
		let router = ShopRouter()

		view.presenter = presenter

		presenter.view = view

		interactor.presenter = presenter
		presenter.router = router
		presenter.interactor = interactor
//		router.presenter = presenter

		return navController
	}
}

// MARK: - Util
private extension ShopRouter {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
