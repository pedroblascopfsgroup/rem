package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;

@Component
public class TabActivoDatosRegistrales implements TabActivoService {
    
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
		return new String[]{TabActivoService.TAB_DATOS_REGISTRALES};
	}
	
	
	public DtoActivoDatosRegistrales getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoDatosRegistrales activoDto = new DtoActivoDatosRegistrales();
		
		BeanUtils.copyProperties(activoDto, activo);
		if (activo.getInfoRegistral() != null) {
			BeanUtils.copyProperties(activoDto, activo.getInfoRegistral());
		}
		if (activo.getAdjNoJudicial() != null) {
			BeanUtils.copyProperties(activoDto, activo.getAdjNoJudicial());
		}
		
		if (!Checks.estaVacio(activo.getPdvs())) {
			BeanUtils.copyProperties(activoDto, activo.getPdvs().get(0));
		}
		
		if (activo.getTitulo() != null) {
			BeanUtils.copyProperties(activoDto, activo.getTitulo());
			if (activo.getTitulo().getEstado() != null) {
				if (activo.getTitulo().getEstado() != null) {
					BeanUtils.copyProperty(activoDto, "estadoTitulo", activo.getTitulo().getEstado().getCodigo());
				}
			}
		}
		
		if (activo.getInfoRegistral() != null) {
			BeanUtils.copyProperties(activoDto, activo.getInfoRegistral().getInfoRegistralBien());
			
			if (activo.getInfoRegistral().getEstadoDivHorizontal() != null ) {
				BeanUtils.copyProperty(activoDto, "estadoDivHorizontalCodigo", activo.getInfoRegistral().getEstadoDivHorizontal().getCodigo());
			}
			
			if(activo.getInfoRegistral().getDivHorInscrito() == null) {
				activoDto.setDivHorInscrito(null);
			}
			
			if (activo.getInfoRegistral().getEstadoObraNueva() != null ) {
				BeanUtils.copyProperty(activoDto, "estadoObraNuevaCodigo", activo.getInfoRegistral().getEstadoObraNueva().getCodigo());
			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getLocalidad() != null) {
				BeanUtils.copyProperty(activoDto, "poblacionRegistro", activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getCodigo());
			}

			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaRegistro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getCodigo());
			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getLocalidadAnterior() != null) {
				BeanUtils.copyProperty(activoDto, "localidadAnteriorCodigo", activo.getInfoRegistral().getLocalidadAnterior().getCodigo());
			}
			
			if (activo.getTipoTitulo() != null) {
				BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
			}
			if (activo.getSubtipoTitulo() != null) {
				BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
			}
			if (activo.getCartera() != null) {
				BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			}
			
		}
		
		if (activo.getAdjJudicial() != null) {
			
			BeanUtils.copyProperties(activoDto, activo.getAdjJudicial());
			
			if (activo.getAdjJudicial().getAdjudicacionBien() != null) {
				BeanUtils.copyProperties(activoDto, activo.getAdjJudicial().getAdjudicacionBien());

				if (activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria() != null) {
					BeanUtils.copyProperty(activoDto, "entidadAdjudicatariaCodigo", activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria().getCodigo());
				}
					
			}
			
			if (activo.getAdjJudicial().getEntidadEjecutante() != null) {
				BeanUtils.copyProperty(activoDto, "entidadEjecutanteCodigo", activo.getAdjJudicial().getEntidadEjecutante().getCodigo());
			}

			if (activo.getAdjJudicial().getJuzgado() != null) {
				BeanUtils.copyProperty(activoDto, "tipoJuzgadoCodigo", activo.getAdjJudicial().getJuzgado().getCodigo());
			}
			
			if (activo.getAdjJudicial().getPlazaJuzgado() != null) {
				BeanUtils.copyProperty(activoDto, "tipoPlazaCodigo", activo.getAdjJudicial().getPlazaJuzgado().getCodigo());
			}
			
			if (activo.getAdjJudicial().getEstadoAdjudicacion() != null) {
				BeanUtils.copyProperty(activoDto, "estadoAdjudicacionCodigo", activo.getAdjJudicial().getEstadoAdjudicacion().getCodigo());

			}
			
		}

		
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoDatosRegistrales dto = (DtoActivoDatosRegistrales) webDto;
		
		try {
			
			if (activo.getInfoRegistral() == null) {
				activo.setInfoRegistral(new ActivoInfoRegistral());
				activo.getInfoRegistral().setActivo(activo);

			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() == null) {
				activo.getInfoRegistral().setInfoRegistralBien(new NMBInformacionRegistralBien());
				activo.getInfoRegistral().getInfoRegistralBien().setBien(activo.getBien());
			}
			
			beanUtilNotNull.copyProperties(activo, dto);
			//beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), dto);
			beanUtilNotNull.copyProperties(activo.getInfoRegistral(), dto);
			beanUtilNotNull.copyProperties(activo.getInfoRegistral().getInfoRegistralBien(), dto);
		
			if (activo.getTitulo() == null) {
				activo.setTitulo(new ActivoTitulo());
				activo.getTitulo().setActivo(activo);
			}

			if (dto.getEstadoTitulo() != null) {
				
				DDEstadoTitulo estadoTituloNuevo = (DDEstadoTitulo) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, dto.getEstadoTitulo());
		
				activo.getTitulo().setEstado(estadoTituloNuevo);
			
			}
			
			if (activo.getDivHorizontal() != 0) {
				
				DDEstadoDivHorizontal estadoDivHorizontal = null;
				
				if (dto.getEstadoDivHorizontalCodigo() != null) {
					
					estadoDivHorizontal = (DDEstadoDivHorizontal) 
							diccionarioApi.dameValorDiccionarioByCod(DDEstadoDivHorizontal.class,  dto.getEstadoDivHorizontalCodigo());
				}
				
				activo.getInfoRegistral().setEstadoDivHorizontal(estadoDivHorizontal);
			
			} else {
				activo.getInfoRegistral().setEstadoDivHorizontal(null);
				activo.getInfoRegistral().setDivHorInscrito(null);
			}
			
			activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(NMBInformacionRegistralBien.class, activo.getInfoRegistral().getInfoRegistralBien())));
			activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class, activo.getInfoRegistral())));
			
			if (dto.getEstadoObraNuevaCodigo() != null) {
				
				DDEstadoObraNueva estadoObraNueva = (DDEstadoObraNueva) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoObraNueva.class, dto.getEstadoObraNuevaCodigo());
				
				activo.getInfoRegistral().setEstadoObraNueva(estadoObraNueva);
				
			}
			
			if (dto.getLocalidadAnteriorCodigo() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadAnteriorCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().setLocalidadAnterior(municipioNuevo);	
				
			}
			
			if (dto.getPoblacionRegistro() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPoblacionRegistro());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(municipioNuevo);
				
			}
			
			if (dto.getPoblacionRegistro() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPoblacionRegistro());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(municipioNuevo);
				activo.getInfoRegistral().getInfoRegistralBien().setProvincia(municipioNuevo.getProvincia());
				
			}
			
			activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(NMBInformacionRegistralBien.class, activo.getInfoRegistral().getInfoRegistralBien())));
			activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class, activo.getInfoRegistral())));
			
			
			if (dto.getTipoTituloCodigo() != null) {
				
				DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class, dto.getTipoTituloCodigo());
				
				activo.setTipoTitulo(tipoTitulo);
				
			}
			
			if (dto.getSubtipoTituloCodigo() != null) {
				
				DDSubtipoTituloActivo subtipoTitulo = (DDSubtipoTituloActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dto.getSubtipoTituloCodigo());
				
				activo.setSubtipoTitulo(subtipoTitulo);
				
			}
                     
			if (activo.getTipoTitulo() != null) {
				
				if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloNoJudicial)) {
					
					if (activo.getAdjNoJudicial() == null) {
						activo.setAdjNoJudicial(new ActivoAdjudicacionNoJudicial());
						activo.getAdjNoJudicial().setActivo(activo);
					}
					beanUtilNotNull.copyProperties(activo.getAdjNoJudicial(), dto);
					
					activo.setAdjNoJudicial((genericDao.save(ActivoAdjudicacionNoJudicial.class, activo.getAdjNoJudicial())));
					
				} else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloPDV)) {
					ActivoPlanDinVentas pdv = null;
					if (Checks.estaVacio(activo.getPdvs())) {
						 pdv = new ActivoPlanDinVentas();
						 pdv.setActivo(activo);
						 beanUtilNotNull.copyProperties(pdv, dto);
						 genericDao.save(ActivoPlanDinVentas.class, pdv);
						 activo.getPdvs().add(pdv);
					} else {
						pdv = activo.getPdvs().get(0);						
						beanUtilNotNull.copyProperties(pdv, dto);
						genericDao.update(ActivoPlanDinVentas.class, pdv);
					}


				} else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloJudicial)) {
					
					if (activo.getAdjJudicial() == null) {
						activo.setAdjJudicial(new ActivoAdjudicacionJudicial());
						activo.getAdjJudicial().setActivo(activo);
					}
					beanUtilNotNull.copyProperties(activo.getAdjJudicial(), dto);
					
					
					if (activo.getAdjJudicial().getAdjudicacionBien() == null) {
						activo.getAdjJudicial().setAdjudicacionBien(new NMBAdjudicacionBien());
						activo.getAdjJudicial().getAdjudicacionBien().setBien(activo.getBien());
					}
						
					beanUtilNotNull.copyProperties(activo.getAdjJudicial().getAdjudicacionBien(), dto);
					
					activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(NMBAdjudicacionBien.class, activo.getAdjJudicial().getAdjudicacionBien())));


					
					if (dto.getEntidadAdjudicatariaCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEntidadAdjudicatariaCodigo());
						DDEntidadAdjudicataria entidadAdjudicataria = (DDEntidadAdjudicataria) genericDao.get(DDEntidadAdjudicataria.class, filtro);
		
						activo.getAdjJudicial().getAdjudicacionBien().setEntidadAdjudicataria(entidadAdjudicataria);						
						
					}
					
					if (dto.getEntidadEjecutanteCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEntidadEjecutanteCodigo());
						DDEntidadEjecutante entidadEjecutante = (DDEntidadEjecutante) genericDao.get(DDEntidadEjecutante.class, filtro);
		
						activo.getAdjJudicial().setEntidadEjecutante(entidadEjecutante);					
						
					}

					if (dto.getTipoJuzgadoCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoJuzgadoCodigo());
						TipoJuzgado juzgado = (TipoJuzgado) genericDao.get(TipoJuzgado.class, filtro);
						
						activo.getAdjJudicial().setJuzgado(juzgado);
					}
					
					if (dto.getTipoPlazaCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoPlazaCodigo());
						TipoPlaza plazaJuzgado = (TipoPlaza) genericDao.get(TipoPlaza.class, filtro);
						
						activo.getAdjJudicial().setPlazaJuzgado(plazaJuzgado);
					}
					
					if (dto.getEstadoAdjudicacionCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoAdjudicacionCodigo());
						DDEstadoAdjudicacion estadoAdjudicacion = (DDEstadoAdjudicacion) genericDao.get(DDEstadoAdjudicacion.class, filtro);
						
						activo.getAdjJudicial().setEstadoAdjudicacion(estadoAdjudicacion);
					}
					
					activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(NMBAdjudicacionBien.class, activo.getAdjJudicial().getAdjudicacionBien())));
					activo.setAdjJudicial((genericDao.save(ActivoAdjudicacionJudicial.class, activo.getAdjJudicial())));

				}
			
			} 
			

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
