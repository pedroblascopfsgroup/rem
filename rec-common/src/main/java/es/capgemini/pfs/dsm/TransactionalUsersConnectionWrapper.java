package es.capgemini.pfs.dsm;

import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.NClob;
import java.sql.PreparedStatement;
import java.sql.SQLClientInfoException;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Savepoint;
import java.sql.Statement;
import java.sql.Struct;
import java.util.Map;
import java.util.Properties;

public class TransactionalUsersConnectionWrapper implements Connection{

	private Connection connection;
	
	private String currentSchema;

	public String getCurrentSchema() {
		return currentSchema;
	}

	public void setCurrentSchema(String currentSchema) {
		this.currentSchema = currentSchema;
	}

	public <T> T unwrap(Class<T> iface) throws SQLException {
		return connection.unwrap(iface);
	}

	public boolean isWrapperFor(Class<?> iface) throws SQLException {
		return connection.isWrapperFor(iface);
	}

	public Statement createStatement() throws SQLException {
		return connection.createStatement();
	}

	public PreparedStatement prepareStatement(String sql) throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql));
	}

	public CallableStatement prepareCall(String sql) throws SQLException {
		return connection.prepareCall(replaceEntitySchema(sql));
	}

	public String nativeSQL(String sql) throws SQLException {
		return connection.nativeSQL(replaceEntitySchema(sql));
	}

	public void setAutoCommit(boolean autoCommit) throws SQLException {
		connection.setAutoCommit(autoCommit);
	}

	public boolean getAutoCommit() throws SQLException {
		return connection.getAutoCommit();
	}

	public void commit() throws SQLException {
		connection.commit();
	}

	public void rollback() throws SQLException {
		connection.rollback();
	}

	public void close() throws SQLException {
		connection.close();
	}

	public boolean isClosed() throws SQLException {
		return connection.isClosed();
	}

	public DatabaseMetaData getMetaData() throws SQLException {
		return connection.getMetaData();
	}

	public void setReadOnly(boolean readOnly) throws SQLException {
		connection.setReadOnly(readOnly);
	}

	public boolean isReadOnly() throws SQLException {
		return connection.isReadOnly();
	}

	public void setCatalog(String catalog) throws SQLException {
		connection.setCatalog(catalog);
	}

	public String getCatalog() throws SQLException {
		return connection.getCatalog();
	}

	public void setTransactionIsolation(int level) throws SQLException {
		connection.setTransactionIsolation(level);
	}

	public int getTransactionIsolation() throws SQLException {
		return connection.getTransactionIsolation();
	}

	public SQLWarning getWarnings() throws SQLException {
		return connection.getWarnings();
	}

	public void clearWarnings() throws SQLException {
		connection.clearWarnings();
	}

	public Statement createStatement(int resultSetType, int resultSetConcurrency)
			throws SQLException {
		return connection.createStatement(resultSetType, resultSetConcurrency);
	}

	public PreparedStatement prepareStatement(String sql, int resultSetType,
			int resultSetConcurrency) throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql), resultSetType,
				resultSetConcurrency);
	}

	public CallableStatement prepareCall(String sql, int resultSetType,
			int resultSetConcurrency) throws SQLException {
		return connection.prepareCall(replaceEntitySchema(sql), resultSetType, resultSetConcurrency);
	}

	public Map<String, Class<?>> getTypeMap() throws SQLException {
		return connection.getTypeMap();
	}

	public void setTypeMap(Map<String, Class<?>> map) throws SQLException {
		connection.setTypeMap(map);
	}

	public void setHoldability(int holdability) throws SQLException {
		connection.setHoldability(holdability);
	}

	public int getHoldability() throws SQLException {
		return connection.getHoldability();
	}

	public Savepoint setSavepoint() throws SQLException {
		return connection.setSavepoint();
	}

	public Savepoint setSavepoint(String name) throws SQLException {
		return connection.setSavepoint(name);
	}

	public void rollback(Savepoint savepoint) throws SQLException {
		connection.rollback(savepoint);
	}

	public void releaseSavepoint(Savepoint savepoint) throws SQLException {
		connection.releaseSavepoint(savepoint);
	}

	public Statement createStatement(int resultSetType,
			int resultSetConcurrency, int resultSetHoldability)
			throws SQLException {
		return connection.createStatement(resultSetType, resultSetConcurrency,
				resultSetHoldability);
	}

	public PreparedStatement prepareStatement(String sql, int resultSetType,
			int resultSetConcurrency, int resultSetHoldability)
			throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql), resultSetType,
				resultSetConcurrency, resultSetHoldability);
	}

	public CallableStatement prepareCall(String sql, int resultSetType,
			int resultSetConcurrency, int resultSetHoldability)
			throws SQLException {
		return connection.prepareCall(replaceEntitySchema(sql), resultSetType, resultSetConcurrency,
				resultSetHoldability);
	}

	public PreparedStatement prepareStatement(String sql, int autoGeneratedKeys)
			throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql), autoGeneratedKeys);
	}

	public PreparedStatement prepareStatement(String sql, int[] columnIndexes)
			throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql), columnIndexes);
	}

	public PreparedStatement prepareStatement(String sql, String[] columnNames)
			throws SQLException {
		return connection.prepareStatement(replaceEntitySchema(sql), columnNames);
	}

	public Clob createClob() throws SQLException {
		return connection.createClob();
	}

	public Blob createBlob() throws SQLException {
		return connection.createBlob();
	}

	public NClob createNClob() throws SQLException {
		return connection.createNClob();
	}

	public SQLXML createSQLXML() throws SQLException {
		return connection.createSQLXML();
	}

	public boolean isValid(int timeout) throws SQLException {
		return connection.isValid(timeout);
	}

	public void setClientInfo(String name, String value)
			throws SQLClientInfoException {
		connection.setClientInfo(name, value);
	}

	public void setClientInfo(Properties properties)
			throws SQLClientInfoException {
		connection.setClientInfo(properties);
	}

	public String getClientInfo(String name) throws SQLException {
		return connection.getClientInfo(name);
	}

	public Properties getClientInfo() throws SQLException {
		return connection.getClientInfo();
	}

	public Array createArrayOf(String typeName, Object[] elements)
			throws SQLException {
		return connection.createArrayOf(typeName, elements);
	}

	public Struct createStruct(String typeName, Object[] attributes)
			throws SQLException {
		return connection.createStruct(typeName, attributes);
	}

	public TransactionalUsersConnectionWrapper(Connection cnx) {
		assert cnx != null;
		this.connection = cnx;
	}
	
	private String replaceEntitySchema(String sql){
		if (this.currentSchema != null){
			return sql.replaceAll("\\$\\{entity\\.schema\\}\\.", this.currentSchema);
			
		}else{
			return sql;
		}
		
	}

}
