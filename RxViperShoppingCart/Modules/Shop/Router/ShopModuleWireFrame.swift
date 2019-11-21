//
//  ShopModuleWireFrame.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 22/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift

class ShopModuleWireFrame {
	static func createModule() -> UIViewController {
		guard let navController = mainStoryboard.instantiateInitialViewController() as? UINavigationController,
			let view = navController.children.first as? ShopViewController else {
				assertionFailure()
				return UINavigationController()
		}

		let presenter = ShopPresenter()
		let interactor = ShopInteractorAssembler.createInstance()
		let router = ShopRouter(presenter: presenter, navController: navController)

		view.presenter = presenter
		presenter.view = view
		interactor.presenter = presenter
		presenter.interactor = interactor
		presenter.router = router

		//		presenter.bindInputsFromView()
		bind(presenter, with: view)
		bind(presenter, with: interactor)
		bind(presenter, with: router)

		//		presenter.bindInputsFromInteractor()

		return navController
	}

	// MARK: - Util
	private static let disposeBag = DisposeBag()
}

// MARK: - Binding
private extension ShopModuleWireFrame {
	static func bind(_ presenter: ShopPresenterProtocol, with view: ShopViewProtocol) {
		view
			.viewDidLoadObservable
			.subscribe(presenter.viewDidLoadSubject)
			.disposed(by: disposeBag)

		view
			.cartButtonTapObservable
			.subscribe(presenter.cartButtonTapSubject)
			.disposed(by: disposeBag)

		view
			.emptyCartButtonTapObservable
			.subscribe(presenter.emptyCartButtonTapSubject)
			.disposed(by: disposeBag)

		presenter
			.tableViewDriverSubject
			.subscribe(view.tableViewDriverSubject)
			.disposed(by: disposeBag)

		presenter
			.cartButtonIsEnabledDriverSubject
			.subscribe(view.cartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)

		presenter
			.cartButtonTitleDriverSubject
			.subscribe(view.cartButtonTitleDriverSubject)
			.disposed(by: disposeBag)

		presenter
			.totalCostLabelTextDriverSubject
			.subscribe(view.totalCostLabelTextDriverSubject)
			.disposed(by: disposeBag)

		presenter
			.emptyCartButtonIsEnabledDriverSubject
			.subscribe(view.emptyCartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)
	}

	static func bind(_ presenter: ShopPresenterProtocol, with interactor: ShopInteractorProtocol) {
		presenter
			.fetchShopItemsObservable
			.subscribe(interactor.fetchShopItemsObserver)
			.disposed(by: disposeBag)

		presenter
			.emptyCartObservable
			.subscribe(interactor.emptyCartObserver)
			.disposed(by: disposeBag)

		interactor
			.shopItemsObservable
			.subscribe(presenter.interactorShopItemsObservable)
			.disposed(by: disposeBag)

		interactor
			.cartItemsObservable
			.subscribe(presenter.interactorCartItemsSubject)
			.disposed(by: disposeBag)

		interactor
			.totalCostOfItemsInCartObservable
			.subscribe(presenter.interactorTotalCostOfItemsInCartSubject)
			.disposed(by: disposeBag)

		interactor
			.totalNumberOfItemsInCartObservable
			.subscribe(presenter.interactorTotalNumberOfItemsInCartSubject)
			.disposed(by: disposeBag)
	}

	static func bind(_ presenter: ShopPresenterProtocol, with router: ShopRouterProtocol) {
		presenter
			.goToCartScreenObservable
			.subscribe(router.presentCartViewObserver)
			.disposed(by: disposeBag)
	}
}

// MARK: - Util
private extension ShopModuleWireFrame {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
