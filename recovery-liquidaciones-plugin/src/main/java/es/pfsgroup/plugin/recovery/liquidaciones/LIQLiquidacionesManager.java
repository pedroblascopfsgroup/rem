package es.pfsgroup.plugin.recovery.liquidaciones;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoReportResponse;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

/**
 * Manager para las operaciones relacionadas con Persona.
 * 
 * @author marruiz
 */
@Service
public class LIQLiquidacionesManager {

	@Autowired
	private LIQCobroPagoDao cobroPagoDao;

	@Autowired
	private Executor executor;

	public LIQLiquidacionesManager() {
		super();
	}

	public LIQLiquidacionesManager(LIQCobroPagoDao cobroPagoDao,
			Executor executor) {
		super();
		this.cobroPagoDao = cobroPagoDao;
		this.executor = executor;
	}


	/**
	 * Genera el informe de las liquidaciones
	 * 
	 * @param request
	 * @return
	 */
	@BusinessOperation("plugin.liquidaciones.liquidacionesManager.createReport")
	public LIQDtoReportResponse createReport(LIQDtoReportRequest request) {
		Procedimiento proc = (Procedimiento) executor.execute(
				ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, request
						.getActuacion());
		Contrato cont = (Contrato) executor
				.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, request
						.getContrato());
		Assertions.assertNotNull(proc,
				"plugin.liquidaciones.error.procedimiento.null");
		Assertions.assertNotNull(cont,
				"plugin.liquidaciones.error.contrato.null");
		Date fechaCierre;
		Date fechaLiquidacion;
		try {
			fechaCierre = DateFormat.toDate(request.getFechaCierre());
			fechaLiquidacion = DateFormat.toDate(request.getFechaLiquidacion());
		} catch (ParseException e) {
			throw new BusinessOperationException("plugin.liquidaciones.error.date.format");
		}
		
		LIQDtoReportResponse response = new LIQDtoReportResponse();
		response.getCabecera().setAcuerdo(cont.getCodigoContrato());
		response.getCabecera().setAutos(proc.getCodigoProcedimientoEnJuzgado());
		response.getCabecera().setDni(request.getDni());
		response.getCabecera().setFechaLiquidacion(fechaCierre);
		response.getCabecera().setNombre(request.getNombre());

		Float deuda = request.getPrincipal();
		Float interes = request.getIntereses();
		Date fmov = fechaCierre;
		Float totalIntereses = 0.0F;
		Float entregado = 0.0F;

		List<LIQCobroPago> entregas = cobroPagoDao.findEntregasACuenta(request
				.getContrato(), fechaCierre,fechaLiquidacion);
		
		for (LIQCobroPago cp : entregas) {
			Float importe = cp.getImporte();
			
			LIQDtoTramoLiquidacion tramo = createTramoLiquidacion(deuda,
					interes, fmov, cp.getFecha(), importe);

			deuda -= importe;
			if (deuda < 0.0F) deuda = 0.0F;
			fmov = cp.getFecha();
			totalIntereses += tramo.getIntereses();
			entregado += tramo.getEntregado();
			response.addTramoLiquidacion(tramo);
		}
		//Agregamos un último tramo desde la última entrega a cuenta hasta la fecha actual
		LIQDtoTramoLiquidacion tramo = createTramoLiquidacion(deuda, interes, fmov, fechaLiquidacion, 0.0F);
		response.addTramoLiquidacion(tramo);
		
		totalIntereses += tramo.getIntereses();
		Float totalDeuda = request.getPrincipal() + totalIntereses - entregado;
		if (totalDeuda < 0.00F) totalDeuda = 0.00F;
		response.getCabecera().setTotalDeuda(totalDeuda);
		
		return response;
	}

	private LIQDtoTramoLiquidacion createTramoLiquidacion(Float deuda,
			Float interes, Date desde, Date hasta, Float importe) {
		
		Float coeficiente = (deuda * interes) / 36000;
		Long dias = (hasta.getTime() - desde.getTime()) / 86400000L;
		Float totalIntereses = dias * coeficiente;
		
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		tramo.setCoefic(coeficiente);
		tramo.setDeuda(deuda);
		tramo.setDias(dias);
		tramo.setEntregado(importe);
		tramo.setFechaMovimiento(desde);
		tramo.setfLiquidacion(hasta);
		tramo.setInteres(interes);
		tramo.setIntereses(totalIntereses);
		return tramo;
	}

	/**
	 * Busca el primer titular de un contrato.
	 * @param idContrato ID del contrato
	 * @return Si no encuentra al primer titular devuelve NULL
	 */
	@BusinessOperation("plugin.liquidaciones.liquidacionesManager.findpPrimerTitular")
	public Persona findPrimerTitularContrato(Long idContrato){
		EventFactory.onMethodStart(this.getClass());
		
		Contrato c = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET,idContrato);
		for (ContratoPersona cp : c.getContratoPersona()){
			if (cp.getTipoIntervencion().getTitular() && (cp.getOrden() == 1)){
				return cp.getPersona();
			}
		}
		return null;
	}
}
