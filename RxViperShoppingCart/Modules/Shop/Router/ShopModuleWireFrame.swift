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

		bind(presenter, with: view)
		bind(presenter, with: interactor)
		bind(presenter, with: router)

		return navController
	}

	// MARK: - Util
	private static let disposeBag = DisposeBag()
}

// MARK: - Binding Presenter and View
private extension ShopModuleWireFrame {
	static func bind(_ presenter: ShopPresenterProtocol, with view: ShopViewProtocol) {
		bind(outputSocketOf: presenter, withInputSocketOf: view)
		bind(outputSocketOf: view, withInputSocketOf: presenter)
	}

	static func bind(outputSocketOf view: ShopViewProtocol, withInputSocketOf presenter: ShopPresenterProtocol) {
		view.outputSocket
			.viewWillAppearObservable
			.subscribe(presenter.inputSocketForView.viewWillAppearSubject)
			.disposed(by: disposeBag)

		view.outputSocket
			.cartButtonTapObservable
			.subscribe(presenter.inputSocketForView.cartButtonTapSubject)
			.disposed(by: disposeBag)

		view.outputSocket
			.emptyCartButtonTapObservable
			.subscribe(presenter.inputSocketForView.emptyCartButtonTapSubject)
			.disposed(by: disposeBag)
	}

	static func bind(outputSocketOf presenter: ShopPresenterProtocol, withInputSocketOf view: ShopViewProtocol) {
		presenter.outputSocketForView
			.tableViewDriverSubject
			.subscribe(view.inputSocket.tableViewDriverSubject)
			.disposed(by: disposeBag)

		presenter.outputSocketForView
			.cartButtonIsEnabledDriverSubject
			.subscribe(view.inputSocket.cartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)

		presenter.outputSocketForView
			.cartButtonTitleDriverSubject
			.subscribe(view.inputSocket.cartButtonTitleDriverSubject)
			.disposed(by: disposeBag)

		presenter.outputSocketForView
			.totalCostLabelTextDriverSubject
			.subscribe(view.inputSocket.totalCostLabelTextDriverSubject)
			.disposed(by: disposeBag)

		presenter.outputSocketForView
			.emptyCartButtonIsEnabledDriverSubject
			.subscribe(view.inputSocket.emptyCartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - Binding Presenter and Interactor
private extension ShopModuleWireFrame {
	static func bind(_ presenter: ShopPresenterProtocol, with interactor: ShopInteractorProtocol) {
		bind(outputSocketOf: presenter, withInputSocketOf: interactor)
		bind(outputSocketOf: interactor, withInputSocketOf: presenter)
	}

	static func bind(outputSocketOf presenter: ShopPresenterProtocol, withInputSocketOf interactor: ShopInteractorProtocol) {
		presenter.outputSocketForInteractor
			.fetchShopItemsObservable
			.subscribe(interactor.inputSocket.fetchShopItemsObserver)
			.disposed(by: disposeBag)

		presenter.outputSocketForInteractor
			.emptyCartObservable
			.subscribe(interactor.inputSocket.emptyCartObserver)
			.disposed(by: disposeBag)
	}

	static func bind(outputSocketOf interactor: ShopInteractorProtocol, withInputSocketOf presenter: ShopPresenterProtocol) {
		interactor.outputSocket
			.cartObservable
			.subscribe(presenter.inputSocketForInteractor.cartSubject)
			.disposed(by: disposeBag)

		interactor.outputSocket
			.shopItemsObservable
			.subscribe(presenter.inputSocketForInteractor.interactorShopItemsObservable)
			.disposed(by: disposeBag)

		interactor.outputSocket
			.cartItemsObservable
			.subscribe(presenter.inputSocketForInteractor.interactorCartItemsSubject)
			.disposed(by: disposeBag)

		interactor.outputSocket
			.totalCostOfItemsInCartObservable
			.subscribe(presenter.inputSocketForInteractor.interactorTotalCostOfItemsInCartSubject)
			.disposed(by: disposeBag)

		interactor.outputSocket
			.totalNumberOfItemsInCartObservable
			.subscribe(presenter.inputSocketForInteractor.interactorTotalNumberOfItemsInCartSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - Binding Presenter and Router
private extension ShopModuleWireFrame {
	static func bind(_ presenter: ShopPresenterProtocol, with router: ShopRouterProtocol) {
		bind(outputSocketOf: presenter, withInputSocketOf: router)
	}

	static func bind(outputSocketOf presenter: ShopPresenterProtocol, withInputSocketOf router: ShopRouterProtocol) {
		presenter.outputSocketForRouter
			.goToCartScreenObservable
			.subscribe(router.inputSocketForPresenter.presentCartViewObserver)
			.disposed(by: disposeBag)
	}
}

// MARK: - Util
private extension ShopModuleWireFrame {
	static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
