package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaRespuestaOfertante implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

   	private static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RPTA_OFERTANTE);
			DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
			expediente.setEstado(estado);
			genericDao.save(ExpedienteComercial.class, expediente);
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESPUESTA_OFERTANTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
