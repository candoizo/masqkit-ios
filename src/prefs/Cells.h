#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>

@interface PSSegmentTableCell : NSObject
@property (nonatomic, assign) UIColor * tintColor;
-(UIControl *)control;
- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3;
@end

@interface MASQSegmentCell : PSSegmentTableCell
@end

@interface MASQSwitchCell : PSSwitchTableCell
@end

@interface MASQThemeLinkCell : PSTableCell
@end

@interface MASQChildLinkCell : PSTableCell
@end
