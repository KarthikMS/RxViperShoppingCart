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
	var interactor: ShopInteractorProtocol!
	var router: ShopRouterProtocol!

	// MARK: - Properties
	let inputSocketForView = ShopPresenterInputSocketForView()
	let outputSocketForView = ShopPresenterOutputSocketForView()
	let inputSocketForInteractor = ShopPresenterInputSocketForInteractor()
	let outputSocketForInteractor = ShopPresenterOutputSocketForInteractor()
	let outputSocketForRouter = ShopPresenterOutputSocketForRouter()

	// MARK: - Initializations
	init() {
		handleInputsFromView()
		handleInputsFromInteractor()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Setup
private extension ShopPresenter {
	func handleInputsFromView() {
		inputSocketForView
			.viewWillAppearSubject
			.subscribe(outputSocketForInteractor.fetchShopItemsObservable)
			.disposed(by: disposeBag)

		inputSocketForView
			.emptyCartButtonTapSubject
			.subscribe(outputSocketForInteractor.emptyCartObservable)
			.disposed(by: disposeBag)

		inputSocketForView
			.cartButtonTapSubject
			.subscribe(outputSocketForRouter.goToCartScreenObservable)
			.disposed(by: disposeBag)
	}

	func handleInputsFromInteractor() {
		inputSocketForInteractor
			.interactorShopItemsObservable
			.map { shopItems in
				shopItems.map { [weak self] shopItem in
					guard let self = self,
						let cart = try? self.inputSocketForInteractor.cartSubject.value() else {
							assertionFailure()
							return (shopItem, Cart()) }
					return (shopItem, cart)
				}
			}
			.subscribe(outputSocketForView.tableViewDriverSubject)
			.disposed(by: disposeBag)

		inputSocketForInteractor
			.interactorTotalNumberOfItemsInCartSubject
			.map { String($0) }
		.debug("Presenter: interactorTotalNumberOfItemsInCartSubject")
			.subscribe(outputSocketForView.cartButtonTitleDriverSubject)
			.disposed(by: disposeBag)

		inputSocketForInteractor
			.interactorTotalNumberOfItemsInCartSubject
			.map { $0 != 0 }
			.subscribe(outputSocketForView.cartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)

		inputSocketForInteractor
			.interactorTotalCostOfItemsInCartSubject
			.map { "Total Cost: Rs.\($0)" }
			.subscribe(outputSocketForView.totalCostLabelTextDriverSubject)
			.disposed(by: disposeBag)

		inputSocketForInteractor
			.interactorTotalNumberOfItemsInCartSubject
			.map { $0 != 0 }
			.subscribe(outputSocketForView.emptyCartButtonIsEnabledDriverSubject)
			.disposed(by: disposeBag)
	}
}
