package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaSoloRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;

@Component
public class UpdaterServiceSancionOfertaPBCReserva implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
		
	@Autowired
	private NotificatorServiceSancionOfertaSoloRechazo notificatorRechazo;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Autowired
    private ReservaApi reservaApi;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;
	
	@Autowired
	private FuncionesTramitesApi funcionesTramitesApi;

	@Autowired
    private UsuarioApi usuarioApi;
	
	private static final String CODIGO_T017_PBC_RESERVA = "T017_PBCReserva";
	private static final String CODIGO_T013_PBC_RESERVA = "T013_PBCReserva";
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaPBCReserva.class);

	private static final String COMBO_RESPUESTA = "comboRespuesta";
	private static final String COMBO_QUITAR = "comboQuitar";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";
	private static final String CODIGO_SUBCARTERA_OMEGA = "65";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	private static final String TIPO_OPERACION = "tipoOperacion";
	private static final String OBSERVACIONES = "observaciones";

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		boolean quitarArras = false;
		boolean cambiaEstadoBc = false;
		boolean anula = false;
		String observaciones = null;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		
		
		
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			String estadoExp = null;
			String estadoBc = null;

			if (!Checks.esNulo(expediente)) {

				for (TareaExternaValor valor : valores) {

					if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {

						if (DDSiNo.NO.equals(valor.getValor())) {
							anula = true;
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class,filtro);
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

							expediente.setFechaVenta(null);
							expediente.setEstadoPbcR(0);
							expediente.setEstadoPbcArras(0);
							expediente.setFechaAnulacion(new Date());

							genericDao.save(ExpedienteComercial.class, expediente);

							// Finaliza el trámite
							Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo",CODIGO_TRAMITE_FINALIZADO);
							tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
							genericDao.save(ActivoTramite.class, tramite);
							

							// Rechaza la oferta y descongela el resto
							ofertaApi.rechazarOferta(ofertaAceptada);
							for (ActivoOferta actOfr : ofertaAceptada.getActivosOferta()) {
								ActivoOfertaPk actOfrePk = actOfr.getPrimaryKey();
								Activo act = actOfrePk.getActivo();

								GestorEntidadDto gestorEntidadDto = new GestorEntidadDto();
								gestorEntidadDto.setIdEntidad(act.getId());
								gestorEntidadDto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO);
								
							}
							try {
								ofertaApi.descongelarOfertas(expediente);
								ofertaApi.finalizarOferta(ofertaAceptada);
							} catch (Exception e) {
								logger.error("Error descongelando ofertas.", e);
							}
							notificatorRechazo.notificatorFinTareaConValores(tramite, valores);
									
							// Motivo anulación
						if (!ofertaApi.checkReserva(ofertaAceptada) && DDSiNo.NO.equals(valor.getValor())) {
							 filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",CODIGO_ANULACION_IRREGULARIDADES);
							DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
							expediente.setMotivoAnulacion(motivoAnulacion);

							DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,DDTipoRechazoOferta.CODIGO_ANULADA);

							DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,motivoAnulacion.getCodigo());

							motivoRechazo.setTipoRechazo(tipoRechazo);
							ofertaAceptada.setMotivoRechazo(motivoRechazo);
							genericDao.save(Oferta.class, ofertaAceptada);
						} 

						} else {
							String codSubCartera = null;
							if (!Checks.esNulo(activo.getSubcartera())) {
								codSubCartera = activo.getSubcartera().getCodigo();
							}
							if (CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
								Oferta oferta = expediente.getOferta();
								List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
								for (Oferta ofertaAux : listaOfertas) {
									if (!ofertaAux.getId().equals(oferta.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
										ofertaApi.congelarOferta(ofertaAux);
									}
								}
							}
							expediente.setEstadoPbcR(1);
							expediente.setEstadoPbcArras(1);
							genericDao.save(ExpedienteComercial.class, expediente);

						}
					
					}
					if (COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							quitarArras = true;
							
						}
					}
					if (OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						observaciones = valor.getValor();
					}
				}
				
				Activo activoPrincipal = ofertaAceptada.getActivoPrincipal();
				if(activoPrincipal != null) {
					if(quitarArras) {
						campos.put(TIPO_OPERACION, false);
						estadoExp = DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA;
						
						Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId()));
						
						if (reserva != null) {
							Auditoria.delete(reserva);
							genericDao.save(Reserva.class, reserva);
						}

						CondicionanteExpediente condicionanteExpediente = expediente.getCondicionante();
						condicionanteExpediente.setSolicitaReserva(0);
						condicionanteExpediente.setTipoCalculoReserva(null);
						condicionanteExpediente.setPorcentajeReserva(null);
						condicionanteExpediente.setPlazoFirmaReserva(null);
						condicionanteExpediente.setImporteReserva(null);
						genericDao.save(CondicionanteExpediente.class, condicionanteExpediente);

					}else if(anula && DDCartera.isCarteraBk(activoPrincipal.getCartera())) {
						String estadoBcString = expedienteComercialApi.devolverEstadoCancelacionBCEco(expediente.getOferta(),  expediente);
						if(reservaApi.tieneReservaFirmada(expediente)) {
							if(Checks.isFechaNula(expediente.getFechaAnulacion())) {
					        	expediente.setFechaAnulacion(new Date());
					        }
						}
							
						Filter filtroEstadoBc = genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBcString);
						
						expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, filtroEstadoBc));
						expediente.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
						expediente.setDetalleAnulacionCntAlquiler(observaciones);
						Usuario usuario = usuarioApi.getUsuarioLogado();
						if(usuario != null) {
							expediente.setPeticionarioAnulacion(usuario.getUsername());
						}
						genericDao.save(ExpedienteComercial.class, expediente);
					} else if(!anula && DDCartera.isCarteraBk(activoPrincipal.getCartera())){
						estadoExp = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS;
					}
					
					if (DDCartera.isCarteraBk(activo.getCartera())){
						funcionesTramitesApi.desactivarHistoricoPbc(ofertaAceptada.getId(), DDTipoTareaPbc.CODIGO_PBC);
						genericDao.save(HistoricoTareaPbc.class, funcionesTramitesApi.createHistoricoPbc(ofertaAceptada.getId(), DDTipoTareaPbc.CODIGO_PBC));
					}
					
				}
				if (estadoExp != null){
					expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoExp)));
				}

				if(estadoBc != null && expediente.getEstadoBc() != null &&!estadoBc.equals(expediente.getEstadoBc().getCodigo())) {
					cambiaEstadoBc = true;
					expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoBc)));
				}

				
				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
			}
		}
	}

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}
    @Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_PBC_RESERVA , CODIGO_T013_PBC_RESERVA};
	}



}
