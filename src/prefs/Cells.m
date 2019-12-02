#import "MASQChildController.h"
#import "../MASQThemeManager.h"
#import "../UIColor+MASQColorUtil.h"
#import "../Interfaces.h"
#import "Cells.h"
#define kMasqTint(x) [UIColor colorWithRed:0.87 green:0.25 blue:0.40 alpha:x]


@interface PSSegmentTableCell(priv)
-(void)_setSelectionStyle:(int)arg1 selectionTintColor:(UIColor *)arg2;
-(void)refreshCellContentsWithSpecifier:(PSSpecifier *)arg1;
-(int)selectionStyle;
-(void)layoutSubviews;
-(PSSpecifier *)specifier;
-(UISegmentedControl *)newControl;
@end

@interface UISegmentedControl (prov)
@property (nonatomic, assign) UIColor * selectedSegmentTintColor;
-(MASQChildController *)_viewControllerForAncestor;
-(void)_setInteractionTintColor:(UIColor *)arg1;
@end

@interface UIControl (Priv)
@property (nonatomic, assign) UIColor * selectedSegmentTintColor;
// -(void)_setSele
@end

@implementation MASQSegmentCell
- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * tintHex = [arg3 propertyForKey:@"tint"];
		if (tintHex) self.tintColor = [UIColor _masq_hexToRGB:tintHex];
		else self.tintColor = kMasqTint(0.8);
	}
	return self;
}

-(BOOL)_definesDynamicTintColor {
	return YES;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	if ([self.control respondsToSelector:@selector(setSelectedSegmentTintColor:)])
	self.control.selectedSegmentTintColor = self.tintColor;
}
@end


@implementation MASQSwitchCell
- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * tintHex = [arg3 propertyForKey:@"tint"];
		if (tintHex) [((UISwitch *)[self control]) setOnTintColor:[UIColor _masq_hexToRGB:tintHex]];
		else [((UISwitch *)[self control]) setOnTintColor:kMasqTint(0.8)]; //?TODO

		if ([arg3 propertyForKey:@"hint"])	{
			self.detailTextLabel.text = [arg3 propertyForKey:@"hint"];
			self.detailTextLabel.textAlignment = 4;
			self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
			if (tintHex) {
				self.detailTextLabel.textColor = [[UIColor _masq_hexToRGB:tintHex] colorWithAlphaComponent:0.7];
			}
			else self.detailTextLabel.textColor = kMasqTint(0.7);
		}
	}
	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];

	if ([self.specifier propertyForKey:@"hint"]) {
	  self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.bounds.size.height*0.35);
   	self.detailTextLabel.frame = CGRectMake(self.titleLabel.frame.origin.x,self.frame.size.height*0.6, self.detailTextLabel.intrinsicContentSize.width,15);
	}
}
@end


@implementation MASQThemeLinkCell
- (void)refreshCellContentsWithSpecifier:(id)arg1 {
	[super refreshCellContentsWithSpecifier:arg1];

	self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
	NSString * tintHex = [arg1 propertyForKey:@"tint"];
	if (tintHex) self.detailTextLabel.textColor = [[UIColor _masq_hexToRGB:tintHex] colorWithAlphaComponent:0.7];
	else self.detailTextLabel.textColor = kMasqTint(0.7);
}

-(void)layoutSubviews {
	[super layoutSubviews];

	NSString * themeKey = [self.specifier propertyForKey:@"themeKey"];

	if (themeKey) {
		UIView * acc = [self valueForKey:@"_accessoryView"];

		int ver = UIDevice.currentDevice.systemVersion.doubleValue;
		// ios 13 this is off center for some reason
		// @TODO see if backwards compatible
		int yVal = ver < 13 ? acc.center.y : self.titleLabel.center.y;
		self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x, yVal);
	}

	if ([[NSClassFromString(@"MASQThemeManager") prefs] valueForKey:themeKey])	{
		NSString * tlabel = [[[NSClassFromString(@"MASQThemeManager") prefs] valueForKey:themeKey] componentsSeparatedByString:@"@"].firstObject;
		self.detailTextLabel.text = tlabel;
	}
}
@end

@interface MASQSubPageLinkCell : MASQChildLinkCell
@end

@implementation MASQSubPageLinkCell
+(NSString *)deprecationInfo {
	return @"This class is being deprecated in favour of MASQChildLinkCell. \n\nPlease avoid referenceing this class as it could be removed at a future major version change.";
}
@end


@implementation MASQChildLinkCell
- (void)refreshCellContentsWithSpecifier:(id)arg1 {
	[super refreshCellContentsWithSpecifier:arg1];

	if (!self.imageView.image && [self.specifier propertyForKey:@"iconBundle"]) {
		self.imageView.image = [UIImage _applicationIconImageForBundleIdentifier:[self.specifier propertyForKey:@"iconBundle"] format:0 scale:UIScreen.mainScreen.scale];
	}
	else if (!self.imageView.image && [self.specifier propertyForKey:@"iconPath"]) {
		NSString * path = [self.specifier propertyForKey:@"iconPath"];
		self.imageView.image = [UIImage imageNamed:path.lastPathComponent inBundle:[NSBundle bundleWithPath:[path stringByDeletingLastPathComponent]]];
	}
}
@end
