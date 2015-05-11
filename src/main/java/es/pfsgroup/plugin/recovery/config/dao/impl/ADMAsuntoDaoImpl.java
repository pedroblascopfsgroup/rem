package es.pfsgroup.plugin.recovery.config.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.dao.ADMAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Repository("ADMAsuntoDao")
public class ADMAsuntoDaoImpl extends AbstractEntityDao<EXTAsunto, Long> implements ADMAsuntoDao{

	@Override
	public List<EXTAsunto> getAsuntosProcurador(Long idProcurador) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.procurador.id", idProcurador);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<EXTAsunto> getAsuntosSupervisor(Long idSupervisor) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.supervisor.id", idSupervisor);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<EXTAsunto> getAsuntosGestor(Long idGestor) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.gestor.id", idGestor);
		return HibernateQueryUtils.list(this, hb);
	}

	
	@Override
	public List<EXTAsunto> getAsuntosUsuario(Long idUsuario) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.gestor.usuario.id", idUsuario);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<EXTAsunto> getAsuntosUsuarioProcurador(Long idUsuario) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.procurador.usuario.id", idUsuario);
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<EXTAsunto> getAsuntosUsuarioSupervisor(Long idUsuario) {
		HQLBuilder hb = new HQLBuilder("from Asunto asu");
		hb.appendWhere("asu.auditoria.borrado=0");
		hb.appendWhere("asu.estadoAsunto!='06'");
		HQLBuilder.addFiltroIgualQue(hb, "asu.supervisor.usuario.id", idUsuario);
		return HibernateQueryUtils.list(this, hb);
	}
	
	

}
