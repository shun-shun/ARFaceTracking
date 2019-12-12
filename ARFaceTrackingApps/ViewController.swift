//
//  ViewController.swift
//  ARFaceTrackingApps
//
//  Created by しゅん on 2019/12/12.
//  Copyright © 2019 g-chan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController,ARSessionDelegate {
    
    @IBOutlet weak var ARView: ARSCNView!
    
    var session: ARSession {
        return ARView.session
    }
    
    let contentUpdater = VirtualContentUpdater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let handler:((Bool)->Void) = { bool in
            print(bool)
        }
        //カメラへのアクセスダイアログ表示
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: handler)
        //オーディオへのアクセスダイアログ
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: handler)
        
        ARView.delegate = contentUpdater
        ARView.session.delegate = self
        ARView.automaticallyUpdatesLighting = true //シーンの照明を更新するかどうか
        
        contentUpdater.virtualFaceNode = createFaceNode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true //デバイスの自動光調節をOFF
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause() //セッション停止
    }
    
    //マスクを生成
    public func createFaceNode() -> VirtualFaceNode? {
        guard
            let device = ARView.device,
            let geometry = ARSCNFaceGeometry(device : device) else {
                return nil
        }
        
        return Mask(geometry: geometry)
    }
    
    //セッション開始
    func startSession() {
        print("STARTING A NEW SESSION")
        guard ARFaceTrackingConfiguration.isSupported else { return } //ARFaceTrackingをサポートしているか
        let configuration = ARFaceTrackingConfiguration() //顔の追跡を実行するための設定
        configuration.isLightEstimationEnabled = true //オブジェクトにシーンのライティングを提供するか
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    //MARK: - ARSessionDelegat
    //エラーの時
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        print("SESSION ERROR")
    }
    //中断した時
    func sessionWasInterrupted(_ session: ARSession) {
        print("SESSION INTERRUPTED")
    }
    //中断再開した時
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.startSession() //セッション再開
        }
    }
}
