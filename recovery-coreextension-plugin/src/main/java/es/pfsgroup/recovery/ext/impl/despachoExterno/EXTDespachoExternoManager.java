package es.pfsgroup.recovery.ext.impl.despachoExterno;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.DespachoExternoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;

@Component
public class EXTDespachoExternoManager extends
		BusinessOperationOverrider<DespachoExternoApi> implements
		DespachoExternoApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<DespachoExterno> getDespachosPorTipoZona(String arg0,
			String arg1) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * DOV - 14/12/2011 
	 * tanto si es multiGestor o no solo se deben obtener
	 * los gestores del despacho.
	 * 
	 */
	@Override
	@BusinessOperation(overrides = "despachoExternoManager.getGestoresDespacho")
	public List<GestorDespacho> getGestoresDespacho(Long arg0) {
		//if (proxyFactory.proxy(EXTAsuntoApi.class).modeloMultiGestor()) {
			//return getTodosLosGestoresOSupervisoresDelDespacho(arg0);
		//} else {
			return parent().getGestoresDespacho(arg0);
		//}
	}

	private List<GestorDespacho> getTodosLosGestoresOSupervisoresDelDespacho(
			Long idDespacho) {
		return genericDao.getList(GestorDespacho.class, genericDao
				.createFilter(FilterType.EQUALS, "despachoExterno.id",
						idDespacho));
	}

	@Override
	public String managerName() {
		return "despachoExternoManager";
	}

}
