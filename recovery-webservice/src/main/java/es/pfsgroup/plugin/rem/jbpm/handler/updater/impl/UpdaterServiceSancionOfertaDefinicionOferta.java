package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceSancionOfertaDefinicionOferta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
   	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		/* Si tiene atribuciones guardamos la fecha de aceptación de la tarea como fecha de sanción,
			en caso contrario, la fecha de sanción será la de resolución del comité externo.
		*/
		if(trabajoApi.checkAtribuciones(tramite.getTrabajo())){
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				expediente.setFechaSancion(new Date());
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_DEFINICION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
