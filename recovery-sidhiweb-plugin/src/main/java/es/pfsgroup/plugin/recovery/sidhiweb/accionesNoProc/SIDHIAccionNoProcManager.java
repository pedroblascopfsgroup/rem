//package es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import es.capgemini.devon.bo.annotations.BusinessOperation;
//import es.capgemini.devon.pagination.Page;
//import es.pfsgroup.plugin.recovery.sidhiweb.accionesNoProc.dao.SIDHIAccionNoProcDao;
//import es.pfsgroup.plugin.recovery.sidhiweb.api.accionesNoProc.SIDHIAccionNoProcApi;
//import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
//
//@Component
//public class SIDHIAccionNoProcManager implements SIDHIAccionNoProcApi{
//	
//	@Autowired
//	SIDHIAccionNoProcDao accionNoProcDao;
//
//	@Override
//	@BusinessOperation(SIDHI_BO_FIND_ACCIONES_NOPROC_ASU)
//	public Page getAccionesNoProcAsunto(SIDHIDtoBuscarAcciones dto) {
//		return accionNoProcDao.findAccionesNoProcAsunto(dto);
//	}
//
//	@Override
//	@BusinessOperation(SIDHI_BO_FIND_ACCIONES_NOPROC_EXP)
//	public Page getAccionesNoProcExpediente(SIDHIDtoBuscarAcciones dto) {
//		return accionNoProcDao.findAccionesNoProcExpediente(dto);
//	}
//
//}
