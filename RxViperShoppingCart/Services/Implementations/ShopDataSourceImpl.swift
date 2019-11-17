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
		ShopItem(id: "1", name: "Apple", cost: 10),
		ShopItem(id: "2", name: "Ball", cost: 20),
		ShopItem(id: "3", name: "Crayon", cost: 30),
		ShopItem(id: "4", name: "Desk", cost: 40),
		ShopItem(id: "5", name: "Eraser", cost: 50),
		ShopItem(id: "6", name: "Flower", cost: 60),
		ShopItem(id: "7", name: "Gel", cost: 70),
		ShopItem(id: "8", name: "Hat", cost: 80),
		ShopItem(id: "9", name: "Ink", cost: 90),
		ShopItem(id: "10", name: "Jug", cost: 100)
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
