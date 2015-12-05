//
//  TestFinalTests.swift
//  TestFinalTests
//
//  Created by Edward Gale on 15/11/2015.
//  Copyright © 2015 Edward Gale. All rights reserved.
//

import XCTest
@testable import TestFinal

class TestFinalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print ("Test setup")
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testGetScene() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        let scenes = huuey.scenes
        for i in scenes {
            print("\(i.getName())")
        }

        
    }
    
    func testDeepScene() {
        
        let redXY: [Float] = [0.675, 0.322]
        let greenXY: [Float] = [0.409,0.518]
        let blueXY: [Float] = [0.167,0.04]
        let huuey: Huuey = Huuey()
        huuey.getData()
        for _ in 1...10 {
            moveAlongGamutLine(redXY, endXY: greenXY, huuey: huuey)
            moveAlongGamutLine(greenXY, endXY: blueXY, huuey: huuey)
            moveAlongGamutLine(blueXY, endXY: redXY, huuey: huuey)
            
        }
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func moveAlongGamutLine(startXY: [Float], endXY: [Float], huuey: Huuey) {
        let incrementCount=10
        let xIncrement:Float = (endXY[0] - startXY[0]) / Float(incrementCount)
        let yIncrement:Float = (endXY[1] - startXY[1]) / Float(incrementCount)
        
        for count in 0...incrementCount-1 {
            
            let x: Float = startXY[0] + xIncrement*Float(count)
            let y: Float = startXY[1] + yIncrement*Float(count)
            
            print ("\(x) \(y) and the start x is \(startXY[0]) and end x is \(endXY[0]) for count \(count)")
            
            for light in huuey.lights {
                
                light.setXY(x, y: y)
                huuey.setXY(light)
                
            }
            sleep(1)
            
            //            sleep(1)
        }
    }
    
    func testWhiteScene() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        for _ in 1...10 {
            for light in huuey.lights {
                
                for ct in 0...255 {
                    print ("\(ct)")
                    light.setCT(ct)
                    huuey.setCT(light)
                }
                
                for var ct=255; ct > 0; ct-- {
                    print ("\(ct)")
                    light.setCT(ct)
                    huuey.setCT(light)
                }
            }
        }
    }
    
    func testNiceWhiteScene() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        let minCT=240
        let maxCT=255
        let ctIncrement=100
        for _ in 1...10 {
            for var ct=minCT; ct <= maxCT; ct+=ctIncrement {
                
                //            for var ct=minCT; ct <=maxCT; ct+=5 {
                for light in huuey.lights {
                    print ("\(ct)")
                    light.setCT(ct)
                    huuey.setCT(light)
                }
                sleep(1)
            }
            for var ct=maxCT; ct >= minCT; ct-=ctIncrement {
                
                //            for var ct=maxCT; ct <=minCT; ct-- {
                for light in huuey.lights {
                    print ("\(ct)")
                    light.setCT(ct)
                    huuey.setCT(light)
                }
                sleep(1)
            }
        }
    }
    
    func testEdgeToGamutCentre() {
        let redXY: [Float] = [0.675, 0.322]
        let greenXY: [Float] = [0.409,0.518]
        let blueXY: [Float] = [0.167,0.04]
        
        let gamutCentre: [Float] = [(redXY[0] + greenXY[0] + blueXY[0]) / Float(3), (redXY[1] + greenXY[1] + blueXY[1]) / Float(3)]
        
        let huuey: Huuey = Huuey()
        huuey.getData()
        moveAlongGamutLine(greenXY, endXY: gamutCentre, huuey: huuey)
    }
    
    func testEdgeToWhite() {
        let redXY: [Float] = [0.675, 0.322]
        let greenXY: [Float] = [0.409,0.518]
        let blueXY: [Float] = [0.167,0.04]
        
        let whiteXY: [Float] = [0.3127, 0.3290]
        
        let huuey: Huuey = Huuey()
        huuey.getData()
        moveAlongGamutLine(redXY, endXY: whiteXY, huuey: huuey)
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func testRGB() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        
        let light = huuey.lights[0]
        light.setUIColor(UIColor.yellowColor())
        huuey.setHSB(light)
        
        
    }
    
    func testSaturation() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        
        let light = huuey.lights[0]
        light.setUIColor(UIColor.blueColor())
        let blueXY: [Float] = [0.167,0.04]
        //        light.setXY(blueXY[0], y: blueXY[1])
        huuey.setHSB(light)
        sleep (2)
        for var count = 255; count >= 0; count-=15 {
            print ("\(light.toString())")
            light.setSaturation(count)
            huuey.sync(light)
            sleep(1)
        }
    }
    
    func testRandom() {
        let x = Float(drand48())
        let y = Float(drand48())
        
        let huuey: Huuey = Huuey()
        huuey.getData()
        let light = huuey.lights[0]
        light.setXY(x, y: y)
        print ("\(x), \(y)")
        
        huuey.setXY(light)
        
        
        
    }
    
    
    
    func testRandoms() {
        let redXY: [Float] = [0.675, 0.322]
        let greenXY: [Float] = [0.409,0.518]
        let blueXY: [Float] = [0.167,0.04]
        let huuey: Huuey = Huuey()
        huuey.getData()
        for _ in 1...2 {
            for light in huuey.lights {
                
                for ct in 0...255 {
                    print ("\(ct)")
                    light.setXY(redXY[0], y: redXY[1])
                    huuey.setXY(light)
                    
                    //                    print ("\(ct)")
                    delay(0.1) {
                        print ("***************")
                        light.setXY(redXY[0], y: redXY[1])
                        huuey.setXY(light)
                        
                    }
                    delay(0.1) {
                        light.setXY(blueXY[0], y: blueXY[1])
                        huuey.setXY(light)
                        
                    }
                }
            }
        }
    }
    
    
    
    func testTurnOn() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        huuey.set(true, lights: huuey.lights)
    }
    
    func testTurnOff() {
        let huuey: Huuey = Huuey()
        huuey.getData()
        huuey.set(false, lights: huuey.lights)
    }
    
    //    func testImageCreation() {
    //        let imgg = UIImage.imageWithColor(UIColor.greenColor())
    //
    //    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
