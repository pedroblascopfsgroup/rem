package es.pfsgroup.plugin.rem.deposito;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.model.ConfiguracionDeposito;
import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ParametrizacionDeposito;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDeposito;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;

@Service("depositoManager")
public class DepositoManager extends BusinessOperationOverrider<DepositoApi> implements DepositoApi {
	
	
	protected static final Log logger = LogFactory.getLog(DepositoManager.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
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
	
	@Override
	public Long vincularCuentaVirtual() {
		return 1L;
	}

	@Override
	public void generaDeposito(Oferta oferta){
		Deposito dep = new Deposito();
		dep.setImporte(getImporteDeposito(oferta));
		dep.setEstadoDeposito(genericDao.get(DDEstadoDeposito.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDeposito.CODIGO_PENDIENTE)));
		dep.setOferta(oferta);
		vincularCuentaVirtual();

		genericDao.save(Deposito.class, dep);
	}
	
	@Override
	public Double getImporteDeposito(Oferta oferta) {
		Double importeDeposito = null;
		Double precioVentaActivo = activoApi.getImporteValoracionActivoByCodigo(oferta.getActivoPrincipal(), DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);
		Filter filterSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera", oferta.getActivoPrincipal().getSubcartera());
		Filter filterEquipoGestion = genericDao.createFilter(FilterType.EQUALS, "equipoGestion", oferta.getActivoPrincipal().getEquipoGestion().getCodigo());
		List<ParametrizacionDeposito> parametrizacionDeposito = genericDao.getList(ParametrizacionDeposito.class, filterSubcartera, filterEquipoGestion);
		if (parametrizacionDeposito != null) {
			for (ParametrizacionDeposito paramDeposito: parametrizacionDeposito) {
				if (paramDeposito.getPrecioVenta() >= precioVentaActivo) {
					importeDeposito = paramDeposito.getImporteDeposito();
				}
			}
		}
		return importeDeposito;
	}
	
}