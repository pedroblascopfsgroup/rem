package es.pfsgroup.recovery.batch.recuperaciones.expedientes;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.devon.batch.tasks.utils.EventBatchUtil;
import es.capgemini.devon.bpm.JbpmActionHandler;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.batch.common.ValidationTasklet;
import es.capgemini.pfs.cliente.ClienteManager;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;

import org.jbpm.graph.exe.ExecutionContext;

/**
 * TaskLet que crea expedientes de recuperación a partir de una tabla temporal.
 * 
 * @author Carlos
 * 
 */
public class CreacionExpedientesRecuperacionTasklet implements Tasklet, StepExecutionListener ,ClienteBPMConstants, ExpedienteBPMConstants {

	private String query;
	private String argumento;
	private String tableName;
	private DataSource dataSource;
	private String bindings;
	private String message;
	private String severidad;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
    private ClienteManager clienteMgr;
	
	@Autowired
	private JBPMProcessManager expUtil;
	
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

		if (Checks.estaVacio(result)) {
			return ExitStatus.FINISHED;
		}else {
			Long idCliente = null;
			int i = 0;
			for (Map record : result) {
				if (!Checks.esNulo(record)) {
					idCliente =  Long.valueOf(record.get("CLI_ID").toString());
					try {
						crearExpediente(idCliente);
					} catch (Exception e) {
						logger.error("Error creando el expediente al cliente: "+ idCliente + "\n" +e.getMessage(),e);
						if (severidad != null && "error".equalsIgnoreCase(severidad)) {
							ExitStatus exit = new ExitStatus(false, ExitStatus.FAILED.getExitCode(), getMessage());
							return exit;
						}
					}
				}
			}
			return ExitStatus.FINISHED;			
		}
	
	}
	
	@Transactional(readOnly = false)
    public void crearExpediente(Long idCliente) throws Exception {

        Cliente cli = clienteMgr.getWithContratos(idCliente);
        if (Checks.esNulo(cli)) {        	
        	logger.error("Cliente " + idCliente + " se ha borrado previamente");
        	return;
        }
        
        Date fechaExtraccion = (Date) cli.getPersona().getFechaExtraccion(); //executionContext.getVariable(FECHA_EXTRACCION);
        
        if (Checks.esNulo(cli.getContratoPrincipal())) {
        	logger.error("El cliente " + idCliente + " no tiene contrato principal o ya está borrado");
        	return;
        }
        Long idContrato = cli.getContratoPrincipal().getId();
        Long idPersona = cli.getPersona().getId();
        Date fechaUmbral = cli.getPersona().getFechaUmbral();
        Float umbral = cli.getPersona().getImporteUmbral();
//        //BUG: No se setea cuando se cambia de arquetipo y por tanto se ha tenido que añadir esto
//
        Long idArquetipo = cli.getArquetipo().getId();
//        executionContext.setVariable(ARQUETIPO_ID, idArquetipo);

        Map<String, Object> param = new HashMap<String, Object>();

        param.put(PERSONA_ID, idPersona);
        param.put(CONTRATO_ID, idContrato);
        param.put(FECHA_EXTRACCION, fechaExtraccion);
        param.put(ARQUETIPO_ID, idArquetipo);
        
        if (fechaUmbral != null && (fechaUmbral.getTime() > System.currentTimeMillis())) {

            //Float importe = cli.getPersona().getTotalRiesgo();
            Float importe = cli.getPersona().getRiesgoDirectoVencido();

            //Hay que tomar en cuanta el umbral
            if (umbral > importe) {
                //Se tiene que quedar en GV
                cli.setFechaGestionVencidos(new Date());
                clienteMgr.saveOrUpdate(cli);
                logger.warn("\n\n\nMando de nuevo por umbral al cliente " + cli.getId() + "\n\n\n");
            } else {
                //Crear proceso de expediente
                expUtil.crearNewProcess(EXPEDIENTE_PROCESO, param);
            }
        } else {
            // 	Crear proceso de expediente
            expUtil.crearNewProcess(EXPEDIENTE_PROCESO, param);
        }
    }
		

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
