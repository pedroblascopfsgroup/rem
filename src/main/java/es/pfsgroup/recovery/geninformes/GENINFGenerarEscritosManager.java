package es.pfsgroup.recovery.geninformes;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.TipoProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.geninformes.api.GENINFGenerarEscritosApi;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeTPO;

@Component
public class GENINFGenerarEscritosManager implements GENINFGenerarEscritosApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private TipoProcedimientoDao tipoProcedimientoDao;
	
	@Override
	@BusinessOperation(PLUGIN_GENINFORMES_BO_GET_ESCRITOS_BY_TPO)
	public List<GENINFInformeTPO> getEscritosByTPO(Long idTipoProc) {
		List<GENINFInformeTPO> listInformeTPO = new ArrayList<GENINFInformeTPO>();
		TipoProcedimiento tipoProcedimiento = tipoProcedimientoDao.get(idTipoProc);
		if (!Checks.esNulo(tipoProcedimiento)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento", tipoProcedimiento);
			Order orden = new Order(OrderType.ASC, "descripcion");
			listInformeTPO = genericDao.getListOrdered(GENINFInformeTPO.class, orden, filtro);
		}
		return listInformeTPO;
	}

}
