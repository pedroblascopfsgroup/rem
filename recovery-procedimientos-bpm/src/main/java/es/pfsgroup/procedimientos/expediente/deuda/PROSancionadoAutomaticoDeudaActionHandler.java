package es.pfsgroup.procedimientos.expediente.deuda;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.api.bmp.expediente.EstrategiaGeneracionAsuntoAutomatico;
import es.pfsgroup.recovery.ext.api.expediente.EXTExpedienteApi;
import es.pfsgroup.recovery.ext.impl.bpm.expediente.EstrategiaGeneracionAsuntoAutomaticoPorDefecto;

public class PROSancionadoAutomaticoDeudaActionHandler extends PROBaseActionHandler
		implements ExpedienteBPMConstants {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired(required = false)
	private EstrategiaGeneracionAsuntoAutomatico estrategiaGeneracionAsunto;

	private static final long serialVersionUID = 1L;

	/**
	 * Este metodo debe llamar a la creacion del expediente.
	 * 
	 * @throws Exception
	 *             e
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		if (logger.isDebugEnabled()) {
			logger.debug("SancionadoAutomaticoDeudaActionHandler......");
		}

		EXTExpedienteApi expedienteManager = proxyFactory
				.proxy(EXTExpedienteApi.class);

		Long idArquetipo = (Long) executionContext.getVariable(ARQUETIPO_ID);

		Arquetipo a = (Arquetipo) executor.execute(
				ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_WITH_ESTADO,
				idArquetipo);
		Estado estadoSanc = a.getItinerario().getEstado(
				DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO);

		
		DecisionComiteAutomatico dca = estadoSanc.getDecisionComiteAutomatico();
		if (dca == null) {
			throw new BusinessOperationException(
					"batch.dca.configuracion.noExiste");
		}

		Long idExpediente = (Long) executionContext.getVariable(EXPEDIENTE_ID);
		Expediente expediente = expedienteManager.getExpediente(idExpediente);
		if (expediente == null) {
			logger.warn("EXPEDIENTE NO ENCONTRADO [" + idExpediente
					+ "]: no se va a tomar la decisión automática");
			executionContext.getProcessInstance().signal(SANCIONADO);
			return;
		}
		if (DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO.equals(expediente
				.getEstadoExpediente().getCodigo())) {
			logger.warn("EXPEDIENTE CANCELADO [" + idExpediente
					+ "]: no se va a tomar la decisión automática");
			return;
		}

		List<Long> asuntos = getEstrategiaGeneracionAsuntoAutomatico()
				.generaAsuntos(idExpediente, dca);

		for (Long idAsunto : asuntos) {
			if (dca.getAceptacionAutomatico() && idAsunto != null) {

				List<TareaNotificacion> lista = (List<TareaNotificacion>) executor
						.execute(
								ComunBusinessOperation.BO_TAREA_MGR_GET_LIST_BY_ASUNTO,
								idAsunto);
				// List<TareaNotificacion> lista =
				// tareaNotificacionManager.getListByAsunto(idAsunto);
				// Finalizo la tarea de confirmacion de asunto.
				for (TareaNotificacion tarea : lista) {
					if (SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR.equals(tarea
							.getSubtipoTarea().getCodigoSubtarea())) {
						tarea.setBorrado(true);
						executor
								.execute(
										ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
										tarea);
						// tareaNotificacionManager.saveOrUpdate(tarea);
					} else if (SubtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO
							.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {
						tarea.setBorrado(true);
						executor
								.execute(
										ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
										tarea);
						// tareaNotificacionManager.saveOrUpdate(tarea);
					}
				}
			}
		}

		executionContext.getProcessInstance().signal();
	}

	private EstrategiaGeneracionAsuntoAutomatico getEstrategiaGeneracionAsuntoAutomatico() {
		if (estrategiaGeneracionAsunto != null) {
			return estrategiaGeneracionAsunto;
		} else {
			return new EstrategiaGeneracionAsuntoAutomaticoPorDefecto(
					proxyFactory);
		}
	}

}
