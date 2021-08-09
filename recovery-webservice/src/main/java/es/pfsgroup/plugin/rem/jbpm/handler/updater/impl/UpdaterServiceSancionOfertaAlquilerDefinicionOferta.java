package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
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
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	private static final String CODIGO_T014_DEFINICION_OFERTA = "T014_DefinicionOferta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = new ExpedienteComercial();
		
		if(ofertaApi.checkAtribuciones(tramite.getTrabajo())){
			Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
			if(!Checks.esNulo(ofertaAceptada)){
				expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				expedienteComercial.setFechaSancion(new Date());
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expedienteComercial.setEstado(estado);
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

			}
		}
		else {
			List<Oferta> ofertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
			if(!Checks.estaVacio(ofertas)) {
				
				for(Oferta oferta : ofertas) {
					expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if(!Checks.esNulo(expedienteComercial))
						break;
				}
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_SANCION);
				DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
				expedienteComercial.setEstado(estado);
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

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
