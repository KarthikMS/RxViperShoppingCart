//
//  PurchaseService.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 12/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol PurchaseService {
	var purchaseResultObservable: Observable<PurchaseResult> { get }
	func purchase(_ items: [CartItem])
}
