#import "RSSignatureViewManager.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUIManager.h>

@implementation RSSignatureViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(rotateClockwise, BOOL)
RCT_EXPORT_VIEW_PROPERTY(square, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showBorder, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showNativeButtons, BOOL)
RCT_EXPORT_VIEW_PROPERTY(showTitleLabel, BOOL)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)


-(dispatch_queue_t) methodQueue
{
	return dispatch_get_main_queue();
}

-(UIView *) view
{
	RSSignatureView *signView = [[RSSignatureView alloc] init];
	signView.manager = self;
	return signView;
}

// Both of these methods needs to be called from the main thread so the
// UI can clear out the signature.
RCT_EXPORT_METHOD(saveImage:(nonnull NSNumber *)reactTag) {
	dispatch_async(dispatch_get_main_queue(), ^{
		UIView *subView = [self.bridge.uiManager viewForReactTag:reactTag];
 		if([subView isKindOfClass:[RSSignatureView class]]) [((RSSignatureView *)subView) saveImage];
	});
}

RCT_EXPORT_METHOD(resetImage:(nonnull NSNumber *)reactTag) {
	dispatch_async(dispatch_get_main_queue(), ^{
		UIView *subView = [self.bridge.uiManager viewForReactTag:reactTag];
 		if([subView isKindOfClass:[RSSignatureView class]]) [((RSSignatureView *)subView) erase];
	});
}

-(void) publishSaveImageEvent:(nonnull NSDictionary *) event {
	[self.bridge.eventDispatcher
	 sendDeviceEventWithName:@"onSaveEvent"
	 body:@{
					@"pathName": event[@"pathName"],
					@"encoded": event[@"encoded"],
					@"uri": event[@"uri"],
					@"fileName": event[@"fileName"],
					@"fileSize": event[@"fileSize"],
					@"type": event[@"type"],
					@"width": event[@"width"],
					@"height": event[@"height"]
					}];
}

-(void) publishDraggedEvent {
	[self.bridge.eventDispatcher
	 sendDeviceEventWithName:@"onDragEvent"
	 body:@{@"dragged": @YES}];
}

@end
