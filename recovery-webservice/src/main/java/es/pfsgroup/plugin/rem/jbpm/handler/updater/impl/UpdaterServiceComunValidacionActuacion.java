package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

@Component
public class UpdaterServiceComunValidacionActuacion implements UpdaterService {
	
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String COMBO_VALORACION = "comboValoracion";
	private static final String COMBO_CORRECCION = "comboCorreccion";
	private static final String CODIGO_T002_SOLICITUD_VALIDACION_ACTUACION = "T002_ValidacionActuacion";
	private static final String CODIGO_T006_VALIDACION_INFORME = "T006_ValidacionInforme";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	private static final Log logger = LogFactory.getLog(UpdaterServiceComunValidacionActuacion.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;
	
	
	@Transactional
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		if (!valores.isEmpty() && CODIGO_T002_SOLICITUD_VALIDACION_ACTUACION.equals(valores.get(0).getTareaExterna().getTareaProcedimiento().getCodigo())) {
			updateFechaObtencionDocumento(tramite, new Date());
		}

		for(TareaExternaValor valor : valores){

			//Fecha Solicitud - Se procesa guardado adicional solo si la pantalla la informa (gestión de campos obligatorios)
			if(FECHA_VALIDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor()))
			{
				try {
					updateFechaObtencionDocumento(tramite, ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("UpdaterServiceComunValidacionActuacion, Error parse date", e);
				}
			}

			//Combo de valoración - Se procesa guardado adicional solo si la pantalla lo informa (gestión de campos obligatorios)
			if(COMBO_VALORACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				Trabajo trabajo = tramite.getTrabajo();
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", valor.getValor());
				DDTipoCalidad tipoCalidad = genericDao.get(DDTipoCalidad.class, filtro);
				trabajo.setTipoCalidad(tipoCalidad);
				Auditoria.save(trabajo);
			}
			
			//Combo de corrección de documento
			if(COMBO_CORRECCION.equals(valor.getNombre())){
				
				Trabajo trabajo = tramite.getTrabajo();
				
				if(DDSiNo.SI.equals(valor.getValor())){
					
					
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_VALIDADO);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					Auditoria.save(trabajo);					
					
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
					
					/* Estado del trabajo: Un estado diferente, según si el trámite avanza o retrocede por la decisión de "Validación Actuación".
					 * Ejecutado = SI (avanza): Estado = Finalizado PDE. Validación (se mantiene el estado sin cambio)
					 */
				}else{
					/* Estado del trabajo: Un estado diferente, según si el trámite avanza o retrocede por la decisión de "Validación Actuación".
					 * Ejecutado = NO (retrocede): Estado = En Trámite (cambia a estado anterior)
					 */
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_EN_TRAMITE);
					DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class, filter);
					trabajo.setEstado(estadoTrabajo);
					Auditoria.save(trabajo);
				}
			}
		}

	}

	private void updateFechaObtencionDocumento(ActivoTramite tramite, Date fecha) {
		Trabajo trabajo = tramite.getTrabajo();
		
		DDSubtipoTrabajo subtipoTrabajo = trabajo.getSubtipoTrabajo();
		List<ActivoAdmisionDocumento> listaDocumentos = tramite.getActivo().getAdmisionDocumento();
		for(ActivoAdmisionDocumento documento : listaDocumentos){
			if(subtipoTrabajo.getCodigo().equals(diccionarioTargetClassMap.getSubtipoTrabajo(documento.getConfigDocumento().getTipoDocumentoActivo().getCodigo()))) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDocumento.CODIGO_ESTADO_OBTENIDO);
				DDEstadoDocumento estadoDocumento = (DDEstadoDocumento) genericDao.get(DDEstadoDocumento.class, filtro);

				documento.setFechaSolicitud(fecha);
				documento.setEstadoDocumento(estadoDocumento);
				Auditoria.save(documento);
			}
		}

		trabajo.setFechaValidacion(fecha);
		Auditoria.save(trabajo);
	}

	public String[] getCodigoTarea() {
		// TODO Constantes con los nombres de los nodos.
		return new String[]{CODIGO_T002_SOLICITUD_VALIDACION_ACTUACION, CODIGO_T006_VALIDACION_INFORME};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

    
}
