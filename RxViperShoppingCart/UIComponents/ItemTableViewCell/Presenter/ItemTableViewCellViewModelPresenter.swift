//
//  ItemTableViewCellViewModelPresenter.swift
//  RxMVVMShoppingCartWithServer
//
//  Created by Karthik M S on 11/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxCocoa

struct ItemTableViewCellViewModelPresenter {
	// MARK: - Properties
	let nameLabelDriver: Driver<String>
	let costLabelDriver: Driver<String>
	let addToCartButtonIsEnabledDriver: Driver<Bool>
	let removeFromCartIsEnabledDriver: Driver<Bool>
	let itemCountLabelDriver: Driver<String>

	// MARK: - Initializers
	init(viewModelOutput: ItemTableViewCellViewModelOutputs) {
		self.nameLabelDriver = viewModelOutput.itemNameObservable.asDriver(onErrorJustReturn: "None")
		self.costLabelDriver = viewModelOutput.itemCostObservable
			.map { String($0) }
			.asDriver(onErrorJustReturn: "0.0")
		self.addToCartButtonIsEnabledDriver = viewModelOutput.numberOfItemsObservable
			.map { $0 != 5 }
			.asDriver(onErrorJustReturn: false)
		self.removeFromCartIsEnabledDriver = viewModelOutput.numberOfItemsObservable
			.map { $0 != 0 }
			.asDriver(onErrorJustReturn: false)
		self.itemCountLabelDriver = viewModelOutput.numberOfItemsObservable
			.map { String($0) }
			.asDriver(onErrorJustReturn: "0")
	}
}
