//
//  VirtualFaceContent.swift
//  ARFaceTrackingApps
//
//  Created by しゅん on 2019/12/12.
//  Copyright © 2019 g-chan. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

protocol VirtualFaceContent {
    func update(withFaceAnchor: ARFaceAnchor)
}

typealias VirtualFaceNode = VirtualFaceContent & SCNNode
