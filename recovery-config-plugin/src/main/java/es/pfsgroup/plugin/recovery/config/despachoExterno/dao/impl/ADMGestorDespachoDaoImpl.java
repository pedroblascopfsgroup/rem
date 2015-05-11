package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMGestorDespachoDao;

@Repository("ADMGestorDespachoDao")
public class ADMGestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho, Long> implements ADMGestorDespachoDao{

}
