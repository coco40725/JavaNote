package DAOpackage;

import Test.Customer;

import java.sql.Connection;
import java.sql.Date;
import java.util.List;

/**
 * @desc 實現customer interface
 * @author Yu-Jing
 * @create 2022-09-28-下午 12:58
 */
public class CustomerDAOImpl extends BaseDAO<Customer> implements CustomerDAO{

    @Override
    public void insert(Connection conn, Customer cust) {
        String sql = "insert into customers(name, email, birth) values(?,?,?);";
        update(conn, sql, cust.getName(), cust.getEmail(), cust.getBirth());
    }

    @Override
    public void deleteByID(Connection conn, int id) {
        String sql = "delete from customers where id = ?";
        update(conn, sql, id);
    }

    @Override
    public void updateByID(Connection conn, int id, Customer cust) {
        String sql = "update customers set name = ?, email = ?, birth = ? where id = ?; ";
        update(conn, sql, cust.getName(), cust.getEmail(), cust.getBirth(), id);
    }

    @Override
    public Customer getCustomerByID(Connection conn, int id) {
        String sql = "select name, email, birth from customers where id = ?; ";
        return getInstance(conn, sql, id);
    }

    @Override
    public List<Customer> getAll(Connection conn) {
        String sql = "select name, email, birth from customers; ";
        return getMultiInstance(conn, sql);
    }

    @Override
    public Long getCount(Connection conn) {
        String sql = "select count(1) from customers; ";
        return getValue(conn, sql);
    }

    @Override
    public Date getMaxBirth(Connection conn) {
        String sql = "select max(birth) from customers; ";
        return getValue(conn, sql);
    }
}
