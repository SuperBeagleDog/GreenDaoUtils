# GreenDaoUtils
GreenDao的代码生成器的优化版

注:x.x.x代表最新版本号
使用方法：

一、添加两行代码：
1、在project的gralde里添加  maven { url "https://jitpack.io" }
2、在当前项目的gradle里添加   compile 'com.github.SuperBeagleDog:GreenDaoUtils:x.x.x'

添加后如下所示

如下图所示

project的gradle:
allprojects {
    repositories {
        jcenter()
        maven { url "https://jitpack.io" }
    }
}

当前项目的gradle:
dependencies {
    compile 'com.github.SuperBeagleDog:GreenDaoUtils:1.0.3'
}

这样就已经配置好了代码生成器以及GreenDao的增删查改的优化工具。

但是，代码生成器需要开发者，自已定义要生成哪些Dao类，以及生成的GreenDao的相关类的存放路径,
源码在GreenDaoUtils的GDGenerator类里,可以自行定位到当前类,然后，复制里面的代码,
再自行修改即可。
