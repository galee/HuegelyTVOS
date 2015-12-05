//: Playground - noun: a place where people can play

import UIKit


let delay = 0.1 * Double(NSEC_PER_SEC)
print("\(delay)")
let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
dispatch_after(time, dispatch_get_main_queue()) {
    print("in the dispatch after time")
    
}



var str = "Hello, playground"
var k: Double = 1.02342

var data :[String:AnyObject] = ["hue":232]

var button = UIButton();
button.backgroundColor = UIColor.blueColor()
var cg = button.backgroundColor?.CGColor


var point = CGColorGetComponents(cg)
CGColorGetNumberOfComponents(cg)

var hue=CGColorGetComponents(cg)[0]
var sat=CGColorGetComponents(cg)[1]
var bri=CGColorGetComponents(cg)[2]
var alp=CGColorGetComponents(cg)[3]

CGColorGetColorSpace(cg)
CGColorGetPattern(cg)
CGColorGetTypeID()

var col1 = UIColor(CGColor: cg!)
var h: CGFloat
var s: CGFloat
var b: CGFloat
var a: CGFloat
//col1.getHue(hue: h, saturation: s, brightness: b, alpha: a)


if (CGColorGetNumberOfComponents(cg) == 4) {
    var components = CGColorGetComponents(cg)
    components[0]
    var red = components[0]
    var green = components[1]
    var blue = components[2]
    var alpha = components[3]
    
    pow(green, 3.0)
    
    var r = red > 0.45 ? pow((red + 0.055) / (1.0 + 0.055), 2.4) : (red / 12.92)
    var g = green > 0.04045 ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92);
    var b = blue > 0.04045 ? pow((blue + 0.055) / (1.0 + 0.055), 2.4) : (blue / 12.92);

    var X = red * 0.649926 + green * 0.103455 + blue * 0.197109
    var Y = red * 0.234327 + green * 0.743075 + blue * 0.022598
    var Z = red * 0.0000000 + green * 0.053077 + blue * 1.035763
    
    var x = X / (X + Y + Z)
    var y = Y / (X + Y + Z)
    
}


//var r = red > 0.45 ? pow((red + 0.055) / (1.0 + 0.055), 2.4) : (red / 12.92)

