//
//  ShopDataSourceImpl.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class ShopDataSourceImpl: ShopDataSource {
	// MARK: - Properties
	private let HardCodedItems = [
		ShopItem(id: "1", name: "Trimmer", cost: 10),
		ShopItem(id: "2", name: "Power Bank", cost: 20),
		ShopItem(id: "3", name: "TV", cost: 50)
	]

	private let itemsSubject = PublishSubject<[ShopItem]>()
}

// MARK: ShopDataSource
extension ShopDataSourceImpl {
	func fetchItems() {
		itemsSubject.onNext(HardCodedItems)
	}

	var itemsObservable: Observable<[ShopItem]> {
		itemsSubject
	}
}
