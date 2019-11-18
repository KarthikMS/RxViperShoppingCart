//
//  ShopPresenter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 13/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxCocoa

class ShopPresenter: ShopPresenterProtocol {
	// MARK: - Dependencies
	var view: ShopViewObservablesForPresenterProvider! {
		didSet {
			observeView()
		}
	}

	var interactor: ShopInteractorObservablesForPresenterProvider! {
		didSet {
//			observeInteractor()
		}
	}

	var router: ShopRouterProtocol!

	// MARK: - Subjects for view
	private var tableViewSubject = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	private var cartButtonIsEnabledSubject = PublishSubject<Bool>()
	private var cartButtonTitleSubject = PublishSubject<String>()
	private var totalCostLabelTextSubject = PublishSubject<String>()
	private let emptyCartButtonIsEnabledSubject = PublishSubject<Bool>()

	// MARK: - Subjects for interactor
	private let fetchShopItemsSubject = PublishSubject<Void>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private var viewObservables: ShopViewObservablesForPresenter!
}

// MARK: - ShopPresenterProtocol
extension ShopPresenter {
	func observeView() {
		self.viewObservables = view.observablesForPresenter!

		viewObservables
			.viewDidLoadObservable
			.subscribe(onCompleted: { [weak self] in
				self?.observeInteractor()
				self?.fetchShopItemsSubject.onNext(())
			})
		.disposed(by: disposeBag)
	}

	func observeInteractor() {
		let interactorObservables = interactor.observablesForPresenter!
		let cart = interactorObservables.cart

		interactorObservables
			.shopItemsObservable
			.map { $0.map { ($0, cart) } }
			.subscribe(onNext: { [weak self] in
				self?.tableViewSubject.onNext($0)
			})
//			.subscribe(tableViewSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.totalNumberOfItemsInCartObservable
			.map { String($0) }
			.subscribe(cartButtonTitleSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.totalNumberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(onNext: { [weak self] in
				self?.cartButtonIsEnabledSubject.onNext($0)
			})
			.disposed(by: disposeBag)

		interactorObservables
			.totalCostOfItemsInCartObservable
			.map { "Total Cost: Rs.\($0)" }
			.subscribe(totalCostLabelTextSubject)
			.disposed(by: disposeBag)

		interactorObservables
			.totalNumberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(emptyCartButtonIsEnabledSubject)
			.disposed(by: disposeBag)
	}
}

// MARK: - ShopPresenterObservablesForViewProvider
extension ShopPresenter {
	var observablesForView: ShopPresenterObservablesForView! {
		ShopPresenterObservablesForView(
			tableViewDriver: tableViewSubject.asDriver(onErrorJustReturn: []),
			cartButtonIsEnabledDriver: cartButtonIsEnabledSubject.asDriver(onErrorJustReturn: false),
			cartButtonTitleDriver: cartButtonTitleSubject.asDriver(onErrorJustReturn: "0"),
			totalCostLabelTextDriver: totalCostLabelTextSubject.asDriver(onErrorJustReturn: "Total cost: Rs.0"),
			emptyCartButtonIsEnabledDriver: emptyCartButtonIsEnabledSubject.asDriver(onErrorJustReturn: false)
		)
	}
}

// MARK: - ShopPresenterObservablesForInteractorProvider
extension ShopPresenter {
	var observablesForInteractor: ShopPresenterObservablesForInteractor! {
		ShopPresenterObservablesForInteractor(
			fetchShopItemsObservable: fetchShopItemsSubject,
			emptyCartObservable: viewObservables.emptyCartButtonTapObservable
		)
	}
}

// MARK: - ShopPresenterObservablesForRouterProvider
extension ShopPresenter {
	var observablesForRouter: ShopPresenterObservablesForRouter! {
		ShopPresenterObservablesForRouter(
			cartButtonTapObservable: viewObservables!.cartButtonTapObservable
		)
	}
}
