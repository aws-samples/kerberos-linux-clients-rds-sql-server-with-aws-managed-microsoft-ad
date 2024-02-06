import com.microsoft.sqlserver.jdbc.SQLServerDriver;
import java.sql.*;

public class TestJdbc {
    
    public static void main(String[] args) throws SQLException {
        String jdbcConnString = args[0];
        String sql = args[1];
        
        System.out.println("jdbcConnString="+jdbcConnString);
        System.out.println("sql="+sql);
        System.out.println("");
        
        Connection connection = DriverManager.getConnection(jdbcConnString);
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
    
        ResultSetMetaData metadata = resultSet.getMetaData();
        int colCount = metadata.getColumnCount();
        
        for(int c=1; c<=colCount; c++) {
            System.out.print(metadata.getColumnName(c));
            System.out.print("\t");
        }
        System.out.println("");
        
        for(int c=1; c<=colCount; c++) {
            System.out.print("----------");
            System.out.print("\t");
        }
        System.out.println("");
        
        if (resultSet.next()) {
            for(int c=1; c<=colCount; c++) {
                System.out.print(resultSet.getString(c));
                System.out.print("\t");
            }
            System.out.println("");
        }

        statement.close();
        connection.close();
    }
        
}
