////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Qualcomm Innovation Center, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////

#import "AJNMViewController.h"
#import "AJNMObjectModel.h"
#import "AJNMObject.h"
#import "AJNMInterface.h"
#import "AJNMProperty.h"
#import "AJNMSignal.h"
#import "AJNMMethod.h"
#import "AJNMArgument.h"
#import "AJNMAnnotation.h"
#import "AJNMType.h"

@interface AJNMViewController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, strong) NSXMLDocument *xmlDocument;
@property (nonatomic, strong) AJNMObjectModel *objectModel;
@property (nonatomic, readonly) AJNMModelElement *selectedElementInObjectsView;
@property (nonatomic, readonly) AJNMModelElement *selectedElementInDetailsView;

- (void)openFileURL:(NSURL*)url;
- (void)buildObjectModelFromXMLDocument;
- (AJNMObjectModel *)buildObjectFromXMLElement:(NSXMLElement *)nodeElement;
- (AJNMInterface *)buildInterfaceFromXMLElement:(NSXMLElement *)methodElement;
- (AJNMMethod *)buildMethodFromXMLElement:(NSXMLElement *)methodElement;
- (AJNMSignal *)buildSignalFromXMLElement:(NSXMLElement *)methodElement;
- (AJNMProperty *)buildPropertyFromXMLElement:(NSXMLElement *)methodElement;
- (AJNMArgument *)buildArgumentFromXMLElement:(NSXMLElement *)methodElement;
- (AJNMAnnotation *)buildAnnotationFromXMLElement:(NSXMLElement *)methodElement;

@end

@implementation AJNMViewController

@synthesize objectsOutlineView = _objectsOutlineView;
@synthesize detailsOutlineView = _detailsOutlineView;
@synthesize inspectorTableView = _inspectorTableView;
@synthesize xmlDocument = _xmlDocument;
@synthesize objectModel = _objectModel;

- (AJNMModelElement *)selectedElementInObjectsView
{
    return [self.objectsOutlineView itemAtRow:self.objectsOutlineView.selectedRow];
}

- (AJNMModelElement *)selectedElementInDetailsView
{
    return [self.detailsOutlineView itemAtRow:self.detailsOutlineView.selectedRow];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - UI event handlers

- (IBAction)didSelectFileOpen:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    NSInteger result = [openPanel runModal];
    if (result == NSFileHandlingPanelOKButton) {
        if (openPanel.URLs.count == 1) {
            NSURL *url = [openPanel.URLs objectAtIndex:0];
            NSLog(@"Selected the file: %@", url);
            
            [self.objectsOutlineView setDelegate:self];            
            [self.objectsOutlineView setDataSource:self];
            [self.detailsOutlineView setDelegate:self];
            [self.detailsOutlineView setDataSource:self];
            
            // open the object model XML file
            //
            [self openFileURL:url];
            
            // update the objects outline view
            //
            [self.objectsOutlineView reloadData];
            [self.detailsOutlineView reloadData];
            [self.inspectorTableView reloadData];
        }
    }
}

- (IBAction)didSelectFileSave:(id)sender 
{
    
}

#pragma mark - Object Model file operations

- (void)openFileURL:(NSURL *)url
{
    NSError *error = nil;
    
    self.xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if (error != nil) {
        NSLog(@"ERROR: Unable to open XML document at %@. %@", url, error);
        return;
    }
    
    // build out the object model from the file
    //
    [self buildObjectModelFromXMLDocument];
}

#pragma mark - Object Model XML processing

- (void)buildObjectModelFromXMLDocument
{
    self.objectModel = [[AJNMObjectModel alloc] init];
    
    for (NSXMLElement *aNodeElement in self.xmlDocument.rootElement.children)
    {
        if ([aNodeElement.name compare:@"node"] == NSOrderedSame) {
            [self.objectModel.objects addObject:[self buildObjectFromXMLElement:aNodeElement]];
        }
    }
}

- (AJNMObject *)buildObjectFromXMLElement:(NSXMLElement *)nodeElement
{
    AJNMObject *anObject = [[AJNMObject alloc] init];
    NSXMLNode *anAttribute = [nodeElement attributeForName:@"name"];
    
    anObject.name = anAttribute.stringValue;
    
    for (NSXMLElement *aChildElement in nodeElement.children)
    {
        if ([aChildElement.name compare:@"annotation"] == NSOrderedSame) {
            [anObject.annotations addObject:[self buildAnnotationFromXMLElement:aChildElement]];
        }
        else if ([aChildElement.name compare:@"interface"] == NSOrderedSame) {
            [anObject.interfaces addObject:[self buildInterfaceFromXMLElement:aChildElement]];
        }
        else if ([aChildElement.name compare:@"node"] == NSOrderedSame) {
            [anObject.children addObject:[self buildObjectFromXMLElement:aChildElement]];
        }
    }
    
    return anObject;
}

- (AJNMInterface *)buildInterfaceFromXMLElement:(NSXMLElement *)interfaceElement
{
    AJNMInterface *anInterface = [[AJNMInterface alloc] init];
    NSXMLNode *nameAttribute = [interfaceElement attributeForName:@"name"];        
    
    anInterface.name = nameAttribute.stringValue;
    
    for (NSXMLElement *aChildElement in interfaceElement.children)
    {
        if ([aChildElement.name compare:@"annotation"] == NSOrderedSame) {
            [anInterface.annotations addObject:[self buildAnnotationFromXMLElement:aChildElement]];
        }
        else if ([aChildElement.name compare:@"method"] == NSOrderedSame) {
            [anInterface.methods addObject:[self buildMethodFromXMLElement:aChildElement]];
        }
        else if ([aChildElement.name compare:@"signal"] == NSOrderedSame) {
            [anInterface.signals addObject:[self buildSignalFromXMLElement:aChildElement]];
        }
        else if ([aChildElement.name compare:@"property"] == NSOrderedSame) {
            [anInterface.properties addObject:[self buildPropertyFromXMLElement:aChildElement]];
        }
    }
    
    return anInterface;
}

- (AJNMMethod *)buildMethodFromXMLElement:(NSXMLElement *)methodElement
{
    AJNMMethod *aMethod = [[AJNMMethod alloc] init];
    NSXMLNode *nameAttribute = [methodElement attributeForName:@"name"];
    
    aMethod.name = nameAttribute.stringValue;
    
    for (NSXMLElement *aChildElement in methodElement.children)
    {
        if ([aChildElement.name compare:@"arg"] == NSOrderedSame) {
            [aMethod.arguments addObject:[self buildArgumentFromXMLElement:aChildElement]];
        }
    }
    
    return aMethod;
}

- (AJNMSignal *)buildSignalFromXMLElement:(NSXMLElement *)signalElement
{
    AJNMSignal *aSignal = [[AJNMSignal alloc] init];
    NSXMLNode *nameAttribute = [signalElement attributeForName:@"name"];
    
    aSignal.name = nameAttribute.stringValue;
    
    for (NSXMLElement *aChildElement in signalElement.children)
    {
        if ([aChildElement.name compare:@"arg"] == NSOrderedSame) {
            [aSignal.arguments addObject:[self buildArgumentFromXMLElement:aChildElement]];
        }
    }
    
    return aSignal;
}

- (AJNMProperty *)buildPropertyFromXMLElement:(NSXMLElement *)propertyElement
{
    AJNMProperty *aProperty = [[AJNMProperty alloc] init];
    NSXMLNode *nameAttribute = [propertyElement attributeForName:@"name"];
    NSXMLNode *typeAttribute = [propertyElement attributeForName:@"type"];
    NSXMLNode *accessAttribute = [propertyElement attributeForName:@"access"];
    
    aProperty.name = nameAttribute.stringValue;
    aProperty.type = [AJNMType typeFromSignature:typeAttribute.stringValue];
    if ([accessAttribute.stringValue compare:@"read"] == NSOrderedSame) {
        aProperty.access = kAJNMPropertyAccessTypeRead;
    }
    else if ([accessAttribute.stringValue compare:@"readwrite"] == NSOrderedSame)
    {
        aProperty.access = kAJNMPropertyAccessTypeReadWrite;
    }
    else if ([accessAttribute.stringValue compare:@"write"] == NSOrderedSame)
    {
        aProperty.access = kAJNMPropertyAccessTypeWrite;
    }
    
    return aProperty;    
}

- (AJNMArgument *)buildArgumentFromXMLElement:(NSXMLElement *)argumentElement
{
    AJNMArgument *anArgument = [[AJNMArgument alloc] init];
    NSXMLNode *nameAttribute = [argumentElement attributeForName:@"name"];    
    NSXMLNode *typeAttribute = [argumentElement attributeForName:@"type"];
    NSXMLNode *directionAttribute = [argumentElement attributeForName:@"direction"];
    
    anArgument.name = nameAttribute.stringValue;
    anArgument.type = [AJNMType typeFromSignature:typeAttribute.stringValue];
    if ([directionAttribute.stringValue compare:@"in"] == NSOrderedSame) {
        anArgument.direction = kAJNMArgumentDirectionIn;
    }
    else if ([directionAttribute.stringValue compare:@"out"] == NSOrderedSame) {
        anArgument.direction = kAJNMArgumentDirectionOut;        
    }

    for (NSXMLElement *aChildElement in argumentElement.children)
    {
        if ([aChildElement.name compare:@"annotation"] == NSOrderedSame) {
            [anArgument.annotations addObject:[self buildAnnotationFromXMLElement:aChildElement]];
        }
    }
    
    return anArgument;
}

- (AJNMAnnotation *)buildAnnotationFromXMLElement:(NSXMLElement *)annotationElement
{
    AJNMAnnotation *anAnnotation = [[AJNMAnnotation alloc] init];
    NSXMLNode *nameAttribute = [annotationElement attributeForName:@"name"];    
    NSXMLNode *valueAttribute = [annotationElement attributeForName:@"value"];
    
    anAnnotation.name = nameAttribute.stringValue;
    anAnnotation.value = valueAttribute.stringValue;
    
    return anAnnotation;
}

#pragma mark - NSOutlineViewDataSource implementation

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSInteger numberOfChildren = 0;

    if (outlineView == self.objectsOutlineView) {
        if (item == nil) {
            numberOfChildren = self.objectModel.objects.count;
        }
        else if ([item isKindOfClass:[AJNMObject class]]) {
            numberOfChildren = ((AJNMObject*)item).interfaces.count;
        }
    }
    else if (outlineView == self.detailsOutlineView) {
        // get the selected item in the objects pane
        //
        AJNMModelElement *element = self.selectedElementInObjectsView;

        if (item == nil) {
            if ([element isKindOfClass:[AJNMObject class]]) {
                numberOfChildren = ((AJNMObject *)element).interfaces.count;
            }
            else if ([element isKindOfClass:[AJNMInterface class]]) {
                // we always have three top level children when an interface is selected:
                //      Methods
                //      Properties
                //      Signals
                //
                numberOfChildren = 3;
            }
        }
        else if ([item isKindOfClass:[NSString class]]) {
            NSString *itemString = item;
            if ([itemString compare:@"Methods"] == NSOrderedSame) {
                numberOfChildren = ((AJNMInterface *)element).methods.count;
            }
            else if ([itemString compare:@"Properties"] == NSOrderedSame)
            {
                numberOfChildren = ((AJNMInterface *)element).properties.count;
            }
            else if ([itemString compare:@"Signals"] == NSOrderedSame)
            {
                numberOfChildren = ((AJNMInterface *)element).signals.count;
            }
        }
    }
    
    return numberOfChildren;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    id requestedItem = nil;
    
    if (outlineView == self.objectsOutlineView) {
        if (item == nil) {
            requestedItem = [self.objectModel.objects objectAtIndex:index];
        } 
        else if ([item isKindOfClass:[AJNMObject class]]) {
            requestedItem = [((AJNMObject*)item).interfaces objectAtIndex:index];
        }
    }
    else if (outlineView == self.detailsOutlineView) {
        AJNMModelElement *selectedElement = self.selectedElementInObjectsView;
        if (item == nil) {
            if ([selectedElement isKindOfClass:[AJNMObject class]]) {
                requestedItem = [((AJNMObject*)selectedElement).interfaces objectAtIndex:index];
            }
            else if ([selectedElement isKindOfClass:[AJNMInterface class]]) {
                NSArray *items = [NSArray arrayWithObjects:@"Properties", @"Methods", @"Signals", nil];
                requestedItem = [items objectAtIndex:index];
            }
        }
        else if ([item isKindOfClass:[NSString class]]) {
            NSString *selectedItemString = item;
            if ([selectedItemString compare:@"Methods"] == NSOrderedSame) {
                requestedItem = [((AJNMInterface *)selectedElement).methods objectAtIndex:index];
            }
            else if ([selectedItemString compare:@"Properties"] == NSOrderedSame) {
                requestedItem = [((AJNMInterface *)selectedElement).properties objectAtIndex:index];
            }
            else if ([selectedItemString compare:@"Signals"] == NSOrderedSame) {
                requestedItem = [((AJNMInterface *)selectedElement).signals objectAtIndex:index];
            }
        }
    }
    
    return requestedItem;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    BOOL isExpandable = NO;
    
    if (outlineView == self.objectsOutlineView) {
        if (item == nil) {
            isExpandable = YES;
        }
        else if ([item isKindOfClass:[AJNMObject class]]) {
            isExpandable = YES;
        }
    }
    else if (outlineView == self.detailsOutlineView) {
        if (item == nil) {
            isExpandable = YES;
        }
        else if ([item isKindOfClass:[NSString class]]) {
            isExpandable = YES;
        }
    }
    
    return isExpandable;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    id objectValue = nil;
    
    if (outlineView == self.objectsOutlineView) {
        if (item == nil) {
            if ([tableColumn.identifier compare:@"name"] == NSOrderedSame) {
                objectValue = @"Name";
            }
            else if ([tableColumn.identifier compare:@"detail"] == NSOrderedSame) {
                objectValue = @"Details";
            }
        }
        else 
        {
            if ([tableColumn.identifier compare:@"name"] == NSOrderedSame) {
                objectValue = [item descriptiveName];
            }
            else if ([tableColumn.identifier compare:@"detail"] == NSOrderedSame) {
                objectValue = [item name];
            }
            
        }
    }
    else if (outlineView == self.detailsOutlineView) {
        
        if (item == nil) {
            if ([tableColumn.identifier compare:@"name"] == NSOrderedSame) {
                objectValue = @"Name";
            }
            else if ([tableColumn.identifier compare:@"detail"] == NSOrderedSame) {
                objectValue = @"Details";
            }
        }
        else if ([item isKindOfClass:[NSString class]]) {
            if ([tableColumn.identifier compare:@"member"] == NSOrderedSame) {
                objectValue = item;
            }
        }
        else 
        {
            if ([tableColumn.identifier compare:@"member"] == NSOrderedSame) {
                objectValue = [item descriptiveName];
            }
            else if ([tableColumn.identifier compare:@"detail"] == NSOrderedSame) {
                objectValue = [item name];
            }
            
        }
    }

    return objectValue;
}

#pragma mark - NSOutlineViewDelegate implementation

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if (notification.object == self.objectsOutlineView) {
        [self.detailsOutlineView reloadData];
        [self.inspectorTableView reloadData];        
    }
    else if (notification.object == self.detailsOutlineView) {
        [self.inspectorTableView reloadData];
    }
}

@end
