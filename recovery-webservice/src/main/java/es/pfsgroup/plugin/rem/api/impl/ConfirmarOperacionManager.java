package es.pfsgroup.plugin.rem.api.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ConfirmarOperacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.ReintegroApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;

@Service("confirmarOperacionManager")
public class ConfirmarOperacionManager extends BusinessOperationOverrider<ConfirmarOperacionApi>
		implements ConfirmarOperacionApi {

	protected static final Log logger = LogFactory.getLog(ConfirmarOperacionManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private ReservaApi reservaApi;

	@Autowired
	private ReintegroApi reintegroApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Override
	public String managerName() {
		return "ConfirmarOperacionManager";
	}

	@Override
	public HashMap<String, String> validateConfirmarOperacionPostRequestData(ConfirmacionOpDto confirmacionOpDto,
			Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;
		HashMap<String, String> errorList = null;

		hashErrores = restApi.validateRequestObject(confirmacionOpDto, TIPO_VALIDACION.INSERT);

		if (!Checks.esNulo(confirmacionOpDto.getAccion())
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA)
				&& !confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)) {
			hashErrores.put("accion", RestApi.REST_MSG_UNKNOWN_KEY);

		} else if (!Checks.esNulo(confirmacionOpDto.getResultado())
				&& !confirmacionOpDto.getResultado().equals(Integer.valueOf(0))
				&& !confirmacionOpDto.getResultado().equals(Integer.valueOf(1))) {
			hashErrores.put("resultado", RestApi.REST_MSG_UNKNOWN_KEY);

		} else {

			if (confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA)
					|| confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA)
					|| confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA)
					|| confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA)
					|| confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA)
					|| confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA)) {
				ReservaDto reservaDto = new ReservaDto();
				reservaDto.setAccion(confirmacionOpDto.getAccion());
				reservaDto.setActivo(confirmacionOpDto.getActivo());
				reservaDto.setOfertaHRE(confirmacionOpDto.getOfertaHRE());
				errorList = reservaApi.validateReservaPostRequestData(reservaDto, jsonFields);
				hashErrores.putAll(errorList);

			} else if (confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)) {
				ReintegroDto reintegroDto = new ReintegroDto();
				reintegroDto.setOfertaHRE(confirmacionOpDto.getOfertaHRE());
				errorList = reintegroApi.validateReintegroPostRequestData(reintegroDto, jsonFields);
				hashErrores.putAll(errorList);

			}
		}

		return hashErrores;
	}

	/**
	 * Registra el cobro de la reserva. Insertar en entregas a cuentas en
	 * positivo, actualizar fecha firma reserva y fecha envío reserva, estado
	 * del expediente como RESERVADO y el estado de la reserva a FIRMADA
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar el cobro de la reserva
	 * @return void
	 */
	@Override
	public void cobrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Date fechaActual = new Date();

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}

		// Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}

		// Insertar en entregas a cuentas en positivo
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar el cobro de la reserva.");
		}

		// Actualizar fecha firma reserva y fecha envío reserva,
		reserva.setFechaFirma(fechaActual);
		reserva.setFechaEnvio(fechaActual);

		// Actualizar estado reserva a FIRMADA
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_FIRMADA);
		if (estReserva == null) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		reserva.setEstadoReserva(estReserva);
		expedienteComercial.setReserva(reserva);

		// Actualizar estado expediente comercial a RESERVADO
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi
				.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.RESERVADO);
		if (Checks.esNulo(estadoExpCom)) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		expedienteComercial.setEstado(estadoExpCom);
		//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Registra el cobro de la venta. Insertar en entregas a cuentas en
	 * positivo, actualizar fecha contabilizacionPropietario, fecha venta,
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar el cobro de la venta
	 * @return void
	 */
	@Override
	public void cobrarVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Double importeTotal = null;
		Date fechaActual = new Date();
		
		//boolean tieneFechaIngresoChequeVenta = false;
		

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		
		Reserva reserva = expedienteComercial.getReserva();
		
		if(reserva != null){
			// Importe Reserva:
			CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
			if (!Checks.esNulo(condExp)) {
				importeReserva = condExp.getImporteReserva();
			}
	
			if (Checks.esNulo(reserva) || importeReserva == null) {
				importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta()
						: oferta.getImporteContraOferta();
			} else {
				importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta() - importeReserva
						: oferta.getImporteContraOferta() - importeReserva;
			}
	
			// Insertar en entregas a cuentas en positivo,
			EntregaReserva entregaReserva = new EntregaReserva();
			entregaReserva.setImporte(importeTotal);
			Date fechaEntrega = new Date();
			entregaReserva.setFechaEntrega(fechaEntrega);
			entregaReserva.setReserva(reserva);
			if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
				throw new Exception("No se ha podido guardar el cobro de la venta.");
			}
		}

		expedienteComercial.setFechaContabilizacionPropietario(fechaActual);
		boolean pasaAVendido = false;
		if (!Checks.esNulo(expedienteComercial.getFechaVenta())){
			DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.VENDIDO);
			expedienteComercial.setEstado(estadoExpCom);
			//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

			pasaAVendido = true;
		}
		if (!expedienteComercialApi.update(expedienteComercial,pasaAVendido)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Registra la devolución de la reserva. Insertar en entregas a cuentas en
	 * negativo, Actualiza estado reserva a CODIGO_RESUELTA_DEVUELTA, el estado
	 * de la oferta CODIGO_RECHAZADA, el estado del expediente ANULADO, Poner
	 * fecha de devolución e importe devolución Actualiza fecha de devolución e
	 * importe devuelto
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar la devolución de la
	 *            reserva
	 * @return void
	 */
	@Override
	public void devolverReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Date fechaActual = new Date();

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}
		
		Oferta oferta = activoApi.tieneOfertaTramitadaOCongeladaConReserva(activo);	
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas o congeladas con reserva firmada.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}

		// Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}

		// Insertar en entregas a cuentas en negativo
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(-importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar la devolución de la reserva.");
		}

		// Actualiza estado reserva a CODIGO_RESUELTA_DEVUELTA,
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_RESUELTA_DEVUELTA);
		if (Checks.esNulo(estReserva)) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		expedienteComercial.getReserva().setEstadoReserva(estReserva);

		// Actualiza estado de la oferta CODIGO_RECHAZADA
		DDEstadoOferta estOferta = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_RECHAZADA);
		if (Checks.esNulo(estOferta)) {
			throw new Exception("Error al actualizar el estado de la oferta.");
		}
		expedienteComercial.getOferta().setEstadoOferta(estOferta);

		// Actualiza estado del expediente comercial ANULADO
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi
				.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.ANULADO);
		if (Checks.esNulo(estadoExpCom)) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		
		expedienteComercial.setFechaVenta(null);
		expedienteComercial.setEstado(estadoExpCom);
		//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

		// Descongela el resto de ofertas del activo
		ofertaApi.descongelarOfertas(expedienteComercial);


		// Actualiza fecha de devolución e importe devuelto
		expedienteComercial.setFechaDevolucionEntregas(fechaActual);
		expedienteComercial.setImporteDevolucionEntregas(importeReserva);
		
		// HREOS-3891
		ActivoTramite tramite = null;
		List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
		if (Checks.estaVacio(listaTramites)) {
			throw new Exception("No se ha podido recuperar el trámite de la oferta.");
		} else {
			tramite = listaTramites.get(0);
			if (Checks.esNulo(tramite)) {
				throw new Exception("No se ha podido recuperar el trámite de la oferta.");
			}
		}
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaActivasByIdTramite(tramite.getId());
		for (TareaExterna tarea : listaTareas) {
			if (!Checks.esNulo(tarea)) {
				tareaActivoApi.guardarDatosResolucion(tarea.getId(), new java.sql.Date(System.currentTimeMillis()), DDEstadoResolucion.CODIGO_ERE_APROBADA);
				tareaActivoApi.saltoFin(tarea.getId());
				break;
			}
		}
		
		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Registra el reintegro de la reserva. Insertar en entregas a cuentas en
	 * negativo, Actualiza estado reserva a CODIGO_RESUELTA_REINTEGRADA,
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar el reintegro de la
	 *            reserva
	 * @return void
	 */
	@Override
	public void reintegrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Date fechaActual = new Date();

		// Estas validaciones ya se realizan en el metodo validador del ws
		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(confirmacionOpDto.getOfertaHRE());
		if (Checks.esNulo(oferta)) {
			throw new Exception("No existe la oferta.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}

		// Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}

		// Insertar en entregas a cuentas en negativo,
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(-importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar el reintegro de la reserva.");
		}

		// Actualiza estado reserva a CODIGO_RESUELTA_REINTEGRADA
		DDEstadosReserva estReserva = reservaApi
				.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_RESUELTA_REINTEGRADA);
		if (Checks.esNulo(estReserva)) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		expedienteComercial.getReserva().setEstadoReserva(estReserva);

		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Anula el cobro de la reserva si es en el mismo día que el cobro. Borra de
	 * entregas a cuentas la reserva, Borrar fecha firma reserva y fecha envío
	 * reserva. Poner a null Actualiza el estado del expediente como "Aprobado"
	 * y el estado de la reserva a "Pendiente firma"
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar el cobro de la reserva
	 * @return void
	 */
	@Override
	public void anularCobroReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		List<EntregaReserva> listaEntregas = null;

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}

		// Borrar de entregas a cuentas la reserva. Borramos todas las entregas
		// cuyo importe sea igual al importe de la reserva
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
			listaEntregas = reserva.getEntregas();
			if (!Checks.esNulo(listaEntregas) && listaEntregas.size() > 0) {
				for (int i = 0; i < listaEntregas.size(); i++) {
					EntregaReserva entrega = listaEntregas.get(i);
					if (!Checks.esNulo(entrega) && entrega.getImporte().equals(importeReserva)) {
						expedienteComercialApi.deleteEntregaReserva(entrega.getId());
					}
				}
			}
		}

		// Borrar la fecha firma reserva y fecha envío reserva. Poner a NULL
		reserva.setFechaFirma(null);
		reserva.setFechaEnvio(null);

		// Actualiza el estado de la reserva a "Pendiente firma"
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_PENDIENTE_FIRMA);
		if (estReserva == null) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		reserva.setEstadoReserva(estReserva);
		expedienteComercial.setReserva(reserva);

		// Actualizar estado del expediente como "Aprobado"
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi
				.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.APROBADO);
		if (Checks.esNulo(estadoExpCom)) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		expedienteComercial.setEstado(estadoExpCom);
		//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

		if(DDEstadosExpedienteComercial.APROBADO.equals(estadoExpCom.getCodigo())) {
			if(expedienteComercial.getCondicionante().getSolicitaReserva()!=null && 1 == expedienteComercial.getCondicionante().getSolicitaReserva()) {															
				EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
						.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");

				if(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expedienteComercial, "GBOAR") == null) {
					GestorEntidadDto ge = new GestorEntidadDto();
					ge.setIdEntidad(expedienteComercial.getId());
					ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
					ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());								
					ge.setIdTipoGestor(tipoGestorComercial.getId());
					gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
				}
			}
		}

		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Anula el cobro de la venta si es en el mismo día que el cobro. Borra de
	 * entregas a cuentas la venta, Borrar fecha contabilizacionPropietario y
	 * fecha venta. Poner a null
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar el cobro de la venta
	 * @return void
	 */
	@Override
	public void anularCobroVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Double importeTotal = null;
		List<EntregaReserva> listaEntregas = null;

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();

		// Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}
		
		if (Checks.esNulo(reserva) || importeReserva == null) {
			importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta()
					: oferta.getImporteContraOferta();
		} else {
			importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta() - importeReserva
					: oferta.getImporteContraOferta() - importeReserva;
		}
		
		// Borra de entregas a cuentas la venta.
		if (!Checks.esNulo(importeTotal)) {
			listaEntregas = reserva.getEntregas();
			if (!Checks.esNulo(listaEntregas) && listaEntregas.size() > 0) {
				for (int i = 0; i < listaEntregas.size(); i++) {
					EntregaReserva entrega = listaEntregas.get(i);
					if (!Checks.esNulo(entrega) && entrega.getImporte().equals(importeTotal)) {
						expedienteComercialApi.deleteEntregaReserva(entrega.getId());
					}
				}
			}
		}

		// Borrar fecha contabilizacionPropietario y fecha venta. Poner a null
		expedienteComercial.setFechaContabilizacionPropietario(null);
		//expedienteComercial.setFechaVenta(null);
		if (Checks.esNulo(expedienteComercial.getFechaVenta())){
			DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.FIRMADO);
			expedienteComercial.setEstado(estadoExpCom);
			//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

		}
		
		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

	/**
	 * Anula la devolución del cobro de la reserva si es en el mismo día que la
	 * devolución. Borra de entregas a cuentas la devolución. Actualiza estado
	 * reserva a "Pendiente de devolución", el estado de la oferta "Aceptada",
	 * el estado del expediente "En devolución", Borrar fecha de devolución e
	 * importe devolución. Poner a null.
	 * 
	 * @param ConfirmacionOpDto
	 *            con los datos necesarios para registrar la devolución de la
	 *            reserva
	 * @return void
	 */
	@Override
	public void anularDevolucionReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception {
		Double importeReserva = null;
		Double importeDevuelto = null;
		Oferta oferta = null;
		List<EntregaReserva> listaEntregas = null;

		// Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (activo == null) {
			throw new Exception("No existe el activo");
		}

		if (!Checks.esNulo(confirmacionOpDto.getOfertaHRE())){
			oferta = ofertaApi.getOfertaByNumOfertaRem(confirmacionOpDto.getOfertaHRE());
		} else {
			// HREOS-1704: Para la ANULACION_DEVOLUCION_RESERVA hay que buscar la
			// última oferta rechazada.
			DtoOfertasFilter dtoOfertasFilter = new DtoOfertasFilter();
			dtoOfertasFilter.setIdActivo(activo.getId());
			dtoOfertasFilter.setEstadoOferta(DDEstadoOferta.CODIGO_RECHAZADA);
			
			List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfer = (List<VGridOfertasActivosAgrupacionIncAnuladas>) ofertaApi
					.getListOfertasFromView(dtoOfertasFilter);
			if (!Checks.esNulo(listaOfer) && listaOfer.size() > 0) {
				Long idOferta = listaOfer.get(0).getIdOferta();
				if (!Checks.esNulo(idOferta)) {
					oferta = ofertaApi.getOfertaById(idOferta);
				}
			}
		}
		if (oferta == null) {
			throw new Exception("El activo no tiene ofertas rechazadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (expedienteComercial == null) {
			throw new Exception("No existe expediente comercial para esta activo.");
		}
		Reserva reserva = expedienteComercial.getReserva();
		if (reserva == null) {
			throw new Exception("El activo no tiene reserva");
		}

		// Borra de entregas a cuentas la devolución.
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (condExp != null) {
			importeReserva = condExp.getImporteReserva();
		}

		if (importeReserva != null) {
			importeDevuelto = importeReserva * Double.valueOf(-1);
			listaEntregas = reserva.getEntregas();
			if (!Checks.esNulo(listaEntregas) && listaEntregas.size() > 0) {
				for (int i = 0; i < listaEntregas.size(); i++) {
					EntregaReserva entrega = listaEntregas.get(i);
					if (!Checks.esNulo(entrega) && entrega.getImporte().equals(importeDevuelto)) {
						expedienteComercialApi.deleteEntregaReserva(entrega.getId());
					}
				}
			}
		}

		// Actualiza estado reserva a CODIGO_PENDIENTE_DEVOLUCION,
		DDEstadosReserva estReserva = reservaApi
				.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_PENDIENTE_DEVOLUCION);
		if (estReserva == null) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		reserva.setEstadoReserva(estReserva);
		expedienteComercial.setReserva(reserva);

		// Actualiza estado de la oferta CODIGO_ACEPTADA
		DDEstadoOferta estOferta = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_ACEPTADA);
		if (estOferta == null) {
			throw new Exception("Error al actualizar el estado de la oferta.");
		}
		oferta.setEstadoOferta(estOferta);
		expedienteComercial.setOferta(oferta);

		// Actualiza estado del expediente comercial EN_DEVOLUCION
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi
				.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.EN_DEVOLUCION);
		if (estadoExpCom == null) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		expedienteComercial.setEstado(estadoExpCom);
		//recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpCom);

		// Congela el resto de ofertas del activo
		ofertaApi.congelarOfertasPendientes(expedienteComercial);

		// Borrar fecha de devolución e importe devolución. Poner a null.
		expedienteComercial.setFechaDevolucionEntregas(null);
		expedienteComercial.setImporteDevolucionEntregas(null);

		if (!expedienteComercialApi.update(expedienteComercial,false)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}

}
