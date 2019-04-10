package es.pfsgroup.plugin.rem.activo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;

public class MaestroDeActivos {
	
	private Long numActivo = null;
	private Long numActivoRem = null;
	private Long numActivoRemAM = null;
	
	@Autowired
	private MSVRawSQLDao rawDao;

	public MaestroDeActivos(Long numActivo, Long numActivoRem, Long numActivoRemAM) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.numActivo = numActivo;
		this.numActivoRem = numActivoRem;
		this.numActivoRemAM = numActivoRemAM;
	}
	
	@Transactional
	public Long getNewNumActivo(Long numActivo, Long numActivoRem, Long numActivoRemAM) {
		return Long.valueOf(rawDao.getExecuteSQL("SELECT MAX(ACT_NUM_ACTIVO) + 1 FROM ACT_ACTIVO"));
	}
	
}
