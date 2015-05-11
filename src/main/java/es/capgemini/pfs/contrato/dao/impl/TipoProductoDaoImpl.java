package es.capgemini.pfs.contrato.dao.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dao.TipoProductoDao;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz TipoProductoDao.
 *
 */
@Repository("TipoProductoDao")
public class TipoProductoDaoImpl extends AbstractEntityDao<DDTipoProducto, Long> implements TipoProductoDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public DDTipoProducto findByCodigo(String codigo) {
        String hsql = "from DDTipoProducto where codigo = ?";

        List<DDTipoProducto> tipos = getHibernateTemplate().find(hsql, new Object[] { codigo });
        if (tipos.size() > 0) { return tipos.get(0); }
        return null;
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings({ "unchecked", "cast" })
	public List<DDTipoProducto> getTiposProductoByCodigos(Set<String> codigos) {
		if(codigos.size()==0 || codigos.toString().equals("[]")) {
			return new ArrayList<DDTipoProducto>();
		}
		Iterator<String> it = codigos.iterator();
		String lista = "";
		while(it.hasNext()) {
			if(lista.equals("")) {
				lista += "'" + it.next() + "'";
			} else {
				lista += ", '" + it.next() + "'";
			}
		}
        String hql = "from DDTipoProducto tpr "
        	       + "where tpr.codigo in (" + lista + ")"
        	       + "      and tpr.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return (List<DDTipoProducto>) getHibernateTemplate().find(hql);
	}
}
