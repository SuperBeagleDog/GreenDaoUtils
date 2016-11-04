# GreenDaoUtils
GreenDao的代码生成器的优化版

使用方法：

一、添加两段代码：

1、在project的gralde里添加 

    maven { url "https://jitpack.io" }
    classpath 'org.greenrobot:greendao-gradle-plugin:3.2.0'
 
2、在当前项目的gradle里添加  

    compile 'com.github.SuperBeagleDog:GreenDaoUtils:1.0.4'

添加后如下所示,如下图所示:

project的gradle:

    allprojects {
       repositories {
          jcenter()
          maven { url "https://jitpack.io" }
       }
    }
    
    buildscript {
       repositories {
         mavenCentral()
       }
       dependencies {
         classpath 'org.greenrobot:greendao-gradle-plugin:3.2.0'
       }
    }

当前项目的gradle:

    dependencies {
       compile 'com.github.SuperBeagleDog:GreenDaoUtils:1.0.3'
    }

需要注意的一点是,这个工具已经集成了GreenDao的jar包,所以不要再在当前项目的gradle的depencies里面添加如下代码

重要的事说三遍,千万不要、不要、不要在gralde里再添加这一行代码！！！

    compile 'org.greenrobot:greendao:3.2.0'
        
这样就已经配置好了代码生成器以及GreenDao的增删查改的优化工具。

但是，代码生成器需要开发者，自已定义要生成哪些Dao类，以及生成的GreenDao的相关类的存放路径,
源码在GreenDaoUtils的GDGenerator类里,可以自行定位到当前类,然后，复制里面的代码,
再自行修改即可。
