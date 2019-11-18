//
//  CartPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

class CartPresenter: CartPresenterProtocol {
	// MARK: - Dependencies
	var view: CartViewObservablesForPresenterProvider!
	var interactor: CartInteractorObservablesForPresenterProvider!

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - CartPresenterProtocol
extension CartPresenter {
	func observeView() {
	}

	func observeInteractor() {
	}
}

// MARK: - CartPresenterDriversForViewProvider
extension CartPresenter {
	var driversForView: CartPresenterDriversForView {
		CartPresenterDriversForView()
	}
}

// MARK: - CartPresenterObservablesForInteractorProvider
extension CartPresenter {
	var observablesForInteractor: CartPresenterObservablesForInteractor {
		CartPresenterObservablesForInteractor()
	}
}

// MARK: - CartPresenterObservablesForRouterProvider
extension CartPresenter {
	var observablesForRouter: CartPresenterObservablesForRouter {
		CartPresenterObservablesForRouter()
	}
}
