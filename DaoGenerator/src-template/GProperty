package ${schema.defaultJavaPackageDao};

import org.greenrobot.greendao.Property;
import javax.xml.validation.Schema;

/**
 * Created by lyf on 2016/11/4.
 */
public class GProperty extends Property {

    private String className;

    public GProperty(String className,int ordinal,
                     Class<?> type, String name,
                     boolean primaryKey, String columnName) {
        super(ordinal, type, name, primaryKey,columnName);
        this.className = className;
    }

    public Class getDaoClass() throws ClassNotFoundException {
        return Class.forName(getClass().getPackage().getName()+"."+className);
    }

}
