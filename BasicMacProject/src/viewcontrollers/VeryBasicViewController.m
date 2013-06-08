//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VeryBasicViewController.h"
#import "BasicTextField.h"
#import "BasicSecureTextField.h"
#import "BasicCustomWindow.h"


@implementation VeryBasicViewController {
}


@synthesize backgroundView;
@synthesize controlsArray;
@synthesize autoTabbing;
@synthesize navigationBar;
@synthesize showsNavigationBar;
@synthesize navigationController;

@synthesize modalWindow;



#pragma mark IBActions

@synthesize submitButton;

- (IBAction) dismiss: (id) sender {
    if (modalWindow != nil) {
        [modalWindow dismissController: self animated: YES];
    }
}



#pragma mark Initing


- (id) initWithDefaultNib {
    NSString *path = [[NSBundle mainBundle] pathForResource: NSStringFromClass([self class]) ofType: @"nib"];
    if (path != nil) {
        return [self initWithNibName: NSStringFromClass([self class]) bundle: nil];
    } else {
        NSLog(@"Did not find nib for %@", NSStringFromClass([self class]));
        return [self initWithNibName: NSStringFromClass([self superclass]) bundle: nil];
    }
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark NavigationBar


- (void) setShowsNavigationBar: (BOOL) showsNavigationBar1 {
    showsNavigationBar = showsNavigationBar1;
}

- (void) loadView {
    [super loadView];
    if (_queue == nil) _queue = [NSOperationQueue new];
    _model = [Model sharedModel];
    [_model subscribeDelegate: self];
    self.controlsArray = [[NSMutableArray alloc] init];
}

- (void) embedViewController: (NSViewController *) viewController inView: (NSView *) aSuperview {
    viewController.view.frame = aSuperview.bounds;
    //    [viewController.view setAutoresizingMask: aSuperview.autoresizingMask];

    //    if ([aSuperview superview]) [aSuperview removeFromSuperview];
    [aSuperview addSubview: viewController.view];
}

- (void) replaceViewControllerView: (NSViewController *) viewController asView: (NSView *) aSuperview; {

    viewController.view.frame = aSuperview.bounds;
    [viewController.view setAutoresizingMask: aSuperview.autoresizingMask];

    if ([aSuperview superview]) [aSuperview removeFromSuperview];
    [self.view addSubview: viewController.view];
}

- (void) replaceView: (NSView *) newView asView: (NSView *) oldView; {
    newView.frame = oldView.frame;
    newView.autoresizingMask = oldView.autoresizingMask;
    if ([oldView superview]) {
        NSView *superView = [oldView superview];
        [oldView removeFromSuperview];
        [superView addSubview: newView];
    }
}

- (void) addExternalView: (NSViewController *) viewController toView: (NSView *) aSuperview {

    viewController.view.frame = aSuperview.bounds;
    [viewController.view setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    [aSuperview addSubview: viewController.view];
}

- (IBAction) handleSubmitButton: (id) sender {
}


#pragma mark NSTextFieldDelegate

- (BOOL) control: (NSControl *) control textShouldBeginEditing: (NSText *) fieldEditor {
    return YES;
}

- (BOOL) control: (NSControl *) control textShouldEndEditing: (NSText *) fieldEditor {
    [self textFieldEndedEditing: (NSTextField *) control];
    return YES;
}


#pragma mark BasicTextField

- (void) subscribeControl: (NSTextField *) control {
    if (control == nil) return;
    if ([control isKindOfClass: [NSTextField class]]) {
        NSTextField *textField = (NSTextField *) control;
        textField.delegate = self;

        NSTextField *lastTextField = [controlsArray lastObject];
        lastTextField.nextKeyView = textField;

        if ([controlsArray count] > 0) {
            textField.nextKeyView = [controlsArray objectAtIndex: 0];
        } else {
            if (modalWindow) {
                modalWindow.initialFirstResponder = textField;
                //                modalWindow.autorecalculatesKeyViewLoop
            }
        }
    }
    [controlsArray addObject: control];
}

- (void) textFieldEndedEditing: (NSTextField *) textField {
    if ([textField isKindOfClass: [BasicTextField class]]) {
        BasicTextField *basicTextField = (BasicTextField *) textField;
        [self textFieldEndedEditing: basicTextField withRowObject: basicTextField.rowObject tableSection: basicTextField.tableSection];
    }

    else if ([textField isKindOfClass: [BasicSecureTextField class]]) {
        BasicSecureTextField *secureTextField = (BasicSecureTextField *) textField;
        NSLog(@"secureTextField = %@", secureTextField);
        [self textFieldEndedEditing: secureTextField withRowObject: secureTextField.rowObject tableSection: secureTextField.tableSection];
    }


    //    [self triggerNextControl: textField];
}

- (void) resignAllTextFields {
    for (NSControl *control in controlsArray) {
        if ([control isKindOfClass: [NSTextField class]]) {
            [self textFieldEndedEditing: (NSTextField *) control];
        }
    }
}

- (void) triggerNextControl: (NSControl *) control {

    if (autoTabbing) {
        if ([controlsArray containsObject: control]) {
            NSUInteger index = [controlsArray indexOfObject: control];
            if (index < [controlsArray count] - 1) {
                NSControl *nextControl = [controlsArray objectAtIndex: index + 1];
                //                [[nextControl window] becomeFirstResponder];
                //                [[nextControl window] makeFirstResponder: nextControl];
            }
        }
    }
}

- (void) textFieldEndedEditing: (NSTextField *) textField withRowObject: (TableRowObject *) rowObject tableSection: (TableSection *) tableSection {
}




#pragma mark Push / pop

- (void) viewDidAppear {

}

@end