//
//  ItemDetailViewProtocol.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 24/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import RxSwift

protocol ItemDetailViewProtocol: ItemDetailPresenterToViewProtocol {
	var presenter: ItemDetailViewToPresenterProtocol! { get set }
}

protocol ItemDetailPresenterToViewProtocol {
	var inputFromPresenter: ItemDetailViewInputFromPresenter { get }
}

struct ItemDetailViewInputFromPresenter {
	let itemNameLabelTextDriverSubject = PublishSubject<String>()
	let itemCostLabelTextDriverSubject = PublishSubject<String>()
}





protocol ItemDetailPresenterProtocol: ItemDetailViewToPresenterProtocol {
	var view: ItemDetailPresenterToViewProtocol! { get set }
}

protocol ItemDetailViewToPresenterProtocol {
	var inputFromView: ItemDetailPresenterInputFromView { get }
}

struct ItemDetailPresenterInputFromView {
	let testSubject = PublishSubject<Void>()
}
