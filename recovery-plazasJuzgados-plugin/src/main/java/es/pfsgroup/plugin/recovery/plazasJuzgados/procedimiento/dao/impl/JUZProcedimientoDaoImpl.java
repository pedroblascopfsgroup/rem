package es.pfsgroup.plugin.recovery.plazasJuzgados.procedimiento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.plazasJuzgados.procedimiento.dao.JUZProcedimientoDao;

@Repository("JUZProcedimientoDao")
public class JUZProcedimientoDaoImpl extends AbstractEntityDao<Procedimiento, Long> implements JUZProcedimientoDao {

	@Override
	public List<Procedimiento> findPorJuzgado(Long id) {
		HQLBuilder hb = new HQLBuilder("from Procedimiento proc");
		
		hb.appendWhere("proc.auditoria.borrado=false");
		hb.appendWhere("proc.tipoProcedimiento.codigo!='05' and proc.tipoProcedimiento.codigo!='04'");
		
		HQLBuilder.addFiltroIgualQue(hb, "proc.juzgado.id", id);
		return HibernateQueryUtils.list(this, hb);
	}

}
