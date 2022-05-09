package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.HistoricoPeticionesPrecios;
import es.pfsgroup.plugin.rem.model.HistoricoRequisitosFaseVenta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.model.dd.DDTributacionAdquisicion;
import es.pfsgroup.plugin.rem.rest.dto.ReqFaseVentaDto;



@Component
public class TabActivoInfoAdministrativa implements TabActivoService {
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_INFO_ADMINISTRATIVA};
	}
	
	
	public DtoActivoInformacionAdministrativa getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoInformacionAdministrativa activoDto = new DtoActivoInformacionAdministrativa();
		
		// Si es una UA cogemos los datos del activo matriz
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		
		if(esUA) {
			//Cuando es una UA, cargamos los datos de su AM
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if (!Checks.esNulo(agrupacion)) {
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (!Checks.esNulo(activoMatriz)) {
					if (activoMatriz.getInfoAdministrativa() != null) {
						BeanUtils.copyProperties(activoDto, activoMatriz.getInfoAdministrativa());
						if (activoMatriz.getInfoAdministrativa().getTipoVpo() != null) {
							BeanUtils.copyProperty(activoDto, "tipoVpoId", activoMatriz.getInfoAdministrativa().getTipoVpo().getId());
							BeanUtils.copyProperty(activoDto, "tipoVpoCodigo", activoMatriz.getInfoAdministrativa().getTipoVpo().getCodigo());
							BeanUtils.copyProperty(activoDto, "tipoVpoDescripcion", activoMatriz.getInfoAdministrativa().getTipoVpo().getDescripcion());
						}
					}
					
					BeanUtils.copyProperty(activoDto, "vpo", activoMatriz.getVpo());
				}
				
			}
			
		}
		
		else {
		
			if (activo.getInfoAdministrativa() != null) {
				BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
				if (activo.getInfoAdministrativa().getTipoVpo() != null) {
					BeanUtils.copyProperty(activoDto, "tipoVpoId", activo.getInfoAdministrativa().getTipoVpo().getId());
					BeanUtils.copyProperty(activoDto, "tipoVpoCodigo", activo.getInfoAdministrativa().getTipoVpo().getCodigo());
					BeanUtils.copyProperty(activoDto, "tipoVpoDescripcion", activo.getInfoAdministrativa().getTipoVpo().getDescripcion());
				}
			}
			
			BeanUtils.copyProperty(activoDto, "vpo", activo.getVpo());
		
		}
		
		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
			activoDto.setCamposPropagablesUas(TabActivoService.TAB_INFO_ADMINISTRATIVA);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoDto.setCamposPropagables(TabActivoService.TAB_INFO_ADMINISTRATIVA);
		}
		
		// datos informacion relacionada con VPO
		if (!Checks.esNulo(activo.getInfoAdministrativa())) {
			activoDto.setVigencia(activo.getInfoAdministrativa().getVigencia());
			activoDto.setComunicarAdquisicion(activo.getInfoAdministrativa().getComunicarAdquisicion());
			activoDto.setNecesarioInscribirVpo(activo.getInfoAdministrativa().getNecesarioInscribirVpo());
			activoDto.setLibertadCesion(activo.getInfoAdministrativa().getLibertadCesion());
			activoDto.setRenunciaTanteoRetrac(activo.getInfoAdministrativa().getRenunciaTanteoRetrac());
			activoDto.setVisaContratoPriv(activo.getInfoAdministrativa().getVisaContratoPriv());
			activoDto.setVenderPersonaJuridica(activo.getInfoAdministrativa().getVenderPersonaJuridica());
			activoDto.setMinusvalia(activo.getInfoAdministrativa().getMinusvalia());
			activoDto.setInscripcionRegistroDemVpo(activo.getInfoAdministrativa().getInscripcionRegistroDemVpo());
			activoDto.setIngresosInfNivel(activo.getInfoAdministrativa().getIngresosInfNivel());
			activoDto.setResidenciaComAutonoma(activo.getInfoAdministrativa().getResidenciaComAutonoma());
			activoDto.setNoTitularOtraVivienda(activo.getInfoAdministrativa().getNoTitularOtraVivienda());
			if(activo.getInfoAdministrativa().getTributacionAdquisicion() != null) {
				activoDto.setTributacionAdq(activo.getInfoAdministrativa().getTributacionAdquisicion().getCodigo());
				activoDto.setTributacionAdqDescripcion(activo.getInfoAdministrativa().getTributacionAdquisicion().getDescripcion());
			}
			activoDto.setFechaLiqComplementaria(activo.getInfoAdministrativa().getFechaLiqComplementaria());
			activoDto.setFechaVencTpoBonificacion(activo.getInfoAdministrativa().getFechaVencTpoBonificacion());
			
			activoDto.setFechaSoliCertificado(activo.getInfoAdministrativa().getFechaSolCertificado());
			activoDto.setFechaComAdquisicion(activo.getInfoAdministrativa().getFechaComAdquision());
			activoDto.setFechaComRegDemandantes(activo.getInfoAdministrativa().getFechaComRegDem());
			activoDto.setFechaVencimiento(activo.getInfoAdministrativa().getFechaVencimiento());
			
			if(activo.getInfoAdministrativa().getActualizaPrecioMax() != null) {
				activoDto.setActualizaPrecioMaxId(activo.getInfoAdministrativa().getActualizaPrecioMax().getCodigo().equals(DDSinSiNo.CODIGO_NO) ? 0L : 1L);				
			}
			if(activo.getInfoAdministrativa().getFechaRecepcionRespuestaOrganismo() != null) {
				activoDto.setFechaRecepcionRespuestaOrganismo(activo.getInfoAdministrativa().getFechaRecepcionRespuestaOrganismo());
			}
			if(activo.getInfoAdministrativa().getFechaEnvioComunicacionOrganismo() != null) {
				activoDto.setFechaEnvioComunicacionOrganismo(activo.getInfoAdministrativa().getFechaEnvioComunicacionOrganismo());
			}
			if(activo.getInfoAdministrativa().getEstadoVenta() != null) {
				activoDto.setEstadoVentaCodigo(activo.getInfoAdministrativa().getEstadoVenta().getCodigo());
				activoDto.setEstadoVentaDescripcion(activo.getInfoAdministrativa().getEstadoVenta().getDescripcion());
			}
			try {
				List<ReqFaseVentaDto> requisitosVenta = activoApi.getReqFaseVenta(activo.getId());
						
				if(requisitosVenta != null && !requisitosVenta.isEmpty()) {
					for (int i = 0; i < requisitosVenta.size(); i++) {
						ReqFaseVentaDto req = requisitosVenta.get(i);
						if(req.getFechavencimiento() != null && req.getPreciomaximo() != null) {
							activoDto.setMaxPrecioVenta("" + req.getPreciomaximo());
							String dateStr = req.getFechavencimiento().split(" ")[0];
						    Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);  
							activoDto.setFechaVencimiento(date);
							break;
						}
					}
				}
			}catch (Exception e) {
				e.printStackTrace();
			}
			
			if (activo.getInfoAdministrativa().getMaxPrecioModuloAlquiler() != null) {
				activoDto.setMaxPrecioModuloAlquiler(String.valueOf(activo.getInfoAdministrativa().getMaxPrecioModuloAlquiler()));
			}
			if (activo.getInfoAdministrativa().getCompradorAcojeAyuda() != null) {
				activoDto.setCompradorAcojeAyuda(activo.getInfoAdministrativa().getCompradorAcojeAyuda());
			}
			if (activo.getInfoAdministrativa().getImporteAyudaFinanciacion() != null) {
				activoDto.setImporteAyudaFinanciacion(activo.getInfoAdministrativa().getImporteAyudaFinanciacion());
			}
			if (activo.getInfoAdministrativa().getFechaVencimientoAvalSeguro() != null) {
				activoDto.setFechaVencimientoAvalSeguro(activo.getInfoAdministrativa().getFechaVencimientoAvalSeguro());
			}
			if (activo.getInfoAdministrativa().getFechaDevolucionAyuda() != null) {
				activoDto.setFechaDevolucionAyuda(activo.getInfoAdministrativa().getFechaDevolucionAyuda());
			}
		}
		
		
		return activoDto;		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoInformacionAdministrativa dto = (DtoActivoInformacionAdministrativa) webDto;
		
		try {
			
			if (activo.getInfoAdministrativa() == null) {
				activo.setInfoAdministrativa(new ActivoInfAdministrativa());
				activo.getInfoAdministrativa().setActivo(activo);
			}
				
			beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), dto);
			
			DDTributacionAdquisicion tributacion = (DDTributacionAdquisicion) diccionarioApi.dameValorDiccionarioByCod(DDTributacionAdquisicion.class, dto.getTributacionAdq());
			activo.getInfoAdministrativa().setTributacionAdquisicion(tributacion);
			activo.getInfoAdministrativa().setFechaLiqComplementaria(dto.getFechaLiqComplementaria());
			activo.getInfoAdministrativa().setFechaVencTpoBonificacion(dto.getFechaVencTpoBonificacion());
			
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
			
			ActivoInfAdministrativa infoAdministrativa = activo.getInfoAdministrativa();
			
			if (dto.getTipoVpoCodigo() != null) {
			
				DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, dto.getTipoVpoCodigo());
				infoAdministrativa.setTipoVpo(tipoVpo);
			}
			
			if(infoAdministrativa.getTipoVpo() != null) {
				
				if(dto.getFechaSoliCertificado() != null) {
					infoAdministrativa.setFechaSolCertificado(dto.getFechaSoliCertificado());					
				}
				
				if(dto.getFechaComAdquisicion() != null) {
					infoAdministrativa.setFechaComAdquisicion(dto.getFechaComAdquisicion());
				}
				
				if(dto.getFechaComRegDemandantes() != null) {
					infoAdministrativa.setFechaComRegDem(dto.getFechaComRegDemandantes());					
				}
				
				if(dto.getActualizaPrecioMaxId() != null) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", (dto.getActualizaPrecioMaxId() == 0) ? DDSinSiNo.CODIGO_NO : DDSinSiNo.CODIGO_SI);
					DDSinSiNo mapeadoSinSiNo =genericDao.get(DDSinSiNo.class, filter); 
					infoAdministrativa.setActualizaPrecioMax(mapeadoSinSiNo);					
				}
				
				if(dto.getFechaVencimiento() != null) {
					infoAdministrativa.setFechaVencimiento(dto.getFechaVencimiento());					
				}
				
				if(dto.getFechaEnvioComunicacionOrganismo() != null) {
					infoAdministrativa.setFechaEnvioComunicacionOrganismo(dto.getFechaEnvioComunicacionOrganismo());
				}
				
				if(dto.getFechaRecepcionRespuestaOrganismo() != null) {
					infoAdministrativa.setFechaRecepcionRespuestaOrganismo(dto.getFechaRecepcionRespuestaOrganismo());
				}
				
				if(dto.getEstadoVentaCodigo() != null) {
					Filter filterEstadoVenta = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoVentaCodigo());
					DDEstadoVenta ddEstadoVenta = genericDao.get(DDEstadoVenta.class, filterEstadoVenta); 
					infoAdministrativa.setEstadoVenta(ddEstadoVenta);	
				}
				
				if (dto.getMaxPrecioModuloAlquiler() != null) {
					infoAdministrativa.setMaxPrecioModuloAlquiler(Double.parseDouble(dto.getMaxPrecioModuloAlquiler()));
				}
				
				if (dto.getCompradorAcojeAyuda() != null) {
					infoAdministrativa.setCompradorAcojeAyuda(dto.getCompradorAcojeAyuda());
				}
				
				if (dto.getImporteAyudaFinanciacion() != null) {
					infoAdministrativa.setImporteAyudaFinanciacion(dto.getImporteAyudaFinanciacion());
				}
				
				if (dto.getFechaVencimientoAvalSeguro() != null) {
					infoAdministrativa.setFechaVencimientoAvalSeguro(dto.getFechaVencimientoAvalSeguro());
				}

				if (dto.getFechaDevolucionAyuda() != null) {
					infoAdministrativa.setFechaDevolucionAyuda(dto.getFechaDevolucionAyuda());
				}
			}
			
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
