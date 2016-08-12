package es.pfsgroup.plugin.rem.adapter;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.web.dto.factory.DTOFactory;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionObservacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoVisitasActivo;
import es.pfsgroup.plugin.rem.model.DtoVisitasAgrupacion;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaAgrupaciones;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorFactoryApi;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service
public class AgrupacionAdapter {
	
    @Autowired
    private DTOFactory dtoFactory;
	
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private MSVFicheroDao ficheroDao;
 
    
    @Autowired 
    private ActivoApi activoApi;
    
    @Autowired 
    private ActivoAgrupacionApi activoAgrupacionApi;
    
    @Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
    
    @Autowired
    private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;
    
    @Autowired
    protected JBPMProcessManagerApi jbpmProcessManagerApi;
    
    @Autowired
    protected TipoProcedimientoManager tipoProcedimiento;
    
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
	@Autowired
	List<AgrupacionAvisadorApi> avisadores;
	
	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
	@Autowired
	private AgrupacionValidatorFactoryApi agrupacionValidatorFactory;
	
	private final Log logger = LogFactory.getLog(getClass());
    
	public DtoAgrupaciones getAgrupacionById(Long id){
		
		DtoAgrupaciones dtoAgrupacion = new DtoAgrupaciones();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);	

		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		DtoAgrupacionFilter dtoAgrupacionFilter = new DtoAgrupacionFilter();
		dtoAgrupacionFilter.setAgrupacionId(agrupacion.getId().toString());
		dtoAgrupacionFilter.setLimit(1);
		dtoAgrupacionFilter.setStart(0);

		VBusquedaAgrupaciones agrupacionVista = (VBusquedaAgrupaciones) activoAgrupacionApi.getListAgrupaciones(dtoAgrupacionFilter, usuarioLogado).getResults().get(0);

		try {
			
			BeanUtils.copyProperties(dtoAgrupacion, agrupacion);
			BeanUtils.copyProperty(dtoAgrupacion, "numeroPublicados", agrupacionVista.getPublicados());
			BeanUtils.copyProperty(dtoAgrupacion, "numeroActivos", agrupacionVista.getActivos());
			
			if (agrupacion.getTipoAgrupacion() != null) {
				
				BeanUtils.copyProperty(dtoAgrupacion, "tipoAgrupacionDescripcion", agrupacion.getTipoAgrupacion().getDescripcion());
				BeanUtils.copyProperty(dtoAgrupacion, "tipoAgrupacionCodigo", agrupacion.getTipoAgrupacion().getCodigo());

				
				// SI ES TIPO OBRA NUEVA
				if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
					
					ActivoObraNueva agrupacionTemp = (ActivoObraNueva) agrupacion;
					
					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);
					
					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion", agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo", agrupacionTemp.getLocalidad().getCodigo());
					}
					
					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion", agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo", agrupacionTemp.getProvincia().getCodigo());
					}

					if (agrupacionTemp.getEstadoObraNueva() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "estadoObraNuevaCodigo", agrupacionTemp.getEstadoObraNueva().getCodigo());
					}

					
				// SI ES TIPO RESTRINGIDA	
				} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
					
					ActivoRestringida agrupacionTemp = (ActivoRestringida) agrupacion;
					
					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);
					
					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion", agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo", agrupacionTemp.getLocalidad().getCodigo());
					}
					
					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion", agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo", agrupacionTemp.getProvincia().getCodigo());
					}
					
				}
				
				// TODO: Hacer cuando esté listo el activo principal dentro de la agrupación
				
				if(agrupacion.getActivoPrincipal() != null && !agrupacion.getActivoPrincipal().getPropietariosActivo().isEmpty()) {
					if(agrupacion.getActivoPrincipal().getPropietariosActivo().size()>1) {
						BeanUtils.copyProperty(dtoAgrupacion, "propietario", "varios");						
					} else {
						BeanUtils.copyProperty(dtoAgrupacion, "propietario", agrupacion.getActivoPrincipal().getPropietariosActivo().get(0).getPropietario().getFullName());
					}					
				}
				
				if (agrupacion.getActivoPrincipal() != null && agrupacion.getActivoPrincipal().getCartera() != null) {
					BeanUtils.copyProperty(dtoAgrupacion, "cartera", agrupacion.getActivoPrincipal().getCartera().getDescripcion());	
				} else if (agrupacion.getActivos() != null && !agrupacion.getActivos().isEmpty() && agrupacion.getActivos().get(0).getActivo().getCartera() != null) {
					BeanUtils.copyProperty(dtoAgrupacion, "cartera", agrupacion.getActivos().get(0).getActivo().getCartera().getDescripcion());		
				}
				/*
				 * if(activo.getTipoActivo() != null ) {					
					BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
					BeanUtils.copyProperty(activoDto, "tipoActivoDescripcion", activo.getTipoActivo().getDescripcion());
				}
				 */
					
				
				
			}
			
			
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return dtoAgrupacion;
		
	}

	
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter filtro, Long id) {
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
//		DtoAgrupacionFilter filtro = new DtoAgrupacionFilter();
		filtro.setAgrupacionId(String.valueOf(id));
		try { 	
			Page listaActivos = activoAgrupacionApi.getListActivosAgrupacionById(filtro, usuarioLogado);
			return listaActivos;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	
				
	}

	public Page getListAgrupaciones(DtoAgrupacionFilter dtoAgrupacionFilter) {

		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioLogado.getId()));
		if(!Checks.esNulo(usuarioCartera))
			dtoAgrupacionFilter.setCodCartera(usuarioCartera.getCartera().getCodigo());

		Page temp = (Page) activoAgrupacionApi.getListAgrupaciones(dtoAgrupacionFilter, usuarioLogado);
		return temp;
				
	}	
	
	public Object getAgrupacionByIdParcial(Long id, int pestana) {
		
		Activo activo = activoApi.get(id);			
		
		
		// Pestaña 1: Ficha
		// Seteamos los campos a mano que no pueden copiarse con el copyProperties debido a las referencias
		try {
			// 1: Cabecera
			if (pestana == 1) {
				
				DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();

				BeanUtils.copyProperties(activoDto, activo);
				if (activo.getLocalizacion() != null) {
					BeanUtils.copyProperties(activoDto, activo.getLocalizacion().getLocalizacionBien());
					BeanUtils.copyProperties(activoDto, activo.getLocalizacion());
					
					if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getTipoVia() != null) {
						BeanUtils.copyProperty(activoDto, "tipoViaCodigo", activo.getLocalizacion().getLocalizacionBien().getTipoVia().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getPais() != null) {
						BeanUtils.copyProperty(activoDto, "paisCodigo", activo.getLocalizacion().getLocalizacionBien().getPais().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null) {
						BeanUtils.copyProperty(activoDto, "municipioCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional() != null) {
						BeanUtils.copyProperty(activoDto, "inferiorMunicipioCodigo", activo.getLocalizacion().getLocalizacionBien().getUnidadPoblacional().getCodigo());
					}
					if (activo.getLocalizacion().getLocalizacionBien() != null && activo.getLocalizacion().getLocalizacionBien().getLocalidad() != null
							&& activo.getLocalizacion().getLocalizacionBien().getLocalidad().getProvincia() != null) {
						BeanUtils.copyProperty(activoDto, "provinciaCodigo", activo.getLocalizacion().getLocalizacionBien().getLocalidad().getProvincia().getCodigo());
					}
					
				}

				return activoDto;	

			} else {
				
				DtoActivoFichaCabecera activoDto = new DtoActivoFichaCabecera();
				BeanUtils.copyProperties(activoDto, activo);
				return activoDto;	
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
			
		
	}

	@Transactional(readOnly = false)
	public void createActivoAgrupacion(Long numActivo, Long idAgrupacion, Integer activoPrincipal) throws JsonViewerException {
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);	
		
		int num = activoAgrupacionActivoApi.numActivosPorActivoAgrupacion(agrupacion.getId());

		try {			
		
			if(Checks.esNulo(activo)) {			
				throw new JsonViewerException("El activo no existe");
			}
			
			// Si es el primer activo, validamos si tenemos los datos necesarios del activo, y modificamos la agrupación con esos datos
			if ( num == 0 ) {
				
				activoAgrupacionValidate(activo, agrupacion);			
				agrupacion = updateAgrupacionPrimerActivo(activo, agrupacion);			
				activoAgrupacionApi.saveOrUpdate(agrupacion);
			}
			
			// Validaciones de agrupación
			agrupacionValidate(activo, agrupacion);			
			
			ActivoAgrupacionActivo activoAgrupacionActivo = new ActivoAgrupacionActivo();
			activoAgrupacionActivo.setActivo(activo);
			activoAgrupacionActivo.setAgrupacion(agrupacion);
			Date today = new Date();
			activoAgrupacionActivo.setFechaInclusion(today);
			
			activoAgrupacionActivoApi.save(activoAgrupacionActivo);
		} catch (JsonViewerException jve) {
		    throw jve;
		} catch (Exception e) {
		    logger.debug(e);
		}
		
	}
	
	private void agrupacionValidate(Activo activo, ActivoAgrupacion agrupacion) throws JsonViewerException {

		List<AgrupacionValidator> validators = agrupacionValidatorFactory.getServices(agrupacion.getTipoAgrupacion().getCodigo());
		
		for(AgrupacionValidator v: validators) {
			
			String errorResult = v.getValidationError(activo, agrupacion);
			
			if ( errorResult != null && !errorResult.equals("") ){
				throw new JsonViewerException(errorResult);
			}	
			
		}

		
	}


	/**
	 * Realiza las validaciones necesarias del activo para poderlo incluir en la agrupación
	 * @param activo Activo
	 * @param agrupacion ActivoAgrupacion
	 */
	private void activoAgrupacionValidate(Activo activo, ActivoAgrupacion agrupacion) {
		
					
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();
		
		if ( Checks.esNulo(pobl.getLocalidad()) ) throw new JsonViewerException(BusinessValidators.ERROR_LOC_NULL);
		if ( Checks.esNulo(pobl.getCodPostal()) ) throw new JsonViewerException(BusinessValidators.ERROR_CP_NULL);
		if ( Checks.esNulo(pobl.getProvincia()) ) throw new JsonViewerException(BusinessValidators.ERROR_PROV_NULL);
		
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

			if ( Checks.esNulo(activo.getCartera()) ) throw new JsonViewerException(BusinessValidators.ERROR_CARTERA_NULL);					
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			
			if (Checks.esNulo(activo.getPropietariosActivo())) throw new JsonViewerException(BusinessValidators.ERROR_PROPIETARIO_NULL);
			
		}
	}

	private ActivoAgrupacion updateAgrupacionPrimerActivo(Activo activo, ActivoAgrupacion agrupacion) {
		
		NMBLocalizacionesBienInfo pobl = activo.getLocalizacionActual();

		
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

			ActivoObraNueva obraNueva = (ActivoObraNueva) agrupacion;
			obraNueva.setLocalidad(pobl.getLocalidad()); 					
			obraNueva.setProvincia(pobl.getProvincia());					
			obraNueva.setCodigoPostal(pobl.getCodPostal());
			return obraNueva;				
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			ActivoRestringida restringida = (ActivoRestringida) agrupacion;
			restringida.setLocalidad(pobl.getLocalidad()); 					
			restringida.setProvincia(pobl.getProvincia());					
			restringida.setCodigoPostal(pobl.getCodPostal());
			restringida.setActivoPrincipal(activo);
			
			return restringida;
		}
		
		return agrupacion;		
	}


	@Transactional(readOnly = false)
	public boolean marcarPrincipal(Long idAgrupacion, Long idActivo) {
		
		Activo activo = activoApi.get(idActivo);
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);
		
		try {
				
			// Si es RESTRINGIDA	
			if (agrupacion.getTipoAgrupacion() != null && agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {

				ActivoRestringida restringida = (ActivoRestringida) agrupacion;				
				restringida.setActivoPrincipal(activo);
				
				activoAgrupacionApi.saveOrUpdate(restringida);
				
			}

			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	

	@Transactional(readOnly = false)
	public boolean deleteActivoAgrupacion(Long id) throws JsonViewerException{
		
		ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.get(id);
		Activo activo =  activoAgrupacionActivo.getActivo();

		
		if (activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			
			int numActivos = activoAgrupacionActivoApi.numActivosPorActivoAgrupacion(activoAgrupacionActivo.getAgrupacion().getId());
			if (numActivos == 0) {
				throw new JsonViewerException("No hay ningún activo asociado a esta agrupación.");
			} else if (numActivos == 1) {
				throw new JsonViewerException("El último activo de una agrupación no se puede eliminar. Intenta borrar toda la agrupación.");
			}
			
			if (DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA.equals(activo.getSituacionComercial().getCodigo()) || DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA.equals(activo.getSituacionComercial().getCodigo())) {
				throw new JsonViewerException("No se puede dar de baja un activo restringido si tiene ofertas VIVAS.");
			}
			
		}

		
		try {	
			
			if (activoAgrupacionActivo.getActivo().equals(activoAgrupacionActivo.getAgrupacion().getActivoPrincipal())) {
				activoAgrupacionActivo.getAgrupacion().setActivoPrincipal(null);
				genericDao.update(ActivoAgrupacion.class, activoAgrupacionActivo.getAgrupacion());
			}
			activoAgrupacionActivoApi.delete(activoAgrupacionActivo);

		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteActivosAgrupacion(Long[] id) {
		
		try {
			
			for (int i = 0; i<id.length; i++) {
				
				ActivoAgrupacionActivo activoAgrupacionActivo = activoAgrupacionActivoApi.get(id[i]);
				
				if (activoAgrupacionActivo.getActivo().equals(activoAgrupacionActivo.getAgrupacion().getActivoPrincipal())) {
					activoAgrupacionActivo.getAgrupacion().setActivoPrincipal(null);
					genericDao.update(ActivoAgrupacion.class, activoAgrupacionActivo.getAgrupacion());
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteAllActivosAgrupacion(Long id) {
		
		try {
			
			ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
			int tamano = agrupacion.getActivos().size();
			
			Long[] activosEliminar = new Long[tamano] ; 
			for (int i = 0; i<tamano; i++) {
				activosEliminar[i] = agrupacion.getActivos().get(i).getId();
			}
						
			agrupacion.getActivos().clear();
			agrupacion.setActivoPrincipal(null);
			activoAgrupacionApi.saveOrUpdate(agrupacion);
			
			deleteActivosAgrupacion(activosEliminar);

		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	

	@Transactional(readOnly = false)
	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion) {
		
		// En fase 1, solo se podrán insertar agrupaciones RESTRINGIDAS, por lo que lo seteamos manualmente.
		/*if (dtoAgrupacion.getTipoAgrupacion() == null || dtoAgrupacion.getTipoAgrupacion().equals("") || dtoAgrupacion.getTipoAgrupacion().equals("Restringida")) {
			dtoAgrupacion.setTipoAgrupacion(AGRUPACION_RESTRINGIDA);
		}*/
		
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAgrupacion.getTipoAgrupacion());
		DDTipoAgrupacion tipoAgrupacion = (DDTipoAgrupacion) genericDao.get(DDTipoAgrupacion.class, filtro);
		
		Long numAgrupacionRem = activoAgrupacionApi.getNextNumAgrupacionRemManual();
		
		// Si es OBRA NUEVA
		if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
			
			ActivoObraNueva obraNueva = new ActivoObraNueva();
			
			obraNueva.setDescripcion(dtoAgrupacion.getDescripcion());
			obraNueva.setNombre(dtoAgrupacion.getNombre());
			obraNueva.setTipoAgrupacion(tipoAgrupacion);
			obraNueva.setFechaAlta(new Date());
			obraNueva.setNumAgrupRem(numAgrupacionRem);
			
			genericDao.save(ActivoObraNueva.class, obraNueva);

		// Si es RESTRINGIDA	
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			
			ActivoRestringida restringida = new ActivoRestringida();

			restringida.setDescripcion(dtoAgrupacion.getDescripcion());
			restringida.setNombre(dtoAgrupacion.getNombre());
			restringida.setTipoAgrupacion(tipoAgrupacion);
			restringida.setFechaAlta(new Date());
			restringida.setNumAgrupRem(numAgrupacionRem);

			genericDao.save(ActivoRestringida.class, restringida);
			
		}

		return true;
		
	}
	

	@Transactional(readOnly = false)
	public boolean deleteAgrupacionById(DtoAgrupacionesCreateDelete dtoAgrupacion) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(Long.valueOf(dtoAgrupacion.getId()));
		
		try {
			
			// Si es OBRA NUEVA
			if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
				
				genericDao.deleteById(ActivoObraNueva.class, Long.valueOf(dtoAgrupacion.getId()));
				
			}
			// RESTRINGIDA
			else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
				
				genericDao.deleteById(ActivoRestringida.class, Long.valueOf(dtoAgrupacion.getId()));

			} else {
				
				activoAgrupacionApi.deleteById(Long.valueOf(dtoAgrupacion.getId()));
				
			}
			
			//Después borra todos los ActivoAgrupacionActivo de esta Agrupación y los guarda en el histórico
			List<ActivoAgrupacionActivo> list = agrupacion.getActivos();
			for (int i = 0; i < list.size(); i++) {
				activoAgrupacionActivoApi.delete(list.get(i));
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return true;
		
	}
	
	public List<DtoObservacion> getListObservacionesAgrupacionById(Long id) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		//DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();

		if (agrupacion.getAgrupacionObservacion() != null) 
		{
		
			for (int i = 0; i < agrupacion.getAgrupacionObservacion().size(); i++)
			{
				
				
				DtoObservacion observacionDto = new DtoObservacion();
				
				try {
					
					BeanUtils.copyProperties(observacionDto, agrupacion.getAgrupacionObservacion().get(i));
					String nombreCompleto =agrupacion.getAgrupacionObservacion().get(i).getUsuario().getNombre();
					Long idUsuario = agrupacion.getAgrupacionObservacion().get(i).getUsuario().getId();
					if (agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido1() != null) {
						
						nombreCompleto += agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido1();
						
						if (agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido2() != null) {
							nombreCompleto += agrupacion.getAgrupacionObservacion().get(i).getUsuario().getApellido2();
						}
						
					}
					BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
					BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);
				
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDtoObservaciones.add(observacionDto);
			}
		}
		
		return listaDtoObservaciones;	
				
	}
	
	public List<DtoVisitasAgrupacion> getListVisitasAgrupacionById(Long id) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		//DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<DtoVisitasAgrupacion> listaDtoVisitasAgrupacion = new ArrayList<DtoVisitasAgrupacion>();
		
		if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)){
			
			Activo activoPrincipal= agrupacion.getActivoPrincipal();	
			if (activoPrincipal !=null && activoPrincipal.getVisitas() != null) {
				
				for (int i = 0; i < activoPrincipal.getVisitas().size(); i++) 
				{
					DtoVisitasAgrupacion dtoAgrupacionVisitas = new DtoVisitasAgrupacion();
					try {
						
						BeanUtils.copyProperties(dtoAgrupacionVisitas, activoPrincipal.getVisitas().get(i));
						//BeanUtils.copyProperties(dtoActivoVisitas, activo.getAgrupaciones().get(i).getAgrupacion());
						
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "idVisita", activoPrincipal.getVisitas().get(i).getId());
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "fechaSolicitud", activoPrincipal.getVisitas().get(i).getFechaSolicitud());
						if(activoPrincipal.getVisitas().get(i).getCliente()!=null){
							BeanUtils.copyProperty(dtoAgrupacionVisitas, "nombre", activoPrincipal.getVisitas().get(i).getCliente().getNombre()+activoPrincipal.getVisitas().get(i).getCliente().getApellidos());
							BeanUtils.copyProperty(dtoAgrupacionVisitas, "numDocumento", activoPrincipal.getVisitas().get(i).getCliente().getDocumento());
						}
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "fechaVisita", activoPrincipal.getVisitas().get(i).getFechaVisita());
						
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
					listaDtoVisitasAgrupacion.add(dtoAgrupacionVisitas);
			
				}
			}
			
		}
		else{
			for(int i = 0; i < agrupacion.getActivos().size(); i++){	
				for(Visita visita: agrupacion.getActivos().get(i).getActivo().getVisitas()){
					
					DtoVisitasAgrupacion dtoAgrupacionVisitas = new DtoVisitasAgrupacion();
					
					try {
						
						BeanUtils.copyProperties(dtoAgrupacionVisitas, visita);
						//BeanUtils.copyProperties(dtoActivoVisitas, activo.getAgrupaciones().get(i).getAgrupacion());
						
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "idVisita", visita.getId());
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "fechaSolicitud", visita.getFechaSolicitud());
						if(visita.getCliente()!=null){
							BeanUtils.copyProperty(dtoAgrupacionVisitas, "nombre", visita.getCliente().getNombre()+visita.getCliente().getApellidos());
							BeanUtils.copyProperty(dtoAgrupacionVisitas, "numDocumento", visita.getCliente().getDocumento());
						}
						BeanUtils.copyProperty(dtoAgrupacionVisitas, "fechaVisita", visita.getFechaVisita());
						
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
					listaDtoVisitasAgrupacion.add(dtoAgrupacionVisitas);	
				}
			}
		}
	
		return listaDtoVisitasAgrupacion;	
				
	}
	
	public List<VOfertasActivosAgrupacion>  getListOfertasAgrupacion(Long idAgrupacion) {
		
		Filter filtro= genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", idAgrupacion.toString());	
		Order order = new Order(OrderType.ASC, "id");
		List<VOfertasActivosAgrupacion> resultadoOfertasAgrupacion= new ArrayList<VOfertasActivosAgrupacion>();
		List<VOfertasActivosAgrupacion> todasOfertasAgrupacion= genericDao.getListOrdered(VOfertasActivosAgrupacion.class, order,filtro);
		
		if(todasOfertasAgrupacion != null && todasOfertasAgrupacion.size()!=0){
			ActivoAgrupacion agrupacion = activoAgrupacionApi.get(idAgrupacion);
			if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)){
				Activo activoPrincipal= agrupacion.getActivoPrincipal();
				
				for(VOfertasActivosAgrupacion vOfertas: todasOfertasAgrupacion){
					if(activoPrincipal.getId().equals(Long.valueOf(vOfertas.getIdActivo()))){
						resultadoOfertasAgrupacion.add(vOfertas);
					}
				}
			}
			else{
				resultadoOfertasAgrupacion= todasOfertasAgrupacion;
			}
		}
		else{
			resultadoOfertasAgrupacion= todasOfertasAgrupacion;
		}
		
		return resultadoOfertasAgrupacion;
		
	}
	
	
	
	//public List<DtoActivoAviso> getAvisosActivoById(Long id) {
		// FIXME: Formatear aquí o en vista cuando se sepa el diseño.
	public DtoAviso getAvisosAgrupacionById(Long id) {
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);	
		
		//List<DtoAviso> listaAvisos = new ArrayList<DtoAviso>();
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		
		for (AgrupacionAvisadorApi avisador: avisadores) {
			
			if ( avisador.getAviso(agrupacion, usuarioLogado) != null &&  avisador.getAviso(agrupacion, usuarioLogado).getDescripcion() != null) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() +
						"<div class='div-aviso'>" + avisador.getAviso(agrupacion, usuarioLogado).getDescripcion() + "</div>");
			}
			
        }
		
		return avisosFormateados;	
				
	}



	public Object procesarMasivo (Long idProcess, Long idOperation) {
		
		MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
		
        Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", idOperation);
        MSVDDOperacionMasiva tipoOperacion = genericDao.get(MSVDDOperacionMasiva.class, filter);

		try {
			MSVLiberator lib = factoriaLiberators.dameLiberator(tipoOperacion);
			if (!Checks.esNulo(lib)) lib.liberaFichero(document);
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//TODO: Cambiar estado DocumentoMasivo
		
		return true;
	}
	
	

	@Transactional(readOnly = false)
	public boolean saveObservacionesAgrupacion(DtoObservacion dtoObservacion, Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoAgrupacionObservacion agrupacionObservacion = genericDao.get(ActivoAgrupacionObservacion.class, filtro);
		
		try {
			
			beanUtilNotNull.copyProperties(agrupacionObservacion, dtoObservacion);
			genericDao.save(ActivoAgrupacionObservacion.class, agrupacionObservacion);
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean createObservacionesAgrupacion(DtoObservacion dtoObservacion, Long id) {
		
		ActivoAgrupacionObservacion agrupacionObservacion = new ActivoAgrupacionObservacion();
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		try {
			
			agrupacionObservacion.setObservacion(dtoObservacion.getObservacion());
			agrupacionObservacion.setFecha(new Date());
			agrupacionObservacion.setUsuario(usuarioLogado);
			agrupacionObservacion.setAgrupacion(agrupacion);
			
			ActivoAgrupacionObservacion observacionNueva = genericDao.save(ActivoAgrupacionObservacion.class, agrupacionObservacion);
			
			agrupacion.getAgrupacionObservacion().add(observacionNueva);
			activoAgrupacionApi.saveOrUpdate(agrupacion);	
			
		} catch (Exception e) {
			e.printStackTrace();
		} 

		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean deleteObservacionAgrupacion(Long idObservacion) {
		
		try {
			
			genericDao.deleteById(ActivoAgrupacionObservacion.class, idObservacion);
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		
		
		return true;
		
	}
	
	@Transactional(readOnly = false)
	public boolean saveAgrupacion(DtoAgrupaciones dto, Long id) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		// SI ES TIPO OBRA NUEVA
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
			
			ActivoObraNueva obraNueva = (ActivoObraNueva) agrupacion;
			
			try {
				
				beanUtilNotNull.copyProperties(obraNueva, dto);
				
				
				if (dto.getMunicipioCodigo() != null) {
					
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
					
					obraNueva.setLocalidad(municipioNuevo);
				}
				
				if (dto.getEstadoObraNuevaCodigo() != null) {
					
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoObraNuevaCodigo());
					DDEstadoObraNueva estadoNuevo = (DDEstadoObraNueva) genericDao.get(DDEstadoObraNueva.class, filtro);
					
					obraNueva.setEstadoObraNueva(estadoNuevo);
					
				}
				
				if (dto.getProvinciaCodigo() != null) {
					
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
					
					obraNueva.setProvincia(provinciaNueva);
				}
				
				activoAgrupacionApi.saveOrUpdate(obraNueva);
				
			} catch (Exception e) {
				
				e.printStackTrace();
				return false;
			}
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			
			ActivoRestringida restringida = (ActivoRestringida) agrupacion;
			
			try {
				
				beanUtilNotNull.copyProperties(restringida, dto);
				
				
				if (dto.getMunicipioCodigo() != null) {
					
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
					
					restringida.setLocalidad(municipioNuevo);
				}
				
				if (dto.getProvinciaCodigo() != null) {
					
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
					
					restringida.setProvincia(provinciaNueva);
				}
				
				//ActivoAgrupacionActivo activoAgrupacionNuevo = genericDao.save(ActivoAgrupacionActivo.class, activoAgrupacion);

				activoAgrupacionApi.saveOrUpdate(restringida);
				
				
			} catch (Exception e) {
				
				e.printStackTrace();
				return false;
			}
		}
		
		return true;
		
			
	}

	
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {
		
		return activoAgrupacionApi.getFotosActivosAgrupacionById(id);

	}

	
	protected DDTipoAgrupacion getTipoAgrupacion(Long id) {
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		DDTipoAgrupacion tipoAgrupacion = genericDao.get(DDTipoAgrupacion.class, filter);

		return tipoAgrupacion;
	}
	


}
