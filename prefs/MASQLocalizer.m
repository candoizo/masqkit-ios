#import "MASQLocalizer.h"

@implementation MASQLocalizer
+(NSString *)localStringForKey:(NSString *)key {
	NSString * prefPath = @"/Library/PreferenceBundles/MASQPrefs.bundle/";
	NSString * lang = [NSLocale.currentLocale objectForKey:NSLocaleLanguageCode];
	NSBundle * langBundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@.lproj",prefPath, lang]];
	NSString * localStr = nil;
	if (langBundle) localStr = [langBundle localizedStringForKey:key value:nil table:nil];
	else localStr = [[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@.lproj",prefPath, @"en"]] localizedStringForKey:key value:nil table:nil];
	return [[NSBundle bundleWithPath:prefPath] localizedStringForKey:key value:localStr table:nil];
}

+(void)parseSpecifiers:(NSArray *)specifiers {
	for (PSSpecifier *specifier in specifiers) {
		NSString *localTitle = [MASQLocalizer localStringForKey:specifier.properties[@"label"]];
		NSString *localFooter = [MASQLocalizer localStringForKey:specifier.properties[@"footerText"]];
		[specifier setProperty:localFooter forKey:@"footerText"];
		specifier.name = localTitle;
		NSString *localHint = [MASQLocalizer localStringForKey:specifier.properties[@"hint"]];
		[specifier setProperty:localHint forKey:@"hint"];
	}
}
@end
