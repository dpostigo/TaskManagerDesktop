//
//  JSIntroductionTableCellView.h
//  DEGS
//
//  Created by Jacopo Sabbatini on 26/07/12.
//
//

#import "JSTableCellView.h"
#import "JSTextField.h"

@interface JSIntroductionTableCellView : JSTableCellView

@property (strong) IBOutlet NSPopUpButton *formatButton;
@property (strong) IBOutlet JSTextField *filenameTextField;

@end
