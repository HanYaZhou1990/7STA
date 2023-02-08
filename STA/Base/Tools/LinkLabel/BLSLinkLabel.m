//
//  BLSLinkLabel.m
//  VoQiPei
//
//  Created by 韩亚周 on 2021/4/9.
//

#import "BLSLinkLabel.h"

@interface BLSLinkLabel ()

@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextStorage *textStorage;

@end

@implementation BLSLinkLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _layoutManager = [[NSLayoutManager alloc] init];
    _textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    _textStorage = [[NSTextStorage alloc]  initWithAttributedString:self.attributedText];
    [_textStorage addLayoutManager:_layoutManager];
    _textContainer.lineBreakMode  = self.lineBreakMode;
    _textContainer.maximumNumberOfLines = self.numberOfLines;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTapOnLabel:)]];
}

- (void)setConfig:(BLSLinkConfig *)config {
    _config = config;
    
    //设置需要高亮的文字
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange range = [[self text] rangeOfString:config.hStr];
    [attr addAttributes:@{NSForegroundColorAttributeName: config.hColor} range:range];
    [attr addAttributes:@{NSFontAttributeName: config.hFont} range:range];
    self.attributedText = attr;
    
    //计算高亮文字的size
    CGFloat wth = [_config.hStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX , 20)
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName:_config.hFont}
                                             context:nil].size.width;
    
    CGFloat ht = [_config.hStr boundingRectWithSize:CGSizeMake(wth , CGFLOAT_MAX)
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName:_config.hFont}
                                             context:nil].size.height;
    
    self.textContainer.size = CGSizeMake(wth, ht);
}

//最后，检测点击是否正好在链接上：
- (void)handleTapOnLabel:(UITapGestureRecognizer *)sender {
    CGPoint locationOfTouchInLabel = [sender locationInView:sender.view];
    CGSize labelSize = self.textContainer.size;
    CGPoint textContainerOffset = CGPointMake(labelSize.width, labelSize.height);

    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,                                                          locationOfTouchInLabel.y - textContainerOffset.y);
    if (locationOfTouchInTextContainer.x <= 0 && locationOfTouchInTextContainer.y <= 0) {
        if (_clickedHandle) {
            _clickedHandle(self);
        }
    } else {
        //需要将事件传出去，不然点击高亮外其他文字，影响点击事件传递
        if (_otherClickedHandle) {
            _otherClickedHandle(self);
        }
    }

    /*
     CGPoint locationOfTouchInLabel = [sender locationInView:sender.view];
 //    CGSize labelSize = sender.view.bounds.size;
     CGSize labelSize = self.textContainer.size;
     CGRect textBoundingBox = [self.layoutManager usedRectForTextContainer:self.textContainer];
     CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,                                                                            (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
     CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,                                                          locationOfTouchInLabel.y - textContainerOffset.y);
     NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer                                                             inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
     NSRange linkRange = [[self text] rangeOfString:_config.hStr];
     if (NSLocationInRange(indexOfCharacter, linkRange)) {
         if (_clickedHandle) {
             _clickedHandle(self);
         }
     }
     */
    
}

@end


@implementation BLSLinkConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _hStr = @"";
        _hColor = [UIColor blueColor];
        _hFont = [UIFont systemFontOfSize:17.0f];
    }
    return self;
}

@end
