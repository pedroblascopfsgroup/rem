package es.capgemini.pfs.batch.recobro;

import java.util.Date;

import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ControlSimulacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.GeneracionYPersistenciaInformeSimulacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.Genericas;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.HistorizacionFacturacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.HistorizacionRecobro;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.PreProcesadoCobros;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.PreProcesadoIndependienteCobros;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.PreparacionRecobro;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.PreparacionSimulacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoArquetipado;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoArquetipadoSimulacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoFacturacion;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoGeneracionExpedientes;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoLimpiezaExpedientes;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoMarcadoExpedientes;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoPersistenciaPreviaEnvio;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoRanking;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoRearquetipacionExpedientes;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoReparto;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoRevisionExpedientesActivos;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ValidacionRecobro;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.ProcesoFacturacionJobLauncher;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.ProcesoHistorizacionFacturacionJobLauncher;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.ProcesoPreProcesadoCobrosIndependienteJobLauncher;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.ProcesoPreProcesadoCobrosJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoArquetipadoJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoGeneracionExpedientesJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoHistorizacionJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoLimpiezaExpedientesJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoMarcadoExpedientesJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoPersistenciaPreviaEnvioJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoPreparacionRecobroJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoRearquetipacionExpedientesJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoRepartoJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoRevisionExpedientesActivosJobLauncher;
import es.capgemini.pfs.batch.recobro.jobs.ProcesoValidacionRecobroJobLauncher;
import es.capgemini.pfs.batch.recobro.ranking.jobs.ProcesoRankingJobLauncher;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.ProcesoArquetipadoSimulacionJobLauncher;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.ProcesoControlSimulacionJobLauncher;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncher;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.ProcesoGuardadoExcelSimulacionJobLauncher;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.ProcesoPreparacionSimulacionJobLauncher;

/**
 * Clase de punto de entrada de la consola JMX para los procesos de las Agencias de Recobro
 * @author Guillem
 *
 */
@Component
@ManagedResource(Genericas.DEVON_TYPE_BATCH_RECOBRO)
public class BatchRecobroConsolePlugin {

	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Marcado de Expedientes correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoMarcadoExpedientes.DESCRIPCION_PROCESO_MARCADO_EXPEDIENTES)
    public void ejecutarProcesoMarcadoExpedientes(String workingCode) {
    	ProcesoMarcadoExpedientesJobLauncher marcadoExpedientesJobLauncher = (ProcesoMarcadoExpedientesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoMarcadoExpedientes.PROCESO_MARCADO_EXPEDIENTES_RECOBRO_HANDLER);
    	marcadoExpedientesJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Limpieza de Expedientes correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoLimpiezaExpedientes.DESCRIPCION_PROCESO_LIMPIEZA_EXPEDIENTES)
    public void ejecutarProcesoLimpiezaExpedientes(String workingCode) {
    	ProcesoLimpiezaExpedientesJobLauncher limpiezaExpedientesJobLauncher = (ProcesoLimpiezaExpedientesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoLimpiezaExpedientes.PROCESO_LIMPIEZA_EXPEDIENTES_RECOBRO_HANDLER);
    	limpiezaExpedientesJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Revisi�n de Expedientes Activos correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoRevisionExpedientesActivos.DESCRIPCION_PROCESO_REVISION_EXPEDIENTES_ACTIVOS)
    public void ejecutarProcesoRevisionExpedientesActivos(String workingCode) {
    	ProcesoRevisionExpedientesActivosJobLauncher expedientesActivosJobLauncher = (ProcesoRevisionExpedientesActivosJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoRevisionExpedientesActivos.PROCESO_REVISION_EXPEDIENTES_ACTIVOS_RECOBRO_HANDLER);
    	expedientesActivosJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Revisi�n de Expedientes Activos correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoRearquetipacionExpedientes.DESCRIPCION_PROCESO_REARQUETIPACION_EXPEDIENTES)
    public void ejecutarProcesoRearquetipacionExpedientes(String workingCode) {
    	ProcesoRearquetipacionExpedientesJobLauncher rearquetipacionExpedientesJobLauncher = (ProcesoRearquetipacionExpedientesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoRearquetipacionExpedientes.PROCESO_REARQUETIPACION_EXPEDIENTES_RECOBRO_HANDLER);
    	rearquetipacionExpedientesJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Arquetipado correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoArquetipadoSimulacion.DESCRIPCION_PROCESO_ARQUETIPADO_SIMULACION)
    public void ejecutarProcesoArquetipadoSimulacion(String workingCode) {
    	ProcesoArquetipadoSimulacionJobLauncher arquetipadoSimulacionJobLauncher = (ProcesoArquetipadoSimulacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoArquetipadoSimulacion.PROCESO_ARQUETIPADO_SIMULACION_RECOBRO_HANDLER);
    	arquetipadoSimulacionJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Arquetipado correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoArquetipado.DESCRIPCION_PROCESO_ARQUETIPADO)
    public void ejecutarProcesoArquetipado(String workingCode) {
    	ProcesoArquetipadoJobLauncher arquetipadoJobLauncher = (ProcesoArquetipadoJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoArquetipado.PROCESO_ARQUETIPADO_RECOBRO_HANDLER);
    	arquetipadoJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Generaci�n de Expedientes correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoGeneracionExpedientes.DESCRIPCION_PROCESO_GENERACION_EXPEDIENTES)
    public void ejecutarProcesoGeneracionExpedientes(String workingCode) {
    	ProcesoGeneracionExpedientesJobLauncher generacionExpedientesJobLauncher = (ProcesoGeneracionExpedientesJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoGeneracionExpedientes.PROCESO_GENERACION_EXPEDIENTES_RECOBRO_HANDLER);
    	generacionExpedientesJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Reparto correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoReparto.DESCRIPCION_PROCESO_REPARTO)
    public void ejecutarProcesoReparto(String workingCode) {
    	ProcesoRepartoJobLauncher repartoJobLauncher = (ProcesoRepartoJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoReparto.PROCESO_REPARTO_RECOBRO_HANDLER);
    	repartoJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Persistencia Previa Env�o correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoPersistenciaPreviaEnvio.DESCRIPCION_PROCESO_PERSISTENCIA_PREVIA_ENVIO)
    public void ejecutarProcesoPersistenciaPreviaEnvio(String workingCode) {
    	ProcesoPersistenciaPreviaEnvioJobLauncher persistenciaPreviaEnvioJobLauncher = (ProcesoPersistenciaPreviaEnvioJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoPersistenciaPreviaEnvio.PROCESO_PERSISTENCIA_PREVIA_ENVIO_RECOBRO_HANDLER);
    	persistenciaPreviaEnvioJobLauncher.handle(workingCode,new Date());
    }
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso INDEPENDIENTE de PreProcesado de los Cobros de Recobro para la posterior facturaci�n a Agencias
	 * @param workingCode
	 */
    @ManagedOperation(description=PreProcesadoIndependienteCobros.DESCRIPCION_PREPROCESADO_INDEPENDIENTE_COBROS)
    public void ejecutarProcesoIndependientePreProcesadoCobrosFacturacion(String workingCode) {
    	ProcesoPreProcesadoCobrosIndependienteJobLauncher preProcesadoCobrosIndependienteJobLauncher = (ProcesoPreProcesadoCobrosIndependienteJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(PreProcesadoIndependienteCobros.PROCESO_PREPROCESADO_INDEPENDIENTE_COBROS_RECOBRO_HANDLER);
    	preProcesadoCobrosIndependienteJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de PreProcesado de los Cobros de Recobro y la posterior facturaci�n a Agencias
	 * @param workingCode
	 */
    @ManagedOperation(description=PreProcesadoCobros.DESCRIPCION_PREPROCESADO_COBROS)
    public void ejecutarProcesoPreProcesadoCobrosFacturacion(String workingCode) {
    	ProcesoPreProcesadoCobrosJobLauncher preProcesadoCobrosJobLauncher = (ProcesoPreProcesadoCobrosJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(PreProcesadoCobros.PROCESO_PREPROCESADO_COBROS_RECOBRO_HANDLER);
    	preProcesadoCobrosJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Facturacion correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoFacturacion.DESCRIPCION_PROCESO_FACTURACION)
    public void ejecutarProcesoFacturacion(String workingCode) {
    	ProcesoFacturacionJobLauncher facturacionJobLauncher = (ProcesoFacturacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoFacturacion.PROCESO_FACTURACION_RECOBRO_HANDLER);
    	facturacionJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Preparaci�n de la Simulacion correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=PreparacionSimulacion.DESCRIPCION_PROCESO_PREPARACION_SIMULACION_RECOBRO)
    public void ejecutarProcesoPreparacionSimulacion(String workingCode) {
    	ProcesoPreparacionSimulacionJobLauncher preparacionSimulacionJobLauncher = (ProcesoPreparacionSimulacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(PreparacionSimulacion.PROCESO_PREPARACION_SIMULACION_RECOBRO_HANDLER);
    	preparacionSimulacionJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Generacion y Persistencia de la Simulaci�n correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=GeneracionYPersistenciaInformeSimulacion.DESCRIPCION_PROCESO_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO)
    public void ejecutarProcesoGeneracionYPersistenciaInformeSimulacion(String workingCode) throws Throwable{
    	try{
    	ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncher generacionYPersistenciaInformeSimulacionJobLauncher = (ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(GeneracionYPersistenciaInformeSimulacion.PROCESO_PREPARACION_GENERACION_PERSISTENCIA_INFORME_SIMULACION_RECOBRO_HANDLER);
    	generacionYPersistenciaInformeSimulacionJobLauncher.handle(workingCode,new Date());
    	}catch(Throwable e){
    		throw e;    		
    	}
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Preparaci�n del batch correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=PreparacionRecobro.DESCRIPCION_PROCESO_PREPARACION_RECOBRO)
    public void ejecutarProcesoPreparacionBatchRecobro(String workingCode) {
    	ProcesoPreparacionRecobroJobLauncher preparacionRecobroJobLauncher = (ProcesoPreparacionRecobroJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(PreparacionRecobro.PROCESO_PREPARACION_RECOBRO_HANDLER);
    	preparacionRecobroJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Historizaci�n correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=HistorizacionRecobro.DESCRIPCION_PROCESO_HISTORIZACION_RECOBRO)
    public void ejecutarProcesoHistorizacionBatchRecobro(String workingCode) {
    	ProcesoHistorizacionJobLauncher historizacionRecobroJobLauncher = (ProcesoHistorizacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(HistorizacionRecobro.PROCESO_HISTORIZACION_RECOBRO_HANDLER);
    	historizacionRecobroJobLauncher.handle(workingCode,new Date());
    }    
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Control correspondiente a las Agencias de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ControlSimulacion.DESCRIPCION_PROCESO_CONTROL_SIMULACION_RECOBRO)
    public void ejecutarProcesoControlSimulacion(String workingCode) {
    	ProcesoControlSimulacionJobLauncher preparacionControlJobLauncher = (ProcesoControlSimulacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ControlSimulacion.PROCESO_CONTROL_RECOBRO_HANDLER);
    	preparacionControlJobLauncher.handle(workingCode,new Date());
    }   
      
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Historizaci�n correspondiente al proceso de Facturaci�n
	 * @param workingCode
	 */
    @ManagedOperation(description=HistorizacionFacturacion.DESCRIPCION_PROCESO_HISTORIZACION_FACTURACION)
    public void ejecutarProcesoHistorizacionFacturacion(String workingCode) {
    	ProcesoHistorizacionFacturacionJobLauncher historizacionFacturacionJobLauncher = (ProcesoHistorizacionFacturacionJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(HistorizacionFacturacion.PROCESO_HISTORIZACION_FACTURACION_HANDLER);
    	historizacionFacturacionJobLauncher.handle(workingCode,new Date());
    }        
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Validaci�n correspondiente al proceso del Batch de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ValidacionRecobro.DESCRIPCION_PROCESO_VALIDACION_RECOBRO)
    public void ejecutarProcesoValidacionBatchRecobro(String workingCode) {
    	ProcesoValidacionRecobroJobLauncher validacionRecobroJobLauncher = (ProcesoValidacionRecobroJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ValidacionRecobro.PROCESO_VALIDACION_RECOBRO_HANDLER);
    	validacionRecobroJobLauncher.handle(workingCode,new Date());
    }     
    
	/**
	 * M�todo de entrada para la ejecuci�n por consola JMX del proceso de Validaci�n correspondiente al proceso del Batch de Recobro
	 * @param workingCode
	 */
    @ManagedOperation(description=ProcesoRanking.DESCRIPCION_PROCESO_RANKING)
    public void ejecutarProcesoRankingRecobro(String workingCode) {
    	ProcesoRankingJobLauncher rankingRecobroJobLauncher = (ProcesoRankingJobLauncher)ApplicationContextUtil.
    			getApplicationContext().getBean(ProcesoRanking.PROCESO_RANKING_HANDLER);
    	rankingRecobroJobLauncher.handle(workingCode,new Date());
    }
    
    /**
	 * M�todo que nos permite generar la excel de simulaci�n de recobro y guardarla en el sistema de archivos
	 * @param workingCode
	 * @param filePath Ruta en d�nde queremos guardar la excel
	 */
    @ManagedOperation(description=ControlSimulacion.DESCRIPCION_GUARDAR_EXCEL_SIMULACION_EN_DISCO)
    public void extraerExcelSimulacion(String workingCode, String filePath){
    	ProcesoGuardadoExcelSimulacionJobLauncher guardadoExcelJobLauncher = (ProcesoGuardadoExcelSimulacionJobLauncher) ApplicationContextUtil.
    			getApplicationContext().getBean(ControlSimulacion.PROCESO_GUARDADO_EXCEL_SIMULACION_HANDLER);
    	guardadoExcelJobLauncher.handle(workingCode, filePath, new Date());
    }
    
}
