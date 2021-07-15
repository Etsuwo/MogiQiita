//
//  APILoadingStatus.swift
//  MogiQiita
//
//  Created by 大谷悦志 on 2021/07/15.
//

import Foundation

enum APILoadingStatus {
    case initial
    case fetching
    case loadMore
    case full
    case error
}
