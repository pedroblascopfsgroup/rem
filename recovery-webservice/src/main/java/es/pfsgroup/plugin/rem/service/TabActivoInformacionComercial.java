package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
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
		
		if (!Checks.esNulo(activo.getInfoComercial())) {
			BeanUtils.copyProperties(activoDto, activo.getInfoComercial());
			
			if (!Checks.esNulo(activo.getInfoComercial().getEdificio())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getEdificio());
				beanUtilNotNull.copyProperty(activoDto,"entornoInfraestructuras",activo.getInfoComercial().getEdificio().getEntornoInfraestructura());
				beanUtilNotNull.copyProperty(activoDto,"entornoComunicaciones",activo.getInfoComercial().getEdificio().getEntornoComunicacion());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getUbicacionActivo())) {
				BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getTipoInfoComercial())) {
				BeanUtils.copyProperty(activoDto, "tipoInfoComercialCodigo", activo.getInfoComercial().getTipoInfoComercial().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getUbicacionActivo())) {
				BeanUtils.copyProperty(activoDto, "ubicacionActivoCodigo", activo.getInfoComercial().getUbicacionActivo().getCodigo());
			}
		
			if (!Checks.esNulo(activo.getInfoComercial().getEstadoConstruccion())) {
				BeanUtils.copyProperty(activoDto, "estadoConstruccionCodigo", activo.getInfoComercial().getEstadoConstruccion().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getEstadoConservacion())) {
				BeanUtils.copyProperty(activoDto, "estadoConservacionCodigo", activo.getInfoComercial().getEstadoConservacion().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getEdificio()) && !Checks.esNulo(activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio())) {
				BeanUtils.copyProperty(activoDto, "estadoConservacionEdificioCodigo", activo.getInfoComercial().getEdificio().getEstadoConservacionEdificio().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getEdificio()) && !Checks.esNulo(activo.getInfoComercial().getEdificio().getTipoFachada())) {
				BeanUtils.copyProperty(activoDto, "tipoFachadaCodigo", activo.getInfoComercial().getEdificio().getTipoFachada().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
				BeanUtils.copyProperty(activoDto, "codigoMediador", activo.getInfoComercial().getMediadorInforme().getId());
				BeanUtils.copyProperty(activoDto, "nombreMediador", activo.getInfoComercial().getMediadorInforme().getNombre());
				BeanUtils.copyProperty(activoDto, "telefonoMediador", activo.getInfoComercial().getMediadorInforme().getTelefono1());
				BeanUtils.copyProperty(activoDto, "emailMediador", activo.getInfoComercial().getMediadorInforme().getEmail());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getInfoDistribucionInterior())) {
				BeanUtils.copyProperty(activoDto, "distribucionTxt", (activo.getInfoComercial()).getInfoDistribucionInterior());
			}
			
			if (activo.getInfoComercial() instanceof ActivoVivienda) {	
				if (!Checks.esNulo(activo.getInfoComercial().getTipoInfoComercial())) {						

					if (!Checks.esNulo(((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda())) {
						BeanUtils.copyProperty(activoDto, "tipoViviendaCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoVivienda().getCodigo());
					}
					
					if (!Checks.esNulo(((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion())) {
						BeanUtils.copyProperty(activoDto, "tipoOrientacionCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoOrientacion().getCodigo());
					}
					
					if (!Checks.esNulo(((ActivoVivienda)activo.getInfoComercial()).getTipoRenta())) {
						BeanUtils.copyProperty(activoDto, "tipoRentaCodigo", ((ActivoVivienda)activo.getInfoComercial()).getTipoRenta().getCodigo());
					}
					
					if (!Checks.esNulo(((ActivoVivienda)activo.getInfoComercial()).getDistribucionTxt())) {
						BeanUtils.copyProperty(activoDto, "distribucionTxt", ((ActivoVivienda)activo.getInfoComercial()).getDistribucionTxt());
					}
				}
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getInfraestructura())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getInfraestructura());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getCarpinteriaInterior())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCarpinteriaInterior());
				if (!Checks.esNulo(activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria())) {
					beanUtilNotNull.copyProperty(activoDto, "acabadoCarpinteriaCodigo", activo.getInfoComercial().getCarpinteriaInterior().getAcabadoCarpinteria().getCodigo());
				}
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getCarpinteriaExterior())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCarpinteriaExterior());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getParamentoVertical())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getParamentoVertical());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getSolado())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getSolado());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getCocina())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getCocina());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getBanyo())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getBanyo());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getInstalacion())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getInstalacion());
			}
			
			if (!Checks.esNulo(activo.getInfoComercial().getZonaComun())) {
				beanUtilNotNull.copyProperties(activoDto, activo.getInfoComercial().getZonaComun());
			}
		}
		
		if (!Checks.esNulo(activo.getTipoActivo())) {
			BeanUtils.copyProperty(activoDto, "tipoActivoCodigo", activo.getTipoActivo().getCodigo());
		}
		
		return activoDto;	
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		DtoActivoInformacionComercial dto = (DtoActivoInformacionComercial) webDto;
		
		try {
			if (Checks.esNulo(activo.getInfoComercial())) {
				activo.setInfoComercial(new ActivoInfoComercial());
				activo.getInfoComercial().setActivo(activo);
			}
			
			beanUtilNotNull.copyProperties(activo.getInfoComercial(), dto);
			
			activo.setInfoComercial(genericDao.save(ActivoInfoComercial.class, activo.getInfoComercial()));
			
			if (!Checks.esNulo(dto.getUbicacionActivoCodigo())) {
				DDUbicacionActivo ubicacionActivo = (DDUbicacionActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDUbicacionActivo.class, dto.getUbicacionActivoCodigo());
				activo.getInfoComercial().setUbicacionActivo(ubicacionActivo);
			}
			
			if (!Checks.esNulo(dto.getEstadoConstruccionCodigo())) {
				DDEstadoConstruccion estadoConstruccion = (DDEstadoConstruccion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConstruccion.class, dto.getEstadoConstruccionCodigo());
				activo.getInfoComercial().setEstadoConstruccion(estadoConstruccion);
			}
			
			if (!Checks.esNulo(dto.getEstadoConservacionCodigo())) {
				DDEstadoConservacion estadoConservacion = (DDEstadoConservacion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConservacion.class, dto.getEstadoConservacionCodigo());
				activo.getInfoComercial().setEstadoConservacion(estadoConservacion);
			}

			if (Checks.esNulo(activo.getInfoComercial().getEdificio())) {
				activo.getInfoComercial().setEdificio(new ActivoEdificio());
			}

			beanUtilNotNull.copyProperties(activo.getInfoComercial().getEdificio(), dto);
			activo.getInfoComercial().getEdificio().setInfoComercial(activo.getInfoComercial());
			activo.getInfoComercial().setEdificio(genericDao.save(ActivoEdificio.class, activo.getInfoComercial().getEdificio()));
			
			if (!Checks.esNulo(dto.getEstadoConservacionEdificioCodigo())) {
				
				DDEstadoConservacion estadoConservacionEdificio = (DDEstadoConservacion) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoConservacion.class, dto.getEstadoConservacionEdificioCodigo());
	
				activo.getInfoComercial().getEdificio().setEstadoConservacionEdificio(estadoConservacionEdificio);
			}
			
			if (!Checks.esNulo(dto.getTipoFachadaCodigo())) {
				DDTipoFachada tipoFachada = (DDTipoFachada) 
						diccionarioApi.dameValorDiccionarioByCod(DDTipoFachada.class, dto.getTipoFachadaCodigo());
	
				activo.getInfoComercial().getEdificio().setTipoFachada(tipoFachada);
			}
				
			if (activo.getInfoComercial() instanceof ActivoVivienda) {
				if (!Checks.esNulo(dto.getTipoViviendaCodigo())) {
					DDTipoVivienda tipoVivienda = (DDTipoVivienda) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoVivienda.class, dto.getTipoViviendaCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoVivienda(tipoVivienda);
				}
				
				if (!Checks.esNulo(dto.getTipoRentaCodigo())) {
					DDTipoRenta tipoRenta = (DDTipoRenta) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoRenta.class, dto.getTipoRentaCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoRenta(tipoRenta);
				}
				
				if (!Checks.esNulo(dto.getTipoOrientacionCodigo())) {
					DDTipoOrientacion tipoOrientacion = (DDTipoOrientacion) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoOrientacion.class, dto.getTipoOrientacionCodigo());
		
					ActivoVivienda vivienda = (ActivoVivienda) activo.getInfoComercial();
					vivienda.setTipoOrientacion(tipoOrientacion);
				}
			} else if (activo.getInfoComercial() instanceof ActivoPlazaAparcamiento) {
				ActivoPlazaAparcamiento plazaAparcamiento = (ActivoPlazaAparcamiento) activo.getInfoComercial();
				
				if (!Checks.esNulo(dto.getUbicacionAparcamientoCodigo())) {
					DDTipoUbicaAparcamiento ubicacionAparcamiento = (DDTipoUbicaAparcamiento) 
							diccionarioApi.dameValorDiccionarioByCod(DDTipoUbicaAparcamiento.class, dto.getUbicacionAparcamientoCodigo());

					plazaAparcamiento.setUbicacionAparcamiento(ubicacionAparcamiento);
				}
				
				if (!Checks.esNulo(dto.getTipoCalidadCodigo())) {
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