package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.InformeJuridico;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProveedor;
import es.pfsgroup.plugin.rem.utils.DiccionarioTargetClassMap;

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
	private ActivoApi activoApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private ProveedoresApi proveedoresApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
    @Autowired
    private TareaActivoApi tareaActivoApi;
    
    
	
	public ActivoTramite get(Long idTramite){
		return activoTramiteDao.get(idTramite);
	}
	
	public Page getTramitesActivo(Long idActivo, WebDto webDto){
		return activoTramiteDao.getTramitesActivo(idActivo, webDto);
	}
	
	public List<ActivoTramite> getListaTramitesActivo(Long idActivo){
		//return activoTramiteDao.getListaTramitesActivo(idActivo);
		return activoTramiteDao.getListaTramitesFromActivoTrabajo(idActivo);
	}
	
	public Page getTramitesActivoTrabajo(Long idTrabajo,  WebDto webDto ){		
		return activoTramiteDao.getTramitesActivoTrabajo(idTrabajo, webDto);		
	}

	public List<ActivoTramite> getTramitesActivoTrabajoList(Long idTrabajo){		
		return activoTramiteDao.getTramitesActivoTrabajoList(idTrabajo);		
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
			BeanUtils.copyProperty(dtoActivoTramite, "id", activo.getId());
			BeanUtils.copyProperty(dtoActivoTramite, "numActivo", activo.getNumActivo());
			BeanUtils.copyProperty(dtoActivoTramite, "numActivoRem", activo.getNumActivoRem());
			BeanUtils.copyProperty(dtoActivoTramite, "idSareb", activo.getIdSareb());
			BeanUtils.copyProperty(dtoActivoTramite, "numActivoUvem", activo.getNumActivoUvem());
			BeanUtils.copyProperty(dtoActivoTramite, "idRecovery", activo.getIdRecovery());
			
			
			if (activo.getLocalizacion() != null && activo.getLocalizacion().getLocalizacionBien() != null) {
				BeanUtils.copyProperty(dtoActivoTramite, "direccion", activo.getLocalizacion().getLocalizacionBien().getDireccion());
				
				if (activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
					BeanUtils.copyProperty(dtoActivoTramite, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
					BeanUtils.copyProperty(dtoActivoTramite, "municipioDescripcion", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getDescripcion());
				}
				if (activo.getLocalizacion().getLocalizacionBien().getProvincia() != null) {
					BeanUtils.copyProperty(dtoActivoTramite, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getProvincia().getCodigo());
					BeanUtils.copyProperty(dtoActivoTramite, "provinciaDescripcion", activo.getLocalizacion().getLocalizacionBien().getProvincia().getDescripcion());
				}
			}
			if (activo.getRating() != null ) {
				BeanUtils.copyProperty(dtoActivoTramite, "ratingCodigo", activo.getRating().getCodigo());
				BeanUtils.copyProperty(dtoActivoTramite, "ratingDescripcion", activo.getRating().getDescripcion());
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
		// ACTIVO...................: A
		// TRABAJO..................: T
		// EXPEDIENTE (comercial)...: E
		// PROVEEDORES..............: P (verifica existencia documento en todos los proveedores de 1 activo)
		// GASTO....................: G (pendiente de desarrollar)
		
		// Si no le pasamos el codigo de DocAdjunto, va a buscar el tipo de documento que corresponde
		// por cada subtipo de trabajo
		if (("A".equals(uGestion) || "T".equals(uGestion)) && Checks.esNulo(codigoDocAdjunto)){
			codigoDocAdjunto = diccionarioTargetClassMap.getTipoDocumento(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getSubtipoTrabajo().getCodigo());
		}
		
		// Si no hemos pasado codigo por param y el mapeo de documentos tampoco nos da un documento, NO realizamos validación
		if (!Checks.esNulo(codigoDocAdjunto)){			
			if (("A".equals(uGestion) || "T".equals(uGestion)) && !Checks.esNulo(codigoDocAdjunto) ){
				return activoApi.comprobarExisteAdjuntoActivo(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getActivo().getId(), codigoDocAdjunto);
			}else if("E".equals(uGestion) && !Checks.esNulo(codigoDocAdjunto) ){
				return expedienteComercialApi.comprobarExisteAdjuntoExpedienteComercial(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getId(), codigoDocAdjunto);
			}else if("P".equals(uGestion) && !Checks.esNulo(codigoDocAdjunto) ){
				return proveedoresApi.comprobarExisteAdjuntoProveedores(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getActivo().getId(), codigoDocAdjunto);
//			}else if("G".equals(uGestion) && !Checks.esNulo(codigoDocAdjunto) ){
//				return proveedoresApi.comprobarExisteAdjuntoProveedores(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getActivo().getId(), codigoDocAdjunto);
			} else {
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
			if (("A".equals(uGestion) || "T".equals(uGestion)) && Checks.esNulo(codigoDocAdjunto)){
				codigoDocAdjunto = diccionarioTargetClassMap.getTipoDocumento(trabajoApi.getTrabajoByTareaExterna(tareaExterna).getSubtipoTrabajo().getCodigo());
			}
			
			// Dependiendo de la unidad de gestión, busca tipos de documento
			// en una u otra entidad
			DDTipoDocumentoActivo tipoFicheroAdjunto = null;
			DDSubtipoDocumentoExpediente tipoFicheroAdjuntoEC = null;
			DDTipoDocumentoProveedor tipoFicheroAdjuntoProveedor = null;
			DDTipoDocumentoGasto tipoFicheroAdjuntoGasto = null;
			
			if ("A".equals(uGestion) || "T".equals(uGestion)){
				tipoFicheroAdjunto = genericDao.get(DDTipoDocumentoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
			}else if("E".equals(uGestion)){
				tipoFicheroAdjuntoEC = genericDao.get(DDSubtipoDocumentoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
			}else if("P".equals(uGestion)){
				tipoFicheroAdjuntoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
			}else if("G".equals(uGestion)){
				tipoFicheroAdjuntoGasto = genericDao.get(DDTipoDocumentoGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
			}
		
			if (!Checks.esNulo(tipoFicheroAdjunto) 
					|| !Checks.esNulo(tipoFicheroAdjuntoEC)
					|| !Checks.esNulo(tipoFicheroAdjuntoProveedor)
					|| !Checks.esNulo(tipoFicheroAdjuntoGasto) ){
 
				mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.debeAportar").concat(" ");
						
				//Dependiendo del entorno de comprobaciÃ³n de existencia, se retorna un mensaje
				if ("A".equals(uGestion)){
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("activo.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}else if("T".equals(uGestion)){
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}else if("E".equals(uGestion)){
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("ecomercial.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}else if("P".equals(uGestion)){
					mensajeValidacion = messageServices.getMessage("proveedores.adjuntos.validacion.advertencia.debeAportar".concat(" "));
				}else if("G".equals(uGestion)){
					mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("gasto.adjuntos.validacion.advertencia.debeAportarSobre").concat(" "));
				}
				
				//Segun unidad de gestion, Incluye en el mensaje, la descripciÃ³n de documento adjunto.
				if (("A".equals(uGestion) || "T".equals(uGestion)) && !Checks.esNulo(tipoFicheroAdjunto) ){
					mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjunto.getDescripcion());
				}else if("E".equals(uGestion) && !Checks.esNulo(tipoFicheroAdjuntoEC) ){
					mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjuntoEC.getDescripcion());
				}else if("P".equals(uGestion) && !Checks.esNulo(tipoFicheroAdjuntoProveedor) ){
					mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjuntoProveedor.getDescripcion());
				}else if("G".equals(uGestion) && !Checks.esNulo(tipoFicheroAdjuntoGasto) ){
					mensajeValidacion = mensajeValidacion.concat(tipoFicheroAdjuntoGasto.getDescripcion());
				}
								
				//Si no encuentra el doc. adjunto de la unidad de gestion correspondiente, retorna un mensaje fijo de advertencia
				if (("A".equals(uGestion) || "T".equals(uGestion)) && Checks.esNulo(tipoFicheroAdjunto) ){
					mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
				}else if("E".equals(uGestion) && Checks.esNulo(tipoFicheroAdjuntoEC) ){
					mensajeValidacion = messageServices.getMessage("ecomercial.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
				}else if("P".equals(uGestion) && Checks.esNulo(tipoFicheroAdjuntoProveedor) ){
					mensajeValidacion = messageServices.getMessage("proveedores.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
				}else if("G".equals(uGestion) && Checks.esNulo(tipoFicheroAdjuntoGasto) ){
					mensajeValidacion = messageServices.getMessage("gasto.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
				}
		
				//Si la unidad de gestiÃ³n no es ninguna de las definidas, retorna un mensaje fijo de advertencia.
				if (!uGestion.isEmpty() && 
						!"A".equals(uGestion) &&
						!"T".equals(uGestion) &&
						!"P".equals(uGestion) &&
						!"E".equals(uGestion) &&
						!"G".equals(uGestion)){
					mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.unidadGestionInvalida").concat(" ").concat(uGestion);
				}
				
			}else{
				mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.codigoDocInvalido").concat(" ").concat(codigoDocAdjunto);
			}
			
		}		
		return mensajeValidacion;
	}
	
	@Override
	public String existeAdjuntoUGCarteraValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion, String cartera) {

		if (!Checks.esNulo(cartera)) {
			DDCartera carteraObj = trabajoApi.getCartera(tareaExterna);
			if (cartera.equals(carteraObj.getCodigo())) {
				return existeAdjuntoUGValidacion(tareaExterna, codigoDocAdjunto, uGestion);
			}
		}

		return null; // solo se valida el documento si cumple con la cartera seleccionada
	}
	
	@Override
	public String mismoNumeroAdjuntosComoActivosExpedienteUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion){
		
		//Mensaje de validación
		String mensajeValidacion = "";
		
		//Realizamos la validación de si existe o no el doc. adjunto
		if(Checks.esNulo(tareaExterna)){
			mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" "));
			
		}else if (!uGestion.isEmpty() && !"A".equals(uGestion) &&
				  !"T".equals(uGestion) && !"P".equals(uGestion) &&
				  !"E".equals(uGestion) && !"G".equals(uGestion)){
			mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.unidadGestionInvalida").concat(" ").concat(uGestion);

		}else{
			
			Trabajo tbj = trabajoApi.getTrabajoByTareaExterna(tareaExterna);
			if(Checks.esNulo(tbj)){
				mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" ");
				
			}else{
		
				ExpedienteComercial eco = expedienteComercialApi.findOneByTrabajo(tbj);
				if(Checks.esNulo(eco)){
					mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" ");
					
				}else{
				
					//Obtenemos el tipo de documento exigido
					DDSubtipoDocumentoExpediente tipoFicheroAdjuntoEC = genericDao.get(DDSubtipoDocumentoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
					
					
					//Obtenemos la lista de documentos del tipo pasado por parámetro del expediente
					Filter filtroTrabajoEC = genericDao.createFilter(FilterType.EQUALS, "expediente.trabajo.id", tbj.getId());
					Filter filtroAdjuntoSubtipoCodigo = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo", codigoDocAdjunto);
					List<AdjuntoExpedienteComercial> listaAdjuntosExpediente = genericDao.getList(AdjuntoExpedienteComercial.class, filtroTrabajoEC, filtroAdjuntoSubtipoCodigo);
					
					List<ActivoOferta> activosExpediente = eco.getOferta().getActivosOferta();
					
					if(!Checks.esNulo(activosExpediente) && !Checks.esNulo(listaAdjuntosExpediente)){
						if(listaAdjuntosExpediente.size() < activosExpediente.size()){
							Object[] obj = new Object[3];
							obj[0] = tipoFicheroAdjuntoEC.getDescripcion();
							obj[1] = activosExpediente.size();
							obj[2] = listaAdjuntosExpediente.size();
							mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("ecomercial.adjuntos.validacion.advertencia.numDocsInvalido", obj));
						}
					}
				}
			}
		}		
		return mensajeValidacion;
	}
	
	public String mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion(TareaExterna tareaExterna, String codigoDocAdjunto, String uGestion, String cartera){
		
		// Mensaje de validación
		String mensajeValidacion = "";

		// Realizamos la validación de si existe o no el doc. adjunto
		if (Checks.esNulo(tareaExterna)) {
			mensajeValidacion = mensajeValidacion.concat(
					messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" "));

		}
		else{
			
			DDCartera carteraObj = trabajoApi.getCartera(tareaExterna);
			if(!Checks.esNulo(cartera) && !Checks.esNulo(carteraObj)){
				if(cartera.equals(carteraObj.getCodigo())){
					Trabajo tbj = trabajoApi.getTrabajoByTareaExterna(tareaExterna);
					if(Checks.esNulo(tbj)){
						mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" ");
						
					}
					else{
						ExpedienteComercial eco = expedienteComercialApi.findOneByTrabajo(tbj);
						if(Checks.esNulo(eco)){
							mensajeValidacion = messageServices.getMessage("trabajo.adjuntos.validacion.advertencia.tareaInvalida").concat(" ");
							
						}
						else{
							
							//Obtenemos el tipo de documento exigido
							DDSubtipoDocumentoExpediente tipoFicheroAdjuntoEC = genericDao.get(DDSubtipoDocumentoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoDocAdjunto));
							
							
							//Obtenemos la lista de documentos del tipo pasado por parámetro del expediente
							Filter filtroTrabajoEC = genericDao.createFilter(FilterType.EQUALS, "expediente.trabajo.id", tbj.getId());
							Filter filtroAdjuntoSubtipoCodigo = genericDao.createFilter(FilterType.EQUALS, "subtipoDocumentoExpediente.codigo", codigoDocAdjunto);
							List<AdjuntoExpedienteComercial> listaAdjuntosExpediente = genericDao.getList(AdjuntoExpedienteComercial.class, filtroTrabajoEC, filtroAdjuntoSubtipoCodigo);
							
							List<CompradorExpediente> compradoresNoBorrados= eco.getCompradoresAlta();
								
							if(listaAdjuntosExpediente.size() >= compradoresNoBorrados.size()){
								Object[] obj = new Object[3];
								obj[0] = tipoFicheroAdjuntoEC.getDescripcion();
								obj[1] = compradoresNoBorrados.size();
								obj[2] = listaAdjuntosExpediente.size();
								mensajeValidacion = mensajeValidacion.concat(messageServices.getMessage("ecomercial.adjuntos.validacion.advertencia.compradores.numDocsInvalido", obj));
							}
						}
					}
				}
			}
		}
		
		return mensajeValidacion;
	}
	
	
	
	@Override
	public Boolean checkFechaEmisionInformeJuridico(TareaExterna tareaExterna){
		
		Boolean ok = false;
		
		if(!Checks.esNulo(tareaExterna)){
			Trabajo tbj = trabajoApi.getTrabajoByTareaExterna(tareaExterna);
			if(!Checks.esNulo(tbj)){
				ExpedienteComercial eco = expedienteComercialApi.findOneByTrabajo(tbj);
				if(!Checks.esNulo(eco)){
					List<InformeJuridico> listaInformes= eco.getListaInformeJuridico();
					List<ActivoOferta> activosExpediente = eco.getOferta().getActivosOferta();
					if(!Checks.estaVacio(listaInformes) && !Checks.estaVacio(activosExpediente)){
						if(activosExpediente.size() == listaInformes.size()){
							for(int i=0;i<listaInformes.size();i++){
								InformeJuridico infJur =listaInformes.get(i);
								if(Checks.esNulo(infJur.getFechaEmision())){
									break;
								}
								if(i==listaInformes.size()-1){
									ok = true;
								}
							}	
						}
					}
				}
			}
		}
		return ok;
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
	public int numeroValidacionTrabajo(ActivoTramite tramite){
		
		Filter filtroTap = genericDao.createFilter(FilterType.EQUALS, "codigo", "T004_ValidacionTrabajo");
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
	

		if(this.numeroValidacionTrabajo(tramite)>0){
			//Como está ordenado de manera descendente, nos quedamos con la primera tarea del tipo
			List<TareaExternaValor> valoresTarea = activoTareaExternaApi.obtenerValoresTarea(listaTareas.get(0).getId());
			
			for(TareaExternaValor valor : valoresTarea){
				if(MOTIVO_INCORRECCION.equals(valor.getNombre()))
					motivo = valor.getValor();
			}
		}
	
		
		return motivo;
	}
	
	@Override
	public String getTareaValorByNombre(List<TareaExternaValor> valores, String tevNombre) {
		
		String valor = null;

		for(TareaExternaValor tev : valores) {
			if(tev.getNombre().equalsIgnoreCase(tevNombre)) {
				if(!Checks.esNulo(tev.getValor()) ) {
					valor = tev.getValor();
				}
				break;
			}
		}
		
		return valor;
	}
	
	@Override
	public String getValorTareasAnteriorByCampo(Long idToken, String tevNombre) {
		
		List<TareaExternaValor> allValoresTramite = new ArrayList<TareaExternaValor>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tokenIdBpm", idToken);
		
		List<TareaExterna> listTareas = genericDao.getList(TareaExterna.class, filtro);
		for(TareaExterna tarea : listTareas) {
			allValoresTramite.addAll(tarea.getValores());
		}
		
		return this.getTareaValorByNombre(allValoresTramite,"emailPropietario");
	}
	
	
	@Override
	public List<TareaProcedimiento> getTareasActivasByIdTramite(Long idTramite) {
		TareaActivo tarAct = null;
		List<TareaProcedimiento> listaTareasProc = new ArrayList<TareaProcedimiento>();
		
		List<TareaActivo>  listaTareas = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		if(!Checks.esNulo(listaTareas)){
			for(int i=0; i<listaTareas.size(); i++){
				tarAct = listaTareas.get(i);
				if(Checks.esNulo(tarAct.getFechaFin())){
					listaTareasProc.add(tarAct.getTareaExterna().getTareaProcedimiento());
				}
			}
		}

		return listaTareasProc;
	}
	
	@Override
	public List<TareaExterna> getListaTareaExternaActivasByIdTramite(Long idTramite) {
		TareaActivo tarAct = null;
		List<TareaExterna> listaTareaExterna = new ArrayList<TareaExterna>();
		
		List<TareaActivo>  listaTareas = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		if(!Checks.esNulo(listaTareas)){
			for(int i=0; i<listaTareas.size(); i++){
				tarAct = listaTareas.get(i);
				if(Checks.esNulo(tarAct.getFechaFin())){
					listaTareaExterna.add(tarAct.getTareaExterna());
				}
			}
		}

		return listaTareaExterna;
	}
	
	@Override
	public List<TareaProcedimiento> getTareasByIdTramite(Long idTramite) {
		TareaActivo tarAct = null;
		List<TareaProcedimiento> listaTareasProc = new ArrayList<TareaProcedimiento>();
		
		List<TareaActivo>  listaTareas = tareaActivoApi.getTareasActivoByIdTramite(idTramite);
		if(!Checks.esNulo(listaTareas)){
			for(int i=0; i<listaTareas.size(); i++){
				tarAct = listaTareas.get(i);
				listaTareasProc.add(tarAct.getTareaExterna().getTareaProcedimiento());	
			}
		}

		return listaTareasProc;
	}
	
	
	
	
}
