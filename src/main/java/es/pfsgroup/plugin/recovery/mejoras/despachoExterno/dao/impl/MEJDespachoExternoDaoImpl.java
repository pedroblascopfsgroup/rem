package es.pfsgroup.plugin.recovery.mejoras.despachoExterno.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.mejoras.despachoExterno.dao.MEJDespachoExternoDao;

@Repository("MEJDespachoExternoDao")
public class MEJDespachoExternoDaoImpl  extends AbstractEntityDao<DespachoExterno, Long> implements MEJDespachoExternoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<DespachoExterno> buscarDespachosPorTipoZona(String zonas,
			String tipoDespacho) {
		String arrayZonas[] = zonas.split(",");
        String hql = "select distinct dex from DespachoExterno dex where (";
        boolean first = true;
        for (String zona : arrayZonas) {
            if (!first)
                hql += " or ";
            else
                first = false;
            hql += " dex.zona.codigo like '" + zona + "%'";

        }
        hql += ")";
        hql += " and dex.tipoDespacho.codigo='" + tipoDespacho + "'";
        hql += " and dex.auditoria.borrado = false";
        hql += " order by dex.despacho asc";
        return  getHibernateTemplate().find(hql);
	}

	

}
