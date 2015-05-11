package es.pfsgroup.recovery.panelcontrol.letrados.manager.dao;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.panelcontrol.letrados.api.dao.DDRangoImportePanelControlDaoApi;
import es.pfsgroup.recovery.panelcontrol.letrados.manager.model.DDRangoImportePanelControl;

@Repository("DDRangoImportePanelControlDao")
public class DDRangoImportePanelControlDao extends AbstractEntityDao<DDRangoImportePanelControl, Long> implements DDRangoImportePanelControlDaoApi {

}
