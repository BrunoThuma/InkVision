//
//  AppError.swift
//  TheOfficers
//
//  Created by Bruno Thuma on 09/11/21.
//

import UIKit

enum AppError: Error{
    case noCamera
    case noDeviceInput
    case noDeviceOutput
    case defaultError
}

extension AppError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noCamera:
            return "Could not find a front facing camera."
        case .noDeviceInput:
            return "Could not create video device input."
        case .noDeviceOutput:
            return "Could not add video device input to the session"
        case .defaultError: return "1"
        }
    }
}
