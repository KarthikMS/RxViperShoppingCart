//
//  Cart.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift
import RxSwiftExt

class Cart: CartService {
	// MARK: - Properties
	private var itemsSubject = BehaviorSubject<[CartItem]>(value: [])
	// del
	private let disposeBag = DisposeBag()
}

// MARK: - CartSerice
extension Cart {
	var itemsObservable: Observable<[CartItem]> {
		itemsSubject
	}

	var isEmptyObservable: Observable<Void> {
//		itemsObservable.filterMap { $0.isEmpty ? .map(Void()) : .ignore }
		totalNumberOfItemsObservable
			.map { $0 == 0 }
			.filterMap { $0 ? .map(Void()) : .ignore }
	}

	func count(of item: ShopItem) -> Int {
		items
			.first { $0.shopItem.id == item.id }?
			.count ?? 0
	}

	func countObservable(of item: ShopItem) -> Observable<Int> {
		Observable.just(count(of: item))
	}

	var totalCostObservable: Observable<Int> {
		itemsSubject.map {
			$0.reduce(0) { (total, item) -> Int in
				total + (item.count * item.shopItem.cost)
			}
		}
	}

	var totalNumberOfItemsObservable: Observable<Int> {
		itemsSubject.map {
			$0.reduce(0) { (total, item) -> Int in
				total + item.count
			}
		}
	}

	var items: [CartItem] {
		do {
			return try itemsSubject.value()
		} catch {
			assertionFailure(error.localizedDescription)
			return []
		}
	}

	func add(_ item: ShopItem) {
		var newItems = self.items

		switch isInCart(item) {
		case let .yes(index):
			newItems[index].count += 1
		case .no:
			newItems.append(CartItem(shopItem: item))
		}

		itemsSubject.onNext(newItems)
	}

	func remove(_ item: ShopItem) {
		var newItems = self.items

		switch isInCart(item) {
		case let .yes(index):
			newItems[index].count -= 1
			if newItems[index].count == 0 {
				newItems.remove(at: index)
			}
		case .no:
			assertionFailure("UI should have been disabled.")
			break
		}

		itemsSubject.onNext(newItems)
	}

	func empty() {
		itemsSubject.onNext([])
	}

}

// MARK: - Util
private extension Cart {
	func isInCart(_ item: ShopItem) -> IsItemInCart {
		for (i, cartItem) in items.enumerated() {
			let cartItemID = cartItem.shopItem.id
			if item.id == cartItemID {
				return .yes(index: i)
			}
		}
		return .no
	}
}

// MARK: - Private Models
private enum IsItemInCart {
	case yes(index: Int)
	case no
}
