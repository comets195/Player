//
//  State.swift
//  Player
//
//  Created by DongJin Lee on 2021/07/01.
//

import Foundation

final class State<Value> {
    typealias Listener = (Value?) -> ()
    
    var value: Value? {
        didSet { listener?(value) }
    }
    
    private var listener: Listener?
    
    init(_ value: Value?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
    }
}
