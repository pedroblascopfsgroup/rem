package es.capgemini.pfs.controlAcceso.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.controlAcceso.dao.EXTControlAccesoDao;
import es.capgemini.pfs.controlAcceso.model.EXTControlAcceso;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

@Repository("EXTControlAccesoDao")
public class EXTControlAccesoDaoImpl extends AbstractEntityDao<EXTControlAcceso, Long> implements EXTControlAccesoDao{

	@Override
	public EXTControlAcceso createNewControlAcceso() {
		return new EXTControlAcceso();
	}

	@Override
	public List<EXTControlAcceso> buscaAccesoHoy(Usuario usuarioLogado) {
		HQLBuilder hb = new HQLBuilder("from EXTControlAcceso ca");
		hb.appendWhere("ca.auditoria.borrado=0");
		
		HQLBuilder.addFiltroIgualQue(hb, "usuario.id", usuarioLogado.getId());
		hb.orderBy("id", HQLBuilder.ORDER_DESC);
		
		return HibernateQueryUtils.list(this, hb);
		
	}

}
