#import "RSSignatureView.h"
#import <React/RCTViewManager.h>

@interface RSSignatureViewManager : RCTViewManager

-(void) saveImage:(nonnull NSNumber *)reactTag;
-(void) resetImage:(nonnull NSNumber *)reactTag;
-(void) publishSaveImageEvent:(nonnull NSDictionary *) event;
-(void) publishDraggedEvent;
@end
