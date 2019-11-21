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
	var presenter: ShopPresenterProtocol!

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

//		presenter.bindInputsFromView()
		router.bind(view, and: presenter, disposeBag: router.disposeBag)
		presenter.bindInputsFromInteractor()

		return navController
	}

	func bind(_ view: ShopViewProtocol, and presenter: ShopPresenterProtocol, disposeBag: DisposeBag) {
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
}

extension ShopRouter {
	var presentCartViewObserver: PublishSubject<Void> {
		PublishSubject<Void>()
	}
}

// MARK: - Util
private extension ShopRouter {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
