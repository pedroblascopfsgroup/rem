package es.pfsgroup.plugin.recovery.config.funciones.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.funciones.dao.ADMFuncionDao;
import es.pfsgroup.plugin.recovery.config.funciones.dto.ADMDtoBuscarFunciones;

@Repository("ADMFuncionDao")
public class ADMFuncionDaoImpl extends AbstractEntityDao<Funcion, Long>
		implements ADMFuncionDao {



	@Override
	public Funcion createNew() {
		return new Funcion();
	}

	@Override
	public Page findAll(ADMDtoBuscarFunciones dto) {
		HQLBuilder hb = new HQLBuilder("from Funcion");
		hb.appendWhere(Auditoria.UNDELETED_RESTICTION);
		return HibernateQueryUtils.page(this, hb, dto);
	}

}
