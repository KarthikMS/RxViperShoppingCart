//
//  ShopRouterProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 22/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - ROUTER
protocol ShopRouterProtocol {
	init(presenter: ShopPresenterProtocol, navController: UINavigationController?)

	var inputSocketForPresenter: ShopRouterInputSocketForPresenter { get }
}

// PRESENTER -> ROUTER
struct ShopRouterInputSocketForPresenter {
	let presentCartViewObserver = PublishSubject<Void>()
}
