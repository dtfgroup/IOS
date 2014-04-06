//
//  ColourSwitcher.m
//  mapper
//
//  Created by Tope on 21/02/2012.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ColorSwitcher.h"

@implementation ColorSwitcher

//@synthesize imageNames, textColor;

@synthesize processedImages, modifiedImages, hue, saturation, textColor;

-(id)initWithScheme:(NSString*)scheme
{
    self = [super init];
    
    if(self)
    {
        if([scheme isEqualToString:@"blue"])
        {   
            hue = 0;
            saturation = 1;
            
            self.textColor = [UIColor colorWithRed:30.0/255 green:110.0/255 blue:178.0/255 alpha:1.0];
            
        }
        else if([scheme isEqualToString:@"brown"])
        {
            hue = -3.14;
            saturation = 1;
            
            self.textColor = [UIColor colorWithRed:194.0/255 green:126.0/255 blue:74.0/255 alpha:1.0];
        }
        self.processedImages = [NSMutableDictionary dictionary];
        self.modifiedImages = [NSMutableDictionary dictionary];
        
        processedImages[@"menubar"] = [UIImage imageNamed:@"menubar.png"];
        processedImages[@"menubar-7"] = [UIImage imageNamed:@"menubar-7.png"];
        processedImages[@"slider-fill"] = [UIImage imageNamed:@"slider-fill.png"];
        processedImages[@"tabbar"] = [UIImage imageNamed:@"tabbar.png"];
        processedImages[@"ipad-menubar-left"] = [UIImage imageNamed:@"ipad-menubar-left.png"];
        processedImages[@"ipad-menubar-left-7"] = [UIImage imageNamed:@"ipad-menubar-left-7.png"];
        processedImages[@"ipad-menubar-right"] = [UIImage imageNamed:@"ipad-menubar-right.png"];
        processedImages[@"ipad-menubar-right-7"] = [UIImage imageNamed:@"ipad-menubar-right-7.png"];
        processedImages[@"ipad-tabbar-left"] = [UIImage imageNamed:@"ipad-tabbar-left.png"];
        processedImages[@"ipad-tabbar-right"] = [UIImage imageNamed:@"ipad-tabbar-right.png"];
        processedImages[@"back"] = [UIImage imageNamed:@"back.png"];
        processedImages[@"bar-button"] = [UIImage imageNamed:@"bar-button.png"];

        
        
    }
    
    return self;
}

-(UIImage*)processImage:(UIImage*)originalImage withKey:(NSString*)key
{
    
    UIImage* existingImage = modifiedImages[key];
    
    if(existingImage)
    {
        return existingImage;
    }
    else if (hue == 0 && saturation == 1)
    {
        return originalImage;
    }
    
    
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(originalImage)];
    
    CIContext* context = [CIContext contextWithOptions:nil];
    
    CIFilter* hueFilter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, beginImage, @"inputAngle", @(hue), nil];
    
    CIImage *outputImage = [hueFilter outputImage];
    
    CIFilter* saturationFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, outputImage, @"inputSaturation", @(saturation), nil];
    
    outputImage = [saturationFilter outputImage];
    
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    
    UIImage *processed;
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 )
    {
        processed = [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp]; 
    }
    else
    {
        processed = [UIImage imageWithCGImage:cgimg]; 
    }
    
    CGImageRelease(cgimg);
    
    modifiedImages[key] = processed;
    
    return processed;
    
}



-(UIImage*)getImageWithName:(NSString*)imageName
{
    UIImage* image = processedImages[imageName];
    
    return [self processImage:image withKey:imageName];
}

/*

-(NSString*)getImageNameForResource:(NSString*)resource
{
    return [imageNames objectForKey:resource];
}
*/

@end
