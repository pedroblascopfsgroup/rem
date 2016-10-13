package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
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
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;

@Component
public class UpdaterServiceSancionOfertaResolucionComite implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private TrabajoApi trabajoApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    private static final String COMBO_RESPUESTA = "comboResolucion";
    private static final String FECHA_RESPUESTA = "fechaRespuesta";
    private static final String IMPORTE_CONTRAOFERTA = "numImporte";
   	private static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
			for(TareaExternaValor valor :  valores){
	
				if(FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					try {
						expediente.setFechaSancion(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						e.printStackTrace();
					}
	
				}
				if(COMBO_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
						if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor()))
							filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
						else{
							if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor()))
								filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
							else
								if(DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor()))
									if(trabajoApi.checkSareb(tramite.getTrabajo()))
										filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.CONTRAOFERTADO);
									else
										filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DOBLE_FIRMA);
						}
							
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expediente.setEstado(estado);
	
				}
				if(IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
				{
					ofertaAceptada.setImporteContraOferta(Double.valueOf(valor.getValor()));
				}
				
				genericDao.save(ExpedienteComercial.class, expediente);
				genericDao.save(Oferta.class, ofertaAceptada);
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_RESOLUCION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
