package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceSancionOfertaSoloRechazo;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

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
	
	private static final String CODIGO_T017_PBC_RESERVA = "T017_PBCReserva";
	private static final String CODIGO_T013_PBC_RESERVA = "T013_PBCReserva";
	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaPBCReserva.class);

	private static final String COMBO_RESPUESTA = "comboRespuesta";
	private static final String COMBO_QUITAR = "comboQuitar";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";
	private static final String CODIGO_SUBCARTERA_OMEGA = "65";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		boolean quitarArras = false;
		boolean cambiaEstadoBc = false;
		
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			String estadoExp = null;
			String estadoBc = null;

			if (!Checks.esNulo(expediente)) {

				for (TareaExternaValor valor : valores) {

					if (COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {

						if (DDSiNo.NO.equals(valor.getValor())) {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
									DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class,
									filtro);
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
							if(reservaApi.tieneReservaFirmada(expediente)) {
								estadoBc = DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC;
								if(Checks.isFechaNula(expediente.getFechaAnulacion())) {
						        	expediente.setFechaAnulacion(new Date());
						        }
							}else {
								estadoBc = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
								ofertaApi.finalizarOferta(ofertaAceptada);
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
				}
				
				if(quitarArras) {
					estadoExp = DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA;
					
					Reserva reserva = genericDao.get(Reserva.class, genericDao.createFilter(FilterType.EQUALS,  "expediente.id", expediente.getId()));
					
					if (reserva != null) {
						Auditoria.delete(reserva);
						genericDao.save(Reserva.class, reserva);
					}
					
					
				}else if(ofertaAceptada.getActivoPrincipal() != null && DDCartera.isCarteraBk(ofertaAceptada.getActivoPrincipal().getCartera())){
					estadoExp = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
					estadoBc = DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS;
				}else {
					estadoExp = DDEstadosExpedienteComercial.RESERVADO;
					
				}
				
				expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoExp)));
				if(estadoBc != null) {
					cambiaEstadoBc = true;
					expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoBc)));
				}
				
				if(cambiaEstadoBc) {
					ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));
				}
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
