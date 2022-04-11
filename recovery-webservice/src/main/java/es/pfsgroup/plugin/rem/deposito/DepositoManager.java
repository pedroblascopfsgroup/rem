package es.pfsgroup.plugin.rem.deposito;

import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.model.ConfiguracionDeposito;
import es.pfsgroup.plugin.rem.model.CuentasVirtuales;
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

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private UsuarioApi usuarioApi;

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
	@Transactional
	public synchronized CuentasVirtuales vincularCuentaVirtual(Oferta oferta) {

		List<CuentasVirtuales> cuentasVirtuales = null;
		if(oferta != null && oferta.getActivoPrincipal() != null && oferta.getActivoPrincipal().getSubcartera() != null) {
			cuentasVirtuales = genericDao.getList(CuentasVirtuales.class,
					genericDao.createFilter(FilterType.EQUALS, "subcartera.codigo", oferta.getActivoPrincipal().getSubcartera().getCodigo()),
					genericDao.createFilter(FilterType.NULL, "fechaInicio"));
		}

		CuentasVirtuales cuentaVirtual = null;
		if(cuentasVirtuales != null && !cuentasVirtuales.isEmpty()) {
			cuentaVirtual = cuentasVirtuales.get(0);
			cuentaVirtual.setFechaInicio(new Date());
			cuentaVirtual.getAuditoria().setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
			cuentaVirtual.getAuditoria().setFechaModificar(new Date());

			genericDao.update(CuentasVirtuales.class, cuentaVirtual);
		}

		return cuentaVirtual;
	}

	@Override
	@Transactional
	public void generaDeposito(Oferta oferta){
		Deposito dep = new Deposito();
		dep.setImporte(getImporteDeposito(oferta));
		dep.setEstadoDeposito(genericDao.get(DDEstadoDeposito.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDeposito.CODIGO_PENDIENTE)));
		dep.setOferta(oferta);

		genericDao.save(Deposito.class, dep);

	}

	@Override
	public Double getImporteDeposito(Oferta oferta) {
		Double importeDeposito = null;
		Double precioVentaActivo = activoApi.getImporteValoracionActivoByCodigo(oferta.getActivoPrincipal(), DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);
		Filter filterSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera", oferta.getActivoPrincipal().getSubcartera());
		Filter filterEquipoGestion = genericDao.createFilter(FilterType.EQUALS, "equipoGestion.codigo", oferta.getActivoPrincipal().getEquipoGestion().getCodigo());
		List<ParametrizacionDeposito> parametrizacionDeposito = genericDao.getList(ParametrizacionDeposito.class, filterSubcartera, filterEquipoGestion);
		if (parametrizacionDeposito != null) {
			for (ParametrizacionDeposito paramDeposito: parametrizacionDeposito) {
				if (paramDeposito.getPrecioVenta() != null && paramDeposito.getPrecioVenta() >= precioVentaActivo) {
					importeDeposito = paramDeposito.getImporteDeposito();
				}
			}
		}
		return importeDeposito;
	}

	@Override
	@Transactional
	public Boolean generaDepositoFromRem3(GeneraDepositoDto dto){
		if(dto != null && dto.getIdOferta() != null){
			Oferta ofr = ofertaApi.getOfertaById(dto.getIdOferta());
			if(ofr != null && esNecesarioDeposito(ofr)){
				generaDeposito(ofr);
				ofr.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoOferta.CODIGO_PDTE_DEPOSITO)));
				genericDao.save(Oferta.class, ofr);
			}

			return true;
		}
		return false;
	}

}