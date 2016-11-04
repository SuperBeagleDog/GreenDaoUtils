package ${schema.defaultJavaPackageDao};


import java.util.List;
import android.util.Log;
import android.content.Context;
import java.lang.reflect.Constructor;
import android.database.sqlite.SQLiteDatabase;
import org.greenrobot.greendao.AbstractDao;
import org.greenrobot.greendao.internal.DaoConfig;
import org.greenrobot.greendao.identityscope.IdentityScopeType;


public class DaoUtils {

    private SQLiteDatabase db;
    public  DaoMaster daoMaster;
    private final static String TAG = "Tag";

    public DaoUtils(Context context) {
       setupDatabase(context);
    }

    // 初始化数据库
    private  void setupDatabase(Context context) {
        // 通过 DaoMaster 的内部类 DevOpenHelper，你可以得到一个便利的 SQLiteOpenHelper 对象。
        // 可能你已经注意到了，你并不需要去编写「CREATE TABLE」这样的 SQL 语句，因为 greenDAO 已经帮你做了。
        // 注意：默认的 DaoMaster.DevOpenHelper 会在数据库升级时，删除所有的表，意味着这将导致数据的丢失。
        // 所以，在正式的项目中，你还应该做一层封装，来实现数据库的安全升级。
        DaoMaster.DevOpenHelper helper = new DaoMaster
                    .DevOpenHelper(context, "notes-db", null);
        db = helper.getWritableDatabase();
        // 注意：该数据库连接属于 DaoMaster，所以多个 Session 指的是相同的数据库连接。
        daoMaster = new DaoMaster(db);
    }

    // 传入类名.class,返回数据库里的所有相应的实体类
    public <T> List<T> search(Class cls) {

        try {

            AbstractDao<T, Long> dao = null;
            DaoConfig daoConfig;
            daoConfig = daoMaster.getDaoConfigMap().get(cls).clone();
            daoConfig.initIdentityScope(IdentityScopeType.Session);

            //获取所有构造函数
            Constructor constructors[] = cls.getDeclaredConstructors();
            for (Constructor constructor : constructors) {
                //获取构造函数的参数
                Class c[] = constructor.getParameterTypes();

                if (c.length == 1) {
                    dao = (AbstractDao) cls.getConstructor(c)
                            .newInstance(daoConfig);
                }
            }
            return dao.queryBuilder()
                    .build().list();
        } catch (NullPointerException e) {
            Log.d(TAG,"生成失败:"+e.toString());
            return null;
        } catch (Exception e) {
            Log.d(TAG,"生成失败:"+e.toString());
            return null;
        }

    }
    public <T> void  insert(T entity) {

        try {

            // 因为生成的Dao类与Master在同一个路径下
            // 所以,通过master对象来获取包名,通过entity来获取类名
            // 从而实现通过类名,来反射获取Class。
            Class cls = Class.forName(daoMaster.getClass().getPackage().getName()
                            +"."+entity.getClass().getSimpleName()+"Dao");

            AbstractDao<T, Long> dao = null;
            DaoConfig daoConfig;
            daoConfig = daoMaster.getDaoConfigMap().get(cls).clone();
            daoConfig.initIdentityScope(IdentityScopeType.Session);

            //获取所有构造函数
            Constructor constructors[] = cls.getDeclaredConstructors();
            for (Constructor constructor : constructors) {
                //获取构造函数的参数
                Class c[] = constructor.getParameterTypes();

                if (c.length == 1) {
                    dao = (AbstractDao) cls.getConstructor(c)
                            .newInstance(daoConfig);
                }
            }

            dao.insert(entity);

        } catch (NullPointerException e) {
            Log.d(TAG,"插入失败:"+e.toString());
        } catch (Exception e) {
            Log.d(TAG,"插入失败:"+e.toString());
        }

    }

        /**
         * 只查询一条
         * @param property 要查询的Dao类的字段
         * @param where 要匹配的字符串
         */
        public <T> T searchUnique(GProperty property, String where) {

            try {

                Class cls = property.getDaoClass();
                AbstractDao<T, Long> dao = null;
                DaoConfig daoConfig;
                daoConfig = daoMaster.getDaoConfigMap().get(cls).clone();
                daoConfig.initIdentityScope(IdentityScopeType.Session);

                //获取所有构造函数
                Constructor constructors[] = cls.getDeclaredConstructors();
                for (Constructor constructor : constructors) {
                    //获取构造函数的参数
                    Class c[] = constructor.getParameterTypes();

                    if (c.length == 1) {
                        dao = (AbstractDao) cls.getConstructor(c)
                                .newInstance(daoConfig);
                    }
                }
                return dao.queryBuilder()
                        .where(property.eq(where))
                        .build().unique();
            } catch (NullPointerException e) {
                Log.d(TAG,"生成失败:"+e.toString());
                return null;
            } catch (Exception e) {
                Log.d(TAG,"生成失败:"+e.toString());
                return null;
            }

        }
}
