package es.pfsgroup.recovery.batch.recuperaciones.jmx;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoArquetipadoRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoCreacionClientesRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoCreacionExpedientesRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoCreacionExpedientesRecuperacionesETL;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoHistorizarArquetipadoRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoRevisionClientesRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.constantes.RecuperacionesConstantes.ProcesoRevisionExpedientesRecuperaciones;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoArquetipadoRecuperacionesJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoCreacionClientesRecuperacionesJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoCreacionExpedientesRecuperacionesETLJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoCreacionExpedientesRecuperacionesJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoHistorizarArquetipadoRecuperacionesJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoRevisionClientesRecuperacionesJobLauncher;
import es.pfsgroup.recovery.batch.recuperaciones.launcher.ProcesoRevisionExpedientesRecuperacionesJobLauncher;

/**
 * Lanzadores JMX para los jobs del batch de recuperaciones.
 * @author carlos
 *
 */
@Component
@ManagedResource("devon:type=BatchRecuperaciones")
public class BatchConsoleJMXRecuperaciones {
	
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@ManagedOperation(description = "Ejecuta el proceso de Arquetipado para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoArquetipado(String workingCode) {
		
		logger.debug("Encolando " + ProcesoArquetipadoRecuperaciones.PROCESO_ARQUETIPADO_RECUPERACIONES_HANDLER);
		
		ProcesoArquetipadoRecuperacionesJobLauncher marcadoExpedientesJobLauncher = (ProcesoArquetipadoRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoArquetipadoRecuperaciones.PROCESO_ARQUETIPADO_RECUPERACIONES_HANDLER);
		
		
    	marcadoExpedientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoArquetipadoRecuperaciones.PROCESO_ARQUETIPADO_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	
	@ManagedOperation(description = "Ejecuta el proceso de Creacion clientes para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoCreacionClientes(String workingCode) {
		
		logger.debug("Encolando " + ProcesoCreacionClientesRecuperaciones.PROCESO_CREACION_CLIENTES_RECUPERACIONES_HANDLER);
		
		ProcesoCreacionClientesRecuperacionesJobLauncher creacionClientesJobLauncher = (ProcesoCreacionClientesRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoCreacionClientesRecuperaciones.PROCESO_CREACION_CLIENTES_RECUPERACIONES_HANDLER);
		
		
    	creacionClientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoCreacionClientesRecuperaciones.PROCESO_CREACION_CLIENTES_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	@ManagedOperation(description = "Ejecuta el proceso de Creacion expedientes para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoCreacionExpedientes(String workingCode) {
		
		logger.debug("Encolando " + ProcesoCreacionExpedientesRecuperaciones.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_HANDLER);
		
		ProcesoCreacionExpedientesRecuperacionesJobLauncher creacionExpedientesJobLauncher = (ProcesoCreacionExpedientesRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoCreacionExpedientesRecuperaciones.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_HANDLER);
		
		
    	creacionExpedientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoCreacionExpedientesRecuperaciones.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	@ManagedOperation(description = "Ejecuta el proceso de Revision clientes para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoRevisionClientes(String workingCode) {
		
		logger.debug("Encolando " + ProcesoRevisionClientesRecuperaciones.PROCESO_REVISION_CLIENTES_RECUPERACIONES_HANDLER);
		
		ProcesoRevisionClientesRecuperacionesJobLauncher revisionClientesJobLauncher = (ProcesoRevisionClientesRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoRevisionClientesRecuperaciones.PROCESO_REVISION_CLIENTES_RECUPERACIONES_HANDLER);
		
		
    	revisionClientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoRevisionClientesRecuperaciones.PROCESO_REVISION_CLIENTES_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	@ManagedOperation(description = "Ejecuta el proceso de Revision expedientes para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoRevisionExpedientes(String workingCode) {
		
		logger.debug("Encolando " + ProcesoRevisionExpedientesRecuperaciones.PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES_HANDLER);
		
		ProcesoRevisionExpedientesRecuperacionesJobLauncher revisionExpedientesJobLauncher = (ProcesoRevisionExpedientesRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoRevisionExpedientesRecuperaciones.PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES_HANDLER);
		
		
    	revisionExpedientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoRevisionExpedientesRecuperaciones.PROCESO_REVISION_EXPEDIENTES_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	@ManagedOperation(description = "Ejecuta el proceso de Historización de arquetipado para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoHistorizarArquetipado(String workingCode) {
		
		logger.debug("Encolando " + ProcesoHistorizarArquetipadoRecuperaciones.PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES_HANDLER);
		
		ProcesoHistorizarArquetipadoRecuperacionesJobLauncher historizarArquetipadoJobLauncher = (ProcesoHistorizarArquetipadoRecuperacionesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoHistorizarArquetipadoRecuperaciones.PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES_HANDLER);
		
		
    	historizarArquetipadoJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoHistorizarArquetipadoRecuperaciones.PROCESO_HISTORIZAR_ARQUETIPADO_RECUPERACIONES_HANDLER + " ya se ha encolado");
		
	}
	
	@ManagedOperation(description = "Ejecuta el proceso de Creacion expedientes para el batch de Recuperaciones. Se debe indicar el workingCode")
	public void ejecutarProcesoCreacionExpedientesETL(String workingCode) {
		
		logger.debug("Encolando " + ProcesoCreacionExpedientesRecuperacionesETL.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL_HANDLER);
		
		ProcesoCreacionExpedientesRecuperacionesETLJobLauncher creacionClientesJobLauncher = (ProcesoCreacionExpedientesRecuperacionesETLJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoCreacionExpedientesRecuperacionesETL.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL_HANDLER);
		
		
    	creacionClientesJobLauncher.handle(workingCode,new Date());
    	
    	logger.debug(ProcesoCreacionExpedientesRecuperacionesETL.PROCESO_CREACION_EXPEDIENTES_RECUPERACIONES_ETL_HANDLER + " ya se ha encolado");
		
	}

}