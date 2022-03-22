package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Component
public class UpdaterServiceSancionOfertaResultadoPBC implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
	private TareaActivoApi tareaActivoApi;
    
    @Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
    private ReservaApi reservaApi;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;
	
	@Autowired
    private UsuarioApi usuarioApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResultadoPBC.class);

    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String COMBO_RESPUESTA = "comboRespuesta";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    public static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
    public static final String CODIGO_T017_PBC_VENTA = "T017_PBCVenta";
    private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";
    private static final String CODIGO_SUBCARTERA_OMEGA = "65";
    public static final String CODIGO_T017 = "T017";
    
    private static final String COMBO_ARRAS = "comboArras";
    private static final String MESES_FIANZA = "mesesFianza";
    private static final String IMPORTE_FIANZA = "importeFianza";
    private static final String TIPO_OPERACION = "tipoOperacion";
    private static final String OBSERVACIONES = "observaciones";
    
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		ExpedienteComercial expediente = null;
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;
		DecimalFormat num = new DecimalFormat("###.##");
		boolean estadoBcModificado = false;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		boolean anulacion = false;
		String observaciones = null;
		
		if(!Checks.esNulo(ofertaAceptada)) {
			expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores){

					if(COMBO_RESULTADO.equals(valor.getNombre())
							|| COMBO_RESPUESTA.equals(valor.getNombre())
							&& !Checks.esNulo(valor.getValor())) {
						//TODO: Rellenar campo PBC del expediente cuando esté creado.
						if(DDSiNo.NO.equals(valor.getValor())) {
							expediente.setEstadoPbc(0);
							Filter filtroEstado = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
							DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtroEstado);
							expediente.setEstado(estado);
							anulacion = true;
							
							
							
							if(!ofertaApi.checkReserva(ofertaAceptada) || 
							(DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) 
							&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())) && !DDCartera.isCarteraBk(activo.getCartera())){
								recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

								expediente.setFechaVenta(null);
								expediente.setFechaAnulacion(new Date());
								//Finaliza el trámite
								
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);

								//Rechaza la oferta y descongela el resto
								try {
									ofertaApi.finalizarOferta(ofertaAceptada);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}

							}

							//Motivo anulación
							if(!ofertaApi.checkReserva(ofertaAceptada)) {
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_ANULACION_IRREGULARIDADES);
								DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
								expediente.setMotivoAnulacion(motivoAnulacion);

								// Tipo rechazo y motivo rechazo ofertas cajamar
								DDTipoRechazoOferta tipoRechazo = (DDTipoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRechazoOferta.class, DDTipoRechazoOferta.CODIGO_ANULADA);
								
								DDMotivoRechazoOferta motivoRechazo = (DDMotivoRechazoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoOferta.class, motivoAnulacion.getCodigo());

								motivoRechazo.setTipoRechazo(tipoRechazo);
								ofertaAceptada.setMotivoRechazo(motivoRechazo);
								genericDao.save(Oferta.class, ofertaAceptada);
							}
							
						} else {
							
							if (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
									&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo())
									&& ofertaApi.checkReserva(ofertaAceptada)) {

								if(Integer.valueOf(2).equals(expediente.getEstadoPbc())) {
									expediente.setEstadoPbc(1);
								} else {
									expediente.setEstadoPbc(2);
								}
								
							} else if(DDCartera.isCarteraBk(activo.getCartera())){
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA);
								DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
								expediente.setEstado(estado);
								expediente.setEstadoPbc(1);
								recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
							}else {
								String codSubCartera = null;
								if (!Checks.esNulo(activo.getSubcartera())) {
									codSubCartera = activo.getSubcartera().getCodigo();
								}
								if (CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
									Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
									DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
									expediente.setEstado(estado);

									Oferta oferta = expediente.getOferta();
									List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
									for (Oferta ofertaAux : listaOfertas) {
										if (!ofertaAux.getId().equals(oferta.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
											ofertaApi.congelarOferta(ofertaAux);
										}
									}
									recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);
								}
								expediente.setEstadoPbc(1);
								
							}
							

							genericDao.save(ExpedienteComercial.class, expediente);
							
							//LLamada servicio web Bankia para modificaciones según tipo propuesta (MOD3) 
							if(!Checks.estaVacio(valores) && activo != null){
								String codigoTarea = null;
								if(activoTramiteApi.isTramiteVenta(tramite.getTipoTramite())) {
									codigoTarea = UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T013_RESULTADO_PBC;
								}else if(activoTramiteApi.isTramiteVentaApple(tramite.getTipoTramite())) {
									codigoTarea = UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T017_PBC_VENTA;
								}
								
								if( codigoTarea != null && !uvemManagerApi.esTramiteOffline(codigoTarea,expediente) && DDCartera.isCarteraBk(activo.getCartera()) 
									&& !DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
									&& !CODIGO_T017.equals(tramite.getTipoTramite().getCodigo())){
									uvemManagerApi.modificacionesSegunPropuesta(valores.get(0).getTareaExterna());
									
								}
							}
						}
					}
					
					if (COMBO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if(DDSiNo.SI.equals(valor.getValor())) {
							vuelveArras = true;
						}
					}
					if (MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						mesesFianza = Integer.valueOf(valor.getValor());
					}
					if (IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (valor.getValor().contains(",")) {
							String valorCambiado = valor.getValor().replaceAll(",", ".");
							importe = Double.valueOf(valorCambiado).doubleValue();
						}else {
							importe = Double.valueOf(valor.getValor());
						}
						
					}
					if (OBSERVACIONES.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						observaciones = valor.getValor();
					}
				}
				
				if (vuelveArras) {	
					campos.put(TIPO_OPERACION, true);				
					expedienteComercialApi.createReservaAndCondicionesReagendarArras(expediente, importe, mesesFianza, ofertaAceptada);
					
				}else if(anulacion) {
					if(activo != null && DDCartera.isCarteraBk(activo.getCartera())) {
						String estadoBcString = null;
						if(reservaApi.tieneReservaFirmada(expediente)) {
							estadoBcString = DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC;
							if(Checks.isFechaNula(expediente.getFechaAnulacion())) {
					        	expediente.setFechaAnulacion(new Date());
					        }
						}else {
							estadoBcString = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
							ofertaApi.finalizarOferta(ofertaAceptada);
						}
						
						Filter filtroEstadoBc = genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBcString);
						DDEstadoExpedienteBc estadoBc = genericDao.get(DDEstadoExpedienteBc.class, filtroEstadoBc);
						expediente.setEstadoBc(estadoBc);
						estadoBcModificado = true;
						expediente.setMotivoAnulacion(genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivoAnulacionExpediente.COD_CAIXA_RECHAZADO_PBC)));
						expediente.setDetalleAnulacionCntAlquiler(observaciones);
						Usuario usuario = usuarioApi.getUsuarioLogado();
						if(usuario != null) {
							expediente.setPeticionarioAnulacion(usuario.getUsername());
						}
					}
					genericDao.save(ExpedienteComercial.class, expediente);
				}
				
				if(estadoBcModificado) {
					ofertaApi.replicateOfertaFlushDto(expediente.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));

				}

				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESULTADO_PBC, CODIGO_T017_PBC_VENTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
