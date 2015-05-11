package es.pfsgroup.procedimientos.moratoria;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class EstamosADosMesesHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	/**
	 * Milisegundos al día
	 */
	private static final long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;

	private static final String TRANSICION_FIN = "Fin";

	private static final String TIMER_NAME = "Espera Solicitar Tasacion";

	private static final String TIMER_DURATION_MASK = "%d days";

	@Autowired
	protected ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	/**
	 * Solicita un número de activo para cada bien.
	 * 
	 * @throws Exception
	 *             e
	 */
	@Override
	public void run(ExecutionContext executionContext) throws Exception {

		// Recupera la subasta de este procedimiento
		Procedimiento prc = getProcedimiento(executionContext);

		// Si el procedimiento está acabado sale:
		if (prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO
				|| prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO) {
			executionContext.getToken().signal(TRANSICION_FIN);
			return;
		}

		List<TareaNotificacion> listTareas = genericDao.getList(
				TareaNotificacion.class, genericDao.createFilter(
						FilterType.EQUALS, "procedimiento.id", prc.getId()));

		for (TareaNotificacion tarea : listTareas) {
			if (!Checks.esNulo(tarea.getTarea())
					&& tarea.getTarea().contains("Registrar resoluci")) {
				TareaExterna tareaExterna = tarea.getTareaExterna();
				List<TareaExternaValor> listTareaExternaValor = tareaExterna
						.getValores();
				for (TareaExternaValor tareaExternaValor : listTareaExternaValor) {
					if ("fechaFinMoratoria".equals(tareaExternaValor
							.getNombre())) {
						try {
							DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
							Date fecha = df.parse(tareaExternaValor.getValor());
							Date hoy = new Date();
							long diasFaltanMoratoria = (fecha.getTime() - hoy
									.getTime()) / MILLSECS_PER_DAY;
							if (diasFaltanMoratoria > 60) {
								String duration = String.format(
										TIMER_DURATION_MASK,
										diasFaltanMoratoria - 60);
								BPMUtils.createTimer(executionContext,
										TIMER_NAME, duration,
										BPMContants.TRANSICION_AVANZA_BPM);
								return;
							} else
								executionContext.getToken().signal(
										BPMContants.TRANSICION_AVANZA_BPM);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

}