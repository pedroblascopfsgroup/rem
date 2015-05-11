package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;

@Repository("ADMTipoDespachoExternoDao")
public class ADMTipoDespachoExternoDaoImpl extends AbstractEntityDao<DDTipoDespachoExterno, Long> implements ADMTipoDespachoExternoDao{

}
