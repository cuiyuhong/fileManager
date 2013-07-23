//tableView和FileManger的使用
#import "FileManagerViewController.h"

@interface FileManagerViewController ()
@property (nonatomic) NSArray *contents;
@end

@implementation FileManagerViewController
- (void)viewDidLoad{
  [super viewDidLoad];
  if (!self.directory){
//  NSHomeDirectory函数可以方便得到Home路径
    self.directory = NSHomeDirectory();
    self.title = @"Root";
  }
//  检查指定目录下有什么文件或者目录
  self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.directory error:NULL];
}

#pragma mark - Table view data source
//tableView的datasource方法.回答有几段，每段有几行
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.contents.count;
}
//tableView的delegate方法，返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//和pickerView类似，也有重用的概念，使用稍微有所不同
  static NSString *CellIdentifier = @"Cell";
//使用一个标示字符串去获得一个cell的原型，这个原型在IB中可以编辑，但标示字符串必须对应，如果没有可重用的cell，tableview会分配一个
//所以不需要判断是不是nil
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//本例子中使用简单原型，有两个子view：textLabel和detailTextLabel，只需要分别对内容进行赋值
  cell.textLabel.text = self.contents[[indexPath row]];
//判断是不是目录
  NSString *fileFullPath = [self.directory stringByAppendingPathComponent:self.contents[[indexPath row]]];
  NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:NULL];
  if ([attribute[NSFileType] isEqualToString:NSFileTypeDirectory]) {
    cell.detailTextLabel.text = @"目录";
  }else cell.detailTextLabel.text = @"文件";
  return cell;
}
//用户选中某行的delegate方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//实际上希望的效果是用户点击目录后进入另一个控制器，但目录的深度是不可知的，也无法使用简单的segue方式
//这里采用程序初始化一个本控制器的一个新的实例，只是directory属性不同，并用navigationController推出
//这种方式在机理上类似于递归
  FileManagerViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"fileManager"];
  detail.title = self.contents[[indexPath row]];
//设置新控制器的directory属性
  detail.directory = [self.directory stringByAppendingPathComponent:self.contents[[indexPath row]]];
//如果是目录，则推出新的控制器
  NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:detail.directory error:NULL];
  if ([attribute[NSFileType] isEqualToString:NSFileTypeDirectory]) {
    [self.navigationController pushViewController:detail animated:YES];
  }else{
//如果是文件，则推出文件细节控制器，尚未实现
  }
}

@end
