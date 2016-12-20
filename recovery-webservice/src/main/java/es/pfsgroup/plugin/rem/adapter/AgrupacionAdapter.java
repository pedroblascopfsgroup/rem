package es.pfsgroup.plugin.rem.adapter;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.users.domain.Usuario;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionObservacion;
import es.pfsgroup.plugin.rem.model.ActivoAsistida;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoLoteComercial;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoUsuario;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VBusquedaAgrupaciones;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidator;
import es.pfsgroup.plugin.rem.validate.AgrupacionValidatorFactoryApi;
import es.pfsgroup.plugin.rem.validate.BusinessValidators;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service
public class AgrupacionAdapter {
	
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private MSVFicheroDao ficheroDao;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoAdapter activoAdapter;

    @Autowired
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

    @Autowired
    private ActivoManager activoManager;
    @Autowired 
    private ActivoApi activoApi;
    
    @Autowired 
    private ActivoAgrupacionApi activoAgrupacionApi;
    
    @Autowired 
    private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
    
    @Autowired
    protected JBPMProcessManagerApi jbpmProcessManagerApi;
    
    @Autowired
    protected TipoProcedimientoManager tipoProcedimiento;
    
    @Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
    
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
	@Autowired
	List<AgrupacionAvisadorApi> avisadores;
	
	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
	@Autowired
	private AgrupacionValidatorFactoryApi agrupacionValidatorFactory;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	public static final String OFERTA_INCOMPATIBLE_AGR_MSG = "El tipo de oferta es incompatible con el destino comercial de algún activo";
	public static final String OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG = "No se puede aceptar la oferta debido a que no se encuentran todos los gestores asignados";
    
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

				// Si es de tipo 'Lote Comercial'
				if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
					ActivoLoteComercial agrupacionTemp = (ActivoLoteComercial) agrupacion;

					if(!Checks.esNulo(agrupacionTemp.getUsuarioGestoriaFormalizacion())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestoriaFormalizacion", agrupacionTemp.getUsuarioGestoriaFormalizacion().getId());
					}
					if(!Checks.esNulo(agrupacionTemp.getUsuarioGestorComercial())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorComercial", agrupacionTemp.getUsuarioGestorComercial().getId());
					}
					if(!Checks.esNulo(agrupacionTemp.getUsuarioGestorFormalizacion())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorFormalizacion", agrupacionTemp.getUsuarioGestorFormalizacion().getId());
					}
					if(!Checks.esNulo(agrupacionTemp.getUsuarioGestorComercialBackOffice())) {
						BeanUtils.copyProperty(dtoAgrupacion, "codigoGestorComercialBackOffice", agrupacionTemp.getUsuarioGestorComercialBackOffice().getId());
					}
				}

				// Si es de tipo 'Asistida'.
				if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
					ActivoAsistida agrupacionTemp = (ActivoAsistida) agrupacion;
					
					BeanUtils.copyProperties(dtoAgrupacion, agrupacionTemp);
					
					if (agrupacionTemp.getLocalidad() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "municipioDescripcion", agrupacionTemp.getLocalidad().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "municipioCodigo", agrupacionTemp.getLocalidad().getCodigo());
					}
					
					if (agrupacionTemp.getProvincia() != null) {
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaDescripcion", agrupacionTemp.getProvincia().getDescripcion());
						BeanUtils.copyProperty(dtoAgrupacion, "provinciaCodigo", agrupacionTemp.getProvincia().getCodigo());
					}
					
					BeanUtils.copyProperty(dtoAgrupacion, "fechaFinVigencia", agrupacionTemp.getFechaFinVigencia());
					BeanUtils.copyProperty(dtoAgrupacion, "fechaInicioVigencia", agrupacionTemp.getFechaInicioVigencia());
				}
				
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
					ActivoPropietario propietario = agrupacion.getActivoPrincipal().getPropietarioPrincipal();
					if(Checks.esNulo(propietario)) {
						BeanUtils.copyProperty(dtoAgrupacion, "propietario", propietario.getFullName());	
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
				
				// Resolvemos si la agrupación será editable
				dtoAgrupacion.setEsEditable(true);
				if(!Checks.esNulo(agrupacion.getFechaBaja())) {
					dtoAgrupacion.setEsEditable(false);					
				}
				
				//Si tiene alguna oferta != Estado.Rechazada ==> No se pueden anyadir activos
				BeanUtils.copyProperty(dtoAgrupacion,"existenOfertasVivas",this.existenOfertasActivasEnAgrupacion(id));
				
			}
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return dtoAgrupacion;
		
	}
	
	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem){
		return activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(numAgrupRem);
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

			// Si la agrupación es asistida, el activo además de existir tiene que ser asistido.
			if(DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo()) && !activoApi.isActivoAsistido(activo)) {
				throw new JsonViewerException(AgrupacionValidator.ERROR_NOT_ASISTIDA);
			}

			// Si es el primer activo, validamos si tenemos los datos necesarios del activo, y modificamos la agrupación con esos datos
			if (num == 0) {
				activoAgrupacionValidate(activo, agrupacion);
				agrupacion = updateAgrupacionPrimerActivo(activo, agrupacion);
				activoAgrupacionApi.saveOrUpdate(agrupacion);
			}

			// Validaciones de agrupación
			agrupacionValidate(activo, agrupacion);

			if(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
				saveAgrupacionLoteComercial(activo, agrupacion);
			} else {
				ActivoAgrupacionActivo activoAgrupacionActivo = new ActivoAgrupacionActivo();
				activoAgrupacionActivo.setActivo(activo);
				activoAgrupacionActivo.setAgrupacion(agrupacion);
				Date today = new Date();
				activoAgrupacionActivo.setFechaInclusion(today);
				activoAgrupacionActivoApi.save(activoAgrupacionActivo);
			}
			//En asistidas hay que hacer una serie de actualizaciones 'especiales'.
			if(DDTipoAgrupacion.AGRUPACION_ASISTIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())) {
				activoApi.updateActivoAsistida(activo);
			}

		} catch (JsonViewerException jve) {
		    throw jve;
		} catch (Exception e) {
		    logger.debug(e);
		}
	}

	/**
	 * Este método guarda la relación de la agrupación lote comercial con el activo a incluir.
	 * Se examina si el activo a incluir pertenece a otra agrupación de tipo restringida y se obtiene
	 * una lista de activos incluidos en la misma para vincularlos por igual a la nueva agrupación.
	 * 
	 * @param activo : activo a incluir en la agrupación lote comercial.
	 * @param agrupacion : agrupación lote comercial en la que incluir el activo.
	 */
	private void saveAgrupacionLoteComercial(Activo activo, ActivoAgrupacion agrupacion) {
		// Obtener agrupaciones del activo.
		boolean incluidoAgrupacionRestringida = false;
		List<Activo> activosList = new ArrayList<Activo>();
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		if(!Checks.estaVacio(agrupacionesActivo)) {

			for(ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo) {
				if(!Checks.esNulo(activoAgrupacionActivo.getAgrupacion()) && !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())) {

					// Solo tratar con agrupaciones del tipo 'restringida'.
					if(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
						incluidoAgrupacionRestringida = true;
						List<ActivoAgrupacionActivo> activosAgrupacion = activoAgrupacionActivo.getAgrupacion().getActivos();
						if(!Checks.estaVacio(activosAgrupacion)) {
							// Obtener todos los activos de la agrupación restringida en la que se encuentra el activo a incluir en la agrupación lote comercial
							// y almacenar una nueva relación de la agrupación lote comercial con cada activo.
							for(ActivoAgrupacionActivo activoAgrupacion : activosAgrupacion) {
								if(!activosList.contains(activoAgrupacion.getActivo())) {
									// Este bucle se realiza para evitar posibles duplicados dado que un activo
									// puede estar en más de una agrupación de tipo restringida.
									activosList.add(activoAgrupacion.getActivo());
								}
							}
						}
					}
				}
			}

			if(!Checks.estaVacio(activosList)) {
				for(Activo act : activosList) {
					ActivoAgrupacionActivo nuevaRelacionAgrupacionActivo = new ActivoAgrupacionActivo();
					nuevaRelacionAgrupacionActivo.setActivo(act);
					nuevaRelacionAgrupacionActivo.setAgrupacion(agrupacion);
					Date today = new Date();
					nuevaRelacionAgrupacionActivo.setFechaInclusion(today);
					activoAgrupacionActivoApi.save(nuevaRelacionAgrupacionActivo);
				}
			}
		}

		if(!incluidoAgrupacionRestringida){
			ActivoAgrupacionActivo nuevaRelacionAgrupacionActivo = new ActivoAgrupacionActivo();
			nuevaRelacionAgrupacionActivo.setActivo(activo);
			nuevaRelacionAgrupacionActivo.setAgrupacion(agrupacion);
			Date today = new Date();
			nuevaRelacionAgrupacionActivo.setFechaInclusion(today);
			activoAgrupacionActivoApi.save(nuevaRelacionAgrupacionActivo);
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
		
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA) 
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

			if ( Checks.esNulo(activo.getCartera()) ) throw new JsonViewerException(BusinessValidators.ERROR_CARTERA_NULL);					
			
		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)
				|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			
			if (Checks.estaVacio(activo.getPropietariosActivo())) throw new JsonViewerException(BusinessValidators.ERROR_PROPIETARIO_NULL);
			
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

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
			ActivoAsistida asistida = (ActivoAsistida) agrupacion;
			asistida.setLocalidad(pobl.getLocalidad());
			asistida.setProvincia(pobl.getProvincia());
			asistida.setCodigoPostal(pobl.getCodPostal());
			return asistida;

		} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			ActivoLoteComercial loteComercial = (ActivoLoteComercial) agrupacion;
			// Sin copiar datos por el momento.
			return loteComercial;
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

		// Para los activos pertenecientes a una agrupación de tipo lote comercial.
		if(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			// Obtener las agrupaciones donde se encuentra el activo a eliminar de la agrupación lote comercial.
			boolean incluidoAgrupacionRestringida = false;
			List<ActivoAgrupacionActivo> agrupacionesActivo = activoAgrupacionActivo.getActivo().getAgrupaciones();
			if(!Checks.estaVacio(agrupacionesActivo)) {

				List<Long> activosID = new ArrayList<Long>();
				for(ActivoAgrupacionActivo activoAgrupaciones : agrupacionesActivo) {
					if(!Checks.esNulo(activoAgrupaciones.getAgrupacion()) && !Checks.esNulo(activoAgrupaciones.getAgrupacion().getTipoAgrupacion())) {

						// Para las agrupaciones de tipo restringido donde se encuentre el activo.
						if(activoAgrupaciones.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
							incluidoAgrupacionRestringida = true;
							// Obtener una lista de activos por la agrupación.
							List<ActivoAgrupacionActivo> activosPorAgrupacionRestringida = activoAgrupaciones.getAgrupacion().getActivos();
							if(!Checks.estaVacio(activosPorAgrupacionRestringida)) {
								// Almacenar los ID de activos para contrastar si se encuentran en la actual agrupación.
								for(ActivoAgrupacionActivo activosAgrupacion : activosPorAgrupacionRestringida) {
									if(!activosID.contains(activosAgrupacion.getActivo().getId())) {
										activosID.add(activosAgrupacion.getActivo().getId());
									}
								}
							}
							
							
							// Devolver estado de las ofertas de cada agrupación afectada al estado de 'pendientes'.
							List<Oferta> ofertasAgrupacion = activoAgrupaciones.getAgrupacion().getOfertas();
							if(!Checks.estaVacio(ofertasAgrupacion)) {
								
								for(Oferta oferta : ofertasAgrupacion) {
									if(!Checks.esNulo(oferta.getEstadoOferta())){

										if(oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_CONGELADA)) {
											DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_PENDIENTE);
											oferta.setEstadoOferta(estadoOferta);
										}
									}
								}
							}
						}
					}
				}

				// Obtener una lista de asociaciones entre la agrupación lote comercial y los activos obtenidos relacionados con el activo a borrar.
				List<ActivoAgrupacionActivo> agrupacionesActivoABorrar = activoAgrupacionActivoDao.getListActivoAgrupacionActivoByAgrupacionIDAndActivos(activoAgrupacionActivo.getAgrupacion().getId(), activosID);
				if(!Checks.estaVacio(agrupacionesActivoABorrar)) {
					for(ActivoAgrupacionActivo agrupaciones : agrupacionesActivoABorrar) {
						activoAgrupacionActivoApi.delete(agrupaciones);
					}
				}
			}
			
			if(!incluidoAgrupacionRestringida) {
				List<ActivoOferta> ofertasActivo = activoAgrupacionActivo.getActivo().getOfertas();
				if(!Checks.estaVacio(ofertasActivo)) {
					// En cada oferta asignada al activo.
					for(ActivoOferta ofertaActivo : ofertasActivo){
						if(!Checks.esNulo(ofertaActivo.getPrimaryKey()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta()) && !Checks.esNulo(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta())){
							// Si su estado es 'congelada' asignar nuevo estado a 'pendiente'.
							if(ofertaActivo.getPrimaryKey().getOferta().getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_CONGELADA)) {
								DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_PENDIENTE);
								ofertaActivo.getPrimaryKey().getOferta().setEstadoOferta(estadoOferta);
							}
						}
					}
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
			}
		}

		if(!activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			try {
				if (activoAgrupacionActivo.getActivo().equals(activoAgrupacionActivo.getAgrupacion().getActivoPrincipal())) {
					activoAgrupacionActivo.getAgrupacion().setActivoPrincipal(null);
					genericDao.update(ActivoAgrupacion.class, activoAgrupacionActivo.getAgrupacion());
				}
				activoAgrupacionActivoApi.delete(activoAgrupacionActivo);
		
			} catch (Exception e) {
				e.printStackTrace();
			}
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

		// Si es ASISTIDA	
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

			ActivoAsistida asistida = new ActivoAsistida();

			asistida.setDescripcion(dtoAgrupacion.getDescripcion());
			asistida.setNombre(dtoAgrupacion.getNombre());
			asistida.setTipoAgrupacion(tipoAgrupacion);
			asistida.setFechaAlta(new Date());
			asistida.setFechaInicioVigencia(dtoAgrupacion.getFechaInicioVigencia());
			asistida.setFechaFinVigencia(dtoAgrupacion.getFechaFinVigencia());
			asistida.setNumAgrupRem(numAgrupacionRem);

			genericDao.save(ActivoAsistida.class, asistida);

		// Si es LOTE COMERCIAL
		} else if (dtoAgrupacion.getTipoAgrupacion().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {

			ActivoLoteComercial loteComercial = new ActivoLoteComercial();

			loteComercial.setDescripcion(dtoAgrupacion.getDescripcion());
			loteComercial.setNombre(dtoAgrupacion.getNombre());
			loteComercial.setTipoAgrupacion(tipoAgrupacion);
			loteComercial.setFechaAlta(new Date());
			loteComercial.setNumAgrupRem(numAgrupacionRem);

			genericDao.save(ActivoLoteComercial.class, loteComercial);
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean deleteAgrupacionById(DtoAgrupacionesCreateDelete dtoAgrupacion) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(Long.valueOf(dtoAgrupacion.getId()));

		try {

			if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {

				genericDao.deleteById(ActivoObraNueva.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {

				genericDao.deleteById(ActivoRestringida.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {

				genericDao.deleteById(ActivoAsistida.class, Long.valueOf(dtoAgrupacion.getId()));

			} else if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {

				genericDao.deleteById(ActivoLoteComercial.class, Long.valueOf(dtoAgrupacion.getId()));

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
	
	public List<VBusquedaVisitasDetalle> getListVisitasAgrupacionById(Long id) {
		
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		//DtoCarga cargaDto = new ArrayList<DtoCarga>();
		List<VBusquedaVisitasDetalle> visitasDetalles= new ArrayList<VBusquedaVisitasDetalle>();
		List<VBusquedaVisitasDetalle> visitasDetallesTemporal= new ArrayList<VBusquedaVisitasDetalle>();

		
		if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)){
			
			Activo activoPrincipal= agrupacion.getActivoPrincipal();	
			if (activoPrincipal !=null && activoPrincipal.getVisitas() != null) {

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", agrupacion.getActivoPrincipal().getId().toString());
				visitasDetalles = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);	
				
				return visitasDetalles;	
			}
			
		}
		else{
			for(int i = 0; i < agrupacion.getActivos().size(); i++){	
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idActivo", agrupacion.getActivos().get(i).getActivo().getId().toString());
				visitasDetallesTemporal = genericDao.getList(VBusquedaVisitasDetalle.class, filtro);
				
				for(VBusquedaVisitasDetalle v: visitasDetallesTemporal){
					visitasDetalles.add(v);
				}
			}
		}
	
		return visitasDetalles;	
				
	}
	
	public List<VOfertasActivosAgrupacion>  getListOfertasAgrupacion(Long idAgrupacion) {
		
		Filter filtro= genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", idAgrupacion.toString());	

		List<VOfertasActivosAgrupacion> ofertasAgrupacion= genericDao.getList(VOfertasActivosAgrupacion.class, filtro);
	
		
		return ofertasAgrupacion;
		
	}

	/**
	 * Este método comprueba si los gestores de una agrupación de tipo 'lote comercial' se encuentran
	 * asignados devolviendo True. Si los gestores no están asignados devuelve False.
	 * 
	 * @param agr : agrupación de tipo 'lote comercial'.
	 * @return True si todos los gestores de la agrupación están asignados. False si no lo están.
	 */
	private boolean agrupacionLoteComercialGestoresAsignados(ActivoAgrupacion agr) {
		ActivoLoteComercial loteComercial = genericDao.get(ActivoLoteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", agr.getId()));

		if(Checks.esNulo(loteComercial.getUsuarioGestorComercial()) || Checks.esNulo(loteComercial.getUsuarioGestorComercialBackOffice()) ||
				Checks.esNulo(loteComercial.getUsuarioGestorFormalizacion()) || Checks.esNulo(loteComercial.getUsuarioGestoriaFormalizacion())) {
			return false;
		}

		return true;
	}

	@Transactional(readOnly = false)
	public boolean saveOfertaAgrupacion(DtoOfertaActivo dto) throws Exception {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdOferta());
		Oferta oferta = genericDao.get(Oferta.class, filtro);

		DDEstadoOferta tipoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, dto.getCodigoEstadoOferta());

		// Si se pretende aceptar la oferta, comprobar primero si la agrupación de la oferta es de tipo 'Lote comercial'.
		if(DDEstadoOferta.CODIGO_ACEPTADA.equals(tipoOferta.getCodigo())){
			if(!Checks.esNulo(oferta.getAgrupacion()) && oferta.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
				// Comprobar si la agrupación tiene todos los gestores asignados.
				if(!agrupacionLoteComercialGestoresAsignados(oferta.getAgrupacion())) {
					throw new Exception(AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG);
				}
			}
		}

		try{
			oferta.setEstadoOferta(tipoOferta);

			//Si el estado de la oferta cambia a Aceptada cambiamos el resto de estados a Congelada excepto los que ya estuvieran en Rechazada
			if(DDEstadoOferta.CODIGO_ACEPTADA.equals(tipoOferta.getCodigo())){
				// Comprobar si la agrupación de la oferta es de tipo 'Lote comercial'.
				if(!Checks.esNulo(oferta.getAgrupacion()) && oferta.getAgrupacion().getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
					// Comprobar si la agrupación tiene todos los gestores asignados.
					if(!agrupacionLoteComercialGestoresAsignados(oferta.getAgrupacion())) {
						throw new Exception(AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG);
					}
				}
				List<VOfertasActivosAgrupacion> listaOfertas= getListOfertasAgrupacion(dto.getIdAgrupacion());

				for(VOfertasActivosAgrupacion vOferta: listaOfertas){

					if(!vOferta.getIdOferta().equals(dto.getIdOferta().toString())){
						Filter filtroOferta = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(vOferta.getIdOferta()));
						Oferta ofertaFiltro = genericDao.get(Oferta.class, filtroOferta);

						DDEstadoOferta vTipoOferta = ofertaFiltro.getEstadoOferta();
						if(!DDEstadoOferta.CODIGO_RECHAZADA.equals(vTipoOferta.getCodigo())){
							DDEstadoOferta vTipoOfertaActualizar = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, "03");
							ofertaFiltro.setEstadoOferta(vTipoOfertaActualizar);
						}
					}
				}

				List<Activo>listaActivos= new ArrayList<Activo>();

				for(ActivoOferta activoOferta: oferta.getActivosOferta()){
					listaActivos.add(activoOferta.getPrimaryKey().getActivo());
				}

				DDSubtipoTrabajo subtipoTrabajo= (DDSubtipoTrabajo) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, DDSubtipoTrabajo.CODIGO_SANCION_OFERTA);
				Trabajo trabajo= trabajoApi.create(subtipoTrabajo, listaActivos, null);

				activoManager.crearExpediente(oferta,trabajo);
			}

			genericDao.update(Oferta.class, oferta);

		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return false;
		}

		return true;
	}
	
	@Transactional(readOnly = false)
	public boolean createOfertaAgrupacion(DtoOfertasFilter dto) throws Exception{
		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(dto.getIdAgrupacion());

		for(ActivoAgrupacionActivo activos: agrupacion.getActivos()){

			// Comprobar el tipo de destino comercial que tiene actualmente el activo y contrastar con la oferta.
			if(!Checks.esNulo(activos.getActivo().getTipoComercializacion())){
				String comercializacion = activos.getActivo().getTipoComercializacion().getCodigo();
				
				if(DDTipoOferta.CODIGO_VENTA.equals(dto.getTipoOferta()) && (!DDTipoComercializacion.CODIGO_VENTA.equals(comercializacion) && !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
					throw new Exception(AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG);
				}
				
				if(DDTipoOferta.CODIGO_ALQUILER.equals(dto.getTipoOferta()) && (!DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(comercializacion) && !DDTipoComercializacion.CODIGO_ALQUILER_VENTA.equals(comercializacion))) {
					throw new Exception(AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG);
				}
			}
		}
		
		try{
			ClienteComercial clienteComercial= new ClienteComercial();

			String codigoEstado = DDEstadoOferta.CODIGO_PENDIENTE;
			// Comprobar si alguno de los activos de la agrupación restringida se encuentra, además, en una agrupación de tipo 'lote comercial'.
			if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
				List<Long> activosID = new ArrayList<Long>();
				for(ActivoAgrupacionActivo activosAgrupacion : agrupacion.getActivos()) {
					activosID.add(activosAgrupacion.getActivo().getId());
				}

				if(!Checks.estaVacio(activosID) && activoAgrupacionActivoDao.algunActivoDeAgrRestringidaEnAgrLoteComercial(activosID)) {
					codigoEstado = DDEstadoOferta.CODIGO_CONGELADA;
				}

			}

			// Comprobar si la grupación tiene ofertas aceptadas para establecer la nueva oferta en estado congelada.
			for (Oferta of: agrupacion.getOfertas()) {
				if(!Checks.esNulo(of.getEstadoOferta()) && DDEstadoOferta.CODIGO_ACEPTADA.equals(of.getEstadoOferta().getCodigo())) {
					codigoEstado =  DDEstadoOferta.CODIGO_CONGELADA;
				}
			}

			DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoOferta.class, codigoEstado);
			DDTipoOferta tipoOferta = (DDTipoOferta) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoOferta.class, dto.getTipoOferta());
			DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoDocumento.class, dto.getTipoDocumento());
			Long numOferta= activoDao.getNextNumOferta();
			Long clcremid= activoDao.getNextClienteRemId();

			clienteComercial.setNombre(dto.getNombreCliente());
			clienteComercial.setApellidos(dto.getApellidosCliente());
			clienteComercial.setDocumento(dto.getNumDocumentoCliente());
			clienteComercial.setTipoDocumento(tipoDocumento);
			clienteComercial.setRazonSocial(dto.getRazonSocialCliente());
			clienteComercial.setIdClienteRem(clcremid);

			genericDao.save(ClienteComercial.class, clienteComercial);

			Oferta oferta= new Oferta();

			oferta.setNumOferta(numOferta);
			oferta.setAgrupacion(agrupacion);
			oferta.setImporteOferta(Double.valueOf(dto.getImporteOferta()));
			oferta.setEstadoOferta(estadoOferta);
			oferta.setTipoOferta(tipoOferta);
			oferta.setFechaAlta(new Date());
			oferta.setDesdeTanteo(dto.getDeDerechoTanteo());

			//Mapa con los valores Tasacion/Aprobado venta de cada activo
			Map<String,Double> valoresTasacion = new HashMap<String,Double>();
			valoresTasacion = this.asignarValoresTasacionAprobadoVenta(agrupacion.getActivos());
			
			List<ActivoOferta> listaActivosOfertas= new ArrayList<ActivoOferta>();

			if(!Checks.estaVacio(valoresTasacion)) {
				//En cada activo de la agrupacion se añade una oferta en la tabla ACT_OFR
				for(ActivoAgrupacionActivo activos: agrupacion.getActivos()){
	
					ActivoOferta activoOferta= new ActivoOferta();
					ActivoOfertaPk activoOfertaPk= new ActivoOfertaPk();
	
					activoOfertaPk.setActivo(activos.getActivo());
					activoOfertaPk.setOferta(oferta);
					activoOferta.setPrimaryKey(activoOfertaPk);
					
					if(!Checks.estaVacio(valoresTasacion)) {
						String participacion = String.valueOf(this.asignarPorcentajeParticipacionEntreActivos(activos, valoresTasacion, valoresTasacion.get("total")));
						activoOferta.setPorcentajeParticipacion(Double.parseDouble(participacion));
						activoOferta.setImporteActivoOferta((oferta.getImporteOferta()*Double.parseDouble(participacion))/100);
					}
					listaActivosOfertas.add(activoOferta);
				}
			}
			oferta.setActivosOferta(listaActivosOfertas);
			oferta.setCliente(clienteComercial);
			genericDao.save(Oferta.class, oferta);
		}catch(Exception ex) {
			logger.error(ex.getMessage());
			return false;
		}

		return true;
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
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
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
		}

		// Si es de tipo 'Lote Comercial'.
		if(agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL)) {
			ActivoLoteComercial loteComercial = (ActivoLoteComercial) agrupacion;

			if(!Checks.esNulo(dto.getCodigoGestoriaFormalizacion())) {
				Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestoriaFormalizacion());
				loteComercial.setUsuarioGestoriaFormalizacion(usuario);
			}
			if(!Checks.esNulo(dto.getCodigoGestorComercial())) {
				Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorComercial());
				loteComercial.setUsuarioGestorComercial(usuario);
			}
			if(!Checks.esNulo(dto.getCodigoGestorFormalizacion())) {
				Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorFormalizacion());
				loteComercial.setUsuarioGestorFormalizacion(usuario);
			}
			if(!Checks.esNulo(dto.getCodigoGestorComercialBackOffice())) {
				Usuario usuario = proxyFactory.proxy(UsuarioApi.class).get(dto.getCodigoGestorComercialBackOffice());
				loteComercial.setUsuarioGestorComercialBackOffice(usuario);
			}
		}

		// Si es de tipo 'Asistida'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA)) {
			ActivoAsistida asistida = (ActivoAsistida) agrupacion;
			
			try {
				beanUtilNotNull.copyProperties(asistida, dto);
				
				if (dto.getMunicipioCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMunicipioCodigo());
					Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
					
					asistida.setLocalidad(municipioNuevo);
				}
				
				if (dto.getProvinciaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaCodigo());
					DDProvincia provinciaNueva = (DDProvincia) genericDao.get(DDProvincia.class, filtro);
					
					asistida.setProvincia(provinciaNueva);
				}

				activoAgrupacionApi.saveOrUpdate(asistida);
				
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		
		// Si es de tipo 'Restringida'.
		if (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			
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
	
	//Devuelve verdadero si en la agrupación existe alguna Oferta activa (estado != RECHAZADA)
	private Boolean existenOfertasActivasEnAgrupacion(Long idAgrupacion) {
		List<VOfertasActivosAgrupacion> lista = this.getListOfertasAgrupacion(idAgrupacion);
		
		for(VOfertasActivosAgrupacion oferta : lista) {
			if(!DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getCodigoEstadoOferta()))
				return true;
		}
		
		return false;
	}
	
	/**
	 * Asignacion de valores (tasacion y sino, Aprobado venta) por activo, y el total de todos ellos
	 * @param activos
	 * @return
	 */
	private Map<String,Double> asignarValoresTasacionAprobadoVenta(List<ActivoAgrupacionActivo> activos) {
		
		Map<String,Double> valores = new HashMap<String,Double>();
		Double total = 0.0;
		
		for(ActivoAgrupacionActivo activo : activos) {
			Double valor = null;
			ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo.getActivo());
			if(!Checks.esNulo(tasacion)) {
				valor = Double.parseDouble(tasacion.getValoracionBien().getImporteValorTasacion().toString());
			}
			else {
				ActivoValoraciones valoracion = activoApi.getValoracionAprobadoVenta(activo.getActivo());
				if(!Checks.esNulo(valoracion)) {
					valor = valoracion.getImporte();
				}
				else {
					//Con que haya un activo sin valor tasacion o valor aprobado venta, no se haran las asignaciones de ninguno.
					return null;
				}
			}
			valores.put(activo.getActivo().getId().toString(), valor);
			total = total + valor;
		}
		
		valores.put("total", total);
		return valores;
	}

	/**
	 * Devuelve el porcentaje correspondiente según el valor por activo
	 * @param activo
	 * @param valores
	 * @param total
	 * @return
	 */
	private Float asignarPorcentajeParticipacionEntreActivos(ActivoAgrupacionActivo activo, Map<String,Double> valores, Double total) {
		
		if(total <= 0)
			return (float) 0;
		
		Float porcentaje = (float) (valores.get(activo.getActivo().getId().toString()) * 100);
		porcentaje = (float) (porcentaje / total);
		
		return porcentaje;
	}

	public List<DtoUsuario> getUsuariosPorCodTipoGestor(String codigoGestor) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);
		EXTDDTipoGestor tipoGestor = (EXTDDTipoGestor) genericDao.get(EXTDDTipoGestor.class, filtro);
		
		if(!Checks.esNulo(tipoGestor)) {
			return activoAdapter.getComboUsuarios(tipoGestor.getId());
		}
		
		return null;
	}
}