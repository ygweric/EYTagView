# EYTagView

------

EYTagView is a custome view simulate iOS Evernote's tag editing view.

---

###What can EYTagView do ???

1\ Show unlimited number of tags in EYTagView with bricks layout

![scrollable.gif](https://raw.githubusercontent.com/ygweric/EYTagView/master/screenshots/1scrollable.gif)


2\ Can add and delete tag free

3\ Can disable editing tags if you want

![scrollable.gif](https://raw.githubusercontent.com/ygweric/EYTagView/master/screenshots/1editable.gif)

4\ You can donfig almost all color and font as yo want

```
_tagView.colorTag=COLORRGB(0xffffff);
_tagView.colorTagBg=COLORRGB(0x2ab44e);
_tagView.colorInput=COLORRGB(0x2ab44e);
_tagView.colorInputBg=COLORRGB(0xffffff);
_tagView.colorInputPlaceholder=COLORRGB(0x2ab44e);
_tagView.backgroundColor=COLORRGB(0xffffff);
_tagView.colorInputBoard=COLORRGB(0x2ab44e);
_tagView.viewMaxHeight=130;
```



---
### how to use EYTagView

```Object-C
   EYTagView* _tagView=[[EYTagView alloc]initWithFrame:CGRectMake(10, 10, 200, 200)];
   [self.view addSubview:_tagView];
    _tagView.delegate=self;
    [_tagView addTags:@[
                        @"111",
                        @"222",
                        @"犬瘟热",
                        @"惹我欠人情无人区污染污染",
                        @"3而是",
                        @"是",
                        ]];
```
in `EYTagViewDelegate` ,the method `heightDidChangedTagView:(EYTagView *)` wil be called when the EYTagView's height is changed, so you can update the layout.

---

If you are using autolayout, you dan do the following:

1\ in xib or storyboard, create a empty UIView as the tagview container(`_vContainer`), add constrants width and height as you want. but set their properity to "999".
2\ addd a new UIView to the _vContainer, change the Class to `EYTagView`, we needed it as "_tagView".

3\ set _tagView's constransts like that:
![constrants.gif](https://raw.githubusercontent.com/ygweric/EYTagView/master/screenshots/1constrants.png)

4\ set
```
_tagView.translatesAutoresizingMaskIntoConstraints=YES;
```

Then the _vContainer's frame will change with _tagView.

---
If you don't know how to use EYTagView well, you can check the example project or create an issue
