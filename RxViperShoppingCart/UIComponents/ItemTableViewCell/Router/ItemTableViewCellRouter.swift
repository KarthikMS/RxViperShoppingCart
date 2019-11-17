//
//  ItemTableViewCellRouter.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

class ItemTableViewCellRouter {
	static func configure(_ view: ItemTableViewCell, for item: ShopItem, cart: CartService) {
		if view.presenter != nil {
			view.configure(for: item)
		} else {
			let interactor = ItemTableViewCellInteractor(shopItem: item, cart: cart)
			let presenter = ItemTableViewCellPresenter()

			view.presenter = presenter
			presenter.view = view

			interactor.presenter = presenter
			presenter.interactor = interactor
		}
	}
}
