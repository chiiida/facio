//
//  DependencyFactory+ViewModelFactoryProtocol.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

protocol ViewModelFactoryProtocol {

    func homeViewModel() -> HomeViewModelProtocol
}

extension DependencyFactory: ViewModelFactoryProtocol {

    func homeViewModel() -> HomeViewModelProtocol {
        HomeViewModel()
    }
}
