package es.pfsgroup.plugin.recovery.itinerarios.tipoProcedimiento;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.itinerarios.PluginItinerariosBusinessOperations;
import es.pfsgroup.plugin.recovery.itinerarios.tipoProcedimiento.dao.ITITipoProcedimientoDao;

@Service("ITITipoProcedimientoManager")
public class ITITipoProcedimientoManager {
	
	@Autowired
	ITITipoProcedimientoDao tipoProcedimientoDao;
	
	@BusinessOperation(PluginItinerariosBusinessOperations.TPC_MGR_GETTIPOSPROCEDIMIENTO)
	public List<TipoProcedimiento> getTiposProcedimiento(){
		return tipoProcedimientoDao.getList();
	}

}
