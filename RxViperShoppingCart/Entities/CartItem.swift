//
//  CartItem.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

struct CartItem {
	// MARK: - Properties
	let shopItem: ShopItem
	var count: Int

	// MARK: - Initializers
	init(shopItem: ShopItem, count: Int = 1) {
		self.shopItem = shopItem
		self.count = count
	}
}
