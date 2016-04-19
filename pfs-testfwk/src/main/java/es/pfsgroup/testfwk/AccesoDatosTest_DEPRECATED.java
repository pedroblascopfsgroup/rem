package es.pfsgroup.testfwk;
//package es.pfsgroup.testfwk;
//
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.sql.Connection;
//import java.sql.SQLException;
//import java.util.List;
//
//import javax.sql.DataSource;
//
//import org.dbunit.database.DatabaseConnection;
//import org.dbunit.database.IDatabaseConnection;
//import org.dbunit.dataset.IDataSet;
//import org.dbunit.dataset.xml.FlatXmlDataSet;
//import org.dbunit.operation.DatabaseOperation;
//import org.springframework.jdbc.datasource.DataSourceUtils;
//import org.springframework.test.AbstractTransactionalDataSourceSpringContextTests;
//
//import es.capgemini.devon.dto.WebDto;
//import es.capgemini.devon.pagination.Page;
//
//public abstract class AccesoDatosTest extends
//		AbstractTransactionalDataSourceSpringContextTests {
//	
//	public static final int DEFAULT_PAGE_LIMIT = 100;
//
//	private static boolean dbsetup = false;
//
//	private String nuevoFicheroDatos = null;
//
//	private Connection con;
//	private IDatabaseConnection dbUnitCon;
//	private DataSource dataSource;
//
//	@Override
//	protected final String[] getConfigLocations() {
//		return new String[] { "pfs-testfwk.xml", getContextoTest() };
//	}
//
//	private final boolean setupDB(Connection connection, String resource)
//			throws IOException, SQLException {
//
//		System.out.println("Reading from file " + resource);
//
//		InputStream is = this.getClass().getResourceAsStream(resource);
//
//		if (is == null) {
//			throw new RuntimeException(resource
//					.concat(": No se ha podido acceder"));
//		}
//
//		BufferedReader reader = new BufferedReader(new InputStreamReader(is));
//		StringBuffer sqlBuf = new StringBuffer();
//		String line;
//		boolean statementReady = false;
//		int count = 0;
//		while ((line = reader.readLine()) != null) {
//			// different continuation for oracle and postgres
//			line = line.trim();
//			line = translateTypes(line);
//			if (line.equals("--/exe/--")) // execute finished statement
//
//			{
//				sqlBuf.append(' ');
//				statementReady = true;
//			} else if (line.equals("/")) // execute finished statement for
//
//			{
//				sqlBuf.append(' ');
//				statementReady = true;
//			} else if (line.startsWith("--") || line.length() == 0) //
//
//			{
//				continue;
//			} else if (line.endsWith(";")) {
//				sqlBuf.append(' ');
//				sqlBuf.append(line.substring(0, line.length() - 1));
//				statementReady = true;
//			} else {
//				sqlBuf.append(' ');
//				sqlBuf.append(line);
//				statementReady = false;
//			}
//			/*
//			 * if (line.startsWith("--")) continue; // comment ? line =
//			 * line.trim(); if (line.length() == 0) continue;
//			 * sqlBuf.append(' '); statementReady = false; if
//			 * (line.endsWith(";")) { sqlBuf.append(line.substring(0,
//			 * line.length() - 1)); statementReady = true; } else if
//			 * (line.equals("/")) { statementReady = true; } else {
//			 * sqlBuf.append(line); }
//			 */
//
//			if (statementReady) {
//				if (sqlBuf.length() == 0)
//					continue;
//				connection.createStatement().execute(sqlBuf.toString());
//				count++;
//				sqlBuf.setLength(0);
//			}
//		}
//
//		System.out.println("" + count + " statements processed");
//		System.out.println("Import done sucessfully");
//
//		return true;
//
//	}
//
//	private String translateTypes(final String line) {
//		String translated = line;
//		translated = translated.replaceAll("VARCHAR2\\(.*\\)", "VARCHAR");
//		translated = translated.replaceAll("VARCHAR\\(.*\\)", "VARCHAR");
//		translated = translated.replaceAll("CHAR\\(.*\\)", "VARCHAR");
//		translated = translated.replaceAll("NUMBER\\(.*\\)", "INTEGER");
//		translated = translated.replaceAll(" NUMBER ", " INTEGER ");
//		translated = translated.replaceAll(" DATE ", " DATETIME ");
//		translated = translated.replaceAll("TIMESTAMP", "DATETIME");
//		
//		return translated;
//	}
//
//	@Override
//	protected final void onSetUpInTransaction() throws Exception {
//		nuevoFicheroDatos = null;
//		dataSource = jdbcTemplate.getDataSource();
//		con = DataSourceUtils.getConnection(dataSource);
//		dbUnitCon = new DatabaseConnection(con);
//
//		if (!dbsetup) {
//			dbsetup = setupDB(con, getFicheroSchema());
//		}
//	}
//
//	protected final void cargaDatos() throws Exception {
//		InputStream is = this.getClass().getResourceAsStream(getDataFile());
//		
//		if (is == null){
//			throw new Exception(getDataFile().concat(": No se ha podido encontrar el recurso"));
//		}
//		
//		IDataSet dataSet = new FlatXmlDataSet(is);
//
//		try {
//			DatabaseOperation.REFRESH.execute(dbUnitCon, dataSet);
//		} finally {
//			DataSourceUtils.releaseConnection(con, dataSource);
//		}
//	}
//
//	protected final <T> List<T> getDatosPruebas(Class<T> clazz, TestDataCriteria ...crit)
//			throws Exception {
//		TestData<T> td = TestData.create(clazz, getDataFile(), crit);
//		return td.getList();
//	}
//
//	protected final void cambiaFicheroDatos(String fd) {
//		this.nuevoFicheroDatos = fd;
//	}
//
//	private final String getDataFile() {
//		if (nuevoFicheroDatos == null) {
//			return this.getFicheroDatos();
//		}
//		return nuevoFicheroDatos;
//	}
//
//	protected final <DTO extends WebDto> DTO setupPage(DTO dto, int start, int limit){
//		dto.setStart(start);
//		dto.setLimit(limit);
//		return dto;
//	}
//	
//	protected final <DTO extends WebDto> DTO setupPage(DTO dto){
//		return setupPage(dto, 0, DEFAULT_PAGE_LIMIT);
//	}
//	
//	protected abstract String getContextoTest();
//
//	protected abstract String getFicheroSchema();
//
//	protected abstract String getFicheroDatos();
//}
