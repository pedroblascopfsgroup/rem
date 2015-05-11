package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDDTipoViaDao;

@Repository("ADMDDTipoViaDao")
public class ADMDDTipoViaDaoImpl extends AbstractEntityDao<DDTipoVia, Long> implements ADMDDTipoViaDao{

}
