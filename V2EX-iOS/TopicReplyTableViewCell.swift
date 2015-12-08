//
//  TopicReplyTableViewCell.swift
//  V2EX-iOS
//
//  Created by ciel on 15/12/3.
//  Copyright © 2015年 CL. All rights reserved.
//

import UIKit
import DTCoreText
import Cartography
import Kingfisher
import Async

class TopicReplyTableViewCell: UITableViewCell, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    var memberButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return button
    }()
    
    var createdTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    lazy var thanksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    lazy var contentLabel: DTAttributedLabel = {
        [unowned self] in
        let label = DTAttributedLabel(frame: CGRectMake(0, 0, self.bounds.size.width, 10))
        label.delegate = self
        label.shouldDrawImages = false
        label.shouldLayoutCustomSubviews = true
        return label
    }()
    
    var contentLabelHeight: CGFloat = 1
    
    var replyModel: TopicReplyModel? {
        willSet(replyModel){
            
            let url = NSURL(string:replyModel!.avatarURL())!
            avatarImageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [KingfisherOptionsInfoItem.Options(KingfisherOptions.None)]) { (image, error, cacheType, imageURL) -> () in
                if let image = image {
                    Async.main(block: { () -> Void in
                        UIGraphicsBeginImageContextWithOptions(self.avatarImageView.bounds.size, false, 1.0)
                        UIBezierPath.init(roundedRect: self.avatarImageView.bounds, cornerRadius: 3.0).addClip()
                        image.drawInRect(self.avatarImageView.bounds)
                        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
                        self.avatarImageView.image = finalImage
                        UIGraphicsEndImageContext()
                    })
                }
            }
            
            memberButton.setTitle(replyModel!.member?.username, forState: .Normal)
            createdTimeLabel.text = V2EXHelper.dateFormat(replyModel!.created!)
            if let thanks = replyModel!.thanks {
                thanksLabel.text = "\(thanks)"
            }
            
            var dic = [String: AnyObject]()
            dic[NSDocumentTypeDocumentAttribute] = NSHTMLTextDocumentType
            dic[NSCharacterEncodingDocumentAttribute] = "\(NSUTF8StringEncoding)"
            
            let options = [DTDefaultFontSize: NSNumber(float: 15),
                DTMaxImageSize: NSValue.init(CGSize: CGSizeMake(self.bounds.width - 20, self.bounds.height - 60)),
                NSBaseURLDocumentOption: NSURL.fileURLWithPath(V2EX_BASE_URL, isDirectory: true),
                DTDefaultLinkColor: "#778087"
            ]
            
            let att = DTHTMLAttributedStringBuilder(HTML: replyModel!.content_rendered?.dataUsingEncoding(NSUTF8StringEncoding), options: options, documentAttributes: nil)
            contentLabel.attributedString = att.generatedAttributedString()
//            let width = self.bounds.width - MARGIN_TO_BOUNDARY * 2 - 50 - SPACING_BEWTWEEN_COMPONENTS
//            let size = self.contentLabel!.suggestedFrameSizeToFitEntireStringConstraintedToWidth(width)
//            self.contentLabelHeight = size.height
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        UILayout()
    }
    
    func UILayout() {
//        addSubview(avatarImageView)
//        addSubview(memberButton)
//        addSubview(createdTimeLabel)
//        addSubview(thanksLabel)
        addSubview(contentLabel)
//        
////        avatarImageView!.backgroundColor = UIColor.redColor()
//        memberButton.backgroundColor = UIColor.greenColor()
//        createdTimeLabel.backgroundColor = UIColor.grayColor()
//        thanksLabel.backgroundColor = UIColor.blueColor()
        contentLabel.backgroundColor = UIColor.yellowColor()
//
//        memberButton.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Horizontal)
//        memberButton.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Vertical)
//        
//        createdTimeLabel.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Horizontal)
//        thanksLabel.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Horizontal)
//        
//        constrain(avatarImageView) { v in
//            let width: CGFloat = 50
//            v.width == width
//            v.height == width
//            v.top == v.superview!.top + MARGIN_TO_BOUNDARY
//            v.left == v.superview!.left + MARGIN_TO_BOUNDARY
//        }
//        
//        
//        constrain(memberButton, createdTimeLabel, thanksLabel, avatarImageView) { v1, v2, v3, v4 in
//            align(top: v1, v2, v3, v4)
//            
//            v1.left == v4.right + SPACING_BEWTWEEN_COMPONENTS
//            v2.left == v1.right + SPACING_BEWTWEEN_COMPONENTS
//            
//            v3.right == v3.superview!.right - MARGIN_TO_BOUNDARY
//            
////            v1.height == 18
////            v2.height == v1.height
//        }
        
//        constrain(contentLabel ) { v1 in
////            align(left: v1, v2)
////            v1.height == self.contentLabelHeight
//            v1.height >= 20 ~ 1000
//            v1.left == v1.superview!.left + MARGIN_TO_BOUNDARY + 50 + SPACING_BEWTWEEN_COMPONENTS
//            v1.top == v1.superview!.top + SPACING_BEWTWEEN_COMPONENTS
//            v1.right == v1.superview!.right - MARGIN_TO_BOUNDARY
//            v1.bottom == v1.superview!.bottom - MARGIN_TO_BOUNDARY
//        }
    }
    
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttachment attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment.isKindOfClass(DTImageTextAttachment){
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.url = attachment.contentURL
            return imageView
            
        }
        return nil
    }
    
    func lazyImageView(lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let url = lazyImageView.url
        let pred = NSPredicate(format: "contentURL == %@", url)
        
        if let res = contentLabel.layoutFrame.textAttachmentsWithPredicate(pred) {
            for index in 0..<res.count {
                let att = res[index] as! DTTextAttachment
                att.originalSize = size
            }
        }
        
        contentLabel.layouter = nil
        contentLabel.relayoutText()
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, didDrawLayoutFrame layoutFrame: DTCoreTextLayoutFrame!, inContext context: CGContext!) {
        contentLabelHeight = layoutFrame.frame.size.height
        var f:CGRect = self.contentLabel.frame
        f.size.height = layoutFrame.frame.size.height
        self.contentLabel.frame = f
        
        let width = self.bounds.width - MARGIN_TO_BOUNDARY * 2 - 50 - SPACING_BEWTWEEN_COMPONENTS
        let size = contentLabel.suggestedFrameSizeToFitEntireStringConstraintedToWidth(width)
        contentLabelHeight = size.height
//        print(layoutFrame.frame.size.height)
//        self.sizeToFit()
        print("=======>>> \(layoutFrame.frame.size.height)")
        print("")
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        
        
        var totalHeight: CGFloat = 0
        totalHeight += MARGIN_TO_BOUNDARY
        totalHeight += 18
        totalHeight += SPACING_BEWTWEEN_COMPONENTS
        totalHeight += contentLabelHeight
        totalHeight += MARGIN_TO_BOUNDARY
        
        return CGSizeMake(size.width, totalHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}