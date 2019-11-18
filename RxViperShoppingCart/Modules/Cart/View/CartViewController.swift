//
//  CartModuleViewController.swift
//  RxViperShoppingCart
//
//  Created by Karthik M S on 17/11/19.
//  Copyright © 2019 Zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController, CartViewProtocol {
	// MARK: - Dependencies
	var presenter: CartPresenterDriversForViewProvider!

	// MARK: - Properties
	private let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension CartViewController {
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CartViewProtocol
extension CartViewController {
	func observePresenter() {
	}
}

// MARK: - CartViewObservablesForPresenterProvider
extension CartViewController {
	var observablesForPresenter: CartViewObservablesForPresenter {
		CartViewObservablesForPresenter()
	}
}
