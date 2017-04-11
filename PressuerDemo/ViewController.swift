//
//  ViewController.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/15/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import UIKit
import CoreMotion

let altimeterRepo = AltimeterRepository()

class ViewController: UIViewController {

 //   var onUpdate:(PAAccelerometerLogger)->Void = {_ in }
    private let motionManager = CMMotionManager()
    private var _lastAcceleration = CMAcceleration()
    
    private var lastVelocity = CMAcceleration()

    var lastAcceleration: CMAcceleration {
        get {
            return self._lastAcceleration
        }
    }
    
    var altimeter: CMAltimeter?
    var altimeterObj = Altimeter()
    
    private var startTime: TimeInterval = NSDate().timeIntervalSince1970
    @IBOutlet weak var velocity: UILabel!
    @IBOutlet weak var lbAltitudeM: UILabel!
    @IBOutlet weak var lbAltitude: UILabel!
    @IBOutlet weak var lbPressure: UILabel!
    @IBOutlet weak var tfSeaLevel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        altimeter = CMAltimeter()
        
        // default sea-level pressure = 29.92
        tfSeaLevel.text = "29.92"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
        altimeter?.stopRelativeAltitudeUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !CMAltimeter.isRelativeAltitudeAvailable() {
            let alertController = UIAlertController(title: "Alert", message: "Not support Alimeter", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            motionStart()

            altimeter?.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData, error) in
                

                let pressureInHg = (altitudeData?.pressure.doubleValue)! * 0.295301
                self.lbPressure.text = String(format:"%.2f In/Hg", pressureInHg)
                
                /*
                 A = 1,000 x ( K -- B )
                 where
                 A is the altitude indicated on the face of the altimeter, in feet
                 K is the pressure setting in the Kollsman window, in inches of mercury
                 B is the actual barometric pressure at the location of the altimeter.
                 */
                let altitude = 1000 * (Double(self.tfSeaLevel.text!)! - pressureInHg)
                self.lbAltitude.text = String(format:"%.2f ft", altitude)
                
                // altitude from feet to meter
                let altitudeM = altitude/3.2808
                self.lbAltitudeM.text = String(format:"%.2f m", altitudeM)

                // save data to local
                if abs(self.altimeterObj.alimeterM - altitudeM) > 1 {
                    self.altimeterObj.pressure = pressureInHg
                    self.altimeterObj.alimeterFt = altitude
                    self.altimeterObj.alimeterM = altitudeM
                    self.altimeterObj.pressureSeaLevel = 29.92
                    self.saveData()
                }
                
                Thread.sleep(forTimeInterval: 1)
                self.velocity.text = String(format:"x: %.2f \ny: %.2f \nz: %.2f", self.lastAcceleration.x, self.lastAcceleration.y, self.lastAcceleration.z)
            })
        }
    }
    
    func saveData() {
        let altimeter = Altimeter(pressure: altimeterObj.pressure, alimeterFt: altimeterObj.alimeterFt, alimeterM: altimeterObj.alimeterM, pressureSeaLevel: altimeterObj.pressureSeaLevel)
        altimeterRepo.add(altimeter: altimeter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func motionStart() {
        let queue = OperationQueue.main
        
        self.motionManager.startDeviceMotionUpdates(to: queue) {
            (data, error) in
            var update = data?.userAcceleration as CMAcceleration!

            
            self._lastAcceleration = update!
            //self.onUpdate(self)
            
            let now = NSDate().timeIntervalSince1970
            let time = now - self.startTime
            self.startTime = now
            
//            self.lastAcceleration = update!
            
            self.lastVelocity = self.calculateVelocity(oldVelocity: self.lastVelocity, acceleration: self.lastAcceleration, time: CGFloat(time))
            
        }
    }
    
    func stop() {
        self.motionManager.stopDeviceMotionUpdates()
        self._lastAcceleration = CMAcceleration()
    }
    
    func calculateVelocity(oldVelocity: CMAcceleration, acceleration: CMAcceleration, time: CGFloat) -> CMAcceleration {
        var lastVelocity = oldVelocity
        
        lastVelocity.x += (acceleration.x * Double(time))
        lastVelocity.y += (acceleration.y * Double(time))
        lastVelocity.z += (acceleration.z * Double(time))
        
        return lastVelocity
    }
    
    
    func calculatePosition(lastPosition: CMAcceleration, acceleration: CMAcceleration, time: CGFloat, velocity: CMAcceleration) -> CMAcceleration {
        
        var lastPos = lastPosition
        
        lastPos.x += velocity.x * Double(time) + (0.5 * acceleration.x * Double(pow(time, 2)));
        lastPos.y += velocity.y * Double(time) + (0.5 * acceleration.y * Double(pow(time, 2)));
        lastPos.z += velocity.z * Double(time) + (0.5 * acceleration.z * Double(pow(time, 2)));
        
        return lastPos
    }
    
}

