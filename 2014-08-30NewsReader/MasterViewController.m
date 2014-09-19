//
//  MasterViewController.m
//  2014-08-30NewsReader
//
//  Created by kotepe on H26/08/30.
//  Copyright (c) 平成26年 kotepe factory. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
{
    NSMutableArray *_items;
    Item *_item;
    NSXMLParser *_parser;
    NSString *_elementName;
    
    
}
@end

@implementation MasterViewController

/*
 
 - (void)awakeFromNib
 {
 [super awakeFromNib];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //画面を引っ張った後の動き
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    [refreshControl addTarget:self//呼び出すメソッドを持つクラスを指定する
     
                       action:@selector(startDownload)//引っ張られた後に呼び出すメソッドを、＠selecter（メッソド名）の形式で指定する。
     
             forControlEvents:UIControlEventValueChanged];//「引っ張られた」というイベントを感知するために、UIControlEventValueChangedを指定する。
    
    self.refreshControl = refreshControl;
    
    
    
    
    /*
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
     
     UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
     self.navigationItem.rightBarButtonItem = addButton;
     */
    
    
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 - (void)insertNewObject:(id)sender
 {
 if (!_objects) {
 _objects = [[NSMutableArray alloc] init];
 }
 [_objects insertObject:[NSDate date] atIndex:0];
 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
 [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 }
 
 


#pragma mark - Table View
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Item *item = _items[indexPath.row];
    cell.textLabel.text = [item title];
    return cell;
}

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 [_objects removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 
 
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Item *item = _items[indexPath.row];
        [[segue destinationViewController] setDetailItem:item];
    
    }
}

//下にスライドさせてダウンロードできる
-(void)startDownload//本を書いた人がこのメソッドを作った
{
    
    //チェックが２回行われている
    //NSLog(@"check out");
    
    
    _items = [[NSMutableArray alloc] init];//すべての記事が入る箱
    NSString *feed = @"http://www.apple.com/jp/main/rss/hotnews/hotnews.rss";
    
    NSURL *url = [NSURL URLWithString:feed];//文字列のURLをNSURLクラスのurlインスタンスに変換している
    NSURLRequest *request = [NSURLRequest requestWithURL:url];//更にurlインスタンスを更にNSURLRequestクラスのreauestインスタンスに変換している
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //くるくる回るアニメーション　と　ニュース記事をダウンロード
    [NSURLConnection sendAsynchronousRequest:request//データが有るウェブサイトのURL（NSURLRequestのインスタンス）を指定している
                                       queue:queue//ダウンロードを行う処理の流れ（NSOperationQueueのインスタンス）を指定している
                           completionHandler:^(NSURLResponse *response, NSData *data,NSError *error)//ダウンロードされたデータを処理するコードを書くブロックを指定する
     {
         _parser = [[NSXMLParser alloc] initWithData:data];
         _parser.delegate = self;//_parserのデリゲートとして(self)を（MasterViewController）を指定しています。
         [_parser parse];//Parseメソッドを呼び出すとデータ解析が始まる
         
     }];
    
    //一回しか読み込まれない
    //NSLog(@"check out");
    
    
    //]zkshdkov
    
    
    
    
    
    
}

  -(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName//elementName引数に要素が入っています。
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict


{
    //何回も読み込むコードである。
    //NSLog(@"check out");
    
    _elementName = elementName;//要素名は別のメソッドでも使うので_elementNameインスタンス変数に入れて、このメソッドが終了しても保持できる
    if ([_elementName isEqualToString:@"item"])//欲しいニュースの記事が入っている要素名は”item”
    {
        _item = [[Item alloc] init];
        _item.title = @"";
        _item.description = @"";
        //何回も読み込まれる
    //NSLog(@"check out")
        }
}


-(void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string

{
    
    //何回も読むこむ
    //NSLog(@"check out")
    
    if ([_elementName isEqualToString:@"title"])//if ([_elementName isEqualToString:@"title])"])と書いていた。
    {
        _item.title = [_item.title stringByAppendingString:string];
    }
    else if ([_elementName isEqualToString:@"description"])
    {
        _item.description = [_item.description stringByAppendingString:string];
    
    }
    
}


//ここで　　parserDidEndDocument:(NSXMLParser *)parser　　と書いたため
//ロードできなかった
-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
//   attributes:(NSDictionary *)attributeDict

{
    if ([elementName isEqualToString:@"item"])
        
    {
        
        [_items addObject:_item];
        
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.refreshControl endRefreshing];
                       [self.tableView reloadData];
                       
                   });
    //一回読み込み
    //NSLog(@"check out");
    
}








@end
