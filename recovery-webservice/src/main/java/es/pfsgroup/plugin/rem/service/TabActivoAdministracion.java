package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoAdministracion;

@Component
public class TabActivoAdministracion implements TabActivoService {
    
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

//	@Autowired
//	private TabActivoFactoryApi tabActivoFactory;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[] { TabActivoService.TAB_ADMINISTRACION };
	}
	
	public DtoActivoAdministracion getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoAdministracion activoDto = new DtoActivoAdministracion();
		BeanUtils.copyProperties(activoDto, activo);
		boolean isUnidadAlquilable = activoDao.isUnidadAlquilable(activo.getId());
		activoDto.setIsUnidadAlquilable(isUnidadAlquilable);
		
		
		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoAdministracion activoAdministracionDto = (DtoActivoAdministracion) webDto;
		
		if(!Checks.esNulo(activoAdministracionDto.getIbiExento())){
			activo.setIbiExento(activoAdministracionDto.getIbiExento());
		}
		
		genericDao.save(Activo.class, activo);
		
		return activo;
	}

}
