//
//  FolderDetailViewController.m
//  MyApp
//
//  Created by Rahul Mane on 02/11/15.
//  Copyright (c) 2015 Rahul Mane. All rights reserved.
//

#import "FolderDetailViewController.h"
#import "FileUtility.h"

@interface FolderDetailViewController ()
@property(nonatomic,weak) IBOutlet UITableView *tableview;

@end

@implementation FolderDetailViewController
{
    NSMutableArray *arrayOfFiles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    FileUtility *file=[[FileUtility alloc]init];
    arrayOfFiles=[[file listFileAtPath:self.fileModel.strFileName] mutableCopy];;
    
    [self.tableview reloadData];
}



#pragma mark - UITableview Delegates


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfFiles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    FileModel *model = [arrayOfFiles objectAtIndex:indexPath.row];
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:101];
    lbl.text =  model.strFileName;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    
    UILabel *lblDateCreated=(UILabel *)[cell viewWithTag:102];
    lblDateCreated.text = [formatter stringFromDate:model.dateCreated];
    
    UILabel *lblSize=(UILabel *)[cell viewWithTag:103];
    lblSize.text = [NSString stringWithFormat:@"%@ %@",[model.sizeInBytes stringValue],@"bytes"];

    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    UIImageView *img=(UIImageView *)[cell viewWithTag:100];
    
    [img setImage:[UIImage imageWithContentsOfFile:model.strFilePath]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileModel *model=[arrayOfFiles objectAtIndex:indexPath.row];
    
    if(model.fileType == fileTypeDirectory){
        FolderDetailViewController *detail=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FolderDetailViewController"];
        detail.fileModel = model;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

@end
