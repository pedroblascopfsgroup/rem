package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
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
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaExclusionBulk;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.thread.TramitacionOfertasAsync;
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
	private OfertaDao ofertaDao;
	
	@Autowired
	private  GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private UsuarioApi usuarioApi;

	protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResolucionCES.class);
	 
	private static final String COMBO_RESOLUCION = "comboResolucion";
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String IMPORTE_CONTRAOFERTA = "numImporteContra";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	private static final String CODIGO_T017_RESOLUCION_CES = "T017_ResolucionCES";
	private static final Integer RESERVA_SI = 1;

	

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		GestorEntidadDto ge = new GestorEntidadDto();	
		OfertaExclusionBulk ofertaExclusionBulkNew = null;
		if (!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {
						
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
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO_CES_PTE_PRO_MANZANA);
						if (DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
	
							// Una vez aprobado el expediente, se congelan el resto de ofertas que no
							// estén rechazadas (aceptadas y pendientes)
							List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
							for (Oferta oferta : listaOfertas) {
								if (!oferta.getId().equals(ofertaAceptada.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getEstadoOferta().getCodigo())) {
									ofertaApi.congelarOferta(oferta);
								}
							}
							//REMVIP-8388
//							if(expediente.getCondicionante().getSolicitaReserva()!=null && RESERVA_SI.equals(expediente.getCondicionante().getSolicitaReserva()) && ge!=null) {															
//								EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
//										.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GBOAR");
//								
//								ge.setIdEntidad(expediente.getId());
//								ge.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
//								ge.setIdUsuario(genericDao.get(Usuario.class,genericDao.createFilter(FilterType.EQUALS, "username","gruboarding")).getId());	
//								ge.setIdTipoGestor(tipoGestorComercial.getId());
//								gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(ge);																	
//								
//							}
									
														
						} else {
							if (DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
								// Deniega el expediente
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADA_OFERTA_CES);
	
								// Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);
	
								// Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								
								// Tipo rechazo y motivo rechazo ofertas cajamar
								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDTipoRechazoOferta.class,
												DDTipoRechazoOferta.CODIGO_DENEGADA);
								
								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi
										.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class,
												DDMotivoRechazoOferta.CODIGO_DECISION_COMITE);
								
								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
								genericDao.save(Oferta.class, ofertaAceptada);
								
								
								try {
									ofertaApi.descongelarOfertas(expediente);
									ofertaApi.finalizarOferta(ofertaAceptada);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}
	
							} else if (DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) 
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PDTE_RESPUESTA_OFERTANTE_CES);
						}
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
	
					}
					if (IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						String doubleValue = valor.getValor();
						doubleValue = doubleValue.replace(',', '.');
						Double nuevoImporte = Double.valueOf(doubleValue);
						ofertaAceptada.setImporteContraofertaCES(nuevoImporte);
						
						ofertaAceptada.setImporteContraOferta(nuevoImporte);
						
						if(activo != null && activo.getSubcartera() != null &&
								(DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo())
								|| DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))) {
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
				}
				if(ofertaExclusionBulkNew != null) {
					genericDao.save(OfertaExclusionBulk.class, ofertaExclusionBulkNew);
				}
				genericDao.save(Oferta.class, ofertaAceptada);
				genericDao.save(ExpedienteComercial.class, expediente);
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
