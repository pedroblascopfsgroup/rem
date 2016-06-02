package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model.DespachoExtrasAmbito;

public interface DespachoExtrasAmbitoDao extends AbstractDao<DespachoExtrasAmbito, Long>{

	DespachoExtrasAmbito getDespachoExtrasAmbitoByCodigoPrv(String codProvincia, Long idDespacho);
	
	boolean isDespachoEnProvincia(String codProvincia, Long idDespacho);
}
