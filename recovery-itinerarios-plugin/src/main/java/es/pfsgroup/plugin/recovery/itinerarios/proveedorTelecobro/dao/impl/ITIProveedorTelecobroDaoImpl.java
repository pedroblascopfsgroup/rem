package es.pfsgroup.plugin.recovery.itinerarios.proveedorTelecobro.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telecobro.model.ProveedorTelecobro;
import es.pfsgroup.plugin.recovery.itinerarios.proveedorTelecobro.dao.ITIProveedorTelecobroDao;

@Repository("ITIProveedorTelecobroDao")
public class ITIProveedorTelecobroDaoImpl extends AbstractEntityDao<ProveedorTelecobro, Long>
	implements ITIProveedorTelecobroDao{

}
