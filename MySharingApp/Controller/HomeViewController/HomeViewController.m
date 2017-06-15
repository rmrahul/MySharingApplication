//
//  HomeViewController.m
//  MyApp
//
//  Created by Rahul Mane on 30/10/15.
//  Copyright (c) 2015 Rahul Mane. All rights reserved.
//

#import "HomeViewController.h"
#import "FileUtility.h"
#import "FolderDetailViewController.h"
#import "FileModel.h"

@import LocalAuthentication;


@interface HomeViewController ()
@property(nonatomic,weak) IBOutlet UITableView *tableview;

@end

@implementation HomeViewController
{
    NSMutableArray *arrayOfFiles;
    NSIndexPath *selectedIndexPath;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self showTouchID];


    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    FileUtility *file=[[FileUtility alloc]init];
    arrayOfFiles=[[file listFileAtPath:@""] mutableCopy];;

    [self.tableview reloadData];
    
}




-(void)showTouchID{
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was a problem verifying your identity."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  return;
                              }
                              
                              if (success) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                  message:@"You are the device owner!"
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                                  
                                  
                                  [self.tableview reloadData];

                                  
                                  
                              } else {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"You are not the device owner."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                              
                          }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device cannot authenticate using TouchID."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


#pragma mark - UITableview Delegates


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfFiles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    FileModel *model = [arrayOfFiles objectAtIndex:indexPath.row];
    
    UILabel *lbl=(UILabel *)[cell viewWithTag:101];
    lbl.text = model.strFileName;

    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    
    UILabel *lblDateCreated=(UILabel *)[cell viewWithTag:102];
    lblDateCreated.text = [formatter stringFromDate:model.dateCreated];

    UILabel *lblSize=(UILabel *)[cell viewWithTag:103];
    lblSize.text = [model.sizeInBytes stringValue];

    
    
    UIImageView *img=(UIImageView *)[cell viewWithTag:100];
   // [img setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",documentsPath,[arrayOfFiles objectAtIndex:indexPath.row]]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    selectedIndexPath=indexPath;
    
    [self performSegueWithIdentifier:@"segueFolderDetail" sender:self];
}


#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueFolderDetail"]){
        FolderDetailViewController *folderDetail=(FolderDetailViewController *)[segue destinationViewController];
        
        folderDetail.fileModel=arrayOfFiles[selectedIndexPath.row];
        
    }
}

#pragma mark - Button delegate

-(IBAction)btnAddFolderClicked:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter folder name" delegate:self cancelButtonTitle:@"Cancel"        otherButtonTitles:@"Done",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - Alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        
    }
    else if(buttonIndex==1){
        if([alertView textFieldAtIndex:0].text.length){
            [self createFolder:[alertView textFieldAtIndex:0].text];
        }
    }
    
}


#pragma mark - Helpers

-(void)createFolder:(NSString *)folderName{
    FileUtility *file=[[FileUtility alloc]init];
    if([file createFolderWithName:folderName]){
        arrayOfFiles=[[file listFileAtPath:@""] mutableCopy];;
        [self.tableview reloadData];
    }
    else{
        [self showError:@"Folder can not be created !!!"];
        
    }
}


-(void)showError:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:@"MySharingApp" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}
@end
