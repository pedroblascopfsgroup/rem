package es.capgemini.pfs.batch.recobro.jdbc.impl.test;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.pfs.batch.recobro.jdbc.api.test.GenericTestDAO;

/**
 * Implementación que permite ejecutar las queries de preparación y validación del entorno de test 
 * @author Guillem
 *
 */
//@Repository
public class GenericTestDAOImpl implements GenericTestDAO{

	private DataSource dataSource;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public Integer ejecutarUPDATESQLCarga(String sql, String msg) throws Throwable{
		try{
			JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
			return jdbcTemplate.update(sql);
		}catch(Throwable e){
			throw e;
		}
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void ejecutarCREATESQLCarga(String sql, String msg) throws Throwable{
		try{
			JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
			jdbcTemplate.execute(sql);
		}catch(Throwable e){
			throw e;
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Integer ejecutarCOUNTSQLValidacion(String sql, String msg) throws Throwable{
		try{
			JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
			return jdbcTemplate.queryForInt(sql);
		}catch(Throwable e){
			throw e;
		}
	}

}
