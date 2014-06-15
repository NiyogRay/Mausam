//
//  ForecastTableViewCell.h
//  Mausam
//
//  Created by Niyog Ray on 13/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLbl;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthLbl;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLbl;
@property (weak, nonatomic) IBOutlet UILabel *minTempLbl;

@property (weak, nonatomic) IBOutlet UILabel *forecastLbl;
@property (weak, nonatomic) IBOutlet UIImageView *forecastIV;

@end
