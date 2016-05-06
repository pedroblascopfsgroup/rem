package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dto.DespachoExternoExtrasDto;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExternoExtras;

public interface DespachoExternoExtrasDao extends AbstractDao<DespachoExternoExtras, Long> {

	DespachoExternoExtrasDto getDtoDespachoExtras(Long idDespacho);
	
	List<DDProvincia> getProvinciasDespachoExtras(Long idDespacho);
	
}
