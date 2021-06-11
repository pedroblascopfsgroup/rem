package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.Method;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.exception.PlusvaliaActivoException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestionPlusv;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTareaDestinoSalto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;

@Component
public class UpdaterTransitionService {
	
	protected static final Log logger = LogFactory.getLog(UpdaterTransitionService.class);
	
	@Resource
    MessageService messageServices;
	
	@Autowired
	private ActivoApi activoApi;
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	
	public void updateFrom(DtoSaltoTarea dto) throws Exception {
		
		
		/*if(DDTareaDestinoSalto.CODIGO_DEFINICION_OFERTA.equals(dto.getCodigoTareaDestino())) {
		updateT013_DefinicionOferta(dto);
		}*/

		String tarea = dto.getCodigoTareaDestino();
		String methodName = "update"+tarea;

		Method method;
		try {
			
			method = this.getClass().getDeclaredMethod(methodName, DtoSaltoTarea.class);
			method.invoke(this, dto);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
		} 
		
	}

	public boolean validarContratoYJustificanteReserva(DtoSaltoTarea dto) throws Exception{
		ActivoTramite activoTramite = activoTramiteApi.get(dto.getIdTramite());
		
		if(DDTareaDestinoSalto.CODIGO_RESULTADO_PBC.equals(dto.getCodigoTareaDestino()) ||
				DDTareaDestinoSalto.CODIGO_POSICIONAMIENTO_Y_FIRMAS.equals(dto.getCodigoTareaDestino())){
			if(dto.getSolicitaReserva() == 1 && !Checks.esNulo(activoTramite.getTrabajo())){
				boolean tieneContratoReserva = expedienteComercialApi.comprobarExisteAdjuntoExpedienteComercial(activoTramite.getTrabajo().getId(), DDSubtipoDocumentoExpediente.CODIGO_CONTRATO_RESERVA);
				boolean tieneJustificanteReserva = expedienteComercialApi.comprobarExisteAdjuntoExpedienteComercial(activoTramite.getTrabajo().getId(), DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
				
				if(!tieneContratoReserva || !tieneJustificanteReserva)
					throw new Exception(messageServices.getMessage("ecomercial.adjuntos.validacion.advertencia.saltoTareas.docsReservaNecesarios"));
			}
		}
		return true;
	}
	
	// Update de datos por tarea (llamadas a metodos desde updateForm)
	public void updateT013_DefinicionOferta(DtoSaltoTarea dto) {
		//En Trámite
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.EN_TRAMITACION);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
		
	}
	public void updateT013_FirmaPropietario(DtoSaltoTarea dto) {
		//Aprobado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	@Transactional(readOnly = false)
	public void updateT013_CierreEconomico(DtoSaltoTarea dto) {
		update(dto);
	}
	public void updateT013_ResolucionComite(DtoSaltoTarea dto) {
		//Pte sanción
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_RespuestaOfertante(DtoSaltoTarea dto) {
		//Contraofertado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_InstruccionesReserva(DtoSaltoTarea dto) {
		//Aprobado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_ObtencionContratoReserva(DtoSaltoTarea dto) {
		//Aprobado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_ResultadoPBC(DtoSaltoTarea dto) throws Exception{
		//Si (Solicita Reserva) está relleno con SÍ entonces Reservado sino Aprobado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		if (!Checks.esNulo(dto.getSolicitaReserva()) && dto.getSolicitaReserva() == 1)
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
		else
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
		
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_PosicionamientoYFirma(DtoSaltoTarea dto) throws Exception {
		//Si (Solicita Reserva) está relleno con SÍ entonces Reservado sino Aprobado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		if (!Checks.esNulo(dto.getSolicitaReserva()) && dto.getSolicitaReserva() == 1)
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
		else
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
		
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}
	public void updateT013_RatificacionComite(DtoSaltoTarea dto) {
		//Contraofertado
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
	}


	private void update(DDEstadosExpedienteComercial estado, DtoSaltoTarea dto) {
		
		ActivoTramite activoTramite = activoTramiteApi.get(dto.getIdTramite());
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(activoTramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Reserva reserva = expediente.getReserva();
		
		expediente.setEstado(estado);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);


		if(DDEstadosExpedienteComercial.APROBADO.equals(estado.getCodigo()) 
				&& !DDCartera.CODIGO_CARTERA_CERBERUS.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
			if(expediente.getCondicionante().getSolicitaReserva()!=null && 1 == expediente.getCondicionante().getSolicitaReserva()) {															
				EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
						.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
	
				if(gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
					GestorEntidadDto ge = new GestorEntidadDto();
					ge.setIdEntidad(expediente.getId());
					ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
					ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());								
					ge.setIdTipoGestor(tipoGestorComercial.getId());
					gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
				}
			}
		}
		
		updateExpediente(expediente, dto);
		
		updateOferta(ofertaAceptada, dto);
		
		if(Checks.esNulo(reserva))
			expedienteComercialApi.createReservaExpediente(expediente);
			
		updateReserva(reserva, dto);
		
		
	}
	
	private void update(DtoSaltoTarea dto) {
		
		ActivoTramite activoTramite = activoTramiteApi.get(dto.getIdTramite());
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(activoTramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Reserva reserva = expediente.getReserva();
		
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		//si esta informada la fecha de ingreso cheque el expediente pasa a vendido, si no a firmado
		if(expediente.getFechaContabilizacionPropietario() != null){
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.VENDIDO);
		}else{
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.FIRMADO);
		}
		
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		expediente.setEstado(estado);
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

		if (expediente.getEstado() != null
				&& DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
				&& activoTramite.getActivo() != null) {
			try {
				activoApi.changeAndSavePlusvaliaEstadoGestionActivoById(activoTramite.getActivo(),
						DDEstadoGestionPlusv.COD_EN_CURSO);
			} catch (PlusvaliaActivoException e) {
				logger.error(e);
			}
		}
		updateExpediente(expediente, dto);
		
		updateOferta(ofertaAceptada, dto);
		
		if(Checks.esNulo(reserva))
			expedienteComercialApi.createReservaExpediente(expediente);
			
		updateReserva(reserva, dto);
		
		
	}

	private void updateReserva(Reserva reserva, DtoSaltoTarea dto) {
		
		Boolean update = false;
		
		if(!Checks.esNulo(dto.getTipoArras())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoArras());
			DDTiposArras tipoArras = (DDTiposArras) genericDao.get(DDTiposArras.class, filtro);						
			reserva.setTipoArras(tipoArras);
			update=true;
		}
		
		if(!Checks.esNulo(dto.getFechaEnvioReserva())) {
			if(!Checks.esNulo(reserva)){
				reserva.setFechaEnvio(dto.getFechaEnvioReserva());	
				update=true;
			}
				
		}
		
		if(!Checks.esNulo(dto.getFechaFirmaReserva())) {
			reserva.setFechaFirma(dto.getFechaFirmaReserva());
			update=true;
		}
		
		if(update) {
			genericDao.save(Reserva.class, reserva);
		}
		
	}

	private void updateOferta(Oferta ofertaAceptada, DtoSaltoTarea dto) {
		
		Boolean update = true;
		
		if(!Checks.esNulo(dto.getImporteContraoferta())) {
			ofertaAceptada.setImporteContraOferta(dto.getImporteContraoferta());
			update=true;
		}
		
		if(!Checks.esNulo(dto.getImporteOfertante())) {
			ofertaAceptada.setImporteContraOferta(dto.getImporteOfertante());
			update=true;
		}
		
		if(update) {
			genericDao.save(Oferta.class, ofertaAceptada);
		}
		
		
	}

	private void updateExpediente(ExpedienteComercial expediente, DtoSaltoTarea dto) {
		
		if(!Checks.esNulo(dto.getConflictoIntereses())) {
			expediente.setConflictoIntereses(dto.getConflictoIntereses());
		}
		
		if(!Checks.esNulo(dto.getRiesgoReputacional())) {
			expediente.setRiesgoReputacional(dto.getRiesgoReputacional());
		}
		
		if(!Checks.esNulo(dto.getComiteSancionador())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getComiteSancionador());
			DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filtro);
			expediente.setComiteSancion(comiteSancion);
		}
		
		if(!Checks.esNulo(dto.getFechaEnvioSancion())) {
			expediente.setFechaSancion(dto.getFechaEnvioSancion());
		}
		
		if(!Checks.esNulo(dto.getPbcAprobado())) {
			expediente.setEstadoPbc(dto.getPbcAprobado());
		}
		
		if(!Checks.esNulo(dto.getMotivoAnulacion())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoAnulacion());
			DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
			expediente.setMotivoAnulacion(motivoAnulacion);
		}
		
		if(!Checks.esNulo(dto.getFechaRespuestaComite())) {
			expediente.setFechaSancion(dto.getFechaRespuestaComite());
		}
		
		if(!Checks.esNulo(dto.getSolicitaReserva())) {
			//COE_CONDICIONANTES_EXPEDIENTE.COE_SOLICITA_RESERVA, cuando se pone un SÍ tenemos que crear un registro en la tabla de RES_RESERVAS para evitar que falle la ventana.
			if(Checks.esNulo(expediente.getReserva()))
				expedienteComercialApi.createReservaExpediente(expediente);
			
		}
		
		genericDao.save(ExpedienteComercial.class, expediente);

	}

}
