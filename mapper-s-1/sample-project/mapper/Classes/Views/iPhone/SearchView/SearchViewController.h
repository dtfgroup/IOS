//
//  SearchViewController.h
//  mapper
//
//  Created by Tope on 25/01/2012.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *textField; 

-(void)setViewMovedUp:(BOOL)movedUp;
@end
