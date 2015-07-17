package es.pfsgroup.procedimientos.subasta;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.BatchAcuerdoCierreDeuda;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class GenerarPropuestaNUSEHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;
    
	//private static final String PROPIEDAD_BANKIA = "BANKIA";
	private static final String PROPIEDAD_SAREB = "SAREB";
	
	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;	
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	private Procedimiento procedimiento = null;
	
	private Procedimiento procedimientoSubasta = null;
	
	/**
	 * Procedimiento asociado
	 * @return
	 */
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	
	public Procedimiento getProcedimientoSubasta() {
		return procedimientoSubasta;
	}


	public void setProcedimientoSubasta(Procedimiento procedimientoSubasta) {
		this.procedimientoSubasta = procedimientoSubasta;
	}


	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}


	protected EXTAsunto getExtAsunto() {
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
	 * Devuelve la subasta
	 * 
	 * @return
	 */
	protected Subasta getSubasta() {

		Subasta subasta = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procedimientoSubasta.getId()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		if (Checks.esNulo(subasta)) {     
        	logger.warn(String.format("CIERRE DE DEUDA: No se ha encontrado la subasta para el procedimiento " + procedimientoSubasta.getId()));        	
        }
		
		return subasta;
	}
	
	
	
	protected void enviarCierreDeuda() {		
		
		EXTAsunto extAsunto = getExtAsunto();
		Subasta subasta = getSubasta();
		
		
		if(!Checks.esNulo(extAsunto) &&  !Checks.esNulo(subasta) ) {		
			
			if (PROPIEDAD_SAREB.equals(extAsunto.getPropiedadAsunto().getCodigo())) {

				for(ProcedimientoBien bien: procedimiento.getBienes()){					
					executor.execute("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.generarEnvioCierreDeuda", subasta, bien.getBien().getId(), BatchAcuerdoCierreDeuda.PROPIEDAD_AUTOMATICO);		
				}				
				
			} else {

				executor.execute("plugin.nuevoModeloBienes.subastas.manager.SubastaManager.generarEnvioCierreDeuda", subasta, null, BatchAcuerdoCierreDeuda.PROPIEDAD_AUTOMATICO);
			}
		
		}

	}
	
    /**
     * Solicita el cierre de deuda para este procedimiento.
     * 
     * @throws Exception e
     */
    @Override
    public void run(ExecutionContext executionContext) throws Exception {
    	// Recuperamos el procedimiento
		this.procedimiento = getProcedimiento(executionContext);
		this.procedimientoSubasta = procedimiento;
				
		enviarCierreDeuda();
    	
		// Avanza BPM
		executionContext.getToken().signal(BPMContants.TRANSICION_AVANZA_BPM);
    }


}