package es.capgemini.pfs.contrato.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dao.TipoProductoEntidadDao;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz TipoProductoEntidadDao.
 *
 */
@Repository("TipoProductoEntidadDao")
public class TipoProductoEntidadDaoImpl extends AbstractEntityDao<DDTipoProductoEntidad, Long> implements TipoProductoEntidadDao {
	
	public List<DDTipoProductoEntidad> getOrderedList() {
        String hql = "from DDTipoProductoEntidad tpe "
        	       + " where tpe.auditoria." + Auditoria.UNDELETED_RESTICTION 
        	       + " order by tpe.descripcion";
        return (List<DDTipoProductoEntidad>) getHibernateTemplate().find(hql);
	}
}
