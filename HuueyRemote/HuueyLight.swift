//
//  HuueyLight.swift
//  HuueyRemote
//
//  Created by Nicholas Young on 10/21/15.
//  Copyright © 2015 Nicholas Young. All rights reserved.
//

import Foundation
import UIKit



public class HuueyLight {
    /**
        Holder variables
     */
    private var state = [String:AnyObject!]()
    private var name: String!
    private var type: String!
    private var id: Int!
    private var color: UIColor
    private var stateChangeSet:Set<String>
    
    /**
        Public initializer
     
        - Parameter: Data, JSON array from HuueyInterface
        - Parameter: id, ID of the light
     */
    public init(data: JSON, id: Int) {
        self.name = data.dictionary!["name"]!.stringValue
        self.type = data.dictionary!["type"]!.stringValue

        self.id = id
        
        for (key, value) in data["state"].dictionary! {
            if ["on", "hue", "bri", "sat", "xy", "ct", "reachable"].contains(key) {
                self.state[key] = value.object
            }
        }
            self.color = UIColor()
            stateChangeSet = Set()
    }
    
    /**
        - Returns: Id of the light
     */
    public func getId() -> Int {
        return self.id
    }
    
    /**
        - Returns: Light is on or off
     */
    public func getState() -> Bool {
        return (self.state["on"]?.boolValue)!
    }
    
    /**
        - Returns: Name of the light
     */
    public func getName() -> String {
        return self.name
    }
    
    
    /**
        - Returns: Raw value of the hue 0 - 65280.0
     */
    public func getColor() -> AnyObject {
        return self.state["hue"]!
    }
    

    /**
     - Returns: Raw value of the hue 0 - 65280.0
     */
    public func getHue() -> AnyObject {
        return self.state["hue"]!
    }

    /**
        - Returns: Saturation of the light 0 - 255
     */
    public func getSaturation() -> AnyObject {
        return self.state["sat"]!
    }
    
    public func setSaturation(saturation: Int) {
        self.state["sat"] = saturation
        stateChangeSet.insert("sat")
        
    }

    
    /**
        - Returns: Brightness of the light 0 - 255
     */
    public func getBrightness() -> AnyObject {
        return self.state["bri"]!
    }
    
    public func setBrightness(bri: Int) {
        self.state["bri"] = bri
        stateChangeSet.insert("bri")

        
    }
    
    
   
    
    public func getXY() -> AnyObject {
        return self.state["xy"]!
    }
    
    /**
     - Returns: Set X and Y values of light.
     */
    public func setXY(x: Float, y: Float) {
        let arr: AnyObject = [x, y]
        self.state["xy"] = arr
        stateChangeSet.insert("xy")
    }
    
    public func getCT() -> AnyObject {
        return self.state["ct"]!
        
    }
    
    public func setCT(ct: Int) {
        self.state["ct"] = ct
        stateChangeSet.insert("ct")

    }
    
    public func getStateChangeSet() -> Set<String> {
        return stateChangeSet
    }
    
    public func resetStateChange() {
        stateChangeSet.removeAll()
    }
    
    /**
        Updates light state
     
        - Parameter: state: Bool
     */
    public func setState(state: Bool) {
        self.state["on"] = state
    }
    
    /**
        Updates the state of the light
     
        - Parameter: hue, Hue value of the light
        - Parameter: sat, Saturation of the light
        - Parameter: bri, Brightness of the light
        - Parameter: on, Status of the light     
     */
    public func update(hue:Int, sat:Int, bri:Int, on: Bool) {
        self.state["hue"] = hue
        self.state["sat"] = sat
        self.state["bri"] = bri
//        self.state["on"] = on
    }

    /**
        Returns UIColor of the light
     
        - Returns: UIColor     
     */
   public func getUIColor() -> UIColor {
        
        var hue = CGFloat(self.getColor().integerValue)
        var sat = CGFloat(self.getSaturation().integerValue)
        var bri = CGFloat(self.getBrightness().integerValue)

        
        hue = round((hue/65280.0)*1000)/1000
        sat = round((sat/255.0)*1000)/1000
        bri = round((bri/255.0)*1000)/1000
        
        let color = UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1.0)
        
        return color
    }
    
    public func toString() ->String {
        return "XY: \(getXY()), ct: \(getCT()), hue: \(getHue()), sat: \(getSaturation()), bri: \(getBrightness()))"
    }
    
    
    /**
     Returns UIColor of the light
     
     - Returns: UIColor
     */
    public func setUIColor(color:UIColor) {
        
        self.color = color
        var cg = color.CGColor
        var components = CGColorGetComponents(cg)
        var red = components[0]
        var green = components[1]
        var blue = components[2]
        var alpha = components[3]
        
        var r = red > 0.45 ? pow((red + 0.055) / (1.0 + 0.055), 2.4) : (red / 12.92)
        var g = green > 0.04045 ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92);
        var b = blue > 0.04045 ? pow((blue + 0.055) / (1.0 + 0.055), 2.4) : (blue / 12.92);
        
        var X = red * 0.649926 + green * 0.103455 + blue * 0.197109
        var Y = red * 0.234327 + green * 0.743075 + blue * 0.022598
        var Z = red * 0.0000000 + green * 0.053077 + blue * 1.035763
        
        var x = Float(X / (X + Y + Z))
        var y = Float(Y / (X + Y + Z))
 
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alp: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alp)
        
        self.state["hue"] = Int(hue*CGFloat(65200.0))
        self.state["sat"] = Int(saturation*CGFloat(255))
        self.state["bri"] = Int(brightness*CGFloat(255))
        
        
        
        setXY(x, y: y)
        
        
        
        
//        
//        color.getHue(hue, saturation: sat, brightness: bri, alpha: alpha)
//        var hue = CGFloat(self.getColor().integerValue)
//        var sat = CGFloat(self.getSaturation().integerValue)
//        var bri = CGFloat(self.getBrightness().integerValue)
//        
//        
//        
//        hue = round((hue/65280.0)*1000)/1000
//        sat = round((sat/255.0)*1000)/1000
//        bri = round((bri/255.0)*1000)/1000
//        
//        self.state["bri"] = bri

//        let color = UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1.0)
        
//        return color
    }
    
    /** Sync light with bridge
    */
    public func sync() {
        
        
    }
    
    /** Sync light with bridge
     */
    public func sync1() {
        
        
    }

}