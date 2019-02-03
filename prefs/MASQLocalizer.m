#import "MASQLocalizer.h"

@implementation MASQLocalizer
+(NSString *)localStringForKey:(NSString *)key {
	NSString * prefPath = @"/Library/PreferenceBundles/MASQSettings.bundle";
	NSString * lang = [NSLocale.currentLocale objectForKey:NSLocaleLanguageCode];
	NSBundle * langBundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/Localizations/%@.lproj",prefPath, lang]];
	NSString * localStr = nil;
	if (langBundle) localStr = [langBundle localizedStringForKey:key value:nil table:nil];
	else localStr = [[NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/Localizations/%@.lproj",prefPath, @"en"]] localizedStringForKey:key value:nil table:nil];
	return [[NSBundle bundleWithPath:prefPath] localizedStringForKey:key value:localStr table:nil];
}

+(void)parseSpecifiers:(NSArray *)specifiers {
	for (PSSpecifier *specifier in specifiers) {
		NSString *localTitle = [MASQLocalizer localStringForKey:specifier.properties[@"label"]];
		specifier.name = localTitle;
		NSString *localFooter = [MASQLocalizer localStringForKey:specifier.properties[@"footerText"]];
		[specifier setProperty:localFooter forKey:@"footerText"];
		NSString *localHint = [MASQLocalizer localStringForKey:specifier.properties[@"hint"]];
		[specifier setProperty:localHint forKey:@"hint"];
	}
}
@end
