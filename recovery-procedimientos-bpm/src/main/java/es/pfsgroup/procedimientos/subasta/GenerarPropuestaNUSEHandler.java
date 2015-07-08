package es.pfsgroup.procedimientos.subasta;

import java.util.Calendar;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda.InformeValidacionCDDDto;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoValidacionCDD;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class GenerarPropuestaNUSEHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;
    
	private static final String BANKIA = "BANKIA";
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	private Procedimiento procedimiento = null;
	
	/**
	 * Procedimiento asociado
	 * @return
	 */
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	/**
	 * Devuelve el asnto extendido
	 * 
	 * @return
	 */
	protected EXTAsunto getExtAsunto(Procedimiento procedimiento) {
		EXTAsunto extAsunto = null;
		Asunto asunto = procedimiento.getAsunto();
		if (Hibernate.getClass(asunto).equals(EXTAsunto.class)) {
            HibernateProxy proxy = (HibernateProxy) asunto;
			extAsunto = (EXTAsunto)proxy.writeReplace();
        } else {
        	logger.warn(String.format("CIERRE DE DEUDA: No es una instancia EXTAsunto el procedimiento %d", procedimiento.getId()));        	
        }
		return extAsunto;
	}
	
	/**
	 * Genera una instancia del cierre de deuda
	 * @return 
	 */
	protected BatchAcuerdoCierreDeuda getCierreDeudaInstance() {
		Auditoria auditoria = Auditoria.getNewInstance();
		BatchAcuerdoCierreDeuda cierreDeuda = new BatchAcuerdoCierreDeuda();
		cierreDeuda.setIdProcedimiento(procedimiento.getId());
		cierreDeuda.setIdAsunto(procedimiento.getAsunto().getId());
		cierreDeuda.setFechaAlta(Calendar.getInstance().getTime());
		cierreDeuda.setUsuarioCrear(auditoria.getUsuarioCrear());
		cierreDeuda.setEntidad(BANKIA);
		logger.debug(String.format("CIERRE DE DEUDA SAREB: idProcedimiento: %d, idAsunto: %d, Entidad: %s", 
				cierreDeuda.getIdProcedimiento(), 
				cierreDeuda.getIdAsunto(), 
				cierreDeuda.getEntidad()));
		cierreDeuda.setOrigenPropuesta(BatchAcuerdoCierreDeuda.PROPIEDAD_AUTOMATICO);
			
		InformeValidacionCDDDto informe = proxyFactory.proxy(SubastaProcedimientoDelegateApi.class).generarInformeValidacionCDD(procedimiento.getId(), null, null);
		if(informe.getValidacionOK()) {
			cierreDeuda.setResultadoValidacion(BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_OK);
		}else{
			String motivo = informe.getResultadoValidacion().get(0);
			DDResultadoValidacionCDD resultadoValidacion = (DDResultadoValidacionCDD) diccionarioApi.dameValorDiccionarioByCod(DDResultadoValidacionCDD.class, motivo);
			cierreDeuda.setResultadoValidacion(BatchAcuerdoCierreDeuda.PROPIEDAD_RESULTADO_KO);
			cierreDeuda.setResultadoValidacionCDD(resultadoValidacion);
		}
		
		return cierreDeuda;
	}
	
	/**
	 * Guarda el cierre de deuda.
	 */
	protected void guardaCierreDeuda() {
		BatchAcuerdoCierreDeuda cierreDeuda = getCierreDeudaInstance();		
		executor.execute("es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.api.guardaBatchAcuerdoCierreDeuda", cierreDeuda);
	}
	
    /**
     * Solicita el cierre de deuda para este procedimiento.
     * 
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
    	// Recupera la subasta de este procedimiento
		procedimiento = getProcedimiento(executionContext);
		guardaCierreDeuda();
    	// Avanza BPM
		executionContext.getToken().signal(BPMContants.TRANSICION_AVANZA_BPM);
    }

}