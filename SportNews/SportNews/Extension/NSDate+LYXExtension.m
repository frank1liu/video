//
//  NSDate+LYXExtension.m
//  T2AEphone
//
//  Created by Hiren Joshi on 31/03/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "NSDate+LYXExtension.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_WEEK		604800

@implementation NSDate (LYXExtension)

- (NSInteger)year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[[NSDate date] dateByAddingDays:1]];
}

- (BOOL)isLeapYear
{
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 ==0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday {
    NSDate *added = [self dateByAddingDays:1];
    return [added isToday];
}

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//  当天的显示具体时间，昨天显示Yesterday，一周内的显示星期几，一周后显示日期。
+ (NSString *)convertToNormalTimeWithDate:(NSDate *)date language:(NSDateNormalTimeLanguage) language
{
    /*
     *  判断是24小时制还是12小时制
     */
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval showTimestamp = [date timeIntervalSince1970];
    if (date.isToday) {
        if (hasAMPM) {
            format.AMSymbol = NSLocalizedString(@"上午", @"History");
            format.PMSymbol =  NSLocalizedString(@"下午", @"History");
            format.dateFormat = @"aaa hh:mm";
        }
        else {
            format.dateFormat = @"HH:mm";
        }
        NSString *timeStr = [format stringFromDate:date];
        return timeStr;
    }
    else if (date.isYesterday) {
        
        format.dateFormat = @"HH:mm";
        NSString *timeStr = [format stringFromDate:date];
        
        return [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"昨天", @"History"),timeStr];
    }
    else if (((showTimestamp - nowTimestamp) / 60 / 60 / 24) < 7 ) {
        return [self weekDayStrWithInteger:[NSDate date].weekday language:language];
    }
    else {
        format.dateFormat = language == NSDateNormalTimeLanguageCN ? @"yy/MM/dd" : @"MM/dd/yy";
        return [format stringFromDate:date];
    }
}

+ (NSString *)weekDayStrWithInteger:(NSUInteger)weekDayInt language:(NSDateNormalTimeLanguage) language {
    NSString *weekdayStr;
    switch (weekDayInt)
    {
        case 1:
        {
            weekdayStr = NSLocalizedString(@"星期天", @"History");
        }break;
        case 2:
        {
            weekdayStr = NSLocalizedString(@"星期一", @"History");
        }break;
        case 3:
        {
            weekdayStr = NSLocalizedString(@"星期二", @"History");
        }break;
        case 4:
        {
            weekdayStr = NSLocalizedString(@"星期三", @"History");
        }break;
        case 5:
        {
            weekdayStr = NSLocalizedString(@"星期四", @"History");
        }break;
        case 6:
        {
            weekdayStr = NSLocalizedString(@"星期五", @"History");
        }break;
        case 7:
        {
            weekdayStr = NSLocalizedString(@"星期六", @"History");
        }break;
        default:
            break;
    }
    return weekdayStr;
}

//  当天的显示今天，昨天显示Yesterday，一周内的显示星期几，一周后显示日期。
+ (NSString *)convertWithDate:(NSDate *)date language:(NSDateNormalTimeLanguage) language
{
    /*
     *  判断是24小时制还是12小时制
     */
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval showTimestamp = [date timeIntervalSince1970];
    if (date.isToday) {
        return NSLocalizedString(@"今天", @"History");
    }
    else if (date.isYesterday) {
        return NSLocalizedString(@"昨天", @"History");
    }
    else if (((showTimestamp - nowTimestamp) / 60 / 60 / 24) < 7 ) {
        return [self weekDayStrWithInteger:[NSDate date].weekday language:language];
    }
    else {
        format.dateFormat = language == NSDateNormalTimeLanguageCN ? @"yy/MM/dd" : @"MM/dd/yy";
        return [format stringFromDate:date];
    }
}


//  时间格式
+ (NSString *)convertToTimeWithDate:(NSDate *)date language:(NSDateNormalTimeLanguage) language
{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    if (hasAMPM) {
        format.AMSymbol = NSLocalizedString(@"上午", @"History");
        format.PMSymbol =  NSLocalizedString(@"下午", @"History");
        format.dateFormat = @"hh:mm aaa";
    }
    else {
        format.dateFormat = @"HH:mm";
    }
    NSString *timeStr = [format stringFromDate:date];
    return timeStr;
    
}

#pragma mark -- 获取日期
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[self class] setDataFormatter];
    NSDate          *date          = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString        *dateString    = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)timeStringWithInterval1:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[self class] setDataFormatter1];
    NSDate          *date          = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString        *dateString    = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *_Nullable)currentDateStr {
    
    NSTimeInterval timestamp = ([[NSDate date] timeIntervalSince1970]*10000000);
    NSString *dateString = [NSString stringWithFormat:@"%0.0f",timestamp];
    return dateString;
}

#pragma mark -- 设置日期格式
+ (NSDateFormatter *)setDataFormatter1 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
     
    return dateFormatter;
}

+ (NSDateFormatter *)setDataFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
     
    return dateFormatter;
}

@end
