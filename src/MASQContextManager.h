#import "NSMapTable+MASQSubscript.h"

@interface MASQContextManager : NSObject
@property (nonatomic, retain) NSMapTable * themes;
@property (nonatomic, retain) NSMapTable * keyMap;
// @property (nonatomic, retain) NSHashTable * managedViews;
@property (nonatomic, retain) NSMutableArray * identities;
// @property (nonatomic, retain) NSMutableArray * dirtyKeys;
// @property (nonatomic, retain) NSMutableArray * managedKeys;

+(MASQContextManager *)sharedInstance;
/*
  the shared accessor on a per-process basis
*/
-(void)registerView:(id)arg1;
// /*
//   An automatic action where all MASQ views register themselves
// */
//
-(void)updateIdentity:(NSString *)arg1;
// /*
//   A way to push updates towards multiple instances
// */
//
// -(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
/*
  posting tings to the appropriate thing?
*/

-(void)updateThemes;
@end
