package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.HistoricoTareaPbc;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaExclusionBulk;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTareaPbc;
import es.pfsgroup.plugin.rem.thread.TransaccionExclusionBulk;

@Component
public class UpdaterServiceSancionOfertaResolucionCES implements UpdaterService {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionCES.class);
	 
	private static final String COMBO_RESOLUCION = "comboResolucion";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String IMPORTE_CONTRAOFERTA = "numImporteContra";
	private static final String CODIGO_T017_RESOLUCION_CES = "T017_ResolucionCES";
	private static final Integer RESERVA_SI = 1;
	private static final String OBSERVACIONES = "observaciones";
	

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		GestorEntidadDto ge = new GestorEntidadDto();	
		OfertaExclusionBulk ofertaExclusionBulkNew = null;
		boolean rechazar = false;
		boolean aprueba = false;
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {
				

				Boolean reserva = expediente.getCondicionante().getSolicitaReserva() != null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva()) ? true : false;
						
				DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
				dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
				
				for (TareaExternaValor valor : valores) {
	
					if (FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						try {
							ofertaAceptada.setFechaResolucionCES(ft.parse(valor.getValor()));
							expediente.setFechaSancion(ft.parse(valor.getValor()));
						} catch (ParseException e) {
							e.printStackTrace();
						}
	
					}
					if (COMBO_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						Filter filtro = null;
						if(DDCartera.CODIGO_CARTERA_BBVA.equals(activo.getCartera().getCodigo()) || DDCartera.isCarteraBk(activo.getCartera())) {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
						}else {
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA);
						}
						if (DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
							aprueba = true;
							ofertaApi.congelarOfertasAndReplicate(activo, ofertaAceptada);
							
							if(reserva && ge!=null && gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, "GBOAR") == null) {
								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
								
								ge.setIdEntidad(expediente.getId());
								ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
								ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());	
								ge.setIdTipoGestor(tipoGestorComercial.getId());
								gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);
							}

							if(DDCartera.isCarteraBk(activo.getCartera())) {
								DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA));
								expediente.setEstadoBc(estadoBc);
							}
							dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
						} else {
							if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
								rechazar = true;
								
								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,DDTipoRechazoOferta.CODIGO_DENEGADA);
								
								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,DDMotivoRechazoOferta.CODIGO_DECISION_COMITE);
								
								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
								genericDao.save(Oferta.class, ofertaAceptada);
								
								dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
							} else if (DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_RESPUESTA_OFERTANTE_CES);
							}
						}
						
						if (!Checks.esNulo(filtro)) {
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
							expediente.setEstado(estado);
							recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
						}						
	
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
						String doubleValue = valor.getValor();
						doubleValue = doubleValue.replace(',', '.');
						Double nuevoImporte = Double.valueOf(doubleValue);
						ofertaAceptada.setImporteContraofertaCES(nuevoImporte);
						
						ofertaAceptada.setImporteContraOferta(nuevoImporte);
						
						if(activo != null && activo.getSubcartera() != null &&
								(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_JAGUAR.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo()))) {
							String codigoBulk = nuevoImporte > 750000d ? DDSinSiNo.CODIGO_SI : DDSinSiNo.CODIGO_NO;
							
							OfertaExclusionBulk ofertaExclusionBulk = genericDao.get(OfertaExclusionBulk.class, 
									genericDao.createFilter(FilterType.EQUALS, "oferta", ofertaAceptada),
									genericDao.createFilter(FilterType.NULL, "fechaFin"));
							
							Usuario usuarioModificador = genericAdapter.getUsuarioLogado();
							
							if(ofertaExclusionBulk != null && ofertaExclusionBulk.getExclusionBulk() != null
									&& !ofertaExclusionBulk.getExclusionBulk().getCodigo().equals(codigoBulk)) {
								
								Thread thread = new Thread(new TransaccionExclusionBulk(ofertaExclusionBulk.getId(),
										usuarioModificador.getUsername()));
								thread.start();
								try {
									thread.join();
								} catch (InterruptedException e) {
									logger.error("Error generando registro exclsion bulk", e);
								}
								
							}
							
							if(ofertaExclusionBulk == null || !ofertaExclusionBulk.getExclusionBulk().getCodigo().equals(codigoBulk)) {
								ofertaExclusionBulkNew = new OfertaExclusionBulk();
								DDSinSiNo sino = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoBulk));
								
								ofertaExclusionBulkNew.setOferta(ofertaAceptada);
								ofertaExclusionBulkNew.setExclusionBulk(sino);
								ofertaExclusionBulkNew.setFechaInicio(new Date());
								ofertaExclusionBulkNew.setUsuarioAccion(usuarioModificador);
							}
								
						}
	
						// Actualizar honorarios para el nuevo importe de contraoferta.
						expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
	
						// Actualizamos la participación de los activos en la oferta;
						expedienteComercialApi.updateParticipacionActivosOferta(ofertaAceptada);
						expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
						
					}
					
					if(OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
						dtoHistoricoBC.setObservacionesBC(valor.getValor());
					}
				}
				if(ofertaExclusionBulkNew != null) {
					genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulkNew);
				}
				genericDao.save(Oferta.class, ofertaAceptada);
				genericDao.save(ExpedienteComercial.class, expediente);
				
				if (DDCartera.isCarteraBk(activo.getCartera())){
					Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo",
							reserva ? DDTipoTareaPbc.CODIGO_PBCARRAS : DDTipoTareaPbc.CODIGO_PBC);
					DDTipoTareaPbc tpb = genericDao.get(DDTipoTareaPbc.class, filtroTipo);
					
					HistoricoTareaPbc htp = new HistoricoTareaPbc();
					htp.setOferta(ofertaAceptada);
					htp.setTipoTareaPbc(!Checks.esNulo(tpb) ? tpb : null);
					
					genericDao.save(HistoricoTareaPbc.class, htp);
				}

				
				HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, expediente);
				
				genericDao.save(HistoricoSancionesBc.class, historico);
				
				if(rechazar) {
	                ofertaApi.inicioRechazoDeOfertaSinLlamadaBC(ofertaAceptada, DDEstadosExpedienteComercial.DENEGADA_OFERTA_CES);
	            } else if (aprueba) {
					ofertaApi.actualizarOfertaBoarding(ofertaAceptada,tareaExternaActual);
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_RESOLUCION_CES };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
