//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import Foundation
import UIKit

class NetworkCell: UITableViewCell {
    
    @IBOutlet weak var leftAlignLine: UILabel!
    @IBOutlet weak var statusCodeLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var requestTimeTextView: CustomTextView!
    @IBOutlet weak var requestUrlTextView: CustomTextView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var statusCodeView: UIView!
    
    var index: NSInteger = 0
    
    let dateFormat :DateFormatter = DateFormatter.init();
    
   
    
    var httpModel: _HttpModel? {
        didSet {
            
            guard let serverURL = CocoaDebugSettings.shared.serverURL else {return}
            
            //域名
            requestUrlTextView.text = httpModel?.url.absoluteString
            if requestUrlTextView.text?.contains(serverURL) == true {
                if #available(iOS 8.2, *) {
                    requestUrlTextView.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
                } else {
                    // Fallback on earlier versions
                    requestUrlTextView.font = UIFont.boldSystemFont(ofSize: 13)
                }
            } else {
                if #available(iOS 8.2, *) {
                    requestUrlTextView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                } else {
                    // Fallback on earlier versions
                    requestUrlTextView.font = UIFont.systemFont(ofSize: 13)
                }
            }
            
            //请求方式
             var methodLabelText = ""
            if(httpModel?.requestHeaderFields.count ?? 0 > 0 ){
                let action = httpModel!.requestHeaderFields!["action"] as? String
                if(action?.count ?? 0 > 0){
                    methodLabelText  = "[" + action! + "]"
                }
            }
            if(methodLabelText.count == 0){
                methodLabelText = httpModel?.method ?? ""
            }
            methodLabel.text = methodLabelText
            
            //请求时间
            var timeText :String = ""
            
            if let startTime = httpModel?.startTime {
                if (startTime as NSString).doubleValue == 0 {
                    timeText.append(self.dateFormat.string(for: Date()) ?? "")
                   
                } else {
                    timeText.append(self.dateFormat.string(for: NSDate(timeIntervalSince1970: (startTime as NSString).doubleValue) as Date) ?? "")
                }
            }
          
            
            requestTimeTextView.text  = timeText
            
            //https://httpcodes.co/status/
            let successStatusCodes = ["200","201","202","203","204","205","206","207","208","226"]
            let informationalStatusCodes = ["100","101","102","103","122"]
            let redirectionStatusCodes = ["300","301","302","303","304","305","306","307","308"]
            
            //状态码
            statusCodeLabel.text = httpModel?.statusCode
            
            if successStatusCodes.contains(statusCodeLabel.text ?? "") {
                statusCodeLabel.textColor = "#42d459".hexColor
            }
            else if informationalStatusCodes.contains(statusCodeLabel.text ?? "") {
                statusCodeLabel.textColor = "#4b8af7".hexColor
            }
            else if redirectionStatusCodes.contains(statusCodeLabel.text ?? "") {
                statusCodeLabel.textColor = "#ff9800".hexColor
            }
            else {
                statusCodeLabel.textColor = "#ff0000".hexColor
            }
            
            if statusCodeLabel.text == "0" { //"0" means network unavailable
                statusCodeLabel.text = "❌"
            }
            
            //是否显示图片label
            if httpModel?.isImage == true
            {
                imageLabel.isHidden = false
                imageLabel.text = "Image"
            }
            else
            {
                //js css
                if let urlString = httpModel?.url.absoluteString {
                    if urlString.suffix(3) == ".js" {
                        imageLabel.isHidden = false
                        imageLabel.text = "JavaScript"
                    } else if urlString.suffix(4) == ".css" {
                        imageLabel.isHidden = false
                        imageLabel.text = "CSS"
                    } else {
                        imageLabel.isHidden = true
                    }
                } else {
                    imageLabel.isHidden = true
                }
            }
            
            //tag
            if httpModel?.isTag == true {
                self.contentView.backgroundColor = "#007aff".hexColor
            } else {
                self.contentView.backgroundColor = .black
            }
            
            //isSelected
            if httpModel?.isSelected == true {
                statusCodeView.backgroundColor = "#222222".hexColor
            } else {
                statusCodeView.backgroundColor = "#333333".hexColor
            }
        }
    }
    
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormat.timeZone = NSTimeZone.system
        dateFormat.dateFormat = "HH:mm:ss.SSS"
    
        imageLabel.backgroundColor = Color.mainGreen
        requestTimeTextView.textColor = Color.mainGreen
        
        requestTimeTextView.textContainer.lineFragmentPadding = 0
        requestTimeTextView.textContainerInset = .zero
        requestTimeTextView.isSelectable = false
        
        requestUrlTextView.textContainer.lineFragmentPadding = 0
        requestUrlTextView.textContainerInset = .zero
        requestUrlTextView.isSelectable = true
        
        leftAlignLine.textAlignment = .center
        leftAlignLine.textColor = .white
        leftAlignLine.adjustsFontSizeToFitWidth = true
        if #available(iOS 8.2, *) {
            leftAlignLine.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        } else {
            leftAlignLine.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    //MARK: - layoutSubviews
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        leftAlignLine.text = String(index + 1)
    }
}
