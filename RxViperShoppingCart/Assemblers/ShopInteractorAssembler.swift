//
//  ShopInteractorAssembler.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 15/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

class ShopInteractorAssembler {
	static func createInstance() -> ShopInteractor {
		ShopInteractor(
			cart: CartServiceAssembler.shared,
			shopDataSource: ShopDataSourceAssembler.shared
		)
	}
}
