//
//  ItemTableViewCellViewModel.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class ItemTableViewCellViewModel {
	// MARK: - Dependencies
	private let cart: CartService
	private let item: ShopItem

	// MARK: - Properites
	let inputs: ItemTableViewCellViewModelInputs
	let outputs: ItemTableViewCellViewModelOutputs

	private let disposeBag = DisposeBag()

	// MARK: - Initializers
	init(item: ShopItem, cart: CartService) {
		self.item = item
		self.cart = cart

		self.inputs = ItemTableViewCellViewModelInputs(
			addItemToCartEventSubject: PublishSubject(),
			removeItemFromCartEventSubject: PublishSubject()
		)

		self.outputs = ItemTableViewCellViewModelOutputs(
			itemNameObservable: Observable.just(item.name),
			itemCostObservable: Observable.just(item.cost),
			numberOfItemsObservable: cart.countObservable(for: item)
		)

		handleInputs()
	}

}

// MARK: - Util
private extension ItemTableViewCellViewModel {
	func handleInputs() {
		inputs.addItemToCartEventSubject
			.subscribe(onNext: { [weak self] in
				guard let `self` = self else { return }
				self.cart.add(self.item)
			})
			.disposed(by: disposeBag)

		inputs.removeItemFromCartEventSubject
			.subscribe(onNext: { [weak self] in
				guard let `self` = self else { return }
				self.cart.remove(self.item)
			})
			.disposed(by: disposeBag)
	}
}
