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
	var view: CartViewObservablesForPresenterProvider! {
		didSet {
			observeView()
		}
	}

	var interactor: CartInteractorObservablesForPresenterProvider! {
		didSet {
			observeInteractor()
		}
	}

	var router: CartRouterProtocol!

	// MARK: - Subjects for view
	private let tableViewSubject = PublishSubject<[(shopItem: ShopItem, cart: CartService)]>()
	private let totalCostLabelSubject = PublishSubject<String>()
	private let buyButtonTitleSubject = PublishSubject<String>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private var viewObservables: CartViewObservablesForPresenter!
}

// MARK: - CartPresenterProtocol
extension CartPresenter {
	func observeView() {
		// TODO: Remove this function
	}

	func observeInteractor() {
		let interactorObservables = interactor.observablesForPresenter
		let cart = interactorObservables.cart

		interactorObservables
			.cartItemsObservable
			.map { $0.map { ($0.shopItem, cart) } }
			.subscribe(tableViewSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.totalNumberOfItemsInCartObservable
			.map { "Buy \($0) items" }
			.subscribe(buyButtonTitleSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.totalCostOfItemsInCartObservable
			.map { "Total cost: Rs.\($0)" }
			.subscribe(totalCostLabelSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - CartPresenterDriversForViewProvider
extension CartPresenter {
	var driversForView: CartPresenterDriversForView {
		CartPresenterDriversForView(
			tableViewDriver: tableViewSubject.asDriver(onErrorJustReturn: []),
			totalCostLabelDriver: totalCostLabelSubject.asDriver(onErrorJustReturn: "Total cost: 0"),
			buyButtonTitleDriver: buyButtonTitleSubject.asDriver(onErrorJustReturn: "Buy 0 items")
		)
	}
}

// MARK: - CartPresenterObservablesForInteractorProvider
extension CartPresenter {
	var observablesForInteractor: CartPresenterObservablesForInteractor {
		self.viewObservables = view.observablesForPresenter

		return CartPresenterObservablesForInteractor(
			buyItemsInCartObservable: viewObservables.buyButtonTapObservable,
			emptyCartObservable: viewObservables.emptyCartButtonTapObservable
		)
	}
}

// MARK: - CartPresenterObservablesForRouterProvider
extension CartPresenter {
	var observablesForRouter: CartPresenterObservablesForRouter {
		CartPresenterObservablesForRouter()
	}
}
