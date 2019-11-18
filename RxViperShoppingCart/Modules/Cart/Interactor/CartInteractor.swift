//
//  CartModuleInteractor.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class CartInteractor: CartInteractorProtocol {
	// MARK: - Dependencies
	var presenter: CartPresenterObservablesForInteractorProvider!

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - CartInteractorProtocol
extension CartInteractor {
	func observePresenter() {

	}
}

// MARK: - CartInteractorObservablesForPresenterProvider
extension CartInteractor {
	var observablesForPresenter: CartInteractorObservablesForPresenter {
		CartInteractorObservablesForPresenter()
	}
}
