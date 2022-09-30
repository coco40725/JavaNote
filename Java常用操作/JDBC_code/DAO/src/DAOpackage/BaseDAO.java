package DAOpackage;

import Util.JDBCUtils;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Yu-Jing
 * @create 2022-09-28-上午 11:46
 */
public abstract class BaseDAO {

    // 通用的增刪改
    public static void update(Connection conn, String sql, Object... args){
        PreparedStatement ps = null;
        try {
            // 1. 獲取連接
            ps = conn.prepareStatement(sql);

            // 2. 補上填充符
            for (int i = 0; i < args.length; i++){
                ps.setObject(i + 1, args[i]);
            }

            // 3. 執行sql
            ps.execute();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            //5. 關閉資源
            JDBCUtils.closeConnection(null, ps);
        }

    }

    // 通用查詢 multiple
    public <T> List<T> getMultiInstance(Connection conn, Class<T> clazz, String sql, Object ... args){
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // 1. 建立connection

            // 2. 欲編譯sql
            ps = conn.prepareStatement(sql);

            // 3. 補上佔位符
            for (int i = 0; i < args.length; i++){
                ps.setObject(i + 1, args[i]);
            }

            // 4. 執行sql 並整理數據
            rs = ps.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int ColumnNum = rsmd.getColumnCount();

            List<T> list = new ArrayList<>();
            while (rs.next()){
                T t = clazz.getDeclaredConstructor().newInstance();

                // 4.1 撈取資料
                for (int i = 0; i < ColumnNum ; i++){
                    Object columnValue = rs.getObject(i + 1);
                    String columnName = rsmd.getColumnName(i + 1);

                    // 4.2 透過反射填入資料
                    Field field = t.getClass().getDeclaredField(columnName);
                    field.setAccessible(true);
                    field.set(t,columnValue);

                }
                list.add(t);
            }
            return list;
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            //5. 關閉資源
            JDBCUtils.closeConnection(null, ps, rs);
        }

    }

    // 通用查詢 single
    public <T> T getInstance(Connection conn, Class<T> clazz, String sql, Object ... args){
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // 1. 獲取connection

            // 2. 欲編譯SQL
            ps = conn.prepareStatement(sql);

            // 3. 補上佔位符
            for(int i = 0; i < args.length; i++) {
                ps.setObject(i + 1, args[i]);
            }

            // 4. 執行SQL 並整理 結果
            rs = ps.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int ColumnNum = rsmd.getColumnCount();

            if (rs.next()){
                T t = clazz.getDeclaredConstructor().newInstance();

                for (int i = 0; i < ColumnNum ; i++){
                    // 4.1 獲取資料
                    Object columnValue = rs.getObject(i + 1);

                    // 4.2 透過反射將屬性賦值
                    String columnName = rsmd.getColumnName(i + 1);
                    Field field = t.getClass().getDeclaredField(columnName);
                    field.setAccessible(true);
                    field.set(t, columnValue);
                }
                return t;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            //5. 關閉資源
            JDBCUtils.closeConnection(null, ps, rs);
        }

        return null;
    }

    // 查詢通用TBLAE 相關性質
    public <T> T getValue(Connection conn, String sql, Object ... args){
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);

            for(int i = 0; i < args.length; i++){
                ps.setObject(i + 1, args[i]);
            }
            rs = ps.executeQuery();

            if(rs.next()){
                T t = (T) rs.getObject(1);
                return t;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(null, ps, rs);
        }
        return null;



    }

}
