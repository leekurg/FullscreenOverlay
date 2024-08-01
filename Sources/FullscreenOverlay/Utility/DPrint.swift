//
//  DPrint.swift
//
//
//  Created by Илья Аникин on 01.08.2024.
//

func dprint(_ verbose: Bool, _ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    if verbose {
        print(items, separator: separator, terminator: terminator)
    }
    #endif
}
