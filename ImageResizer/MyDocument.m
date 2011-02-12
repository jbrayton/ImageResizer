//
//  MyDocument.m
//  ImageResizer
//
//  Created by John Brayton on 2/12/11.
//  Copyright 2011 John Brayton. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
   // return @"MyDocument";
	return nil;
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (void) save:(NSImage*) argImage to:(NSURL*) argUrl {
    NSData *imageData = [argImage TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
	NSString* path = [argUrl path];
	NSLog(@"should be writing to path: %@", path);
	[imageData writeToFile:path atomically:YES];
	NSLog(@"after writeToFile call");
}

- (NSImage *)imageSmall:(NSImage*) argImage
{
	NSImage *newImage = [[NSImage alloc] initWithSize:NSMakeSize(158, 99)];
	NSRect oldRect = NSMakeRect(0.0, 0.0, 1280, 800);
	NSRect newRect = NSMakeRect(0.0, 0.0, 158, 99);
	
	[newImage lockFocus];
	[argImage drawInRect:newRect fromRect:oldRect operation:NSCompositeCopy fraction:1.0];
	[newImage unlockFocus];
	return [newImage autorelease];
}


- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSData* data = [[NSData alloc] initWithContentsOfURL:absoluteURL];
	image = [[NSImage alloc] initWithData:data];
	NSLog(@"image: %@, url: %@", image, absoluteURL);
	NSString* path = [absoluteURL path];
	path = [path stringByDeletingPathExtension];
	path = [path stringByAppendingPathExtension:@"png"];
	[self save:image to:[NSURL fileURLWithPath:path]];
	path = [[[path stringByDeletingPathExtension] stringByAppendingString:@"_preview"] stringByAppendingPathExtension:@"png"];
	
	/*
	NSImage* smallImage = [[NSImage alloc] initWithSize:NSMakeSize(158,99)];
	[smallImage lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	//[image setSize:NSMakeSize(158,99)];
	[image compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
	[smallImage unlockFocus];*/
	
	NSImage* smallImage = [self imageSmall:image];
	
	
	[self save:smallImage to:[NSURL fileURLWithPath:path]];
	return YES;
}
/*
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	
	image = [[NSImage alloc] initWithData:data];
	NSLog(@"at readFromData -- image: %@", image);
	
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}*/

@end
