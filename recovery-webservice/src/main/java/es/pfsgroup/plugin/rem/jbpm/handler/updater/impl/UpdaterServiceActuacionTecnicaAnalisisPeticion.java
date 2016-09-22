package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.IncrementoPresupuesto;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceActuacionTecnicaAnalisisPeticion implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;
    
	private static final String CODIGO_T004_ANALISIS_PETICION = "T004_AnalisisPeticion";
	
	private static final String COMBO_TRAMITAR = "comboTramitar";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";
	private static final String COMBO_ASEGURADORAS = "comboAseguradoras";
	private static final String COMBO_CUBIERTO = "comboCubierto";
	private static final String COMBO_TARIFA = "comboTarifa";
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor :  valores){

			if(COMBO_TRAMITAR.equals(valor.getNombre())){
				// Por defecto el trabajo pasará a en trámite y en caso de que se deniegue a rechazado.
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
				
				if(valor.getValor().equals(DDSiNo.NO)){
					filter = genericDao.createFilter(FilterType.EQUALS, "codigo" , DDEstadoTrabajo.ESTADO_RECHAZADO);
					trabajo.setFechaRechazo(new Date());
				}else{
					trabajo.setFechaAprobacion(new Date());
				}
				DDEstadoTrabajo estado = genericDao.get(DDEstadoTrabajo.class, filter);
				trabajo.setEstado(estado);
			}
			if(COMBO_TARIFA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				if(valor.getValor().equals(DDSiNo.SI)){
					trabajo.setEsTarificado(true);
				}else{
					trabajo.setEsTarificado(false);
				}
			}
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Sólo podrá introducirlo cuando el combo de tramitar es NO
				trabajo.setMotivoRechazo(valor.getValor());
			}
			if(COMBO_CUBIERTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				trabajo.setCubreSeguro(valor.getValor().equals(DDSiNo.SI) ? true : false);
			}
			if(COMBO_ASEGURADORAS.equals(valor.getNombre())){
				trabajo.setCiaAseguradora(valor.getValor());
			}				
		}
		genericDao.save(Trabajo.class, trabajo);

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_ANALISIS_PETICION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
