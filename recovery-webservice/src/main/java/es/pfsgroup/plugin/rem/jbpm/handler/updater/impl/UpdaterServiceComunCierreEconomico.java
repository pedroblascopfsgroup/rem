package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceComunCierreEconomico implements UpdaterService {

	@Autowired
    private GenericABMDao genericDao;
	
	@Autowired
	ActivoManager activoApi;
	
	@Autowired
	private ActivoDao activoDao;
    
	private static final String FECHA_CIERRE = "fechaCierre";
	private static final String CODIGO_T002_CIERRE_ECONOMICO = "T002_CierreEconomico";
	private static final String CODIGO_T003_CIERRE_ECONOMICO = "T003_CierreEconomico";
	//private static final String CODIGO_T004_CIERRE_ECONOMICO = "T004_CierreEconomico";
	private static final String CODIGO_T005_CIERRE_ECONOMICO = "T005_CierreEconomico";
	private static final String CODIGO_T006_CIERRE_ECONOMICO = "T006_CierreEconomico";
	private static final String CODIGO_T008_CIERRE_ECONOMICO = "T008_CierreEconomico";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor :  valores){

			//Fecha cierre
			if(FECHA_CIERRE.equals(valor.getNombre()))
			{
				//Guardado adicional Fecha cierre económico 
				//Trabajo -> gestión económica -> Fecha cierre económico
				try {
					trabajo.setFechaCierreEconomico(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
				
				
				if(Checks.esNulo(trabajo.getFechaPago())){
					
					//Por finalizar la tarea "Cierre Económico", SIN fecha pago en trabajo, estado trabajo a "PENDIENTE PAGO"
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_PENDIENTE_PAGO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					
				}else{
					
					//Por finalizar la tarea "Cierre Económico", CON fecha pago en trabajo, estado trabajo a "PAGADO"
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_PAGADO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					
				}
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
		return new String[]{CODIGO_T002_CIERRE_ECONOMICO, CODIGO_T003_CIERRE_ECONOMICO,  
							/*CODIGO_T004_CIERRE_ECONOMICO,*/ CODIGO_T005_CIERRE_ECONOMICO, 
							CODIGO_T006_CIERRE_ECONOMICO, CODIGO_T008_CIERRE_ECONOMICO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
