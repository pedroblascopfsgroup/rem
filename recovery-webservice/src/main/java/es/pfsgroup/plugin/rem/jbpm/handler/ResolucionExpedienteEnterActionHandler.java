package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;
import java.util.Date;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;

public class ResolucionExpedienteEnterActionHandler extends ActivoGenericEnterActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;

	private static final String TA_RESOLUCION_EXPEDIENTE = "Resolución expediente";

	@Autowired
	private TareaActivoDao tareaActivoDao;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {

		// Primero ejecuta la entrada (creacion) de la tarea
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		TareaExterna tareaExterna = getTareaExterna(executionContext);

		if (tareaExterna.getTareaPadre() instanceof TareaActivo) {
			TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();

			for (TareaActivo ta : tareaActivo.getTramite().getTareas()) {
				if ((Checks.esNulo(ta.getTareaFinalizada()) || !ta.getTareaFinalizada()) && !TA_RESOLUCION_EXPEDIENTE.equals(ta.getTarea())) {

					Auditoria.delete(ta);
					ta.setFechaFin(new Date());
					ta.setTareaFinalizada(true);

					tareaActivoDao.saveOrUpdate(ta);
				}
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