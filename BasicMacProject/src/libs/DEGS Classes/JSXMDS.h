//
//  JSXMDS.h
//  DEGS Model
//
//  Created by Jacopo Sabbatini on 11/12/12.
//  Copyright (c) 2012 Jacopo Sabbatini. All rights reserved.
//

// Main model class

// the structure of an xmds model is a tree where every section and their subelements represent leaves
// the structure of the tree in DEGS matches the structure of the xml tree conatining the script with few notable exception described in their respective classes
// every element in the JSXMDS tree is a JSNode with a parent property
// every node in the tree holds the properties necessary to describe itself and two fundamental methods:
// 1) an exporter that creates an NSXMLElement from the values in the node and its kind
// 2) an initialiser that creates an instance of the node class given an NSXMLElement
// These methods are sufficient to initialise and export the model using recursion in the tree

// For a description of the structure of an xmds tree and the possible values look at: http://www.xmds.org/reference_schema.html

// the description methods in the nodes implementation are used, again with recursion, to create a path that describes the position of the node in the tree.

// throughout the model there are properties that can have only a finite set of values. In these cases, to describe the finite set of options, we use a readonly property in the node with naming convention (propertyName)Options that returns an array of strings representing the options. In this way the view controllers can interrogate the model, ask for the options for a particular propertyName and fill a popUp menu with them. The property associated with the option is represented by an integer and the pattern allows for an easy synchronisation between changes in the model and in the UI. It is also an easy way to avoid that propertyName is set to values that would leave the model in an invalid state.

// some classes in the model act as wrapper for list of other elements. These classes share the following structure:
// a readonly property returning an array of the elements
// a readonly property returning an integer with the number of elements in the list
// an add method that adds the element to the list while setting its parent property to the wrapper class
// a remove method that removes the element from the list given a certain index
// The purpose of the wrapper classes is to keep the tree in a valid state and avoid loose leaves by setting the parent property of the element when added to the list
// The list of classes that act as wrapper is: JSFeatures, JSVectors, JSSequence, JSFilters, JSOperatorsStack, JSOperatorStack, JSOutput.

#import <Foundation/Foundation.h>

#import "JSNode.h"

#import "JSPreamble.h"
#import "JSFeatures.h"
#import "JSDriver.h"
#import "JSGeometry.h"
#import "JSDimension.h"
#import "JSVectors.h"
#import "JSSequence.h"
#import "JSOutput.h"
#import "JSOperatorStack.h"
#import "JSOperatorsStack.h"
#import "JSFilters.h"

@interface JSXMDS : JSNode

// main sections of an xmds script
@property (nonatomic, strong) JSPreamble *preamble;
@property (nonatomic, strong) JSFeatures *features;
@property (nonatomic, strong) JSDriver *driver;
@property (nonatomic, strong) JSGeometry *geometry;
@property (nonatomic, strong) JSVectors *vectors;
@property (nonatomic, strong) JSSequence *sequence;
@property (nonatomic, strong) JSOutput *output;

// the dictionary holds a global list of nodes in the tree that can be accessed through their identifiers. It is useful to directly access some nodes without having to walk the entire tree.
@property (nonatomic, readonly) NSDictionary *globalIdentifiers;

// export method
- (NSXMLDocument *)exportAsXMLDocument;

// designated initiliaser
- (id)initFromXMLDocument:(NSXMLDocument *)aDocument;

// compile dictionary of identifiers and object to trace click on tokens back to their related object
- (NSDictionary *)dimensionIdentifiesDictionary;
- (NSDictionary *)vectorsIdentifiesDictionary;

// high level methods that provides the section view controller with arrays containing lists of the various entities defined in an xmds script
// their implementation calls the low level methods in the respective sections
// the lists are used by the syntaxHighlither for coloring or by the tokenFields for suggestion
- (NSArray *)listOfDimensionsIdentifiersForBasis;
- (NSArray *)listOfDimensionsIdentifiersForDimensions;
- (NSArray *)listOfVectorsIdentifiers;
- (NSArray *)listOfVectorComponentsIdentifiers;
- (NSArray *)listOfArgumentsIdentifiers;
- (NSArray *)listOfMomentsIdentifiers;

- (NSArray *)listOfDimensionsForSubstring:(NSString *)substring;
- (NSArray *)listOfBasisForSubstring:(NSString *)substring;
- (NSArray *)listOfVectorsForSubstring:(NSString *)substring;
- (NSArray *)listOfComponentsForSubstring:(NSString *)substring;
- (NSArray *)listOfArgumentsForSubstring:(NSString *)substring;
- (NSArray *)listOfMomentsForSubstring:(NSString *)substring;

// high level method to extract the lattice of dimension with name dimensionName
- (NSNumber *)gridPointsForDimension:(NSString *)dimensionName;

// create the object path
- (NSArray *)objectPathForString:(NSString *)XPath error:(NSError **)error;

@end
