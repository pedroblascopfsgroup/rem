package es.pfsgroup.plugin.recovery.burofax;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.pfsgroup.plugin.recovery.burofax.dao.BURDDTipoIntervencionDao;

@Component(PluginBurofaxConstantsComponents.DD_TIPO_INTERVENCION_MANAGER)
public class BURDDTipoIntervencionManager {
	
	@Autowired
	private BURDDTipoIntervencionDao tipoIntervencionDao;

	@BusinessOperation(PluginBurofaxConstantsBO.LIST_TIPOS_INTERVENCION)
	public List<DDTipoIntervencion> getList(){
		EventFactory.onMethodStart(this.getClass());
		return tipoIntervencionDao.getList();
	}
}
