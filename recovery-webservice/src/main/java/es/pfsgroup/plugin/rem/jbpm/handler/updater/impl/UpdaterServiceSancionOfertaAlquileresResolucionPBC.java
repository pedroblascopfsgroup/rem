package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoCampo;

@Component
public class UpdaterServiceSancionOfertaAlquileresResolucionPBC implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresResolucionPBC.class);
    
	private static final String RESULTADO_PBC = "resultadoPBC";

	private static final String CODIGO_T015_RESOLUCION_PBC = "T015_ResolucionPBC";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		DDEstadoOferta estadoOferta = null;
		boolean pdteDocu = false;
		
		for(TareaExternaValor valor :  valores){
			
			if(RESULTADO_PBC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {

				expedienteComercial.setEstadoPbc(Integer.parseInt(valor.getValor()));
				
				if(DDResultadoCampo.RESULTADO_APROBADO.equals(valor.getValor())){
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_POSICIONAMIENTO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);


				}else {
					estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.ANULADO));
					expedienteComercial.setEstado(estadoExpedienteComercial);
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estadoExpedienteComercial);

					estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_RECHAZADA);
					oferta.setEstadoOferta(estadoOferta);
					expedienteComercial.setOferta(oferta);
							
					//Descongelar Ofertas de activo
					DDEstadoOferta pendiente = genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PENDIENTE));
					DDEstadoOferta tramitada = genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_ACEPTADA));
					DDEstadoOferta pdteDocumentacion = genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION));
					List<ActivoOferta> activoOfertas = tramite.getActivo().getOfertas();
					if(!Checks.esNulo(activoOfertas) && !Checks.estaVacio(activoOfertas)) {
						ActivoOferta activoOferta;
						Oferta ofertaCongelada;
						for(int i = 0; i<activoOfertas.size(); i++) {
							activoOferta = activoOfertas.get(i);
							ofertaCongelada = ofertaApi.getOfertaById(activoOferta.getOferta());
							if(DDEstadoOferta.CODIGO_CONGELADA.equals(ofertaCongelada.getEstadoOferta().getCodigo())){
								ExpedienteComercial existeExpedienteComercial = genericDao.get(ExpedienteComercial.class,  genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaCongelada.getId()));
								if(!Checks.esNulo(existeExpedienteComercial)) {
									ofertaCongelada.setEstadoOferta(tramitada);	
								}else if(DDCartera.isCarteraBk(activoOferta.getPrimaryKey().getActivo().getCartera()) 
										&& (Checks.esNulo(oferta.getCheckDocumentacion()) || !oferta.getCheckDocumentacion())){
									ofertaCongelada.setEstadoOferta(pdteDocumentacion);
									pdteDocu = true;
								}else {
									ofertaCongelada.setEstadoOferta(pendiente);
								}
								genericDao.save(Oferta.class, ofertaCongelada);
								
								if (pdteDocu) ofertaApi.llamadaPbc(ofertaCongelada);
							}
						}
					}
				}
				
			}
		}

		
		
		
		
		expedienteComercialApi.update(expedienteComercial,false);
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_RESOLUCION_PBC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
