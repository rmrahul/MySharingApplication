//
//  FileUtility.m
//  MyApp
//
//  Created by Rahul Mane on 30/10/15.
//  Copyright (c) 2015 Rahul Mane. All rights reserved.
//

#import "FileUtility.h"
#import "FileModel.h"

@implementation FileUtility


-(NSString *)getBaseFilePath{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    return documentsPath;
}




-(NSArray *)listFileAtPath:(NSString *)strFilePath
{
    NSMutableArray *arrayToReturn=[[NSMutableArray alloc]init];
    NSString *documentPath=[self getBaseFilePath];
    
    if(strFilePath.length>0){
        documentPath=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",strFilePath]];
    }
    
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:NULL];
    for (int count = 0; count < (int)[directoryContent count]; count++)
    {
        FileModel *fileModel = [[FileModel alloc]init];
        
        NSString *nameOfFile =[directoryContent objectAtIndex:count];
        NSError* error;
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",documentPath,nameOfFile] error: &error];
   

        fileModel.strFileName = nameOfFile;
        fileModel.strFilePath = [NSString stringWithFormat:@"%@/%@",documentPath,nameOfFile];

        fileModel.dateCreated = [fileDictionary objectForKey:NSFileCreationDate];
        fileModel.dateModified = [fileDictionary objectForKey:NSFileModificationDate];
        fileModel.sizeInBytes = [fileDictionary objectForKey:NSFileSize];

        if([fileDictionary objectForKey:NSFileType] == NSFileTypeDirectory){
            fileModel.fileType = fileTypeDirectory;
        }

        [arrayToReturn addObject:fileModel];
    }
    return arrayToReturn;
}

-(BOOL)createFolderWithName:(NSString *)foldername{
    BOOL isSuccess=NO;
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dataPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",foldername]];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        isSuccess=YES;
    }
    else {
        isSuccess=NO;
    }
    
    return isSuccess;
}
@end
