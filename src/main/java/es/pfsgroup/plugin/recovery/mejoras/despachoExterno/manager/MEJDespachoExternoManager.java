package es.pfsgroup.plugin.recovery.mejoras.despachoExterno.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.mejoras.despachoExterno.dao.MEJDespachoExternoDao;

@Service("MEJDespachoExternoManager")
public class MEJDespachoExternoManager {
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MEJDespachoExternoDao despachoExternoDao;
	
	@BusinessOperation(overrides="despachoExternoManager.getDespachosExternos")
	public List<DespachoExterno> listaDespachosExternos() {
		
		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS,
				"tipoDespacho.codigo",
				DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
		
		Order orderTipoDespacho = new Order(OrderType.ASC,"despacho");
		return genericDao.getListOrdered(DespachoExterno.class,orderTipoDespacho, filtroTipoDespacho);

	}
	
	@BusinessOperation(overrides="despachoExternoManager.getDespachosPorTipoZona")
    public List<DespachoExterno> getDespachosPorTipoZona(String zonas, String tipoDespacho) {
		return despachoExternoDao.buscarDespachosPorTipoZona(zonas, tipoDespacho);
    }
}
