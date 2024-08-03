//
//  DeviceOrientation.swift
//
//
//  Created by Илья Аникин on 03.08.2024.
//

import Combine
import UIKit

@Observable final class DeviceOrientation {
    var current: Orientation
    var isPortrait: Bool { current == .portrait }

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        current = UIDevice.current.orientation.isLandscape ? .landscape : .portrait

        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { $0.object as? UIDevice }
            .map { device in
                device.orientation.isLandscape ? Orientation.landscape : Orientation.portrait
            }
            .sink { [weak self] orientation in
                self?.current = orientation
            }
            .store(in: &cancellables)
    }
}

extension DeviceOrientation {
    enum Orientation {
        case portrait, landscape
    }
}
