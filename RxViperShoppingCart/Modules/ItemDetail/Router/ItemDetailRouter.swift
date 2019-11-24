//
//  ItemDetailRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 24/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit

class ItemDetailRouter: ItemDetailRouterProtocol {
	static func createInstance() -> UIViewController {
		guard let viewController = mainStoryboard.instantiateViewController(identifier: "ItemDetail") as? ItemDetailViewController else {
			assertionFailure()
			return UIViewController()
		}

		var view: ItemDetailViewProtocol = viewController
		var presenter: ItemDetailPresenterProtocol = ItemDetailPresenter()

		view.presenter = presenter
		presenter.view = view

		return viewController
	}
}
