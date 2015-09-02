//
//  YEHCalendarSelfVC.m
//  YEHCalendar
//
//  Created by Yap Eng Hooi on 9/1/15.
//  Copyright (c) 2015 Yap Eng Hooi. All rights reserved.
//

#import "YEHCalendarSelfVC.h"
#import "YEHDayOfWeekCell.h"
#import "YEHCalendarCell.h"


@interface YEHCalendarSelfVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionViewOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionViewOutlet;
@property (weak, nonatomic) IBOutlet UILabel *labelDateOutlet;


@property (strong, nonatomic) NSDateComponents* currentComponent;
@property (strong, nonatomic) NSDateComponents* displayComponent;
@property (strong, nonatomic) NSDate* displayDate;
@property (nonatomic) int day;

@end

@implementation YEHCalendarSelfVC

- (void)viewDidLoad {
    [super viewDidLoad];

    int width = floor((self.view.frame.size.width - (15*2)) / 7);
    
    ((UICollectionViewFlowLayout *) self.dayCollectionViewOutlet.collectionViewLayout).itemSize = CGSizeMake(width, 25);
    ((UICollectionViewFlowLayout *) self.calendarCollectionViewOutlet.collectionViewLayout).itemSize = CGSizeMake(width, 48);
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    self.currentComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                        fromDate:[NSDate date]];
    self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                        fromDate:[NSDate date]];

    self.displayComponent.day = 1;
    self.displayDate = [calendar dateFromComponents:self.displayComponent];
    self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                        fromDate:self.displayDate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.dayCollectionViewOutlet)
        return 7;
    else
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.displayDate];
        NSInteger count=range.length;
        
        self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                            fromDate:self.displayDate];
        int weekday = (int)self.displayComponent.weekday;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM YYYY";
        self.labelDateOutlet.text = [formatter stringFromDate:self.displayDate];

        self.day = 1;
        
        return count + weekday - 1;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.dayCollectionViewOutlet)
    {
        YEHDayOfWeekCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YEHDayOfWeekCell" forIndexPath:indexPath];
        
        if(indexPath.row == 0)
        {
            cell.label.text = @"S";
        }
        else if(indexPath.row == 1)
        {
            cell.label.text = @"M";
        }
        else if(indexPath.row == 2)
        {
            cell.label.text = @"T";
        }
        else if(indexPath.row == 3)
        {
            cell.label.text = @"W";
        }
        else if(indexPath.row == 4)
        {
            cell.label.text = @"T";
        }
        else if(indexPath.row == 5)
        {
            cell.label.text = @"F";
        }
        else if(indexPath.row == 6)
        {
            cell.label.text = @"S";
        }
        
        return cell;
    }
    else
    {
        YEHCalendarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YEHCalendarCell" forIndexPath:indexPath];

        cell.redDot.hidden = YES;
        cell.label.textColor = [UIColor blackColor];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                            fromDate:self.displayDate];
        int weekday = (int)self.displayComponent.weekday;
        
        if(indexPath.row < weekday - 1)
        {
            cell.label.hidden = YES;
        }
        else
        {
            cell.label.hidden = NO;
            
            cell.label.text = [NSString stringWithFormat:@"%d", self.day];
            self.day++;
        }
        
        if(self.displayComponent.month == self.currentComponent.month && self.day == self.currentComponent.day + 1)
        {
            cell.redDot.hidden = NO;
            cell.redDot.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:87.0f/255.0f blue:144.0f/255.0f alpha:1.0];
            cell.label.textColor = [UIColor whiteColor];
         
            cell.redDot.layer.cornerRadius = cell.redDot.frame.size.width/2;
            cell.redDot.layer.masksToBounds = YES;
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
}

#pragma mark - Actions

- (IBAction)buttonAction:(UIButton *)sender
{
    [self.calendarCollectionViewOutlet reloadData];
}


- (IBAction)previousAction:(UIButton *)sender
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                        fromDate:self.displayDate];
    self.displayComponent.month = self.displayComponent.month - 1;
    self.displayDate = [calendar dateFromComponents:self.displayComponent];
    
    [self.calendarCollectionViewOutlet reloadData];
}


- (IBAction)nextAction:(UIButton *)sender
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    self.displayComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit| NSWeekdayCalendarUnit
                                        fromDate:self.displayDate];
    self.displayComponent.month = self.displayComponent.month + 1;
    self.displayDate = [calendar dateFromComponents:self.displayComponent];
    
    [self.calendarCollectionViewOutlet reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
