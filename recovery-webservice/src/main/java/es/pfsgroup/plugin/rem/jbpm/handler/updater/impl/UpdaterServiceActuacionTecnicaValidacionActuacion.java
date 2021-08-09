package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;

@Component
public class UpdaterServiceActuacionTecnicaValidacionActuacion implements UpdaterService {
	
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String COMBO_VALORACION = "comboValoracion";
	private static final String COMBO_EJECUTADO = "comboEjecutado";
	private static final String CODIGO_T004_VALIDACION_TRABAJO = "T004_ValidacionTrabajo";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	private GenericABMDao genericDao;
	
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Trabajo trabajo = tramite.getTrabajo();
		
		for(TareaExternaValor valor : valores){
			
			//Fecha Solicitud
			if(FECHA_VALIDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{				
				try {
					trabajo.setFechaValidacion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			//Combo de valoración
			if(COMBO_VALORACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
			
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDTipoCalidad tipoCalidad = genericDao.get(DDTipoCalidad.class, filtro);
				trabajo.setTipoCalidad(tipoCalidad);
			}
			
			//Combo de ejecución
			if(COMBO_EJECUTADO.equals(valor.getNombre())){

				if(DDSiNo.SI.equals(valor.getValor())){
					/*
					 * Si es actuación técnica, subtipo tapiado o colocación de puertas, y el combo de ejecutado es SI, entonces guardamos la fecha de ejecución en la fecha
					 * de tapiado o colocación de puertas según sea. Y se marca el booleano a true.
					 */
					if(DDSubtipoTrabajo.CODIGO_AT_TAPIADO.equals(trabajo.getSubtipoTrabajo().getCodigo())){
						Activo activo = trabajo.getActivo();
						ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
						situacionPosesoria.setFechaAccesoTapiado(trabajo.getFechaFin());
						situacionPosesoria.setAccesoTapiado(1);
						situacionPosesoria.setFechaUltCambioTapiado(new Date());
						genericDao.save(ActivoSituacionPosesoria.class, situacionPosesoria);
					}
					
					if(DDSubtipoTrabajo.CODIGO_AT_COLOCACION_PUERTAS.equals(trabajo.getSubtipoTrabajo().getCodigo())){
						Activo activo = trabajo.getActivo();
						ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
						situacionPosesoria.setFechaAccesoAntiocupa(trabajo.getFechaFin());
						situacionPosesoria.setAccesoAntiocupa(1);
						genericDao.save(ActivoSituacionPosesoria.class, situacionPosesoria);
					}
					
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_VALIDADO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					
					/* Estado del trabajo: Un estado diferente, según si el trámite avanza o retrocede por la decisión de Validación Trabajo.
					 * Ejecutado = SI (avanza): Estado = Finalizado PDE. Validación (se mantiene sin cambio)
					 */
				}else{
					/* Estado del trabajo: Un estado diferente, según si el trámite avanza o retrocede por la decisión de Validación Trabajo.
					 * Ejecutado = NO (retrocede): Estado = En Trámite (cambia a estado anterior)
					 */
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					trabajo.setFechaEjecucionReal(null);
				}
			}
			
		}
		genericDao.save(Trabajo.class, trabajo);

	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T004_VALIDACION_TRABAJO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

    
}
