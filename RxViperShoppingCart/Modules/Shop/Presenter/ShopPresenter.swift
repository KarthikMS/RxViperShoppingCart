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
	var view: ShopViewProtocol!
	var interactor: ShopInteractorProtocol! {
		didSet {
//			bindInputsFromView()
//			bindInputsFromInteractor()
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

	private let cartButtonTapSub = PublishSubject<Void>()
	private let viewDidLoadSub = PublishSubject<Void>()
	private let emptyCartButtonTapSub = PublishSubject<Void>()
}

// MARK: - NEW
// MARK:
extension ShopPresenter {
	var cartButtonTapSubject: PublishSubject<Void> {
		cartButtonTapSub
	}

	var viewDidLoadSubject: PublishSubject<Void> {
		viewDidLoadSub
	}

	var emptyCartButtonTapSubject: PublishSubject<Void> {
		emptyCartButtonTapSub
	}
}

extension ShopPresenter {
	func bindInputsFromView() {
		view.viewDidLoadObservable
			.subscribe(onCompleted: { [weak self] in
				self?.interactor.fetchShopItemsObserver.onNext(())
			})
//			.subscribe(interactor.fetchShopItemsObserver)
		.disposed(by: disposeBag)

		// TODO: to router
//		view.cartButtonTapObservable

		view.emptyCartButtonTapObservable
			.subscribe(interactor.emptyCartObserver)
		.disposed(by: disposeBag)
	}

	func bindInputsFromInteractor() {
		let cart = interactor.cart

		interactor
			.shopItemsObservable
			.map { $0.map { ($0, cart) } }
			.subscribe(view.tableViewDriverSubject)
			.disposed(by: disposeBag)

		interactor
			.totalNumberOfItemsInCartObservable
			.map { String($0) }
			.subscribe(view.cartButtonTitleDriverSubject)
			.disposed(by: disposeBag)

		interactor
			.totalNumberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(view.cartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)

		interactor
			.totalCostOfItemsInCartObservable
			.map { "Total Cost: Rs.\($0)" }
			.subscribe(view.totalCostLabelTextDriverSubject)
			.disposed(by: disposeBag)

		interactor
			.totalNumberOfItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(view.emptyCartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)
	}
}
