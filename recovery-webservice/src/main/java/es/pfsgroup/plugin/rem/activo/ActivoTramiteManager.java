package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.trabajo.TrabajoManager;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;;

/**
 * Clase para tratar los trámites de Activo.
 * 
 * @author Daniel Gutiérrez & Bender
 *
 */
@Service("activoTramiteManager")
public class ActivoTramiteManager implements ActivoTramiteApi{

	private static final String MOTIVO_INCORRECCION = "motivoIncorreccion";
	
	@Resource
    MessageService messageServices;
    
	@Autowired
	private GenericABMDao genericDao;

	@Autowired	
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoTramiteDao activoTramiteDao;

	@Autowired
	private ActivoManager activoManager;
	
	@Autowired
	private DiccionarioTargetClassMap diccionarioTargetClassMap;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private TrabajoManager trabajoManager;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	
	
	public ActivoTramite get(Long idTramite){
		return activoTramiteDao.get(idTramite);
	}
	
	public Page getTramitesActivo(Long idActivo, WebDto webDto){
		return activoTramiteDao.getTramitesActivo(idActivo, webDto);
	}
	
	public List<ActivoTramite> getListaTramitesActivo(Long idActivo){
		return activoTramiteDao.getListaTramitesActivo(idActivo);
	}
	
	public Page getTramitesActivoTrabajo(Long idTrabajo,  WebDto webDto ){		
		return activoTramiteDao.getTramitesActivoTrabajo(idTrabajo, webDto);		
	}

	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.getActivosTramite")
	public List<Activo> getActivosTramite(Long idTramite){
		Filter filtroTramite = genericDao.createFilter(FilterType.EQUALS, "id", idTramite);
		ActivoTramite activoTramite = genericDao.get(ActivoTramite.class, filtroTramite);
		
		return activoTramite.getActivos();
	}
	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.getDtoActivosTramite")
	public List<DtoActivoTramite> getDtoActivosTramite(List<Activo> listaActivos){
		
		List<DtoActivoTramite> listDtoActivosTramite = new ArrayList<DtoActivoTramite>();
		
		for (Activo activo : listaActivos){
			listDtoActivosTramite.add((DtoActivoTramite) getDtoActivoTramite(activo));
		}
		
		return listDtoActivosTramite;
	}
	
	private DtoActivoTramite getDtoActivoTramite(Activo activo){

		DtoActivoTramite dtoActivoTramite = new DtoActivoTramite();
		
		try {
			
			BeanUtils.copyProperty(dtoActivoTramite, "numActivo", activo.getNumActivo());
			BeanUtils.copyProperty(dtoActivoTramite, "numActivoRem", activo.getNumActivoRem());
			BeanUtils.copyProperty(dtoActivoTramite, "idSareb", activo.getIdSareb());
			BeanUtils.copyProperty(dtoActivoTramite, "numActivoUvem", activo.getNumActivoUvem());
			BeanUtils.copyProperty(dtoActivoTramite, "idRecovery", activo.getIdRecovery());
			
			
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "getDireccion", activo.getLocalizacion().getLocalizacionBien().getDireccion());
				BeanUtils.copyProperty(dtoActivoTramite, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "municipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
				BeanUtils.copyProperty(dtoActivoTramite, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "provinciaDescripcion", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());
			}
			if (activo.getRating() != null ) {
				BeanUtils.copyProperty(dtoActivoTramite, "rating", activo.getRating().getCodigo());
			}
			
			BeanUtils.copyProperty(dtoActivoTramite, "propietario", activo.getFullNamePropietario());	
			
			if(activo.getTipoActivo() != null ) {					
				BeanUtils.copyProperty(dtoActivoTramite, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "tipoActivoDescripcion", activo.getTipoActivo().getDescripcion());
			}
			 
			if (activo.getSubtipoActivo() != null ) {
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoActivoCodigo", activo.getSubtipoActivo().getCodigo());	
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoActivoDescripcion", activo.getSubtipoActivo().getDescripcion());	
			}
			
			if (activo.getTipoTitulo() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
			}
			
			if (activo.getSubtipoTitulo() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
			}
			
			if (activo.getTipoTitulo() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
			}
			
			if (activo.getSubtipoTitulo() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "subtipoTituloDescripcion", activo.getSubtipoTitulo().getDescripcion());
			}
			
			if (activo.getCartera() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "entidadPropietariaDescripcion", activo.getCartera().getDescripcion());
			}
			
//			if (activo.getBien().getLocalizaciones() != null && activo.getBien().getLocalizaciones().get(0).getLocalidad() != null) {
//				BeanUtils.copyProperty(dtoActivoTramite, "municipioDescripcion", activo.getBien().getLocalizaciones().get(0).getLocalidad().getDescripcion());
//			}
			
			if (activo.getEstadoActivo() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "estadoActivoCodigo", activo.getEstadoActivo().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "estadoActivoDescripcion", activo.getEstadoActivo().getDescripcion());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
			
		return dtoActivoTramite;
		
	}

	@Transactional(readOnly = false)
	public Long saveOrUpdateActivoTramite(ActivoTramite activoTramite){
		return activoTramiteDao.save(activoTramite);
	}
	
	public ActivoTramite getTramiteAdmisionActivo(Long idActivo){
		ActivoTramite tramite = new ActivoTramite();
		if(existeTramiteAdmision(idActivo))
			return activoTramiteDao.getListaTramitesActivoAdmision(idActivo).get(0);
		else
			return tramite;
	}
	
	@BusinessOperationDefinition("activoManager.existeTramiteAdmision")
	public Boolean existeTramiteAdmision(Long idActivo){
		List<ActivoTramite> listaTramites = activoTramiteDao.getListaTramitesActivoAdmision(idActivo);
		return (!listaTramites.isEmpty());
	}
	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.existeAdjuntoUG")
	public Boolean existeAdjuntoUG(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion){
		//Balancea la comprobación de existencia de archivos adjuntos, dentro de la unidad de gestión indicada:
		// ACTIVO.........: A
		// TRABAJO........: T
		
		// Si no le pasamos el codigo de DocAdjunto, va a buscar el tipo de documento que corresponde
		// por cada subtipo de trabajo
		if (Checks.esNulo(codigoDocAdjunto)){
			codigoDocAdjunto = diccionarioTargetClassMap.getTipoDocumento(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getSubtipoTrabajo().getCodigo());
		}
		
		// Si no hemos pasado codigo por param y el mapeo de documentos tampoco nos da un documento, NO realizamos validación
		if (!Checks.esNulo(codigoDocAdjunto)){

			if ("A".equals(uGestion)){
				return activoManager.comprobarExisteAdjuntoActivo(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getActivo().getId(), codigoDocAdjunto);
			}else if ("T".equals(uGestion)){
				return trabajoManager.comprobarExisteAdjuntoTrabajo(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getId(), codigoDocAdjunto);
			}else{
				return false;
			}
			
		}else{
			return true;
		}
	}
	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.existeAdjuntoUGValidacion")
	public String existeAdjuntoUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion){
		
		//Mensaje de validación
		String mensajeValidacion = null;
		
		//Realizamos la validación de si existe o no el doc. adjunto
		if (!existeAdjuntoUG(tareaExterna, codigoDocAdjunto, uGestion)){
			
			// Si no le pasamos el codigo de DocAdjunto, va a buscar el tipo de documento que corresponde
			// por cada subtipo de trabajo
			if (Checks.esNulo(codigoDocAdjunto)){
				codigoDocAdjunto = diccionarioTargetClassMap.getTipoDocumento(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getSubtipoTrabajo().getCodigo());
			}
			
			DDTipoDocumentoActivo tipoFicheroAdjunto = genericDao.get(DDTipoDocumentoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
		
			if (!Checks.esNulo(tipoFicheroAdjunto)){
 
				mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.debeAportar").concat(" ");
						
				//Dependiendo del entorno de comprobaciÃ³n de existencia, se retorna un mensaje
				if (uGestion.equals("A")){
		//			mensajeValidacion = mensajeValidacion.concat("sobre el Activo, el documento ");
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("activo.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}else if(uGestion.equals("T")){
		//			mensajeValidacion = mensajeValidacion.concat("sobre el Trabajo, el documento ");
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}
				
				//Incluye en el mensaje, la descripciÃ³n de documento adjunto.
				mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjunto.getDescripcion());
				
				//Si no encuentra el doc. adjunto por codigo, retorna un mensaje fijo de advertencia
				if (tipoFicheroAdjunto.getCodigo().isEmpty()){
		//			mensajeValidacion = "ATENCION: No se ha podido verificar la existencia de un adjunto porque no existe el codigo indicado: " + codigoDocAdjunto;
					mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
				}
		
				//Si la unidad de gestiÃ³n no es ninguna de las definidas, retorna un mensaje fijo de advertencia.
				if (!uGestion.isEmpty() && !uGestion.equals("A") && !uGestion.equals("T")){
		//			mensajeValidacion = "ATENCION: No es posible verificar la existencia de un adjunto en esta unidad de gestión: " + uGestion;
					mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.unidadGestionInvalida").concat(" ").concat(uGestion);
				}
				
			}else{
				mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
			}
			
		}		
		return mensajeValidacion;
	}
	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.existeAdjuntoUGCadena")
	public Boolean existeAdjuntoUGCadena(TareaExterna tareaExterna, String cadenaDAUG){
		
		String[] arrayDAUG = cadenaDAUG.toUpperCase().split(";");
		String tipoDoc = new String();
		String uGestion = new String();
		
		for (String elementoDAUG: arrayDAUG){
			
			tipoDoc = elementoDAUG.split(",")[0].trim();
			uGestion = elementoDAUG.split(",")[1].trim();
			
			if (!existeAdjuntoUG(tareaExterna, tipoDoc, uGestion)){
				return false;
			}
		}
		
		return true;
	}
	
	@Override
	@BusinessOperation(overrides = "activoTramiteManager.existeAdjuntoUGValidacionCadena")
	public String existeAdjuntoUGValidacionCadena(TareaExterna tareaExterna, String cadenaDAUG){
		
		String[] arrayDAUG = cadenaDAUG.toUpperCase().split(";");
		String mensajeMultiValidacion = new String();
		String tipoDoc = new String();
		String uGestion = new String();
		
		for (String elementoDAUG: arrayDAUG){
			
			tipoDoc = elementoDAUG.split(",")[0].trim();
			uGestion = elementoDAUG.split(",")[1].trim();
			
			if (!existeAdjuntoUG(tareaExterna, tipoDoc, uGestion)){
				mensajeMultiValidacion = mensajeMultiValidacion.concat(existeAdjuntoUGValidacion(tareaExterna,tipoDoc,uGestion)).concat("<br>");
			}
		}
		
		return mensajeMultiValidacion.toString();
	}
	
	
	@Override
	public int numeroFijacionPlazos(ActivoTramite tramite){
		
		Filter filtroTap = genericDao.createFilter(FilterType.EQUALS, "codigo", "T004_FijacionPlazo");
		TareaProcedimiento tareaProcedimiento = genericDao.get(TareaProcedimiento.class, filtroTap);
		
		List<TareaExterna> listaTareas = activoTareaExternaApi.getByIdTareaProcedimientoIdTramite(tramite.getId(), tareaProcedimiento.getId());
		
		return listaTareas.size();
	}
	
	
	@Override
	public String obtenerMotivoDenegacion(ActivoTramite tramite){
		String motivo = null;
		//Filter filtroTap = genericDao.createFilter(FilterType.EQUALS, "codigo", "T004_FijacionPlazo");
		Filter filtroTap = genericDao.createFilter(FilterType.EQUALS, "codigo", "T004_ValidacionTrabajo");
		TareaProcedimiento tareaProcedimiento = genericDao.get(TareaProcedimiento.class, filtroTap);

		List<TareaExterna> listaTareas = activoTareaExternaApi.getByIdTareaProcedimientoIdTramite(tramite.getId(), tareaProcedimiento.getId());
	

		if(this.numeroFijacionPlazos(tramite)>0){
			//Como está ordenado de manera descendente, nos quedamos con la primera tarea del tipo
			List<TareaExternaValor> valoresTarea = activoTareaExternaApi.obtenerValoresTarea(listaTareas.get(0).getId());
			
			for(TareaExternaValor valor : valoresTarea){
				if(MOTIVO_INCORRECCION.equals(valor.getNombre()))
					motivo = valor.getValor();
			}
		}
		return motivo;
	}
	

}