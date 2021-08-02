package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import net.sf.json.JSONException;

@Component
public class UpdaterServiceSancionOfertaDevolucionLlaves implements UpdaterService  {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private UvemManagerApi uvemManagerApi;
 
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDevolucionLlaves.class);

    private static final String CODIGO_T013_DEVOLUCIONLLAVES = "T013_DevolucionLlaves";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if(!Checks.esNulo(expediente)){
				if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva())){

					if(!Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva())){

						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO);
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expediente.getOferta(), estado);

						expediente.setFechaVenta(null);
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
								uvemManagerApi.anularOferta(ofertaAceptada.getNumOferta().toString(), UvemManagerApi.MOTIVO_ANULACION_OFERTA.COMPRADOR_NO_INTERESADO_OPERACION);
							} catch (Exception e) {
								logger.error("Error al invocar el servicio de anular oferta de Uvem.", e);
								throw new UserException(e.getMessage());
							}
						}
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_DEVOLUCIONLLAVES};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
