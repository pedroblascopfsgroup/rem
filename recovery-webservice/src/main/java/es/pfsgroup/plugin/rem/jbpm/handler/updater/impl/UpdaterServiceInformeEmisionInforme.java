package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServiceInformeEmisionInforme implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
	private static final String FECHA_EMISION = "fechaEmision";
	private static final String IMPOSIBILIDAD_EMITIR = "comboImposibilidad";
	private static final String CODIGO_T006_EMISION_INFORME = "T006_EmisionInforme";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		for(TareaExternaValor valor :  valores){

			//Fecha emisión
			if(FECHA_EMISION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				//Guardado adicional Fecha emisión informe => trabajo ->  Fecha finalización
				try {
					tramite.getTrabajo().setFechaFin(ft.parse(valor.getValor()));
					Auditoria.save(tramite.getTrabajo());
				} catch (ParseException e) {
					e.printStackTrace();
				}

			}
			
			
			//INFORME EMITIDO
			if(IMPOSIBILIDAD_EMITIR.equals(valor.getNombre()))
			{
				//Guardado adicional Imposibilidad emitir informe
				//El combo regula el cambio de estado del trabajo. Agrupamos todos los cambios de estado sobre el 
				// mismo campo debido a que no hay certidumbre en el orden en que se van a evaluar los campos de
				// la lista de "valores"
				if(DDSiNo.NO.equals(valor.getValor())){
					//EMITIDO = NO => Trabajo -> estado ->  FALLIDO
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_FALLIDO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					tramite.getTrabajo().setEstado(estadoTrabajo);
					Auditoria.save(tramite.getTrabajo());
				}else{
					//EMITIDO = SI => Trabajo -> estado ->  FINALIZADO PDE VALIDACION
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_FINALIZADO_PENDIENTE_VALIDACION);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					tramite.getTrabajo().setEstado(estadoTrabajo);
					Auditoria.save(tramite.getTrabajo());
				}

			}
			
		}
		//TODO: Marcar amarillo el contenido de "gestión económica"
		//TODO: Sumar el incremento de presupuesto  en "presupuesto asignado al activo"

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T006_EMISION_INFORME};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
