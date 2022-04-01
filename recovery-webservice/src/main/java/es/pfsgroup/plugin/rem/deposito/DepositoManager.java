package es.pfsgroup.plugin.rem.deposito;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.model.ConfiguracionDeposito;
import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDeposito;

@Service("depositoManager")
public class DepositoManager extends BusinessOperationOverrider<DepositoApi> implements DepositoApi {
	
	
	protected static final Log logger = LogFactory.getLog(DepositoManager.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String managerName() {
		return "depositoManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public boolean esNecesarioDeposito(Oferta oferta) {
		
		if(oferta != null && oferta.getActivoPrincipal() != null 
				&& oferta.getActivoPrincipal().getSubcartera() != null ) {
			ConfiguracionDeposito conDep = genericDao.get(ConfiguracionDeposito.class
					,genericDao.createFilter(FilterType.EQUALS,"subcartera.codigo", oferta.getActivoPrincipal().getSubcartera().getCodigo()));
			if(conDep != null && conDep.getDepositoNecesario()) {
				return true;
			}
		}
		
		return false;
	}

	@Override
	public boolean isDepositoIngresado(Deposito deposito) {
		boolean isIngresado = false;
		if(deposito != null && DDEstadoDeposito.isIngresado(deposito.getEstadoDeposito())) {
			isIngresado= true;
		}
		
		return isIngresado;
	}
	
}
