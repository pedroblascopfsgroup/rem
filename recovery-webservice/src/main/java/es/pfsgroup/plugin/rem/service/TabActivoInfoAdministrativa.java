package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;

@Component
public class TabActivoInfoAdministrativa implements TabActivoService {
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoDao activoDao;
	
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
			
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
			
			if (dto.getTipoVpoCodigo() != null) {
			
				DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, dto.getTipoVpoCodigo());
	
				activo.getInfoAdministrativa().setTipoVpo(tipoVpo);
				
			}
			
			
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}

}
