//
//  JSFlexibleButton.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 30/10/12.
//
//

#import "JSFlexibleButton.h"
#import "JSFlexibleButtonCell.h"

#define STANDARD_WIDTH 40.0

@interface JSFlexibleButton() {

NSTrackingRectTag _trackingRect;

}
    
@end

@implementation JSFlexibleButton

# pragma mark - Initilialisers and dealloc

+ (void)initialize
{
	[self setCellClass:[JSFlexibleButtonCell class]];
}

- (id)initWithFrame:(NSRect)frameRect andTitle:(NSString *)theTitle
{
    self = [super initWithFrame:frameRect];
	if (self) {
		[self setDefaultValues];
		[self setTitle:theTitle];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self setDefaultValues];
	}
    return self;
}

- (void)setDefaultValues
{
	if (![[self cell] isKindOfClass:[JSFlexibleButtonCell class]]) {
		NSString *title = [self title];
		if (title == nil) title = @"";
		// keep old cell around to copy some values
		NSButtonCell *oldCell = [self cell];
		[self setCell:[[JSFlexibleButtonCell alloc] initTextCell:title]];
		[self.cell setTag:oldCell.tag];
		[self.cell setTarget:oldCell.target];
		[self.cell setAction:oldCell.action];
		[self.cell setContinuous:oldCell.isContinuous];
		[self.cell setState:self.state];
	}
    // we subscribe to notification for frame changes to update the tracking area
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
    [self setPostsFrameChangedNotifications:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
	[self removeTrackingRect:_trackingRect];
}

// pass the style to the buttonCell
- (void)setStyle:(JSButtonStyle *)style
{
    _style = style;
    ((JSFlexibleButtonCell *)self.cell).style = style;
}

- (void)resetTrackingRect
{
	if (_trackingRect) {
		[self removeTrackingRect:_trackingRect];
	}
	NSRect trackingRect = [self frame];
	trackingRect.origin = NSZeroPoint;
	if (_trackMouseInside) {
		_trackingRect = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:NO];
	} else {
		_trackingRect = 0;
	}
}

- (void)setTrackMouseInside:(BOOL)trackMouseInside
{
	if (trackMouseInside != _trackMouseInside) {
		_trackMouseInside = trackMouseInside;
		if (_trackMouseInside) {
			[self resetTrackingRect];
		} else {
			[self removeTrackingRect:_trackingRect];
			if ([[self cell] isMouseOver]) {
				[[self cell] setIsMouseOver:NO];
			}
		}
	}
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	if ([self isEnabled]) {
		[[self cell] setIsMouseOver:YES];
        [self display];
	}
}

- (void)mouseExited:(NSEvent *)theEvent
{
	if ([self isEnabled]) {
		[[self cell] setIsMouseOver:NO];
        [self display];
	}
}

- (void)frameDidChange:(NSNotification *)aNotification
{
	[self resetTrackingRect];
}

- (void)removeFromSuperview
{
	if (_trackingRect) {
		[self removeTrackingRect:_trackingRect];
	}
	[super removeFromSuperview];
}

- (void)removeFromSuperviewWithoutNeedingDisplay
{
	if (_trackingRect) {
		[self removeTrackingRect:_trackingRect];
	}
	[super removeFromSuperviewWithoutNeedingDisplay];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (void)viewDidMoveToWindow
{
	if ([self window]) {
		[self resetTrackingRect];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSWindowDidResizeNotification object:[self window]];
	} else {
		[self removeTrackingRect:_trackingRect];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
	}
}

- (void)setEnabled:(BOOL)flag
{
	if (!flag) {
		[[self cell] setIsMouseOver:NO];
		[self setNeedsDisplay:YES];
        [self removeTrackingRect:_trackingRect];
	} else {
        [self resetTrackingRect];
    }
	[super setEnabled:flag];
}

@end
