package DAOpackage;

import Util.JDBCUtils;
import org.testng.annotations.Test;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import static org.testng.Assert.*;

/**
 * @author Yu-Jing
 * @create 2022-09-28-下午 01:44
 */
public class CustomerDAOImplTest {
    private CustomerDAOImpl dao = new CustomerDAOImpl();

    @Test
    public void testInsert() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            Customer cust = new Customer(1,"Timmy","ssssssHHHh@gamil.com",new Date(55454565546L));
            dao.insert(conn, cust);
            System.out.println("添加成功");


        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testDeleteByID() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            dao.deleteByID(conn, 6);
            System.out.println("刪除成功");


        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testUpdateByID() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            Customer cust = new Customer(1,"大笨狗","shiny@gamil.com",new Date(55454565565546L));
            dao.updateByID(conn,19, cust);
            System.out.println("更新成功");


        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testGetCustomerByID() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            Customer cust = dao.getCustomerByID(conn, 19);
            System.out.println(cust);
            System.out.println("取得成功");

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testGetAll() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            List<Customer> list = new ArrayList<Customer>();
            list = dao.getAll(conn);
            System.out.println(list);
            System.out.println("取得成功");

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testGetCount() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            Long value = dao.getCount(conn);
            System.out.println(value);
            System.out.println("取得成功");

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }

    @Test
    public void testGetMaxBirth() {
        Connection conn = null;
        try {
            conn = JDBCUtils.getConnection();
            Date value = dao.getMaxBirth(conn);
            System.out.println(value);
            System.out.println("取得成功");

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            JDBCUtils.closeConnection(conn, null);
        }
    }
}