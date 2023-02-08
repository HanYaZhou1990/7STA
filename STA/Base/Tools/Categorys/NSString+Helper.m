//
//  NSString+Helper.m
//  JCExchange
//
//  Created by 韩亚周 on 2019/12/13.
//  Copyright © 2019 韩亚周. All rights reserved.
//

#import "NSString+Helper.h"
#import <UIKit/UIKit.h>

@implementation NSString (Helper)

/**
 * 金额的格式转化
 * str : 金额的字符串
 * numberStyle : 金额转换的格式
 * return  NSString : 转化后的金额格式字符串
 */
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str numberStyle:(NSNumberFormatterStyle)numberStyle {
    
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = numberStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    return money;
}

+ (NSString *)stringChangeMoneyWithStr:(NSString *)str{
    return str;
    //    // 判断是否null 若是赋值为0 防止崩溃
    //    if (([str isEqual:[NSNull null]] || str == nil)) {
    //        str = 0;
    //    }
    //
    //    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    //    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    //    // 注意传入参数的数据长度，可用double
    //    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    //
    //    return money;
}


- (NSString*)htmlText {
    
    NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSMutableAttributedString* attrs = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    
    return attrs.string;
}
-(NSString *)EmptyStringByWhitespace{
    NSString *str=@"";
    if (self && self.length>0) {
        str=[self stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str=[str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    return [str trimString];
}
#pragma mark - Get请求转换
-(NSString *)getRequestString{
    if ([self isEmptyString])
    {
        return [@"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark 段前空两格
-(NSString *)emptyBeforeParagraph
{
    NSString *content=[NSString stringWithFormat:@"\t%@",self];
    content=[content stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    return [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}
#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (!self || self.length <1  || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"] || self==nil || [self isEqualToString:@"null"] || [self isEqualToString:@"null;"]);
}

#pragma mark 用三木运算-空返回@“”，不是就正常返回
- (NSString *)SM
{
    if ([[NSString stringWithFormat:@"%@",self] isEmptyString]) {
        return @"";
    }else{
        return self;
    }
    //    return [[NSString stringWithFormat:@"%@",self] isEmptyString]?@"":self;
}


#pragma mark 返回沙盒中的文件路径
- (NSString *)documentsPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingString:self];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark 读出系统偏好
+ (NSString *)readToNSDefaultsWithKey:(NSString *)key
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
#pragma mark 邮箱验证 MODIFIED BY HELENSONG
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
#pragma mark  银行账号判断
-(BOOL)isValidateBank
{
    NSString *bankNo=@"^\\d{16}|\\d{19}|\\d{18}+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNo];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

-(BOOL)pipeizimu
{
    //判断是否以字母开头
    NSString *ZIMU = @"/^[a-zA-z]/";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:self] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark 手机号码验证 MODIFIED BY HELENSONG
-(BOOL) isValidateMobile
{
    if ([self isEmptyString]) {
        return NO;
    }
    if (self.length==11) {
        return YES;
    }else{
        return NO;
    }
    //    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((1[0-9][0-9])|(14[57])|(17[0678]))\\d{8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //
    //    return [phoneTest evaluateWithObject:self];
}


- (BOOL)validateMobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}




#pragma mark- 判断是否是手机号或固话
-(BOOL) isValidateMobileAndTel{
    if ([self isEmptyString]) {
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((\\d{7,8})|(0\\d{2,3}\\d{7,8})|(1[34578]\\d{9}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}
#pragma mark-  判断是否是手机号或固话或400

-(BOOL) isValidateMobileAndTelAnd400{
    if ([self isEmptyString]) {
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((\\d{7,8})|(0\\d{2,3}\\d{7,8})|(1[34578]\\d{9})|(400\\d{7}))$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:self];
}
#pragma mark 身份证号
-(BOOL) isValidateIdentityCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}


#pragma mark 车牌号验证 MODIFIED BY HELENSONG
-(BOOL) isValidateCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}

#pragma mark 车型号
- (BOOL) isValidateCarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:self];
}
#pragma mark 用户名
- (BOOL) isValidateUserName
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{3,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:self];
}
#pragma mark 密码
-(BOOL) isValidatePassword
{
    if (self.length<6 || self.length>20) {
        return NO;
    }else{
        return YES;
    }
    
    
    //    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    //    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    //    return [passWordPredicate evaluateWithObject:self];
}
#pragma mark 昵称
- (BOOL) isValidateNickname
{
    NSString *nicknameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,6}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:self];
}
#pragma mark - 判断汉子
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
#pragma mark - 字符串转日期
- (NSDate *)dateFromString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年 MM月 dd日 HH点 mm分"];
    NSDate *destDate= [dateFormatter dateFromString:self];
    return destDate;
}
#pragma mark - 日期转字符串
+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年 MM月 dd日 HH点 mm分"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

//判断是否为整形：

- (NSString *)isInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    if ([scan scanInt:&val] && [scan isAtEnd]) {
        return [NSString stringWithFormat:@"%.0f",self.floatValue];
    }else{
        return [NSString stringWithFormat:@"%.2f",self.floatValue];
    }
}

#pragma amrk - 计算文本宽度度
- (float )getContentWidth:(NSString *)content textFont:(UIFont *)font hightFor:(float)hight {
    CGSize size = CGSizeMake(Main_Screen_Width,hight);
    CGSize labelsize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return labelsize.width;
}

#pragma amrk - 计算文本宽度度
- (float )getContentHeight:(NSString *)content textFont:(UIFont *)font widthFor:(float)width {
    CGSize size = CGSizeMake(width,Main_Screen_Height);
    CGSize labelsize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return labelsize.height;
}

@end
