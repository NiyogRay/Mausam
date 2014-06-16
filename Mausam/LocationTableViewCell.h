//
//  LocationTableViewCell.h
//  Mausam
//
//  Created by Niyog Ray on 13/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationWeatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationTempLbl;
@property (weak, nonatomic) IBOutlet UIImageView *locationWeatherIV;

@end
