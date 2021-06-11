package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoListadoTareas;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;

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
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResultadoPBC.class);

    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String COMBO_RESPUESTA = "comboRespuesta";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    public static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
    public static final String CODIGO_T017_PBC_VENTA = "T017_PBCVenta";
    private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";
    private static final String CODIGO_SUBCARTERA_OMEGA = "65";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		Activo activo = ofertaAceptada.getActivoPrincipal();
		
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores){

					if(COMBO_RESULTADO.equals(valor.getNombre())
							|| COMBO_RESPUESTA.equals(valor.getNombre())
							&& !Checks.esNulo(valor.getValor())) {
						//TODO: Rellenar campo PBC del expediente cuando esté creado.
						if(DDSiNo.NO.equals(valor.getValor())) {
							expediente.setEstadoPbc(0);
							if(!ofertaApi.checkReserva(ofertaAceptada) || 
							(DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) 
							&& DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()))){
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
								DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
								expediente.setEstado(estado);
								recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

								expediente.setFechaVenta(null);
								expediente.setFechaAnulacion(new Date());
								//Finaliza el trámite
								
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);

								//Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								ofertaApi.finalizarOferta(ofertaAceptada);
								try {
									ofertaApi.descongelarOfertas(expediente);
									ofertaApi.finalizarOferta(ofertaAceptada);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}

								if (DDCartera.CODIGO_CARTERA_BANKIA
										.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())
										&& !uvemManagerApi.esTramiteOffline(UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T013_RESULTADO_PBC,expediente)) {
									// Notificar del rechazo de la oferta a
									// Bankia.
									try {
										uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(),
												UvemManagerApi.MOTIVO_ANULACION_OFERTA.PBC_DENEGADO);
									} catch (Exception e) {
										logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
										throw new UserException(e.getMessage());
									}
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
							genericDao.save(ExpedienteComercial.class, expediente);
						} else {
							
							if (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(activo.getCartera().getCodigo())
									&& DDSubcartera.CODIGO_YUBAI.equals(activo.getSubcartera().getCodigo())
									&& ofertaApi.checkReserva(ofertaAceptada)) {

								if(Integer.valueOf(2).equals(expediente.getEstadoPbc())) {
									expediente.setEstadoPbc(1);
								} else {
									expediente.setEstadoPbc(2);
								}
								
							} else {
								String codSubCartera = null;
								if (!Checks.esNulo(activo.getSubcartera())) {
									codSubCartera = activo.getSubcartera().getCodigo();
								}
								if (CODIGO_SUBCARTERA_OMEGA.equals(codSubCartera)) {
									Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
									DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
									expediente.setEstado(estado);
									recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

									Oferta oferta = expediente.getOferta();
									List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
									for (Oferta ofertaAux : listaOfertas) {
										if (!ofertaAux.getId().equals(oferta.getId()) && !DDEstadoOferta.CODIGO_RECHAZADA.equals(ofertaAux.getEstadoOferta().getCodigo())) {
											ofertaApi.congelarOferta(ofertaAux);
										}
									}
								}
								expediente.setEstadoPbc(1);
							}
							genericDao.save(ExpedienteComercial.class, expediente);
							
							//LLamada servicio web Bankia para modificaciones según tipo propuesta (MOD3) 
							if(!Checks.estaVacio(valores)){
								if(!Checks.esNulo(ofertaAceptada.getActivoPrincipal()) 
										&& !uvemManagerApi.esTramiteOffline(UpdaterServiceSancionOfertaResultadoPBC.CODIGO_T013_RESULTADO_PBC,expediente)
										&& !Checks.esNulo(ofertaAceptada.getActivoPrincipal().getCartera())
										&& ofertaAceptada.getActivoPrincipal().getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BANKIA) && 
										!DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())){
									uvemManagerApi.modificacionesSegunPropuesta(valores.get(0).getTareaExterna());
									
								}
							}
						}
					}
				}
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
