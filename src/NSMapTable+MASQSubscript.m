@implementation NSMapTable (MASQSubscript)
- (id)objectForKeyedSubscript:(id)arg1
{
    return [self objectForKey:arg1];
}

- (void)setObject:(id)arg1 forKeyedSubscript:(id)arg2
{
  arg1 ? [self setObject:arg1 forKey:arg2] : [self removeObjectForKey:arg2];
}
@end
