//
//  PurchaseServiceImpl.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 12/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

class PurchaseServiceImpl: PurchaseService {
	// MARK: - Properties
	private let purchaseResultSubject = PublishSubject<PurchaseResult>()
}

// MARK: - PurchaseService
extension PurchaseServiceImpl {
	var purchaseResultObservable: Observable<PurchaseResult> {
		purchaseResultSubject
	}

	func purchase(_ items: [CartItem]) {
		purchaseResultSubject.onNext(.success(purchasedItems: items))
	}
}
