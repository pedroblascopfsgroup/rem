package es.pfsgroup.plugin.recovery.liquidaciones;

import java.math.BigDecimal;
import java.sql.Timestamp;
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
import es.capgemini.pfs.multigestor.EXTGestorAdicionalAsuntoManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
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
	
	@Autowired
	private EXTGestorAdicionalAsuntoManager gestorAdicionalAsuntoManager; 
	
	@Autowired
	private UsuarioManager usuarioManager;

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
		
		String logo = usuarioManager.getUsuarioLogado().getEntidad().configValue("logo");
		response.getCabecera().setLogo("/img/"+logo);
		
		response.getCabecera().setAcuerdo(cont.getCodigoContrato());
		response.getCabecera().setDni(request.getDni());
		//response.getCabecera().setFechaLiquidacion(fechaCierre);
		response.getCabecera().setNombre(request.getNombre());
		
		response.getCabecera().setNumCuenta(cont.getNroContratoFormat());
		if (!Checks.esNulo(cont.getLimiteInicial())) {
			response.getCabecera().setCapital(new BigDecimal(cont.getLimiteInicial().toString()));
		}
		response.getCabecera().setFechaVencimiento(cont.getFechaVencimiento());
		response.getCabecera().setInteres(cont.getTipoInteres());
		response.getCabecera().setTipoIntDemora(request.getIntereses());

		response.getCabecera().setFechaLiquidacion(fechaCierre);
		response.getCabecera().setPrincipalCertif(new BigDecimal(request.getPrincipal().toString()));

		if (!Checks.esNulo(proc.getTipoProcedimiento())) {
			response.getCabecera().setTipoProc(proc.getTipoProcedimiento().getDescripcion());
		}
		response.getCabecera().setAutos(proc.getCodigoProcedimientoEnJuzgado());
		if (!Checks.esNulo(proc.getJuzgado())) {
			response.getCabecera().setJuzgado(proc.getJuzgado().getDescripcion());
		}
		if (!Checks.esNulo(proc.getAsunto())) {
			Usuario letrado = gestorAdicionalAsuntoManager.obtenerLetradoDelAsunto(proc.getAsunto().getId());
			if (!Checks.esNulo(letrado)) {
				response.getCabecera().setAbogado(letrado.getApellidoNombre());
			}
		}
		if (!Checks.esNulo(proc.getAsunto())) {
			if (!Checks.esNulo(proc.getAsunto().getProcurador())) {
				if (!Checks.esNulo(proc.getAsunto().getProcurador().getUsuario())) {
					response.getCabecera().setProcurador(proc.getAsunto().getProcurador().getUsuario().getApellidoNombre());
				}
			}
		}

		Float deuda = request.getPrincipal();
		Float interes = request.getIntereses();
		Timestamp fmov = new Timestamp(fechaCierre.getTime());
		Float totalIntereses = 0.0F;
		Float entregado = 0.0F;

		List<LIQCobroPago> entregas = cobroPagoDao.findEntregasACuenta(request.getContrato(), fechaCierre,fechaLiquidacion);
		
		for (LIQCobroPago cp : entregas) {
			Float importe = cp.getImporte();
			LIQDtoTramoLiquidacion tramo = createTramoLiquidacion(deuda, interes, fmov, cp.getFecha(), importe,"COBRO");

			deuda -= importe;
			if (deuda < 0.0F) deuda = 0.0F;
			fmov = new Timestamp(cp.getFecha().getTime());
			totalIntereses += tramo.getIntereses().floatValue();
			entregado += tramo.getEntregado().floatValue();
			response.addTramoLiquidacion(tramo);
		}
		//Agregamos un �ltimo tramo desde la �ltima entrega a cuenta hasta la fecha actual
		LIQDtoTramoLiquidacion tramo = createTramoLiquidacion(deuda, interes, fmov, fechaLiquidacion, 0.0F,"TOTAL PENDIENTE");
		response.addTramoLiquidacion(tramo);
		
		totalIntereses += tramo.getIntereses().floatValue();
		Float totalDeuda = request.getPrincipal() + totalIntereses - entregado;
		if (totalDeuda < 0.00F) totalDeuda = 0.00F;
		response.getCabecera().setTotalDeuda(new BigDecimal(totalDeuda.toString()));
		
		return response;
	}
	
	private LIQDtoTramoLiquidacion createTramoLiquidacion(Float deuda,
			Float interes, Date desde, Date hasta, Float importe, String descripcion) {
		
		Float coeficiente = (deuda * interes) / 36000;
		Long dias = (hasta.getTime() - desde.getTime()) / 86400000L;
		Float totalIntereses = dias * coeficiente;
		
		LIQDtoTramoLiquidacion tramo = new LIQDtoTramoLiquidacion();
		tramo.setDescrMov(descripcion);
		tramo.setCoefic(coeficiente);
		tramo.setDeuda(new BigDecimal(deuda.toString()));
		tramo.setDias(dias);
		tramo.setEntregado(new BigDecimal(importe.toString()));
		tramo.setFechaMovimiento(DateFormat.toString(desde));
		tramo.setfLiquidacion(hasta);
		tramo.setInteres(new BigDecimal(interes.toString()));
		tramo.setIntereses(new BigDecimal(totalIntereses.toString()));
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
