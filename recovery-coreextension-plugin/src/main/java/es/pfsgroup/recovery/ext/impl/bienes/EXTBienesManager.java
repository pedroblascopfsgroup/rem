package es.pfsgroup.recovery.ext.impl.bienes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

@Component
public class EXTBienesManager {

	@Autowired
	private GenericABMDao genericDao;
	
	public ProcedimientoBien getProcedimientoBienByGuid(String guid) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		ProcedimientoBien prcBien = genericDao.get(ProcedimientoBien.class, filtro);
		return prcBien;
	}

	public NMBBien getBienByCodigoInterno(String codigoInterno) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigoInterno", codigoInterno);
		NMBBien prcBien = genericDao.get(NMBBien.class, filtro);
		return prcBien;
	}
	
}
