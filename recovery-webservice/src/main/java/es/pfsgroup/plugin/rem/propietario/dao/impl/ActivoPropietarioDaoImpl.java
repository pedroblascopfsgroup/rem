package es.pfsgroup.plugin.rem.propietario.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.propietario.dao.ActivoPropietarioDao;

@Repository("ActivoPropietarioDao")
public class ActivoPropietarioDaoImpl extends AbstractEntityDao<ActivoPropietario,Long> implements ActivoPropietarioDao {

	@Override
	public List<ActivoPropietario> getPropietarioIdDescripcionCodigo() {
		// TODO Auto-generated method stub
		
	HQLBuilder hb = new HQLBuilder(" from ActivoPropietario act");
	hb.appendWhere(" act.cartera.codigo in(" + DDCartera.CODIGO_CARTERA_BBVA + "," + DDCartera.CODIGO_CARTERA_CERBERUS + ")");
	hb.appendWhere(" act.nombre is not null");

	List<ActivoPropietario> lista = (List<ActivoPropietario>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	if(!lista.isEmpty()) {
		return HibernateUtils.castList(ActivoPropietario.class, lista);
	}
	return lista;
		
	}
	
	



}
