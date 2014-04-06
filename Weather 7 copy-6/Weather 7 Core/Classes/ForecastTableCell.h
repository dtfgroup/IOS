//
//  ForecastTableCell.h
//  Weather 7
//
//  Created by Christopher Coudriet on 10/15/2012.
//  Copyright Christopher Coudriet 2012. All rights reserved.
//
//  Permission is given to license this source code file, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that this source code cannot be redistributed or sold (in part or whole) and must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>


@interface ForecastTableCell : UITableViewCell {
    
    IBOutlet UILabel     *forecastDateView;
    IBOutlet UILabel     *forecastTextView;
    IBOutlet UIImageView *forecastImageview;
}

@property (nonatomic, strong) UILabel     *forecastDateView;
@property (nonatomic, strong) UILabel     *forecastTextView;
@property (nonatomic, strong) UIImageView *forecastImageview;

@end
