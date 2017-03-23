//
//  ContacterCell.h
//  HouseLoan
//
//  Created by Sean on 2017/3/17.
//
//

#define kCellIdentifier_ContacterCell @"ContacterCell"

#import <UIKit/UIKit.h>
@class Contacter;

@interface ContacterCell : UITableViewCell
@property (strong, nonatomic) Contacter *curContacter;

@property (assign, nonatomic) BOOL checked;

+ (CGFloat)cellHeight;
@end
