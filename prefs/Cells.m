#import "PrefUtils.h"
#import "../src/MASQThemeManager.h"

@interface MASQSwitchCell : PSSwitchTableCell
@end

@implementation MASQSwitchCell
- (id)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * identifier = [arg3 propertyForKey:@"key"];
		if ([identifier hasPrefix:@"CC"]) [((UISwitch *)[self control]) setOnTintColor:kCCTintColor];
		else if ([identifier hasPrefix:@"LS"]) [((UISwitch *)[self control]) setOnTintColor:kLSTintColor];
		else if ([identifier hasPrefix:@"MP"]) [((UISwitch *)[self control]) setOnTintColor:kMPTintColor];
		else [((UISwitch *)[self control]) setOnTintColor:[kCustomTint colorWithAlphaComponent:0.8]];

		if ([arg3 propertyForKey:@"hint"])	{
			self.detailTextLabel.text = [arg3 propertyForKey:@"hint"];
			self.detailTextLabel.textAlignment = 4;
			self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
		}
	}
	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];

	if ([self.specifier propertyForKey:@"hint"]) {
	  self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y - 7.5);
   	self.detailTextLabel.frame = CGRectMake(self.titleLabel.frame.origin.x,self.frame.size.height-17.5, self.detailTextLabel.intrinsicContentSize.width,15);
	}
}
@end

@interface MASQThemeLinkCell : PSTableCell
@end

@implementation MASQThemeLinkCell
- (void)refreshCellContentsWithSpecifier:(id)arg1 {
	[super refreshCellContentsWithSpecifier:arg1];
	self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
	self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x, self.accessoryView.center.y - 5);
	if ([[NSClassFromString(@"MASQThemeManager") sharedPrefs] valueForKey:[arg1 propertyForKey:@"themeKey"]])	{
		NSString * tname = [[[NSClassFromString(@"MASQThemeManager") sharedPrefs] valueForKey:[arg1 propertyForKey:@"themeKey"]] componentsSeparatedByString:@"@"].firstObject;
		self.detailTextLabel.text = tname;
	}
	else self.detailTextLabel.text = @"Default";
}

-(void)layoutSubviews {
	[super layoutSubviews];

	if ([self.specifier propertyForKey:@"themeKey"]) {
		UIView * acc = [self valueForKey:@"_accessoryView"];
   	self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x, acc.center.y);
	}
}
@end


@interface MASQSegmentCell : PSSegmentTableCell//PSSegmentCell
@end

@implementation MASQSegmentCell
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self) {

		NSString * identifier = [arg3 propertyForKey:@"tintKey"];
		if ([identifier hasPrefix:@"CC"]) self.tintColor = kCCTintColor;
		else if ([identifier hasPrefix:@"LS"]) self.tintColor = kLSTintColor;
		else if ([identifier hasPrefix:@"MP"]) self.tintColor = kMPTintColor;
		else self.tintColor = [kCustomTint colorWithAlphaComponent:0.8];
	}
	return self;
}
@end
