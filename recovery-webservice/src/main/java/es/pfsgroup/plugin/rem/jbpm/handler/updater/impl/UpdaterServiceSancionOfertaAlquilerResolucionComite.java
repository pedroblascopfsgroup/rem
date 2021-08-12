package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
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
public class UpdaterServiceSancionOfertaAlquilerResolucionComite implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerResolucionComite.class);
    
	private static final String FECHA_RESPUESTA = "fechaRespuesta";
	private static final String COMBO_RES_APROBADA = "comboResAprobada";
	private static final String CODIGO_TRAMITE_FINALIZADO = "11";
	
	private static final String CODIGO_T014_RESOLUCION_COMITE = "T014_ResolucionComiteExterno";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

//		ActivoSituacionPosesoria situacionPosesoria = tramite.getActivo().getSituacionPosesoria();
//		Oferta ofertaAceptada = ofertaApi.getOfertaAceptadaByActivo(tramite.getActivo());
//		ExpedienteComercial expedienteComercial = null;
//		
//		if(!Checks.esNulo(ofertaAceptada))
//			expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta ofertaAceptada = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){

			//Fecha respuesta de resolucion
			if(FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha respuesta => expediente comercial. fecha sanción
				try {
					if(!Checks.esNulo(expedienteComercial))
						expedienteComercial.setFechaSancion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			// Combo acepta Oferta
			if(COMBO_RES_APROBADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				if(DDSiNo.SI.equals(valor.getValor())){
					// Actualizacion del estado de expediente comercial: APROBADO
					if(!Checks.esNulo(expedienteComercial)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO);
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expedienteComercial.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

					}
				} else {
					// Actualizacion del estado de expediente comercial: DENEGADO
					if(!Checks.esNulo(expedienteComercial)) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.DENEGADO);
	
						DDEstadosExpedienteComercial estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
						expedienteComercial.setEstado(estado);
						recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), estado);

					
						//Finaliza el trámite
						Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_TRAMITE_FINALIZADO);
						tramite.setEstadoTramite(genericDao.get(DDEstadoProcedimiento.class, filtroEstadoTramite));
						genericDao.save(ActivoTramite.class, tramite);
	
						//Rechaza la oferta y descongela el resto
						ofertaApi.rechazarOferta(ofertaAceptada);
						try {
							ofertaApi.descongelarOfertas(expedienteComercial);
						} catch (Exception e) {
							logger.error("Error descongelando ofertas.", e);
						}
					}
				}
			}
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T014_RESOLUCION_COMITE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
