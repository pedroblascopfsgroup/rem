package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;
import java.util.Date;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;

public class ResolucionExpedienteEnterActionHandler extends ActivoGenericEnterActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;

	private static final String TA_RESOLUCION_EXPEDIENTE = "Resolución expediente";
	private static final String CODIGO_T017_RESOLUCION_EXPEDIENTE = "T017_ResolucionExpediente";

	@Autowired
	private TareaActivoDao tareaActivoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
    

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {

		// Primero ejecuta la entrada (creacion) de la tarea
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		TareaExterna tareaExterna = getTareaExterna(executionContext);
		TareaActivo tareaActivo = null;

		if (tareaExterna.getTareaPadre() instanceof TareaActivo) {
			tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();

			for (TareaActivo ta : tareaActivo.getTramite().getTareas()) {
				if ((Checks.esNulo(ta.getTareaFinalizada()) || !ta.getTareaFinalizada()) && !TA_RESOLUCION_EXPEDIENTE.equals(ta.getTarea())) {

					Auditoria.delete(ta);
					ta.setFechaFin(new Date());
					ta.setTareaFinalizada(true);

					tareaActivoDao.saveOrUpdate(ta);
				}
			}
			
			if(CODIGO_T017_RESOLUCION_EXPEDIENTE.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
	        	expedienteComercialApi.sacarBulk(genericDao.get(ExpedienteComercial.class, 
	        			genericDao.createFilter(FilterType.EQUALS, "trabajo", tareaActivo.getTramite().getTrabajo())).getId());
	        }
		}		
		
	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}
}