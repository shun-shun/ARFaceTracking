//
//  VirtualContentUpdater.swift
//  ARFaceTrackingApps
//
//  Created by しゅん on 2019/12/12.
//  Copyright © 2019 g-chan. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class VirtualContentUpdater: NSObject, ARSCNViewDelegate {

    //表示 or 更新用
    var virtualFaceNode: VirtualFaceNode? {
        didSet {
            setupFaceNodeContent()
        }
    }
    //セッションを再起動する必要がないように保持用
    private var faceNode: SCNNode?

    private let serialQueue = DispatchQueue(label: "com.example.serial-queue")

    //マスクのセットアップ
    private func setupFaceNodeContent() {
        guard let faceNode = faceNode else { return }

        //全ての子ノードを消去
        for child in faceNode.childNodes {
            child.removeFromParentNode()
        }
        //新しいノードを追加
        if let content = virtualFaceNode {
            faceNode.addChildNode(content)
        }
    }

    //MARK: - ARSCNViewDelegate
    //新しいARアンカーが設置された時に呼び出される
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }

    //ARアンカーが更新された時に呼び出される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        virtualFaceNode?.update(withFaceAnchor: faceAnchor) //マスクをアップデートする
    }
}
