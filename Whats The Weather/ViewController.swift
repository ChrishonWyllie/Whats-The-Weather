//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Chrishon Wyllie on 2/16/16.
//  Copyright © 2016 Chrishon Wyllie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        //Gets the content from what the user puts in the text field
        //Replaces any occurences of a space with a hyphen
        //This is because people type cities like NYC and LA as "New York City"
        //and "Los Angeles". But a URL cannot have a space in it.
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        //What if the user enters an invalid city?
        //It will not result in a url that can be used and thus crash the app!
        //To prevent this, you set the above url as an attempt by NOT unwrapping it with the "!"
        //Then, you set a new variable to that attempt (called attemptedUrl just for personal clarity)
        //And place ALL OF THE CODE WITHIN THAT IF STATEMENT. Otherwise, it will not run
        if let url = attemptedUrl {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                //Since HTML code uses quotation marks, swift sees the quotation marks as the end
                //of a string and causes error. In order to fix this, put forward slashes (\) behind them to
                //tell xcode that they are a part of the entire string.
                
                //Also, the "componentsSeperatedByString" means to separate the components of the
                //HTML file by this line of HTML code. Anything before it will be the 0th element
                //in the array and anything after will be the 1st element in the array.
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                //Checks to see if the actual website actually contains the desired content
                //This means that if a division of the website content actually produces two
                //Strings, (0th and 1st place in the array), then do ....
                /*
                You must also force unwrap it because websiteArray may not exist if the website updates
                its content and the component to be separated by is removed
                */
                if websiteArray.count > 1 {
                    
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        //Replaces the HTML code for degree symbol with Swift code for degree symbol
                        //I pressed "option + 0" for that
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        
                        //Remember, you want to dispatch the operation once it is complete
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            //Remember, you use "self" because you're in a CLOSURE,
                            //and you must specify the location of the resultLabel
                            self.resultLabel.text = weatherSummary
                            
                        })
                        
                    }
                    
                }
                
                
            }
            
            if wasSuccessful == false {
                
                self.resultLabel.text = "Could not find the weather for that city. Please try again"
                
            }
            
        }
        
        task.resume()
         
            //This is what happens when you could not find the attemptedUrl
            //Or in other words, if the user enters something that does not
            //result in a valid URL, such as "!@#@#$#$" etc....
        } else {
            
            self.resultLabel.text = "Could not find the weather for that city. Please try again"
            //self.resultLabel.textColor = red
            
        }

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

