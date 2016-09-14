package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;


@Component
public class TabActivoInformeComercial implements TabActivoService {
    

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoManager activoManager;
	
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_INFORME_COMERCIAL};
	}
	
	/**
	 * Método que devuelve un DTO para la carga del modelo de Informe Comercial del Activo
	 * @param Activo 
	 * @return DtoActivoInformeComercial
	 */
	public DtoActivoInformeComercial getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoInformeComercial informeComercial = new DtoActivoInformeComercial();
		
		try {
			
			if (!Checks.esNulo(activo.getInfoComercial())){
				// Copia al "informe comercial" todos los atributos de "informacion comercial".
				beanUtilNotNull.copyProperties(informeComercial,  activo.getInfoComercial());
				
				if (!Checks.esNulo(activo.getInfoComercial().getProvincia())) {
					beanUtilNotNull.copyProperty(informeComercial, "provinciaCodigo", activo.getInfoComercial().getProvincia().getCodigo());
				}
				
				if (!Checks.esNulo(activo.getInfoComercial().getLocalidad())) {
					beanUtilNotNull.copyProperty(informeComercial, "municipioCodigo", activo.getInfoComercial().getLocalidad().getCodigo());
				}
				
				if (!Checks.esNulo(activo.getInfoComercial().getTipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoActivoCodigo", activo.getInfoComercial().getTipoActivo().getCodigo());
				}
				
				if (!Checks.esNulo(activo.getInfoComercial().getSubtipoActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "subtipoActivoCodigo", activo.getInfoComercial().getSubtipoActivo().getCodigo());
				}

				if(!Checks.esNulo(activo.getInfoComercial().getTipoVia())) {
					beanUtilNotNull.copyProperty(informeComercial, "tipoViaCodigo", activo.getInfoComercial().getTipoVia().getCodigo());
				}
			
				beanUtilNotNull.copyProperty(informeComercial, "numeroVia", activo.getInfoComercial().getNumeroVia());
				beanUtilNotNull.copyProperty(informeComercial, "planta", activo.getInfoComercial().getPlanta());
				
				if(!Checks.esNulo(activo.getInfoComercial().getUnidadPoblacional())) {
					beanUtilNotNull.copyProperty(informeComercial, "inferiorMunicipioCodigo", activo.getInfoComercial().getUnidadPoblacional().getCodigo());
				}
				
				if(!Checks.esNulo(activo.getInfoComercial().getUbicacionActivo())) {
					beanUtilNotNull.copyProperty(informeComercial, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo().getCodigo());
				}
				
				// Datos del mediador (proveedor).
				if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())){
					beanUtilNotNull.copyProperty(informeComercial, "codigoMediador", activo.getInfoComercial().getMediadorInforme().getId());
					beanUtilNotNull.copyProperty(informeComercial, "nombreMediador", activo.getInfoComercial().getMediadorInforme().getNombre());
					beanUtilNotNull.copyProperty(informeComercial, "telefonoMediador", activo.getInfoComercial().getMediadorInforme().getTelefono1());
					beanUtilNotNull.copyProperty(informeComercial, "emailMediador", activo.getInfoComercial().getMediadorInforme().getEmail());
				}
			}
			
			// Entre las valoraciones del activo, se buscan los importes estimados de Venta y Renta 
			// para añadir al Dto.
			Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter estimadoVentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
			Filter estimadoRentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_RENTA);

			ActivoValoraciones activoValoracionEstimadoVenta = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoVentaTPCFilter);
			ActivoValoraciones activoValoracionEstimadoRenta = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoRentaTPCFilter);
			if(!Checks.esNulo(activoValoracionEstimadoVenta)){
				beanUtilNotNull.copyProperty(informeComercial, "valorEstimadoVenta", activoValoracionEstimadoVenta.getImporte());
			}
			if(!Checks.esNulo(activoValoracionEstimadoRenta)){
				beanUtilNotNull.copyProperty(informeComercial, "valorEstimadoRenta", activoValoracionEstimadoRenta.getImporte());
			}			
			
			// Datos de la Comunidad de vecinos al Dto.
			if (!Checks.esNulo(activo.getComunidadPropietarios())){
				ActivoComunidadPropietarios comunidadPropietarios = new ActivoComunidadPropietarios();
				comunidadPropietarios = activo.getComunidadPropietarios();
				
				// Comunidad inscrita = constituida.
				beanUtilNotNull.copyProperty(informeComercial, "inscritaComunidad", comunidadPropietarios.getConstituida());
				// Derrama de la comunidad.
				beanUtilNotNull.copyProperty(informeComercial, "derramaOrientativaComunidad", activo.getInfoComercial().getDerramaOrientativaComunidad());
				// Cuota de la comunidad, tomada del importe medio.
				beanUtilNotNull.copyProperty(informeComercial, "cuotaOrientativaComunidad", activo.getInfoComercial().getCuotaOrientativaComunidad());
				// Nombre y telefono Presidente.
				beanUtilNotNull.copyProperty(informeComercial, "nomPresidenteComunidad", comunidadPropietarios.getNomPresidente());
				beanUtilNotNull.copyProperty(informeComercial, "telPresidenteComunidad", comunidadPropietarios.getTelfPresidente());
				// Nombre y telefono Administrador.
				beanUtilNotNull.copyProperty(informeComercial, "nomAdministradorComunidad", comunidadPropietarios.getNomAdministrador());
				beanUtilNotNull.copyProperty(informeComercial, "telAdministradorComunidad", comunidadPropietarios.getTelfAdministrador());
			}
			
			// Datos del edificio.
			if(!Checks.esNulo(activo.getInfoComercial().getEdificio())){
				// Reformas.
				beanUtilNotNull.copyProperty(informeComercial, "reformaFachada", activo.getInfoComercial().getEdificio().getReformaFachada());
				beanUtilNotNull.copyProperty(informeComercial, "reformaEscalera", activo.getInfoComercial().getEdificio().getReformaEscalera());
				beanUtilNotNull.copyProperty(informeComercial, "reformaPortal", activo.getInfoComercial().getEdificio().getReformaPortal());
				beanUtilNotNull.copyProperty(informeComercial, "reformaAscensor", activo.getInfoComercial().getEdificio().getReformaAscensor());
				beanUtilNotNull.copyProperty(informeComercial, "reformaCubierta", activo.getInfoComercial().getEdificio().getReformaCubierta());
				beanUtilNotNull.copyProperty(informeComercial, "reformaOtrasZonasComunes", activo.getInfoComercial().getEdificio().getReformaOtraZona());
				beanUtilNotNull.copyProperty(informeComercial, "reformaOtroDescEdificio", activo.getInfoComercial().getEdificio().getReformaOtroDescEdificio());
				
				// Inf general.
				if(!Checks.esNulo(activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio())) {
					beanUtilNotNull.copyProperty(informeComercial, "estadoConservacionCodigo", activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio().getCodigo());
				}
				if(!Checks.esNulo(activo.getInfoComercial().getEstadoConstruccion())) {
					beanUtilNotNull.copyProperty(informeComercial, "estadoConstruccionCodigo", activo.getInfoComercial().getEstadoConstruccion().getCodigo());
				}
				beanUtilNotNull.copyProperty(informeComercial, "numPlantas", activo.getInfoComercial().getEdificio().getNumPlantas());
				beanUtilNotNull.copyProperty(informeComercial, "ascensor", activo.getInfoComercial().getEdificio().getAscensor());
				beanUtilNotNull.copyProperty(informeComercial, "numAscensores", activo.getInfoComercial().getEdificio().getNumAscensores());
				beanUtilNotNull.copyProperty(informeComercial, "ediDescripcion", activo.getInfoComercial().getEdificio().getEdiDescripcion());
				beanUtilNotNull.copyProperty(informeComercial, "entornoInfraestructuras", activo.getInfoComercial().getEdificio().getEntornoInfraestructura());
				beanUtilNotNull.copyProperty(informeComercial, "entornoComunicaciones", activo.getInfoComercial().getEdificio().getEntornoComunicacion());
			}
		
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return informeComercial;
	
	}

	/**
	 * Método que guarda los valores del modelo de Informe Comercial del Activo. Devuelve un Activo con los valores
	 * que se han modificado en este, para su posterior guardado en el servicio principal de esta factoría.
	 * @param Activo 
	 * @param WebDto para parsear en DtoActivoInformeComercial
	 * @return Activo
	 */
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoInformeComercial activoInformeDto = (DtoActivoInformeComercial) webDto;
		
		try {

			// Se guardan todas las propieades del "Informe Comercial" que son comunes a "Informacion Comercial"
			if (!Checks.esNulo(activo.getInfoComercial())){
				beanUtilNotNull.copyProperties(activo.getInfoComercial(), activoInformeDto);
				
				if (!Checks.esNulo(activoInformeDto.getProvinciaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getProvinciaCodigo());
					Filter borrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro, borrado);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "provincia", provincia);
				}
				
				if (!Checks.esNulo(activoInformeDto.getMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getMunicipioCodigo());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "localidad", localidad);
				}
				
				if (!Checks.esNulo(activoInformeDto.getTipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoActivoCodigo());
					DDTipoActivo tipoActivo = (DDTipoActivo) genericDao.get(DDTipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "tipoActivo", tipoActivo);
				}
				
				if (!Checks.esNulo(activoInformeDto.getSubtipoActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getSubtipoActivoCodigo());
					DDSubtipoActivo subtipoActivo = (DDSubtipoActivo) genericDao.get(DDSubtipoActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "subtipoActivo", subtipoActivo);
				}

				if (!Checks.esNulo(activoInformeDto.getTipoViaCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getTipoViaCodigo());
					DDTipoVia tipoVia = (DDTipoVia) genericDao.get(DDTipoVia.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "tipoVia", tipoVia);
				}
				
				beanUtilNotNull.copyProperty(activo.getInfoComercial(), "numeroVia", activoInformeDto.getNumeroVia());
				beanUtilNotNull.copyProperty(activo.getInfoComercial(), "planta", activoInformeDto.getPlanta());
				
				if (!Checks.esNulo(activoInformeDto.getInferiorMunicipioCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getInferiorMunicipioCodigo());
					DDUnidadPoblacional unidadPoblacional = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "unidadPoblacional", unidadPoblacional);
				}
				
				if (!Checks.esNulo(activoInformeDto.getUbicacionActivoCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getUbicacionActivoCodigo());
					DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) genericDao.get(DDUbicacionActivo.class, filtro);
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "ubicacionActivo", ubicacionActivo);
				}
				
				// Datos del edificio.
				if(!Checks.esNulo(activo.getInfoComercial().getEdificio())){
					// Reformas.
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaFachada", activoInformeDto.getReformaFachada());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaEscalera", activoInformeDto.getReformaEscalera());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaPortal", activoInformeDto.getReformaPortal());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaAscensor", activoInformeDto.getReformaAscensor());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaCubierta", activoInformeDto.getReformaCubierta());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaOtraZona", activoInformeDto.getReformaOtrasZonasComunes());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "reformaOtroDescEdificio", activoInformeDto.getReformaOtroDescEdificio());
					
					// Inf general.
					if(!Checks.esNulo(activoInformeDto.getEstadoConservacionCodigo())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConservacionCodigo());
						DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) genericDao.get(DDEstadoConservacion.class, filtro);
						beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "estadoConservacionEdificio", estadoConservacion);
					}
					if(!Checks.esNulo(activoInformeDto.getEstadoConstruccionCodigo())) {
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getEstadoConstruccionCodigo());
						DDEstadoConstruccion estadoConstruccion = (DDEstadoConstruccion) genericDao.get(DDEstadoConstruccion.class, filtro);
						beanUtilNotNull.copyProperty(activo.getInfoComercial(), "estadoConstruccion", estadoConstruccion);
					}
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "numPlantas", activoInformeDto.getNumPlantas());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "ascensor", activoInformeDto.getAscensor());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "numAscensores", activoInformeDto.getNumAscensores());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "ediDescripcion", activoInformeDto.getEdiDescripcion());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "entornoInfraestructura", activoInformeDto.getEntornoInfraestructuras());
					beanUtilNotNull.copyProperty(activo.getInfoComercial().getEdificio(), "entornoComunicacion", activoInformeDto.getEntornoComunicaciones());
				}

				activo.setInfoComercial(genericDao.save(ActivoInfoComercial.class, activo.getInfoComercial()));
			}
			
			// Se actualizan los importes estimados de venta y de renta, sobre las valoraciones de este activo
			// Si para este activo no hay valoraciones del tipo estimado venta o renta, el metodo 
			//saveActivoInformeValoracion las creara
			
			// Actualiza o crea la valoracion de tipo Estimado Venta
			if (!Checks.esNulo(activoInformeDto.getValorEstimadoVenta())){
				Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter estimadoVentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
				ActivoValoraciones activoValoracionEstimadoVenta = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoVentaTPCFilter);
				
				DtoPrecioVigente dto = new DtoPrecioVigente();
				dto.setImporte(activoInformeDto.getValorEstimadoVenta());
				dto.setCodigoTipoPrecio(DDTipoPrecio.CODIGO_TPC_ESTIMADO_VENTA);
				dto.setFechaInicio(new Date());
				
				activoManager.saveActivoValoracion(activo, activoValoracionEstimadoVenta,dto);
			}
			
			// Actualiza o crea la valoracion de tipo Estimado Renta
			if (!Checks.esNulo(activoInformeDto.getValorEstimadoRenta())){
				Filter activoFilter = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Filter estimadoRentaTPCFilter = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_ESTIMADO_RENTA);
				ActivoValoraciones activoValoracionEstimadoRenta = (ActivoValoraciones) genericDao.get(ActivoValoraciones.class, activoFilter, estimadoRentaTPCFilter);
				
				DtoPrecioVigente dto = new DtoPrecioVigente();
				dto.setImporte(activoInformeDto.getValorEstimadoRenta());
				dto.setCodigoTipoPrecio(DDTipoPrecio.CODIGO_TPC_ESTIMADO_RENTA);
				dto.setFechaInicio(new Date());
				
				activoManager.saveActivoValoracion(activo, activoValoracionEstimadoRenta, dto);
			}

			// Actualizar los datos de comunidad de propietarios
			ActivoComunidadPropietarios comunidadPropietarios;
			if(!Checks.esNulo(activo.getComunidadPropietarios())) {
				comunidadPropietarios = activo.getComunidadPropietarios();
			} else {
				comunidadPropietarios = new ActivoComunidadPropietarios();
			}
			
			
			beanUtilNotNull.copyProperty(comunidadPropietarios, "constituida", activoInformeDto.getInscritaComunidad());
			beanUtilNotNull.copyProperty(activo.getInfoComercial(), "derramaOrientativaComunidad", activoInformeDto.getDerramaOrientativaComunidad());
			beanUtilNotNull.copyProperty(activo.getInfoComercial(), "cuotaOrientativaComunidad", activoInformeDto.getCuotaOrientativaComunidad());
			beanUtilNotNull.copyProperty(comunidadPropietarios, "nomPresidente", activoInformeDto.getNomPresidenteComunidad());
			beanUtilNotNull.copyProperty(comunidadPropietarios, "telfAdministrador", activoInformeDto.getTelAdministradorComunidad());
			beanUtilNotNull.copyProperty(comunidadPropietarios, "nomAdministrador", activoInformeDto.getNomAdministradorComunidad());
			beanUtilNotNull.copyProperty(comunidadPropietarios, "telfPresidente", activoInformeDto.getTelPresidenteComunidad());
			
			genericDao.save(ActivoComunidadPropietarios.class, comunidadPropietarios);

			activo.setComunidadPropietarios(comunidadPropietarios);
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
