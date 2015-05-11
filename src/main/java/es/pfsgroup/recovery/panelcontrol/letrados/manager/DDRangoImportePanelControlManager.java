package es.pfsgroup.recovery.panelcontrol.letrados.manager;

import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.panelcontrol.letrados.api.DDRangoImportePanelControlApi;
import es.pfsgroup.recovery.panelcontrol.letrados.api.dao.DDRangoImportePanelControlDaoApi;
import es.pfsgroup.recovery.panelcontrol.letrados.api.model.DDRangoImportePanelControlInfo;

@Service
@Transactional(readOnly = true)
public class DDRangoImportePanelControlManager implements DDRangoImportePanelControlApi{

    @Autowired
    private DDRangoImportePanelControlDaoApi ddRangoImportePanelControlDaoApi;
    
	@Override
	@BusinessOperationDefinition(REC_RANGO_IMPORTE_PANEL_CONTROL_GET_BY_ID)
	public	DDRangoImportePanelControlInfo getById(Long id) {
		return ddRangoImportePanelControlDaoApi.get(id);
	}

	@Override
	@BusinessOperationDefinition(REC_RANGO_IMPORTE_PANEL_CONTROL_GET_LIST)
	public	Collection<? extends DDRangoImportePanelControlInfo> getListado() {
		return ddRangoImportePanelControlDaoApi.getList();
	}

}
