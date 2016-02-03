//package es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.dao.impl;
//
//import org.springframework.stereotype.Repository;
//
//import es.capgemini.devon.pagination.Page;
//import es.capgemini.pfs.dao.AbstractEntityDao;
//import es.pfsgroup.commons.utils.HQLBuilder;
//import es.pfsgroup.commons.utils.HibernateQueryUtils;
//import es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.dao.SIDHIAccionNoProcDao;
//import es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.model.SIDHIAccionNoProc;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//@Repository("SIDHIAccionNoProcDao")
//public class SIDHIAccionNoProcDaoImpl extends AbstractEntityDao<SIDHIAccionNoProc, Long> implements SIDHIAccionNoProcDao {
//
//	@Override
//	public Page findAccionesNoProcAsunto(SIDHIDtoBuscarAcciones dto) {
//		HQLBuilder hb = new HQLBuilder("from SIDHIAccionNoProc acc");
//		hb.appendWhere("acc.auditoria.borrado=false and acc.idAccion!=null");
//		
//		HQLBuilder.addFiltroIgualQue(hb, "acc.iterJudicial.procedimiento.asunto.id", dto.getIdAsunto());
//		
//		return HibernateQueryUtils.page(this, hb, dto);
//	}
//
//	@Override
//	public Page findAccionesNoProcExpediente(SIDHIDtoBuscarAcciones dto) {
//		HQLBuilder hb = new HQLBuilder("from SIDHIAccionNoProc acc");
//		hb.appendWhere("acc.auditoria.borrado=false and acc.idAccion!=null");
//		
//		HQLBuilder.addFiltroIgualQue(hb, "acc.iterJudicial.procedimiento.asunto.expediente.id", dto.getIdExpediente());
//		
//		return HibernateQueryUtils.page(this, hb, dto);
//	}
//
//}
