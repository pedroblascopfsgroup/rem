package es.capgemini.pfs.batch.antecedentes;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.batch.ParameterBinder;
import es.capgemini.pfs.batch.revisar.antecedentes.AntecedentesBatchManager;
import es.capgemini.pfs.batch.revisar.clientes.ClientesBatchManager;
import es.capgemini.pfs.batch.revisar.movimientos.dao.MovimientosBatchDao;
import es.capgemini.pfs.batch.revisar.personas.PersonasBatchManager;

/**
 * Tasklet del proceso de cálculo de Antecedentes
 * @author Guillem
 *
 */
public class ProcesoAntecedentesTasklet implements Tasklet, StepExecutionListener {

	private final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private MovimientosBatchDao movimientosDao;
		
    @Autowired
    private ClientesBatchManager clientesBatchManager;
    
    @Autowired
    private AntecedentesBatchManager antecedentesBatchManager;
    
    @Autowired
    private PersonasBatchManager personasBatchManager;
    
    private Date fechaExtraccion;
    private String bindings;    
	 		
	@Override
	public void beforeStep(StepExecution stepExecution) {
        ParameterBinder.bind(this, bindings, stepExecution.getJobParameters());
	}

	@Override
	public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
		return null;
	}

	@Override
	public ExitStatus afterStep(StepExecution stepExecution) {
		return null;
	}

    /**
     * Setea la fecha de extracción.
     * @param fechaExtraccion date
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }
    
    /**
     * Setea los parámetros a cargar en el beforeStep.
     * @param bindings parámetros
     */
    public void setBindings(String bindings) {
        this.bindings = bindings;
    }
	
	/**
	 * Inicia el proceso de cálculo de Antecedentes
	 */
	@Override
	public ExitStatus execute() throws Exception {
        List<Long> contratosCliente;
        Map<String, Object> results;
		try {
			logger.debug("Iniciando proceso de Cálculo de Antecedentes");					
	        List<Long> personasIds = personasBatchManager.buscarPersonasActivas();
	        for (Long personaId : personasIds) {
	            logger.debug("Revisando la persona con id: " + personaId);
	            // Recuperamos todos los contratos del cliente
	            contratosCliente = personasBatchManager.buscarContratos(personaId);
	            // Reviso los movimientos de los contratos del cliente
	            logger.debug("Revisando los contratos del cliente");
	            for (Long contratoId : contratosCliente) {
	            	// Revisamos el movimiento del contrato
	                results = movimientosDao.buscarDiferenciaContrato(contratoId);
	                boolean contratoSaldado = results.get("Saldado").toString().equals("1");
	                if (contratoSaldado) {
		                Date fechaVencido = (Date) results.get("fechaVencido");
		                Date fechaExtraccionMovActual = (Date) results.get("fechaExtraccion");
		                Double importeAnt = new Double(results.get("ImporteAnterior").toString());		                
		                // Solo se registra un antecedente si se ha saldado y además tiene fecha pos vencido en el movAnterior
		                if (fechaVencido != null){
		                	antecedentesBatchManager.compruebaSiExisteAntecedenteBase(personaId);
		                	antecedentesBatchManager.registrarAntecedenteInterno(contratoId, fechaExtraccionMovActual, importeAnt);
		                }
	                }
	            } 
	        }
			logger.debug("Cálculo de Antecedentes finalizado");
			return ExitStatus.FINISHED;
		} catch (Exception e) {
			logger.fatal("No se han podido calcular todos los antecedentes de todas las personas correctamente.", e);
			return ExitStatus.FAILED;
		} catch (Throwable e) {
			logger.fatal("No se ha podido calcular todos los antecedentes de todas las personas correctamente.", e);
			return ExitStatus.FAILED;
		}
	}

}
