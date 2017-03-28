# RCAutomaticHeightTextView
## 这个是干嘛的
    根据字符串的内容自动改变‘TextView’的高度。
## 使用说明

    iOS7+，适用于‘Frame’方式布局和‘AutoLayout’方式高度属性(NSLayoutAttributeHeight)的布局。
    
```Objective-C
    RCAutomaticHeightTextView *textView = [[RCAutomaticHeightTextView alloc] initWithFrame:YourFrame];
    textView.maxHeight = 180;//允许的最大高度（>=自身原始高度）,没有高度限制使用‘RCTextViewHeightNoLimit’。
    textView.frameChangedBlock = ^(CGRect frame){
        
        //your code here...
    };
```
![gif_1](https://github.com/Hymn-RoyCHANG/RCAutomaticHeightTextView/raw/master/screenshot/1.gif "TextView Normal")
![gif_2](https://github.com/Hymn-RoyCHANG/RCAutomaticHeightTextView/raw/master/screenshot/2.gif "TextView In Cell")

# MIT License

Copyright (c) 2017 Roy CHANG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
