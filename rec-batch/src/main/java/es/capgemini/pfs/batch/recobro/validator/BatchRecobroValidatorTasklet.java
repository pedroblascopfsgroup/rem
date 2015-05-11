package es.capgemini.pfs.batch.recobro.validator;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.springframework.batch.core.StepExecution;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.pfs.batch.common.ValidationTasklet;
import es.pfsgroup.commons.utils.Checks;

/**
 * TaskLet que valida un record count de una tabla dada.
 * 
 * @author Guillem
 * 
 */
public class BatchRecobroValidatorTasklet implements ValidationTasklet {

	private String query;
	private String argumento;
	private String tableName;
	private String expectedNumber;
	private DataSource dataSource;
	private String bindings;
	private String message;
	private String severidad;

	/**
	 * Metodo de ejecucion de la clase.
	 * 
	 * @return ExitStatus
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ExitStatus execute() {

		JdbcOperations jdbcTemplate = new JdbcTemplate(getDataSource());
		List<Map> result;
		if (argumento == null) {
			result = jdbcTemplate.queryForList(query);
		} else {
			result = jdbcTemplate.queryForList(query,
					new Object[] { argumento });
		}

		if (result.isEmpty() && Checks.esNulo(expectedNumber)) {
			return ExitStatus.FINISHED;
		}else if (!result.isEmpty() && Checks.esNulo(expectedNumber)) {
			int cantidadDeErrores = 0;
			int maximaCantidadDeErrores = new Integer(appProperties.get("batch.validation.maxQuantityError").toString());
			for (Map record : result) {
				if (cantidadDeErrores > maximaCantidadDeErrores) {
					break;
				}
				String codigoValor = "" + record.get(ERROR_FIELD);
				String codigoEntidad = "" + record.get(ENTITY_CODE);
				Object[] params = new Object[] { codigoValor, codigoEntidad, argumento };
				EventBatchUtil.getInstance().throwEventErrorChannel(getMessage(), getSeveridad(), false, params);
				cantidadDeErrores++;
			}
			if (severidad != null && "error".equalsIgnoreCase(severidad)) {
				ExitStatus exit = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), getMessage());
				return exit;
			}
			return ExitStatus.FINISHED;
		} else if (result.isEmpty() && !Checks.esNulo(expectedNumber)) {
			if (Integer.parseInt(expectedNumber) == 0) {
				return ExitStatus.FINISHED;
			} else{
				return ExitStatus.FAILED;
			}
		} else {
			if (Integer.parseInt(expectedNumber) == result.size()) {
				return ExitStatus.FINISHED;
			} else{
				return ExitStatus.FAILED;
			}
		}
	}
		
	/**
	 * Se hace un autowired del appProperties.
	 */
	@Resource
	private Properties appProperties;

	/**
	 * @return the query
	 */
	public String getQuery() {
		return query;
	}

	/**
	 * @param query
	 *            the query to set
	 */
	public void setQuery(String query) {
		this.query = query;
	}

	/**
	 * @return the tableName
	 */
	public String getTableName() {
		return tableName;
	}

	/**
	 * @param tableName
	 *            the tableName to set
	 */
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	/**
	 * @return the expectedNumber
	 */
	public String getExpectedNumber() {
		return expectedNumber;
	}

	/**
	 * @param expectedNumber
	 *            the expectedNumber to set
	 */
	public void setExpectedNumber(String expectedNumber) {
		this.expectedNumber = expectedNumber;
	}

	/**
	 * @return the dataSource
	 */
	public DataSource getDataSource() {
		return dataSource;
	}

	/**
	 * @param dataSource
	 *            the dataSource to set
	 */
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * @param message
	 *            the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}

	/**
	 * @return the severidad
	 */
	public String getSeveridad() {
		return severidad;
	}

	/**
	 * @param severidad
	 *            the severidad to set
	 */
	public void setSeveridad(String severidad) {
		this.severidad = severidad;
	}

	/**
	 * afterStep.
	 * 
	 * @param arg0
	 *            StepExecution
	 * @return ExitStatus
	 */
	@Override
	public ExitStatus afterStep(StepExecution arg0) {
		return null;
	}

	/**
	 * beforeStep.
	 * 
	 * @param stepExecution
	 *            StepExecution
	 */
	@Override
	public void beforeStep(StepExecution stepExecution) {
		ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
	}

	/**
	 * onErrorInStep.
	 * 
	 * @param arg0
	 *            StepExecution
	 * @param arg1
	 *            Throwable
	 * @return ExitStatus
	 */
	@Override
	public ExitStatus onErrorInStep(StepExecution arg0, Throwable arg1) {
		EventBatchUtil.getInstance().throwEventErrorChannel(arg1,
				getSeveridad(), getMessage());
		return null;
	}

	/**
	 * @return the bindings
	 */
	public String getBindings() {
		return bindings;
	}

	/**
	 * @param bindings
	 *            the bindings to set
	 */
	public void setBindings(String bindings) {
		this.bindings = bindings;
	}

	/**
	 * @return the argumento
	 */
	public String getArgumento() {
		return argumento;
	}

	/**
	 * @param argumento
	 *            the argumento to set
	 */
	public void setArgumento(String argumento) {
		this.argumento = argumento;
	}
}
