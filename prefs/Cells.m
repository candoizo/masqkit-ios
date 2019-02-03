#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <Preferences/PSSegmentTableCell.h>
#import "../src/MASQHousekeeper.h"

@interface MASQSwitchCell : PSSwitchTableCell
@end

@implementation MASQSwitchCell
- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * tintHex = [arg3 propertyForKey:@"tint"];
		if (tintHex) [((UISwitch *)[self control]) setOnTintColor:[NSClassFromString(@"MASQHousekeeper") hexToRGB:tintHex]];
		else [((UISwitch *)[self control]) setOnTintColor:[NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:0.8]]; //?TODO

		if ([arg3 propertyForKey:@"hint"])	{
			self.detailTextLabel.text = [arg3 propertyForKey:@"hint"];
			self.detailTextLabel.textAlignment = 4;
			self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
			if (tintHex) {
				self.detailTextLabel.textColor = [[NSClassFromString(@"MASQHousekeeper") hexToRGB:tintHex] colorWithAlphaComponent:0.7];
			}
			else self.detailTextLabel.textColor = [NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:0.7];
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

@interface MASQThemeLinkCell : PSTableCell
@end

@implementation MASQThemeLinkCell
- (void)refreshCellContentsWithSpecifier:(id)arg1 {
	[super refreshCellContentsWithSpecifier:arg1];

	self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
	NSString * tintHex = [arg1 propertyForKey:@"tint"];
	if (tintHex) self.detailTextLabel.textColor = [[NSClassFromString(@"MASQHousekeeper") hexToRGB:tintHex] colorWithAlphaComponent:0.7];
	else self.detailTextLabel.textColor = [NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:0.7];
}

-(void)layoutSubviews {
	[super layoutSubviews];

	if ([self.specifier propertyForKey:@"themeKey"]) {
		UIView * acc = [self valueForKey:@"_accessoryView"];
   	self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x, acc.center.y);
	}

	if ([[NSClassFromString(@"MASQHousekeeper") sharedPrefs] valueForKey:[self.specifier propertyForKey:@"themeKey"]])	{
		NSString * tname = [[[NSClassFromString(@"MASQHousekeeper") sharedPrefs] valueForKey:[self.specifier propertyForKey:@"themeKey"]] componentsSeparatedByString:@"@"].firstObject;
		self.detailTextLabel.text = tname;
	}
}
@end


@interface MASQSegmentCell : PSSegmentTableCell//PSSegmentCell
@end

@implementation MASQSegmentCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * tintHex = [arg3 propertyForKey:@"tint"];
		if (tintHex) self.tintColor = [NSClassFromString(@"MASQHousekeeper") hexToRGB:tintHex];
		else self.tintColor = [NSClassFromString(@"MASQHousekeeper") masqTintWithAlpha:0.8];
	}
	return self;
}
@end

@interface MASQSubPageLinkCell : PSTableCell
@end

@interface UIImage (Private)
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(CGFloat)arg3;
+(id)imageNamed:(id)arg1 inBundle:(id)arg2;
@end

@implementation MASQSubPageLinkCell
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
