package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;


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
				// Copia al "informe comercial" todos los atributos de "informacion comercial"
				beanUtilNotNull.copyProperties(informeComercial,  activo.getInfoComercial());
				
				if (activo.getInfoComercial().getProvincia() != null) {
					informeComercial.setProvinciaCodigo(activo.getInfoComercial().getProvincia().getCodigo());
				}
				
				if (activo.getInfoComercial().getLocalidad() != null) {
					informeComercial.setMunicipioCodigo(activo.getInfoComercial().getLocalidad().getCodigo());
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
			// para añadir al Dto
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
			
			// Datos de la Comunidad de vecinos al Dto
			if (!Checks.esNulo(activo.getComunidadPropietarios())){
				ActivoComunidadPropietarios comunidadPropietarios = new ActivoComunidadPropietarios();
				comunidadPropietarios = activo.getComunidadPropietarios();
				
				// Comunidad inscrita = constituida
				beanUtilNotNull.copyProperty(informeComercial, "inscritaComunidad", comunidadPropietarios.getConstituida());
				// Cuota de la comunidad, tomada del importe medio
				beanUtilNotNull.copyProperty(informeComercial, "cuotaComunidad", comunidadPropietarios.getImporteMedio());
				// Nombre y telefono Presidente
				beanUtilNotNull.copyProperty(informeComercial, "nomPresidenteComunidad", comunidadPropietarios.getNomPresidente());
				beanUtilNotNull.copyProperty(informeComercial, "telPresidenteComunidad", comunidadPropietarios.getTelfPresidente());
				// Nombre y telefono Administrador
				beanUtilNotNull.copyProperty(informeComercial, "nomAdministradorComunidad", comunidadPropietarios.getNomAdministrador());
				beanUtilNotNull.copyProperty(informeComercial, "telAdministradorComunidad", comunidadPropietarios.getTelfAdministrador());
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
				
				if (activoInformeDto.getProvinciaCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getProvinciaCodigo());
					Filter borrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtro, borrado);
					
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "provincia", provincia);
				}
				
				if (activoInformeDto.getMunicipioCodigo() != null) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activoInformeDto.getMunicipioCodigo());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtro);
					
					beanUtilNotNull.copyProperty(activo.getInfoComercial(), "localidad", localidad);
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
			ActivoComunidadPropietarios comunidadPropietarios = new ActivoComunidadPropietarios();
			comunidadPropietarios = activo.getComunidadPropietarios();
			
			if (!Checks.esNulo(activoInformeDto.getInscritaComunidad())) 
				comunidadPropietarios.setConstituida(activoInformeDto.getInscritaComunidad());
			
			if (!Checks.esNulo(activoInformeDto.getNomPresidenteComunidad()))
				comunidadPropietarios.setNomPresidente(activoInformeDto.getNomPresidenteComunidad());
			
			if (!Checks.esNulo(activoInformeDto.getTelAdministradorComunidad()))
				comunidadPropietarios.setTelfPresidente(activoInformeDto.getTelAdministradorComunidad());
			
			if (!Checks.esNulo(activoInformeDto.getNomAdministradorComunidad()))
				comunidadPropietarios.setNomAdministrador(activoInformeDto.getNomAdministradorComunidad());
			
			if (!Checks.esNulo(activoInformeDto.getTelAdministradorComunidad()))
				comunidadPropietarios.setTelfAdministrador(activoInformeDto.getTelAdministradorComunidad());

			activo.setComunidadPropietarios(comunidadPropietarios);
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
