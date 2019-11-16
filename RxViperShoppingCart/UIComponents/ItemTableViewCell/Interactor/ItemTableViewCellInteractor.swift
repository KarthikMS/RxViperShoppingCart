//
//  ItemTableViewCellInteractor.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 15/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

struct ItemTableViewCellInteractorObservablesForPresenter {
	let itemObservable: Observable<ShopItem>
	let numberOfItemsInCartObservable: Observable<Int>
}

protocol ItemTableViewCellInteractorObservablesForPresenterProvider {
	var observablesForPresenter: ItemTableViewCellInteractorObservablesForPresenter! { get }
}

class ItemTableViewCellInteractor: ItemTableViewCellInteractorObservablesForPresenterProvider {
	// MARK: - Dependencies
	private let item: ShopItem
	private let cart: CartService

	var presenter: ItemTableViewCellPresenterObservablesForInteractorProvider! {
		didSet {
			observePresenter()
		}
	}

	// MARK: - Initializers
	init(item: ShopItem, cart: CartService) {
		self.item = item
		self.cart = cart
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()

	func observePresenter() {
		presenter.observablesForInteractor
			.addItemToCartObservable
			.subscribe(
				onNext: { [weak self] in
					guard let self = self else { return }
					self.cart.add(self.item)
				}
		)
			.disposed(by: disposeBag)

		presenter.observablesForInteractor
			.removeItemToCartObservable
			.subscribe(
				onNext: { [weak self] in
					guard let self = self else { return }
					self.cart.remove(self.item)
				}
		)
			.disposed(by: disposeBag)
	}
}

// MARK: - ItemTableViewCellInteractorObservablesForPresenterProvider
extension ItemTableViewCellInteractor {
	var observablesForPresenter: ItemTableViewCellInteractorObservablesForPresenter! {
		ItemTableViewCellInteractorObservablesForPresenter(
			itemObservable: Observable.just(item),
			numberOfItemsInCartObservable: cart.countObservable(for: item)
		)
	}
}
