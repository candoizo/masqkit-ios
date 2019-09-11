# MASQKit.Extensions
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial*-ShareAlike 4.0 International License, with important clarifications below</a>.

* *Extensions may of course be made for commerical products, but the extension itself may not exist as a "premium feature" / behind their own paywalls in any circumstance. If said project offers a tier / freemium version / trial, MASQKit features must not be considered premium content, and must be available regardless of any tiered reward, else said person will be in violation of the set terms of use.

* As this is released under ShareAlike terms, if you start improving your favourite extensions, please open a discussion and contribute your findings back towards improving the execution of these.

* Attribution must be provided under terms of this lisence, in this case as a MASQ prefix to your extension title.

Example:
A MASQKit extension for the tweak Apace becomes: MASQApace

A MASQKit extension for the app Deezer becomes:  MASQDeezer

Inadmissable examples: Sinatramasq, Supahotthemefiya, mAsQtWeAkSaReGrEaT

## Public API Documentation

The MASQKit library currently offers two classes to bring its most exciting features; Artwork themeing & blurred artwork backgrounds in one easy line! As more features are ported and prepared for mass adoption, documentation will expand.

### MASQArtworkView:

##### Public Interface:
```objc
@interface MASQArtworkView : UIView
@property (nonatomic, assign) BOOL disabled;
-(id)initWithThemeKey:(NSString *)key frameHost:(UIView *)frameOwner imageHost:(UIImageView *)imageOwner;
@end
```

##### Adding MASQKit themeing to your music player's current artwork view:
```objc
-(id)initWithThemeKey:(NSString *)key frameHost:(UIView *)frameOwner imageHost:(UIImageView *)imageOwner;
```

The main method for creating a MASQKit theme relies on three objects to accomplish it's job.

```objc
NSString * key =
```
This variable represents the theme key listened to by the artwork for user changes. Through a matching theme picker offering in the MASQKit Preferences, this allows the user to configure what theme will alter their artwork. Existing keys supported by offical plugins currently are CC = Control Center LS = LockScreen MP = Media Player. If your extension is used to offer themeing to anything in these areas, it is recommended to use the existing ones.

In unique environments where this is not applicable, it is recommended you create your own unique themeKey identifier, for example the programs bundle-identifier; two character keys are reserved for the developer of MASQKit and are actively discourage from use as ignorance will lead to potential conflicting usage down the road.

```objc
UIView * frameOwner =
```
The frame host represents the view that dictates the proper frame for your MASQArtworkView. Sizing is automatically handled by the view when this is specified, and is used to deliver

```objc
UIImageView * imageOwner =
```
This is going to be the view which currently receives artwork images, ie the actual Media Player's artwork image view, which keeps our view in synch to the regular experience.

```objc
@property (nonatomic, assign) BOOL disabled;
```
MASQArtworkView has a disabled property, which represents the user has requested to specifically disable themeing on the current key. This means that any modifications necessary to provide optimal UI should be reverted, else there will appear to be interruptions. Examples of when this is necessary are prevalent through the existing Extensions supplied, and I refer you there for better understanding of how to handle this.

##### MASQBlurredImageView - coming in a couple days, see usage in SpringBoard extensions

If you can appreciate the effort I put into this, it would mean a lot if you left a star! Good luck with your projects~
