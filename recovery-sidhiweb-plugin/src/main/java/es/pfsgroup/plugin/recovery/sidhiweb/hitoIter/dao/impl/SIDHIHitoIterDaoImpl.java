//package es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.dao.impl;
//
//import org.springframework.stereotype.Repository;
//
//import es.capgemini.devon.pagination.Page;
//import es.capgemini.pfs.dao.AbstractEntityDao;
//import es.pfsgroup.commons.utils.HQLBuilder;
//import es.pfsgroup.commons.utils.HibernateQueryUtils;
//import es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.dao.SIDHIHitoIterDao;
//import es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.model.SIDHIHitoIter;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//@Repository("SIDHIHitoIterDao")
//public class SIDHIHitoIterDaoImpl extends AbstractEntityDao<SIDHIHitoIter, Long> implements SIDHIHitoIterDao{
//
//	@Override
//	public Page findHitosAsunto(SIDHIDtoBuscarAcciones dto) {
//		HQLBuilder hb = new HQLBuilder("from SIDHIHitoIter hito");
//		hb.appendWhere("hito.auditoria.borrado=false and hito.idHito!=null");
//		
//		HQLBuilder.addFiltroIgualQue(hb, "hito.iterJudicial.procedimiento.asunto.id", dto.getIdAsunto());
//		
//		return HibernateQueryUtils.page(this, hb, dto);
//	}
//
//	@Override
//	public Page findHitosExpediente(SIDHIDtoBuscarAcciones dto) {
//		HQLBuilder hb = new HQLBuilder("from SIDHIHitoIter hito");
//		hb.appendWhere("hito.auditoria.borrado=false and hito.idHito!=null");
//		
//		HQLBuilder.addFiltroIgualQue(hb, "hito.iterJudicial.procedimiento.asunto.expediente.id", dto.getIdExpediente());
//		
//		return HibernateQueryUtils.page(this, hb, dto);
//	}
//
//}
