package DAOpackage;

import Test.Customer;

import java.sql.Connection;
import java.sql.Date;
import java.util.List;

/**
 * @desc 針對Customer 這張表，你想要什麼樣的功能?
 * @author Yu-Jing
 * @create 2022-09-28-下午 12:50
 */
public interface CustomerDAO {
    /**
     * @desc 新增數據
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    void insert(Connection conn, Customer cust);

    /**
     * @desc 根據id 刪除數據
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    void deleteByID(Connection conn, int id);

    /**
     * @desc 根據id 更新數據 ， 相當於更改對象
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    void updateByID(Connection conn, int id, Customer cust);

     /**
     * @desc 根據id 獲取單筆數據
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
     Customer getCustomerByID(Connection conn, int id);

    /**
     * @desc 根據id 返回全數據
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    List<Customer> getAll(Connection conn);

    /**
     * @desc 返回數據筆數
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    Long getCount(Connection conn);

    /**
     * @desc 返回最大生日
     * @author Yu-Jing
     * @create 2022-09-28-下午 12:50
     */
    Date getMaxBirth(Connection conn);

}
