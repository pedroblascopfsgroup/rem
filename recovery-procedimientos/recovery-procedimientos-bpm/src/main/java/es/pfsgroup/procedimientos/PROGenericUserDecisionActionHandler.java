package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.dao.SubtipoTareaDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;

public class PROGenericUserDecisionActionHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = -2212945246713305195L;

	@Autowired
	private SubtipoTareaDao subtipoTareaDao;

	@Autowired
	ApiProxyFactory proxyFactory;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		boolean reentrada = detectaReentrada(executionContext);

		if (!reentrada) {
			String idSubtipoTarea = SubtipoTarea.CODIGO_TOMA_DECISION_BPM;
			String idTipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO;
			String codigoPlazo = PlazoTareasDefault.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO;

			String descripcion = subtipoTareaDao
					.buscarPorCodigo(idSubtipoTarea).getDescripcionLarga();

			Long idBPM = proxyFactory.proxy(TareaNotificacionApi.class)
					.crearTareaConBPM(
							getProcedimiento(executionContext).getId(),
							idTipoEntidad, idSubtipoTarea, codigoPlazo);
			Long idTarea = (Long) proxyFactory.proxy(JBPMProcessApi.class)
					.getVariablesToProcess(idBPM, TareaBPMConstants.ID_TAREA);
			// Long idBPM =
			// tareaNotificacionManager.crearTareaConBPM(getProcedimiento().getId(),
			// idTipoEntidad, idSubtipoTarea, codigoPlazo);
			// Long idTarea = (Long) processUtils.getVariablesToProcess(idBPM,
			// TareaBPMConstants.ID_TAREA);

			TareaNotificacion tn = proxyFactory.proxy(
					TareaNotificacionApi.class).get(idTarea);
			tn.setDescripcionTarea(descripcion);
			proxyFactory.proxy(TareaNotificacionApi.class).saveOrUpdate(tn);
		}

		// Avanzamos BPM
		executionContext.getToken().signal();
	}

}
