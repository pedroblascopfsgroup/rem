package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEdificio;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoPlazaAparcamiento;
import es.pfsgroup.plugin.rem.model.ActivoVivienda;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConservacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoConstruccion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFachada;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOrientacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRenta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicaAparcamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;

@Component
public class TabActivoInformacionComercial implements TabActivoService {
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_INFORMACION_COMERCIAL};
	}
	
	
	public DtoActivoInformacionComercial getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoInformacionComercial activoDto = new DtoActivoInformacionComercial();
		
		if (activo.getInfoComercial() != null) {
			BeanUtils.copyProperties(activoDto, activo.getInfoComercial());
			
			if (activo.getInfoComercial().getEdificio() != null) {
				BeanUtils.copyProperties(activoDto, activo.getInfoComercial().getEdificio());
			}
			
			if (activo.getInfoComercial().getUbicacionActivo() != null) {
				BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo());
			}
			
			if (activo.getInfoComercial().getTipoInfoComercial() != null) {
				BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
			}
			
			if (activo.getInfoComercial().getUbicacionActivo() != null) {
				BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo().getCodigo());
			}
		
			if (activo.getInfoComercial().getEstadoConstruccion() != null) {
				BeanUtils.copyProperty(activoDto, "estadoConstruccionCodigo", activo.getInfoComercial().getEstadoConstruccion().getCodigo());
			}
			
			if (activo.getInfoComercial().getEstadoConservacion() != null) {
				BeanUtils.copyProperty(activoDto, "estadoConservacionCodigo", activo.getInfoComercial().getEstadoConservacion().getCodigo());
			}
			
			if (activo.getInfoComercial().getEdificio() != null && activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio() != null) {
				BeanUtils.copyProperty(activoDto, "estadoConservacionEdificioCodigo", activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio().getCodigo());
			}
			
			if (activo.getInfoComercial().getEdificio() != null && activo.getInfoComercial().getEdificio().getTipoFachada() != null) {
				BeanUtils.copyProperty(activoDto, "tipoFachadaCodigo", activo.getInfoComercial().getEdificio().getTipoFachada().getCodigo());
			}
			
			if (activo.getInfoComercial().getMediadorInforme() != null) {
				BeanUtils.copyProperty(activoDto, "codigoMediador", activo.getInfoComercial().getMediadorInforme().getId());
				BeanUtils.copyProperty(activoDto, "nombreMediador", activo.getInfoComercial().getMediadorInforme().getNombre());
				BeanUtils.copyProperty(activoDto, "telefonoMediador", activo.getInfoComercial().getMediadorInforme().getTelefono1());
				BeanUtils.copyProperty(activoDto, "emailMediador", activo.getInfoComercial().getMediadorInforme().getEmail());
			}
			
			if (activo.getInfoComercial() instanceof ActivoVivienda)
			{	
				if (activo.getInfoComercial().getTipoInfoComercial() != null) {						

					if (((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda() != null) {
						BeanUtils.copyProperty(activoDto, "tipoViviendaCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda().getCodigo());
					}
					
					if (((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion() != null) {
						BeanUtils.copyProperty(activoDto, "tipoOrientacionCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion().getCodigo());
					}
					
					if (((ActivoVivienda)activo.getInfoComercial()).getTipoRenta() != null) {
						BeanUtils.copyProperty(activoDto, "tipoRentaCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoRenta().getCodigo());
					}
				}
			}
			
			if (activo.getInfoComercial().getInfraestructura()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getInfraestructura());
			}
			
			if (activo.getInfoComercial().getCarpinteriaInterior()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCarpinteriaInterior());
				if (activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria()!=null)
				{
					beanUtilNotNull.copyProperty(activoDto, "acabadoCarpinteriaCodigo", activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria().getCodigo());
				}
			}
			
			if (activo.getInfoComercial().getCarpinteriaExterior()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCarpinteriaExterior());
			}
			
			if (activo.getInfoComercial().getParamentoVertical()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getParamentoVertical());
			}
			
			if (activo.getInfoComercial().getSolado()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getSolado());
			}
			
			if (activo.getInfoComercial().getCocina()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCocina());
			}
			
			if (activo.getInfoComercial().getBanyo()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getBanyo());
			}
			
			if (activo.getInfoComercial().getInstalacion()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getInstalacion());
			}
			
			if (activo.getInfoComercial().getZonaComun()!=null)
			{
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getZonaComun());
			}
		}
		
		if (activo.getTipoActivo() != null)
		{
			BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
		}
		
		return activoDto;	
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoInformacionComercial dto = (DtoActivoInformacionComercial) webDto;
		
		try {
			
			if (activo.getInfoComercial() == null) {
				activo.setInfoComercial(new ActivoInfoComercial());
				activo.getInfoComercial().setActivo(activo);
			}
			
			beanUtilNotNull.copyProperties(activo.getInfoComercial(), dto);
			
			activo.setInfoComercial(genericDao.save(ActivoInfoComercial.class, activo.getInfoComercial()));
			
			if (dto.getUbicacionActivoCodigo() != null)
			{
				DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDUbicacionActivo.class, dto.getUbicacionActivoCodigo());
				activo.getInfoComercial().setUbicacionActivo(ubicacionActivo);
			}
			if (dto.getEstadoConstruccionCodigo() != null)
			{
				DDEstadoConstruccion estadoConstruccion = (DDEstadoConstruccion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConstruccion.class, dto.getEstadoConstruccionCodigo());
				activo.getInfoComercial().setEstadoConstruccion(estadoConstruccion);
			}
			if (dto.getEstadoConservacionCodigo() != null)
			{
				DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConservacion.class, dto.getEstadoConservacionCodigo());
				activo.getInfoComercial().setEstadoConservacion(estadoConservacion);
			}

			if (activo.getInfoComercial().getEdificio() == null) {
				activo.getInfoComercial().setEdificio(new ActivoEdificio());
			}

			beanUtilNotNull.copyProperties(activo.getInfoComercial().getEdificio(), dto);
			activo.getInfoComercial().getEdificio().setInfoComercial(activo.getInfoComercial());
			activo.getInfoComercial().setEdificio(genericDao.save(ActivoEdificio.class, activo.getInfoComercial().getEdificio()));
			
			if (dto.getEstadoConservacionEdificioCodigo() != null) {
				
				DDEstadoConservacion estadoConservacionEdificio = (DDEstadoConservacion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConservacion.class, dto.getEstadoConservacionEdificioCodigo());
	
				activo.getInfoComercial().getEdificio().setEstadoConservacionEdificio(estadoConservacionEdificio);
				
			}
			
			if (dto.getTipoFachadaCodigo() != null) {
				
				DDTipoFachada tipoFachada = (DDTipoFachada) 
						diccionarioApi.dameValorDiccionarioByCod(DDTipoFachada.class, dto.getTipoFachadaCodigo());
	
				activo.getInfoComercial().getEdificio().setTipoFachada(tipoFachada);
				
			}
				
			if (activo.getInfoComercial() instanceof ActivoVivienda)
			{
				if (dto.getTipoViviendaCodigo() != null) {
					DDTipoVivienda tipoVivienda = (DDTipoVivienda) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoVivienda.class, dto.getTipoViviendaCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoVivienda(tipoVivienda);
				}
				if (dto.getTipoRentaCodigo() != null) {
					DDTipoRenta tipoRenta = (DDTipoRenta) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoRenta.class, dto.getTipoRentaCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoRenta(tipoRenta);
				}
				if (dto.getTipoOrientacionCodigo() != null) {
					DDTipoOrientacion tipoOrientacion = (DDTipoOrientacion) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoOrientacion.class, dto.getTipoOrientacionCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoOrientacion(tipoOrientacion);
				}
				
			}
			else if (activo.getInfoComercial() instanceof ActivoPlazaAparcamiento)
			{
				ActivoPlazaAparcamiento plazaAparcamiento = (ActivoPlazaAparcamiento) activo.getInfoComercial();
				
				if (dto.getUbicacionAparcamientoCodigo() != null) {
					DDTipoUbicaAparcamiento ubicacionAparcamiento = (DDTipoUbicaAparcamiento) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoUbicaAparcamiento.class, dto.getUbicacionAparcamientoCodigo());

					plazaAparcamiento.setUbicacionAparcamiento(ubicacionAparcamiento);
					
				}
				if (dto.getTipoCalidadCodigo() != null) {
					DDTipoCalidad tipoCalidad = (DDTipoCalidad) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoCalidad.class, dto.getTipoRentaCodigo());

					plazaAparcamiento.setTipoCalidad(tipoCalidad);
				}	
				
				activo.setInfoComercial(plazaAparcamiento);
				
			} //No hace falta if para ActivoLocalComercial porque tiene diccionarios
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
