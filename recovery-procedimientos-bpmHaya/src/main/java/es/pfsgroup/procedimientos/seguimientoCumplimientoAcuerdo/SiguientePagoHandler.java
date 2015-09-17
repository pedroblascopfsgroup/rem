package es.pfsgroup.procedimientos.seguimientoCumplimientoAcuerdo;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.lang.time.DateFormatUtils;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class SiguientePagoHandler extends PROBaseActionHandler {

	private static final long serialVersionUID = 1L;

	private static final long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
	private static final String TRANSICION_FIN = "Fin";
	private static final String TIMER_NAME = "Espera Registrar Cumplimiento";
	private static final String TIMER_DURATION_MASK = "%d days";

	@Autowired
	private GenericABMDao genericDao;

	/**
	 * Genera un timer para tener una tarea oculta en espera hasta la fecha del siguiente pago, calculada mediante la fecha de último pago y la periodicidad 
	 * 
	 * @throws Exception e
	 */
	@Override
	public void run(ExecutionContext executionContext) throws Exception {

		String codigoPeriodicidad = null;
		long fechaPago = 0;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
		// Se recupera el procedimiento y si está acabado se sale
		Procedimiento prc = getProcedimiento(executionContext);

		if (prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO
				|| prc.getEstadoProcedimiento().getCodigo() == DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO) {
			executionContext.getToken().signal(TRANSICION_FIN);
			return;
		}

		// Se recupera la lista de tareas del procedimiento
		List<TareaNotificacion> listTareas = genericDao.getList(
				TareaNotificacion.class, genericDao.createFilter(
						FilterType.EQUALS, "procedimiento.id", prc.getId()));
		
		// Se recorren las tareas
		for (TareaNotificacion tarea : listTareas) {
			
			// Si se trata de la tarea CJ002_RegistrarAcuerdoAprobado o H041_registrarConvenio se recupera la periodicidad del acuerdo
			if (!Checks.esNulo(tarea.getTarea()) && (tarea.getTareaExterna().getTareaProcedimiento().getCodigo().equals("CJ002_RegistrarAcuerdoAprobado") || tarea.getTareaExterna().getTareaProcedimiento().getCodigo().equals("H041_registrarConvenio"))) {
				TareaExterna tareaExterna = tarea.getTareaExterna();
				List<TareaExternaValor> listTareaExternaValor = tareaExterna.getValores();
				
				for (TareaExternaValor tareaExternaValor : listTareaExternaValor) {
					if ("comboPeriodicidad".equals(tareaExternaValor.getNombre()) || "comboAdhesion".equals(tareaExternaValor.getNombre())) {
						codigoPeriodicidad = tareaExternaValor.getValor();
						break;
					}
				}
			}
			// Si se trata de la tarea CJ002_RegistrarCumplimiento o H041_registrarCumplimiento se recupera la fecha de pago en caso de ser la mayor de todas las tareas de este tipo
			else if(!Checks.esNulo(tarea.getTarea()) && (tarea.getTareaExterna().getTareaProcedimiento().getCodigo().equals("CJ002_RegistrarCumplimiento") || tarea.getTareaExterna().getTareaProcedimiento().getCodigo().equals("H041_registrarCumplimiento"))) {
				
				TareaExterna tareaExterna = tarea.getTareaExterna();
				List<TareaExternaValor> listTareaExternaValor = tareaExterna.getValores();
				
				for (TareaExternaValor tareaExternaValor : listTareaExternaValor) {
					if ("fechaPago".equals(tareaExternaValor.getNombre())) {
						
						Date dPago = sdf.parse(tareaExternaValor.getValor());
						if(dPago.getTime() > fechaPago) {
							fechaPago = dPago.getTime();
							break;
						}
					}
				}
			}
		}
		
		// Se calcula el tiempo que va a estar la tarea en espera y se crea el timer
		Calendar fechaSiguientePago = calculaFechaSiguientePago(fechaPago, codigoPeriodicidad);
		String duracion = dameDuracion(fechaPago, fechaSiguientePago);
		BPMUtils.createTimer(executionContext, TIMER_NAME, duracion, BPMContants.TRANSICION_AVANZA_BPM);
		
		// Se guarda la fecha del siguiente pago
		this.setVariable("fechaSiguientePago", DateFormatUtils.format(fechaSiguientePago.getTime(), "yyyy-MM-dd"), executionContext);
	}

	private Calendar calculaFechaSiguientePago(long fechaPago, String codigoPeriodicidad) 
	{
		GregorianCalendar calendar = new GregorianCalendar();
		calendar.setTimeInMillis(fechaPago);
		
		switch (Integer.valueOf(codigoPeriodicidad)) {
		// Anual
		case 1:
			calendar.add(Calendar.YEAR, 1);
			break;
		// Mensual
		case 2:
			calendar.add(Calendar.MONTH, 1);
			break;
		// Semestral
		case 3:
			calendar.add(Calendar.MONTH, 6);
			break;
		// Trimestral
		case 4:
			calendar.add(Calendar.MONTH, 3);
			break;
		// Bimestral		
		case 5:
			calendar.add(Calendar.MONTH, 2);
			break;
		// Semanal
		case 6:
			calendar.add(Calendar.WEEK_OF_YEAR, 1);
			break;
		// Diario
		case 8:
			calendar.add(Calendar.DATE, 1);
			break;
		// Único y otros (estos valores no se deberían indicar)
		default:
			break;
		}
		
		return calendar;
	}

	// Devuelve una cadena con la duración en días que va a tener la espera, teniendo en cuenta la periodicidad del acuerdo 
	private String dameDuracion(long fechaPago, Calendar fechaSiguientePago) 
	{
		long diasEspera= (fechaSiguientePago.getTimeInMillis() - fechaPago) / MILLSECS_PER_DAY;
		String duracion = String.format(TIMER_DURATION_MASK, diasEspera);
		
		return duracion;
	}
}

	