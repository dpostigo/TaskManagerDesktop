//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Model.h"
#import "BasicTextField.h"
#import "BasicBackgroundView.h"
#import "NavigationController.h"


@class BasicCustomWindow;


@interface VeryBasicViewController : NSViewController <NSTextFieldDelegate> {

    NSOperationQueue *_queue;
    __unsafe_unretained Model *_model;

    BOOL autoTabbing;
    BOOL showsNavigationBar;

    NSMutableArray *controlsArray;
    NavigationController *navigationController;

    IBOutlet NSButton *submitButton;
    IBOutlet NavigationBar *navigationBar;
    IBOutlet BasicBackgroundView *backgroundView;
    IBOutlet BasicCustomWindow *modalWindow;
}


@property(nonatomic) BOOL autoTabbing;
@property(nonatomic) BOOL showsNavigationBar;
@property(nonatomic, strong) NSOperationQueue *queue;
@property(nonatomic, strong) BasicBackgroundView *backgroundView;
@property(nonatomic, strong) NSMutableArray *controlsArray;

@property(nonatomic, strong) NavigationController *navigationController;
@property(nonatomic, strong) NavigationBar *navigationBar;
@property(nonatomic, strong) BasicCustomWindow *modalWindow;

@property(nonatomic, strong) NSButton *submitButton;
- (IBAction) dismiss: (id) sender;
- (IBAction) handleSubmitButton: (id) sender;

- (id) initWithDefaultNib;
- (void) embedViewController: (NSViewController *) viewController inView: (NSView *) aSuperview;
- (void) replaceViewControllerView: (NSViewController *) viewController asView: (NSView *) aSuperview;
- (void) replaceView: (NSView *) newView asView: (NSView *) oldView;
- (void) addExternalView: (NSViewController *) viewController toView: (NSView *) aSuperview;

- (void) subscribeControl: (NSTextField *) control;
- (void) textFieldEndedEditing: (NSTextField *) textField;
- (void) resignAllTextFields;
- (void) textFieldEndedEditing: (NSTextField *) textField withRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tablesection;
- (void) viewDidAppear;
@end