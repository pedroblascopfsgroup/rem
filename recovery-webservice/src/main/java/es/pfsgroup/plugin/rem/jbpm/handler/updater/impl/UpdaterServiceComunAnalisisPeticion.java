package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceComunAnalisisPeticion implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
    private ActivoDao activoDao;
    
	private static final String CODIGO_T002_ANALISIS_PETICION = "T002_AnalisisPeticion";
	private static final String CODIGO_T003_ANALISIS_PETICION = "T003_AnalisisPeticion";
	//private static final String CODIGO_T004_ANALISIS_PETICION = "T004_AnalisisPeticion";
	private static final String CODIGO_T005_ANALISIS_PETICION = "T005_AnalisisPeticion";
	private static final String CODIGO_T006_ANALISIS_PETICION = "T006_AnalisisPeticion";
	private static final String CODIGO_T009_ANALISIS_PETICION = "T009_AnalisisPeticion";
	
	private static final String COMBO_TRAMITAR = "comboTramitar";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Trabajo trabajo = tramite.getTrabajo();
		Filter filter;
		
		for(TareaExternaValor valor :  valores){

			if(COMBO_TRAMITAR.equals(valor.getNombre())){
				
				if(valor.getValor().equals(DDSiNo.NO)){
					// En caso de que se deniegue a rechazado con fecha rechazo
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_RECHAZADO);
					trabajo.setFechaRechazo(new Date());
				} else {
					// Por defecto el trabajo pasará a en trámite con fecha aceptación 
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
					trabajo.setFechaAprobacion(new Date());
				}
				
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estado);
			}
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Motivo de denegación (o rechazo) del trabajo
				tramite.getTrabajo().setMotivoRechazo(valor.getValor());
			}
			
		}
		genericDao.save(Trabajo.class, trabajo);
		
		if(activoDao.isActivoMatriz(trabajo.getActivo().getId())){
			ActivoTrabajo actTrabajo = genericDao.get(ActivoTrabajo.class,genericDao.createFilter(FilterType.EQUALS,"trabajo.id", trabajo.getId()));
			activoApi.actualizarOfertasTrabajosVivos(actTrabajo.getActivo());
		}
		else {
			activoApi.actualizarOfertasTrabajosVivos(trabajo.getActivo());
		}

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos que ejecutan este guardado adicional
		return new String[]{CODIGO_T002_ANALISIS_PETICION, CODIGO_T003_ANALISIS_PETICION, 
							/*CODIGO_T004_ANALISIS_PETICION, */CODIGO_T005_ANALISIS_PETICION, 
							CODIGO_T006_ANALISIS_PETICION, CODIGO_T009_ANALISIS_PETICION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
