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
			observeInteractor()
		}
	}

	var router: ShopPresenterToRouterProtocol!

	// MARK: - Subjects for view
	private var tableViewSubject = PublishSubject<[(item: ShopItem, cart: CartService)]>()
	private var cartButtonIsEnabledSubject = PublishSubject<Bool>()
	private var cartButtonTitleSubject = PublishSubject<String>()
	private var totalCostLabelTextSubject = PublishSubject<String>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - ShopPresenterProtocol
extension ShopPresenter {
	func observeView() {
		let viewObservables = view.observablesForPresenter!

//		viewObservables
//			.viewDidLoadObservable
//			.subscribe(interactor.observablesForPresenter.)
//			.subscribe(
//				onCompleted: { [weak self] in
//					self?.interactor.observablesForPresenter.
//			})

		viewObservables
			.cartButtonTapObservable
			.subscribe { _ in
				print("Cart button tapped")
			}
			.disposed(by: disposeBag)
	}

	func observeInteractor() {
		let interactorObservables = interactor.observablesForPresenter!
		let cart = interactorObservables.cart

		interactorObservables
			.shopItemsObservable
			.map { $0.map { ($0, cart) } }
			.subscribe(tableViewSubject)
			.disposed(by: disposeBag)

		let totalItemsInCartObservable = interactorObservables
			.cartItemsObservable
			.map { cartItems -> Int in
				return cartItems.reduce(0, { totalCount, cartItem in
					totalCount + cartItem.count
				})
			}
			.share()

		totalItemsInCartObservable
			.map { String($0) }
			.subscribe(cartButtonTitleSubject)
			.disposed(by: disposeBag)

		totalItemsInCartObservable
			.map { $0 != 0 }
			.subscribe(cartButtonIsEnabledSubject)
			.disposed(by: disposeBag)

		// TODO: Do not use cart
		cart.totalCostObservable
			.map { "Total Cost: Rs.\($0)" }
			.subscribe(totalCostLabelTextSubject)
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
			totalCostLabelTextDriver: totalCostLabelTextSubject.asDriver(onErrorJustReturn: "Total cost: Rs.0")
		)
	}
}

// MARK: - ShopPresenterObservablesForInteractorProvider
extension ShopPresenter {
	var observablesForInteractor: ShopPresenterObservablesForInteractor! {
		let viewObservables = view.observablesForPresenter!

		return ShopPresenterObservablesForInteractor(
			fetchShopItemsObservable: viewObservables.viewDidLoadObservable,
			emptyCartObservable: viewObservables.cartButtonTapObservable
		)
	}
}
