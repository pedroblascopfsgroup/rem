package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquilerDefinicionOferta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
      
    
	private static final String FECHA_ENVIO = "fechaEnvio";
	
	private static final String CODIGO_T014_DEFINICION_OFERTA = "T014_DefinicionOferta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		if(ofertaApi.checkAtribuciones(tramite.getTrabajo())){
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				expedienteComercial.setFechaSancion(new Date());
			}
		}
		else {
			List<Oferta> ofertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
			if(!Checks.estaVacio(ofertas)) {
				ExpedienteComercial expedienteComercial = null;
				for(Oferta oferta : ofertas) {
					expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if(!Checks.esNulo(expedienteComercial))
						break;
				}
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expedienteComercial.setEstado(estado);
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T014_DEFINICION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
