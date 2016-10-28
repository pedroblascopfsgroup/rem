package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaResolucionTanteo implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    private static final String COMBO_EJERCE = "comboEjerce";
    private static final String CODIGO_TRAMITE_FINALIZADO = "11";
    private static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
			
			for(TareaExternaValor valor :  valores){
				
				if(COMBO_EJERCE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					Filter filtro;
					
					if(DDSiNo.SI.equals(valor.getValor())){
						//Anula el expediente
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESUELTO);
						
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);

						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						List<Oferta> listaOfertas = ofertaApi.trabajoToOfertas(tramite.getTrabajo());
						for(Oferta oferta : listaOfertas){
							if((DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getEstadoOferta().getCodigo()))){
								ofertaApi.descongelarOferta(oferta);
							}
						}
					}else
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.RESERVADO);
					
					DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
					expediente.setEstado(estado);
					
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_TANTEO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
