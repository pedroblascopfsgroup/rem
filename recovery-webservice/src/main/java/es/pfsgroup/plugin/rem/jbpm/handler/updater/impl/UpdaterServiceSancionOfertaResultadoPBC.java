package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
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

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaResultadoPBC.class);

    private static final String COMBO_RESULTADO = "comboResultado";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
    private static final String CODIGO_ANULACION_IRREGULARIDADES = "601";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)) {
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if (!Checks.esNulo(expediente)) {

				for(TareaExternaValor valor :  valores){

					if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						//TODO: Rellenar campo PBC del expediente cuando esté creado.
						if(DDSiNo.NO.equals(valor.getValor())) {
							if(!ofertaApi.checkReserva(ofertaAceptada)){
								Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
								DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
								expediente.setEstado(estado);
								expediente.setEstadoPbc(0);
								expediente.setFechaAnulacion(new Date());

								genericDao.save(ExpedienteComercial.class, expediente);

								//Finaliza el trámite
								Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
								tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
								genericDao.save(ActivoTramite.class, tramite);

								//Rechaza la oferta y descongela el resto
								ofertaApi.rechazarOferta(ofertaAceptada);
								try {
									ofertaApi.descongelarOfertas(expediente);
								} catch (Exception e) {
									logger.error("Error descongelando ofertas.", e);
								}

								if(DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
									// Notificar del rechazo de la oferta a Bankia.
									try {
										uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), UvemManagerApi.MOTIVO_ANULACION_OFERTA.PBC_DENEGADO);
									} catch (Exception e) {
										logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
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
						} else {
							expediente.setEstadoPbc(1);
							genericDao.save(ExpedienteComercial.class, expediente);
						}
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESULTADO_PBC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
