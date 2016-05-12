**FFmpeg**是一个[自由软件](https://zh.wikipedia.org/wiki/%E8%87%AA%E7%94%B1%E8%BB%9F%E9%AB%94)，可以运行音频和视频多种格式的[录影、转换、流功能](http://ffmpeg.org/ffmpeg.html)，包含了libavcodec——这是一个用于多个项目中音频和视频的解码器库，以及libavformat——一个音频与视频格式转换库。

## 环境与工具
**Mac OS X EI Capitan 10.11.4**
**Xcode7.3.1**
**终端**



### 1.安装 [yasm](http://yasm.tortall.net/releases/Release1.3.0.html)

*OS X 下载 Source .tar.gz 即可 *

下载完成后，打开终端，cd 进目录

    $ ./configure
    $ make
    $ make install

安装完成后验证，显示如下表明安装成功

    $ yasm --version
    yasm 1.3.0
    Compiled on May 12 2016.
    Copyright (c) 2001-2014 Peter Johnson and other Yasm developers.
    Run yasm --license for licensing overview and summary.



### 2.下载 [gas-preprocessor.pl](https://github.com/libav/gas-preprocessor)

复制 `gas-preprocessor.pl` 到 `/usr/local/bin` 下 **(网上很多教程都让放在 `/usr/bin` 下，但是现在OS X的 `usr/bin` 目录不可写，所以放在 `/usr/local/bin` )**

修改文件权限 

    $ chmod 777 /usr/local/bin/gas-preprocessor.pl


### 3.下载[脚本文件](https://github.com/kewlbear/FFmpeg-iOS-build-script)

这个脚本可以一次编译，就生成适合各个框架的静态库。

解压后 cd 进目录 ，执行

    $ ./build-ffmpeg.sh

脚本则会自动从github中把ffmpeg源码下到本地并开始编译。 编译结束后，文件目录如下：

![SettingFFmpeg](https://github.com/qiangxinyu/blogImages/blob/master/SettingFFmpeg/SettingFFmpeg_list.png?raw=true)

ffmpeg-3.0是源码， FFmpeg-iOS是编译出来的库，里面是我们需要的.a 静态库，一共有7个。 终端输入

    $ lipo -info libavcodec.a 
    Architectures in the fat file: libavcodec.a are: armv7 i386 x86_64 arm64 

可以看出来静态库支持 `armv7`  `i386`  `x86_64`  `arm64 ` 构架

### 4.把 FFmpeg-iOS 导入工程。

然后在 `Build Settings` 中找到 `Search Paths` ，设置 `Header Search Pahts` 和 `Library Search Paths` 如下。不然会报 `include“libavformat/avformat.h” file not found ` 错误。

![SettingFFmpeg_header](https://github.com/qiangxinyu/blogImages/blob/master/SettingFFmpeg/SettingFFmpeg_header.png?raw=true)

![SettingFFmpeg_library](https://github.com/qiangxinyu/blogImages/blob/master/SettingFFmpeg/SettingFFmpeg_library.png?raw=true)

### 5.在工程中导入其他库文件。

`libz.tbd` 、`ibbz2.tbd` 、 `libiconv.tbd`,在 3.0以后需要添加另外2个框架 `VideoToolbox.framework` 和 `CoreMedia.framework`


### 5.编译

因为这些库是C++，所以需要把一个文件后缀改为 .mm，这样Xcode就会自动打开C++混编，一般会把  `AppDelegate.m` 改为 `AppDelegate.mm` 

然后随便找个 文件，导入 `avcodec.h`

```objectivec
#include "avcodec.h"

- (void)viewDidLoad {
   [super viewDidLoad];    
   avcodec_register_all();
}
```

可以运行起来说明配置成功。


这里放一个[Demo](https://github.com/qiangxinyu/XYFFmpeg)


### 6.可能出现的问题


*   执行 .sh 文件不成功


    $ ./build-ffmpeg.sh
    -bash: ./build-ffmpeg.sh: No such file or directory


这种类型的错误是找不到 `build-ffmpeg.sh` 文件，先看看路径对不对，然后再看下里面有没有这个文件，在安装 `yasm` 的时候我第一次是在 `github` 上下载的一个，里面没有 `.sh` 文件，导致无法执行。

*  Xcode编译报错


    Undefined symbols for architecture x86_64: (或者armv7之类的)
    ...
    ld: symbol(s) not found for architecture x86_64
    clang: error: linker command failed with exit code 1 (use -v to see invocation)


这种一般都是因为缺少依赖，检查一下上述那3个库和2个框架是否正确添加。


### 参考资料

* [http://cnbin.github.io/blog/2015/05/19/iospei-zhi-ffmpegkuang-jia/](http://cnbin.github.io/blog/2015/05/19/iospei-zhi-ffmpegkuang-jia/)
* [http://bbs.iosre.com/t/10-11-usr-bin-class-dump/1936/5](http://bbs.iosre.com/t/10-11-usr-bin-class-dump/1936/5)
* [http://www.jianshu.com/p/147c03553e63
](http://www.jianshu.com/p/147c03553e63
)
* [http://www.cnblogs.com/liyufeng2013/p/4286684.html
](http://www.cnblogs.com/liyufeng2013/p/4286684.html
)
