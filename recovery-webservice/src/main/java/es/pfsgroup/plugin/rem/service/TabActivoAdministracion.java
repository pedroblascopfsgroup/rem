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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.DtoActivoAdministracion;
import es.pfsgroup.plugin.rem.model.dd.DDCarteraBc;

@Component
public class TabActivoAdministracion implements TabActivoService {
    
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

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
		if (activo != null) {
			ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (actCaixa != null) {
				if (actCaixa.getSegmentacionCartera() != null) {
					activoDto.setSegmentacionCarteraCodigo(actCaixa.getSegmentacionCartera().getCodigo());
					activoDto.setSegmentacionCarteraDescripcion(actCaixa.getSegmentacionCartera().getDescripcion());
				}
			}
		}
		
		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoAdministracion activoAdministracionDto = (DtoActivoAdministracion) webDto;
		
		if (activo != null) {
			if(!Checks.esNulo(activoAdministracionDto.getIbiExento())){
				activo.setIbiExento(activoAdministracionDto.getIbiExento());
			}
			
			ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (actCaixa != null) {
				if (activoAdministracionDto.getSegmentacionCarteraCodigo() != null) {
					DDCarteraBc segmentacionCartera = (DDCarteraBc) utilDiccionarioApi.dameValorDiccionarioByCod(DDCarteraBc.class, activoAdministracionDto.getSegmentacionCarteraCodigo());
					if (segmentacionCartera != null) {
						actCaixa.setSegmentacionCartera(segmentacionCartera);
					}
				}
				genericDao.save(ActivoCaixa.class, actCaixa);
			}
		}
		
		genericDao.save(Activo.class, activo);
		
		return activo;
	}

}
