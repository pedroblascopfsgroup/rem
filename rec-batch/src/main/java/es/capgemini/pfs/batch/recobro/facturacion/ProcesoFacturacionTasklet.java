package es.capgemini.pfs.batch.recobro.facturacion;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.recobro.facturacion.manager.CalculoFacturacionManager;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api.RecobroProcesosFacturacionApi;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroDDEstadoProcesoFacturable;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;

/**
 * Proceso de Facturacion a las Agencias de Recobro
 * @author javier
 *
 */
public class ProcesoFacturacionTasklet implements Tasklet, StepExecutionListener {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private CalculoFacturacionManager calculoFacturacionManager;	
	
	@Autowired
	private RecobroProcesosFacturacionApi recobroProcesosFacturacionManager;
	
	@Override
	public void beforeStep(StepExecution stepExecution) {
		
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
	 * Inicia el proceso de Facturacion a Agencias de recobro
	 */
	@Override
	public ExitStatus execute() throws Exception {
		try {
			logger.debug("Iniciando proceso Facturacion a Agencias de recobro");
			List<RecobroProcesoFacturacion> procesosFacturacionPendientes = recobroProcesosFacturacionManager.getProcesosByState(RecobroDDEstadoProcesoFacturable.RCF_ESTADO_PROCESO_FACTURACION_PENDIENTE);
			if(procesosFacturacionPendientes.size() == 0){
				logger.debug("No se ha encontrado ning�n proceso de Facturacion en estado pendiente. Se termina el proceso.");
				return ExitStatus.NOOP;
			}else if(procesosFacturacionPendientes.size() == 1){
				logger.debug("Encontrado un proceso de Facturacion en estado pendiente.");
				calculoFacturacionManager.calcularFacturacion();
				logger.debug("Facturacion a Agencias de recobro finalizada. Se inicia el proceso de historizaci�n de la facturaci�n.");
				return ExitStatus.FINISHED;
			}else{
				logger.debug("Se han encontrado m�s de 1 proceso de Facturacion en estado pendiente. Se aborta el proceso.");
				return ExitStatus.FAILED;
			}
		} catch (Exception e) {
			logger.fatal("No se ha podido facturar a las agencias de recobro", e);
			return ExitStatus.FAILED;
		} catch (Throwable e) {
			logger.fatal("No se ha podido facturar a las agencias de recobro", e);
			return ExitStatus.FAILED;
		}
	}

}
