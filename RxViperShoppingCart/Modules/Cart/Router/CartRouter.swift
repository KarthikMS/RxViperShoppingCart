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
	var presenter: CartPresenterObservablesForRouterProvider!

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - CartRouterProtocol
extension CartRouter {
	static func createModule(shopDataSource: ShopDataSource, cart: CartService) -> CartViewController {
		guard let view = mainStoryboard.instantiateViewController(identifier: "CartScreen") as? CartViewController else {
			assertionFailure()
			return CartViewController()
		}
		let presenter = CartPresenter()
		let interactor = CartInteractor()
		let router = CartRouter()

		view.presenter = presenter
		presenter.view = view
		interactor.presenter = presenter
		presenter.interactor = interactor
		router.presenter = presenter

		return view
	}

	func observePresenter() {
	}
}

// MARK: - Util
private extension CartRouter {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
