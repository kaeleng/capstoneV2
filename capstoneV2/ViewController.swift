//
//  ViewController.swift
//  capstoneV2
//
//  Created by Kaelen Guthrie on 2/4/19.
//  Copyright © 2019 Kaelen Guthrie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMotion

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var distance : Double! = nil
    var steps : NSNumber! = nil
    var stepMessageTriggered = false
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        let status = CMPedometer.authorizationStatus()
        
        if status == .authorized{
//            print("authorized")
            startTrackingDistance()
        }
        
        if status == .denied || status == .notDetermined{
//            print("denied")
            let alert = UIAlertController(title: "This app requires location access", message: "Please turn allow location access for this application", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay.", style: .default) { _ in })
            self.present(alert, animated: true){}
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func startTrackingDistance() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async{
                self?.distance = pedometerData.distance?.doubleValue
                self?.steps = pedometerData.numberOfSteps
//                self?.doStuffBasedOnDistance(distance: self?.distance)
                self?.doStuffBasedOnSteps(steps: self?.steps)
                print(pedometerData.distance ?? 0)
                print("Steps: ")
                print(self?.steps)
            }
        }
    }

//    private func doStuffBasedOnDistance(distance: Double?){
//        if distance! == 1.0 {
//            print("distance 1")
//        }
//    }
    
    private func doStuffBasedOnSteps(steps: NSNumber?){
        if Int(truncating: steps!) >= 20 && stepMessageTriggered == false {
            stepMessageTriggered = true
            print("20 steps")
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
