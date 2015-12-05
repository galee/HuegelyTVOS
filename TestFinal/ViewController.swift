//
//  ViewController.swift
//  TestFinal
//
//  Created by Edward Gale on 15/11/2015.
//  Copyright © 2015 Edward Gale. All rights reserved.
//
extension UIImage {
    class func imageWithColor(color: UIColor, rect: CGRect) -> UIImage {
        //        let rect = CGRectMake(0.0, 0.0, 60.0, 60.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
}


import UIKit

class ViewController: UIViewController {
    
    var huuey: Huuey = Huuey()
    var colArr  = [UIColor]()
    var imgArr  = [UIImage]()
    var segArr  = [UISegmentedControl]()
    var buttScene  = [UIButton: HuueyScene]()

    
    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func segmentAction(sender: AnyObject) {
        print("seg clicked")
        if segArr.contains(sender as! UISegmentedControl) {
            print ("We've got the seg under control")
        }
        for light in self.huuey.lights {
            light.setUIColor(colArr[sender.selectedSegmentIndex])
            huuey.sync(light)
        }
        
        print ("segment clicked \(sender.selectedSegmentIndex)")
        
        
    }
    
    @IBAction func primAction(sender: AnyObject) {
        print("Primary Action")

        
    }
    @IBAction func touchDown(sender: AnyObject) {
           print("Touch down")
    }
    
    @IBAction func touchCancel(sender: AnyObject) {
        print("Touch Cancel")

    }
    
    
    func buttonAction(sender: AnyObject) {
        print("Button Action")
        if let scene = buttScene[sender as! UIButton] {
            huuey.set(scene)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if huuey.isReady() {
            
        }
        
        
        let rect = CGRectMake(0.0, 0.0, segment.frame.width/CGFloat(segment.numberOfSegments), segment.frame.height)
        let colIncrement = CGFloat(1)/CGFloat(segment.numberOfSegments)
        var h = CGFloat(0)
        for var index = 0; index < segment.numberOfSegments; index++ {
            
            let col = UIColor.init(hue: h, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            let imgg = UIImage.imageWithColor(col, rect: rect)
            colArr.append(col)
            imgArr.append(imgg)
            segment.setImage(imgg, forSegmentAtIndex: index)
            h+=colIncrement
        }
        
        segArr.append(segment)
        
        // Add a load of segments.
        let maxRow = 8
        for index in 1...maxRow {
            let segment_new = UISegmentedControl()
            segment_new.frame = CGRectMake(segment.frame.origin.x, segment.frame.origin.y + CGFloat(index)*segment.frame.height, segment.frame.width, segment.frame.height)
            for var count = 0; count < segment.numberOfSegments; count++ {
                segment_new.insertSegmentWithImage(imgArr[count], atIndex: count, animated: false)
            }
            segment_new.addTarget(self, action: "segmentAction", forControlEvents: UIControlEvents.TouchUpInside)
//            self.view.addSubview(segment_new)
            segArr.append(segment_new)
            
        }
        
        // End adding a load of segments.
        
        
        // Add a load of buttons.
        let scenes = huuey.scenes
        let rows = 5
        let cols = 7
        let vGap:CGFloat = 70, hGap:CGFloat=150, bWidth:CGFloat = 200, bHeight:CGFloat = 150
        
        for row in 0...rows-1{
            for col in 0...cols-1 {
                let cellCount = row*cols + col
                if cellCount > scenes.count || scenes.isEmpty {
                    break
                }
                let button   = UIButton(type: UIButtonType.System) as UIButton

                button.frame = CGRectMake(hGap + CGFloat(col) * (bWidth + hGap),  vGap + CGFloat(row) * (bHeight + vGap), bWidth, bHeight)
//                button.backgroundColor = UIColor.greenColor()
                button.setBackgroundImage(imgArr[0], forState: UIControlState.Normal)
                
                button.setTitle("\(scenes[cellCount].getName())", forState: UIControlState.Normal)
                
                button.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(10))
                print("\(scenes[cellCount].getName()) is the scene")

//                button.setTitle("\(row), \(col)", forState: UIControlState.Normal)
                button.addTarget(self, action: "buttonAction", forControlEvents: UIControlEvents.TouchUpInside)
                buttScene[button] = scenes[cellCount]
                self.view.addSubview(button)
            }
        }
        
        
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
        var setup: Bool = false
        if huuey.isReady() {
            setup = true
            
        }
        
        if !setup {
            huuey.setupWithTimeout(60) { (bridgeState) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    switch bridgeState {
                    case .BridgeNotFound:
                        self.ipLabel.text="Unable to find bridge on the network"
                        // We couldn't find the bridge on the network.
                    case .Connected:
                        self.ipLabel.text="Connection made to the bridge"
                        
                        // Object has connection to the bridge.
                    case .Disconnected:
                        self.ipLabel.text="Disconnected from Bridge"
                        
                        // Device is disconnected.
                    case .Failed:
                        self.ipLabel.text="Failed to connect to bridge - device connected."
                        
                        
                        // Either the user missed there chance to press the button or we got invalid json.
                    case .NeedAuth:
                        print("blah need aut")
                        self.ipLabel.text="Need to authorise the application."
                        self.huuey.get(HuueyGet.Api, id: 1)
                        
                        // Let the user know they need to press the blue activation button.
                    }
                }
            }
        }
    }
    
    
    
    func pressed(sender: UIButton!) {
        
        print("pressed")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



