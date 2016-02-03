//package es.pfsgroup.plugin.recovery.sidhiweb.hitoIter;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import es.capgemini.devon.bo.annotations.BusinessOperation;
//import es.capgemini.devon.pagination.Page;
//import es.capgemini.pfs.eventfactory.EventFactory;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.hitoIter.SIDHIHitoIterApi;
//import es.pfsgroup.plugin.recovery.sidhiweb.hitoIter.dao.SIDHIHitoIterDao;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//@Component
//public class SIDHIHitoIterManager implements SIDHIHitoIterApi{
//
//	@Autowired
//	SIDHIHitoIterDao hitoDao;
//	
//	@Override
//	@BusinessOperation(SIDHI_BO_HITO_FINDHITOBYASUNTO)
//	public Page getHitosAsunto(SIDHIDtoBuscarAcciones dto) {
//		EventFactory.onMethodStart(this.getClass());
//		return hitoDao.findHitosAsunto(dto);
//	}
//
//	@Override
//	@BusinessOperation(SIDHI_BO_HITO_FINDHITOBYEXPEDIENTE)
//	public Page getHitosExpediente(SIDHIDtoBuscarAcciones dto) {
//		EventFactory.onMethodStart(this.getClass());
//		return hitoDao.findHitosExpediente(dto);
//	}
//
//}
