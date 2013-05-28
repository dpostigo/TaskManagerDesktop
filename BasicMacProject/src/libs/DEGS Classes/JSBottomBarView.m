//
//  JSBottomBarView.m
//  DEGS
//
//  Created by Jacopo Sabbatini on 16/10/12.
//
//

#import "JSBottomBarView.h"

#import "JSChromeButton.h"

#define SPACE_BETWEEN_BOTTOM_LABELS 15.0 // This is applied only to the lables on left group of buttons and labels in the view
#define BOTTOM_BUTTONS_WIDTH 35.0
#define BOTTOM_BUTTONS_HEIGHT 35.0
#define BOTTOM_TOP_SPACE 3.0
#define BOTTOM_BOTTOM_SPACE 2.0
#define BOTTOM_BUTTON_LABEL_SPACE 1.0
#define BOTTOM_BAR_LINE_COLOR [NSColor colorWithDeviceWhite:0.5f alpha:1.0f] // baseline separator of the bottom bar
// position of the add button when the back button is hidden or shown
#define ADD_BUTTON_POSITION_WHEN_HIDDEN 15.0f
#define ADD_BUTTON_POSITION_WHEN_SHOWN 55.0f

#define TOP_BOTTOM_BARS_TEXTCOLOR [NSColor colorWithCalibratedWhite:0.17f alpha:1.0f]

// utility macros
#define MACRO_VALUE_TO_STRING_( m ) #m
#define MACRO_VALUE_TO_STRING( m ) MACRO_VALUE_TO_STRING_( m )

@interface JSBottomBarView()

@property (strong) IBOutlet NSLayoutConstraint *addButtonPosition;
@property (strong) IBOutlet NSButton *addButton;
@property (strong) IBOutlet NSButton *deleteButton;
@property (strong) IBOutlet NSButton *backButton;
@property (strong) IBOutlet NSButton *helpButton;
@property (strong) IBOutlet NSTextField *addLabel;
@property (strong) IBOutlet NSTextField *deleteLabel;
@property (strong) IBOutlet NSTextField *backLabel;
@property (strong) IBOutlet NSTextField *helpLabel;

@end

@implementation JSBottomBarView

- (void)setUpConstraints
{
    for (NSView *subView in self.subviews) [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.addButtonPosition = [NSLayoutConstraint constraintWithItem:_addLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:ADD_BUTTON_POSITION_WHEN_HIDDEN];
    [self addConstraint:self.addButtonPosition];
    NSDictionary *group = NSDictionaryOfVariableBindings(_backLabel, _addLabel, _deleteLabel, _helpLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_backLabel]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_BOTTOM_LABELS) "-[_addLabel]-" MACRO_VALUE_TO_STRING(SPACE_BETWEEN_BOTTOM_LABELS) "-[_deleteLabel]" options:0 metrics:nil views:group]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_helpLabel]-|" options:0 metrics:nil views:group]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_addLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_addButton
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_backLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_backButton
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_deleteLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_deleteButton
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_helpLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_helpButton
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self.addButton addConstraint:[NSLayoutConstraint constraintWithItem:self.addButton
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:BOTTOM_BUTTONS_WIDTH]];
    [self.addButton addConstraint:[NSLayoutConstraint constraintWithItem:self.addButton
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0f
                                                                constant:BOTTOM_BUTTONS_HEIGHT]];
    
    [self.backButton addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:BOTTOM_BUTTONS_WIDTH]];
    [self.backButton addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:BOTTOM_BUTTONS_HEIGHT]];
    
    [self.deleteButton addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:BOTTOM_BUTTONS_WIDTH]];
    [self.deleteButton addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteButton
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:BOTTOM_BUTTONS_HEIGHT]];
    
    [self.helpButton addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:BOTTOM_BUTTONS_WIDTH]];
    [self.helpButton addConstraint:[NSLayoutConstraint constraintWithItem:self.helpButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:BOTTOM_BUTTONS_HEIGHT]];
    
    group = NSDictionaryOfVariableBindings(_helpButton, _helpLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-" MACRO_VALUE_TO_STRING(BOTTOM_TOP_SPACE) "-[_helpButton]-" MACRO_VALUE_TO_STRING(BOTTOM_BUTTON_LABEL_SPACE) "-[_helpLabel]-" MACRO_VALUE_TO_STRING(BOTTOM_BOTTOM_SPACE) "-|" options:0 metrics:nil views:group]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_helpButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_deleteButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_deleteButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_addButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_addButton
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_backButton
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_helpLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_deleteLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_deleteLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_addLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_addLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_backLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
}

- (void)setButtonsAndLabelsInitialState
{
    [self.backButton setEnabled:NO];
    [self.backButton setAlphaValue:0.0f];
    [self.backLabel setAlphaValue:0.0f];
    self.backLabel.textColor = TOP_BOTTOM_BARS_TEXTCOLOR;
    self.addLabel.textColor = TOP_BOTTOM_BARS_TEXTCOLOR;
    self.deleteLabel.textColor = TOP_BOTTOM_BARS_TEXTCOLOR;
    self.helpLabel.textColor = TOP_BOTTOM_BARS_TEXTCOLOR;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpConstraints];
    
    [self setButtonsAndLabelsInitialState];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backButton = [self createButtonWithImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"BackTemplate"]] action:@selector(backButtonPressed:)];
        [self.backButton setKeyEquivalent:@"b"];
        [self.backButton setKeyEquivalentModifierMask:NSCommandKeyMask];
        
        self.helpButton = [self createButtonWithImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"HelpTemplate"]] action:@selector(helpButtonPressed:)];
        [self.helpButton setKeyEquivalent:@"h"];
        [self.helpButton setKeyEquivalentModifierMask:NSCommandKeyMask];
        
        self.addButton = [self createButtonWithImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"AddTemplate"]] action:@selector(newButtonPressed:)];
        [self.addButton setKeyEquivalent:@"n"];
        [self.addButton setKeyEquivalentModifierMask:NSCommandKeyMask];
        
        self.deleteButton = [self createButtonWithImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"DeleteTemplate"]] action:@selector(deleteButtonPressed:)];
        [self.deleteButton setKeyEquivalent:@"d"];
        [self.deleteButton setKeyEquivalentModifierMask:NSCommandKeyMask];

        self.backLabel = [self createLabelWithTitle:@"Back"];
        self.addLabel = [self createLabelWithTitle:@"New"];
        self.helpLabel = [self createLabelWithTitle:@"Help"];
        self.deleteLabel = [self createLabelWithTitle:@"Delete"];
        
        // the size of the letter "e" is not integer in the system font. When the layout system computes the intrinsicContentSize of the delete label on non retina screens it rounds it to smaller integer which hides the last e in Delete. We have to force the width of the label to the next larger integer to show the missing letter
        [self.deleteLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteLabel
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:37.0f]];
        
        [self setUpConstraints];
        
        [self setButtonsAndLabelsInitialState];
        
    }
    return self;
}

- (NSTextField *)createLabelWithTitle:(NSString *)title
{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 10)];
    [textField setStringValue:title];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [self addSubview:textField];
    return textField;
}

- (NSButton *)createButtonWithImage:(NSImage *)image action:(SEL)action
{
    NSButton *button = [[JSChromeButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
    button.image = image;
    [button setImagePosition:NSImageOnly];
    [button setShowsBorderOnlyWhileMouseInside:YES];
    [button setBezelStyle:NSRegularSquareBezelStyle];
    [button setTarget:self];
    [button setAction:action];
    [button setButtonType:NSMomentaryChangeButton];
    [self addSubview:button];
    return button;
}

# pragma mark - look and state of the buttons

- (void)showBackButton:(BOOL)show withAnimation:(BOOL)animate
{
    if ([self.backButton isEnabled] != show) {
        [self.backButton setEnabled:show];
        if (animate) [NSAnimationContext beginGrouping];
        if (show) {
            [[self.backButton animator] setAlphaValue:1.0f];
            [[self.backLabel animator] setAlphaValue:1.0f];
            [[self.addButtonPosition animator] setConstant:ADD_BUTTON_POSITION_WHEN_SHOWN];
        } else {
            [[self.backButton animator] setAlphaValue:0.0f];
            [[self.backLabel animator] setAlphaValue:0.0f];
            [[self.addButtonPosition animator] setConstant:ADD_BUTTON_POSITION_WHEN_HIDDEN];
        }
        if (animate) [NSAnimationContext endGrouping];
    }
}

- (void)setNewLabel:(NSString *)newLabel
{
    [[self.addLabel animator] setStringValue:newLabel];
}

- (void)enableNewButton:(BOOL)newState
{
    [self.addButton setEnabled:newState];
    [self.addLabel setEnabled:newState];
}

- (void)enableDeleteButton:(BOOL)newState
{
    [self.deleteButton setEnabled:newState];
    [self.deleteLabel setEnabled:newState];
}

# pragma mark - delegate calls

- (IBAction)backButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(backButtonPressed:)]) {
        [self.delegate backButtonPressed:sender];
    }
}

- (IBAction)newButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addElement:)]) {
        [self.delegate addElement:sender];
    }
}

- (IBAction)deleteButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteElement:)]) {
        [self.delegate deleteElement:sender];
    }
}

- (IBAction)helpButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(helpButtonPressed:)]) {
        [self.delegate helpButtonPressed:sender];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // The method is called with dirtyRect being the portion of the view that needs to be redrawn not necessarily the whole view.
    // Our custom drawing method only adds two 1 point lines at the top of the view. we want to save redrawing by checking that the redrawing region does include those two lines
    if (NSMaxY(dirtyRect)<NSMaxY(self.bounds)-2.0) return;

    NSRect bottomRect = NSMakeRect(0.0, NSMaxY(self.bounds) - 2.0, NSWidth(dirtyRect), 1.0);
    [[NSColor colorWithDeviceWhite:1.0 alpha:0.2] setFill];
    [[NSBezierPath bezierPathWithRect:bottomRect] fill];
    
    if (NSMaxY(dirtyRect)<NSMaxY(self.bounds)-1.0) return;
    
    bottomRect.origin.y += 1.0;
    NSColor *bottomColor = BOTTOM_BAR_LINE_COLOR;
    [bottomColor set];
    NSRectFill(bottomRect);
}

@end
