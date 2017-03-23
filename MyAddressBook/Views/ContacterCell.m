//
//  ContacterCell.m
//  HouseLoan
//
//  Created by Sean on 2017/3/17.
//
//

#define kCellSmallPadding kScaleHeight(2.f)

#import "ContacterCell.h"
#import "Contacter.h"

@interface ContacterCell ()
@property (strong, nonatomic) UILabel *nameLbl;
@property (strong, nonatomic) UILabel *phoneLbl;
@property (strong, nonatomic) UIImageView *checkedView;
@end

@implementation ContacterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLbl = [UILabel new];
        _nameLbl.font = [UIFont systemFontOfSize:15.f];
        _nameLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLbl];
        
        _phoneLbl = [UILabel new];
        _phoneLbl.font = [UIFont systemFontOfSize:14.f];
        _phoneLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_phoneLbl];
        
        {
            [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_centerY).offset(-kCellSmallPadding);
                make.left.equalTo(self.contentView).offset(kPadding);
            }];
            
            [_phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_centerY).offset(kCellSmallPadding);
                make.left.equalTo(self.contentView).offset(kPadding);
            }];
        }
    }
    return self;
}

- (void)setCurContacter:(Contacter *)curContacter {
    if (!curContacter) {
        return;
    }
    _curContacter = curContacter;
    _nameLbl.text = _curContacter.name;
    _phoneLbl.text = _curContacter.phone;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    _checkedView.image = _checked ? [UIImage imageNamed:@"checked"] : [UIImage imageNamed:@"unchecked"];
}

+ (CGFloat)cellHeight {
    return kScaleHeight(44.f);
}
@end
