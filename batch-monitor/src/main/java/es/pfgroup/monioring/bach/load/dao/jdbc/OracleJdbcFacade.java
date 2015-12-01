package es.pfgroup.monioring.bach.load.dao.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

/**
 * Fachada con las operaciones más comunes para conectar por JDBC a Oracle.
 * 
 * @author bruno
 * 
 */
public class OracleJdbcFacade implements JDBCConnectionFacace{

    private final Properties appProperties;

    private final String url;

    private final ArrayList<Connection> connections = new ArrayList<Connection>();

    private final ArrayList<PreparedStatement> statements = new ArrayList<PreparedStatement>();

    private final ArrayList<ResultSet> resultsets = new ArrayList<ResultSet>();

    public OracleJdbcFacade(final Properties appProperties) {
        super();
        this.appProperties = appProperties;
        this.url = appProperties.getProperty("url");
    }

    /**
     * Se conecta a la base de datos y ejecuta una query.
     * 
     * @param query
     * @return
     * @throws SQLException
     */
    public ResultSet connectAndExecute(final String query) throws SQLException {
        
        final Connection conn = DriverManager.getConnection(url, appProperties);
        connections.add(conn);
        final PreparedStatement preStatement = conn.prepareStatement(query);
        statements.add(preStatement);
        final ResultSet rs = preStatement.executeQuery();
        resultsets.add(rs);
        return rs;

    }

    /**
     * Cierra todas las conexiones.
     * 
     * @throws SQLException
     */
    public void close() throws SQLException {
        try {
            for (ResultSet r : resultsets) {
                r.close();
            }
        } finally {
            resultsets.clear();
            try {
                for (PreparedStatement st : statements) {
                    st.close();
                }
            } finally {
                statements.clear();
                try{
                    for (Connection cn : connections){
                        cn.close();
                    }
                }finally{
                    connections.clear();
                }
            }
        }

    }
}
	
