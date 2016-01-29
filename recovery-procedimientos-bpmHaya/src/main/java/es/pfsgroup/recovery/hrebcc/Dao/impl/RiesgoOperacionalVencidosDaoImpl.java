package es.pfsgroup.recovery.hrebcc.Dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.hrebcc.Dao.RiesgoOperacionalVencidosDao;
import es.pfsgroup.recovery.hrebcc.model.Vencidos;

@Repository("RiesgoOperacionalVencidosDao")
public class RiesgoOperacionalVencidosDaoImpl extends AbstractEntityDao<Vencidos, Long> implements RiesgoOperacionalVencidosDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Vencidos> getListVencidos(Long cntId) {
		String  hql = "from Vencidos v where v.cntId = ? and v.auditoria.borrado = 0 order by v.tipoVencido.id desc ";
		
		List<Vencidos> vencidos = getHibernateTemplate().find(hql, cntId);
		
		return vencidos;
	}

}
