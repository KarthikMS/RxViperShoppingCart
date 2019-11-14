//
//  ShopPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class ShopPresenter: ShopPresenterProtocol {
	// MARK: - Properties
	var view: ShopViewObservablesForPresenterProvider! {
		didSet {
			observeView()
		}
	}
	var interactor: ShopPresenterToInteractorProtocol!
	var router: ShopPresenterToRouterProtocol!

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

extension ShopPresenter {
	func observeView() {
		view.observablesForPresenter
			.cartButtonObservable
			.subscribe { _ in
				print("Cart button tapped")
			}
			.disposed(by: disposeBag)
	}
}
