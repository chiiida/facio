//
//  HomeViewModel.swift
//  Facio
//
//  Created by Chananchida Fuachai on 13/1/2565 BE.
//

protocol HomeViewModelInput {}

protocol HomeViewModelOutput {}

protocol HomeViewModelProtocol: HomeViewModelInput, HomeViewModelOutput {}

final class HomeViewModel: HomeViewModelProtocol {}
