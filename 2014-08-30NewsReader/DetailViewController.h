//
//  DetailViewController.h
//  2014-08-30NewsReader
//
//  Created by kotepe on H26/08/30.
//  Copyright (c) 平成26年 kotepe factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
