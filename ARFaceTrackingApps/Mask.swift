//
//  Mask.swift
//  ARFaceTrackingApps
//
//  Created by しゅん on 2019/12/12.
//  Copyright © 2019 g-chan. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Mask: SCNNode, VirtualFaceContent {

    init(geometry: ARSCNFaceGeometry) {
        let material = geometry.firstMaterial //初期化
        material?.diffuse.contents = UIColor.gray //マスクの色
        material?.lightingModel = .physicallyBased //オブジェクトの照明のモデル

        super.init()
        self.geometry = geometry
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    //ARアンカーがアップデートされた時に呼ぶ
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        guard let faceGeometry = geometry as? ARSCNFaceGeometry else { return }
        faceGeometry.update(from: anchor.geometry)
    }
}
