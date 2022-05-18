package es.pfsgroup.plugin.rem.deposito;

import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.validator.routines.IBANValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.InvalidDataAccessApiUsageException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.DepositoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ConfiguracionDeposito;
import es.pfsgroup.plugin.rem.model.CuentasVirtuales;
import es.pfsgroup.plugin.rem.model.Deposito;
import es.pfsgroup.plugin.rem.model.DtoDeposito;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GeneraDepositoDto;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ParametrizacionDeposito;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDeposito;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

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
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Override
	public String managerName() {
		return "depositoManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public boolean esNecesarioDeposito(Oferta oferta) {
		
		if(oferta != null && oferta.getActivoPrincipal() != null 
				&& oferta.getActivoPrincipal().getSubcartera() != null && DDTipoOferta.isTipoVenta(oferta.getTipoOferta())) {
			return esNecesarioDepositoBySubcartera(oferta.getActivoPrincipal().getSubcartera().getCodigo());
		}
		
		return false;
	}
	@Override
	public boolean esNecesarioDepositoBySubcartera(String codSubcartera){
		ConfiguracionDeposito conDep = genericDao.get(ConfiguracionDeposito.class
				,genericDao.createFilter(FilterType.EQUALS,"subcartera.codigo", codSubcartera));
		if(conDep != null && conDep.getDepositoNecesario()) {
			return true;
		}
		return false;
	}

	@Override
	public boolean isDepositoIngresado(Deposito deposito) {
		boolean isIngresado = false;
		if(deposito != null 
				&& (DDEstadoDeposito.isIngresado(deposito.getEstadoDeposito()) 
						|| DDEstadoDeposito.isPendienteDevolucion(deposito.getEstadoDeposito()) 
						|| DDEstadoDeposito.isPendienteIncautacion(deposito.getEstadoDeposito())
						|| DDEstadoDeposito.isPdteDecisionDevolucionIncautacion(deposito.getEstadoDeposito()))) {
			isIngresado= true;
		}
		
		return isIngresado;
	}
	
	@Override
	@Transactional
	public synchronized CuentasVirtuales vincularCuentaVirtual(String codigoSubTipoOferta) {
			CuentasVirtuales cuentaVirtual = null;
			List<CuentasVirtuales> cuentasVirtuales = null;
			Filter filtroSubCartera = genericDao.createFilter(FilterType.EQUALS, "subcartera.codigo", codigoSubTipoOferta);
			Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaInicio");
			cuentasVirtuales = genericDao.getList(CuentasVirtuales.class, filtroSubCartera,filtroFechaFin);
			
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
	public boolean esNecesarioDepositoNuevaOferta(Activo ActivoCuentaVirtual) {
		
		if(ActivoCuentaVirtual != null 
				&& ActivoCuentaVirtual.getSubcartera() != null ) {
			ConfiguracionDeposito conDep = genericDao.get(ConfiguracionDeposito.class
					,genericDao.createFilter(FilterType.EQUALS,"subcartera.codigo", ActivoCuentaVirtual.getSubcartera().getCodigo()));
			if(conDep != null && conDep.getDepositoNecesario()) {
				return true;
			}
		}
		
		return false;
	}

	@Override
	@Transactional
	public Deposito generaDeposito(Oferta oferta){
		Deposito dep = new Deposito();
		dep.setImporte(getImporteDeposito(oferta));
		dep.setEstadoDeposito(genericDao.get(DDEstadoDeposito.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDeposito.CODIGO_PENDIENTE)));
		dep.setOferta(oferta);

		return genericDao.save(Deposito.class, dep);
	}
	
	@Override
	@Transactional
	public Deposito generaDepositoAndIban(Oferta oferta, String iban){
		Deposito dep = new Deposito();
		dep.setImporte(getImporteDeposito(oferta));
		dep.setEstadoDeposito(genericDao.get(DDEstadoDeposito.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDeposito.CODIGO_PENDIENTE)));
		dep.setOferta(oferta);
		dep.setIbanDevolucion(iban);

		return genericDao.save(Deposito.class, dep);
	}

	@Override
	public Double getImporteDeposito(Oferta oferta) {
		Double importeDeposito = null;
		Double precioVentaActivo = activoApi.getImporteValoracionActivoByCodigo(oferta.getActivoPrincipal(), DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);

		if(precioVentaActivo != null) {
			Filter filterSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera", oferta.getActivoPrincipal().getSubcartera());
			Filter filterTipoComercializar = genericDao.createFilter(FilterType.EQUALS, "tipoComercializar.codigo", oferta.getActivoPrincipal().getTipoComercializar().getCodigo());
			Order ordenImporteDesc = new Order(OrderType.ASC, "precioVenta");
			List<ParametrizacionDeposito> parametrizacionDeposito = genericDao.getListOrdered(ParametrizacionDeposito.class, ordenImporteDesc, filterSubcartera, filterTipoComercializar);
			if (parametrizacionDeposito != null) {
				for (ParametrizacionDeposito paramDeposito: parametrizacionDeposito) {
					if (paramDeposito.getPrecioVenta() != null && paramDeposito.getPrecioVenta() < precioVentaActivo) {
						importeDeposito = paramDeposito.getImporteDeposito();
					}
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
				ofertaApi.setEstadoOfertaBC(ofr, null);
				genericDao.save(Oferta.class, ofr);
			}

			return true;
		}
		return false;
	}

	
	@Override
	public void modificarEstadoDepositoSiIngresado(Oferta oferta) {
		Deposito deposito = genericDao.get(Deposito.class,genericDao.createFilter(FilterType.EQUALS, "oferta.id",oferta.getId()));
		if(isDepositoIngresado(deposito)) {
			cambiaEstadoDeposito(deposito, DDEstadoDeposito.CODIGO_PDTE_DECISION_DEVOLUCION_INCAUTACION);
		}
	}

	@Override
	public Deposito getDepositoByNumOferta(Long numOferta) {
		if(numOferta != null){
			Deposito dep = genericDao.get(Deposito.class, genericDao.createFilter(FilterType.EQUALS, "oferta.numOferta", numOferta));
			if(dep != null) return dep;
		}
		return null;
	}

	@Override
	public boolean cambiaEstadoDeposito(Deposito dep, String codDeposito) {
		if(dep != null){
			Filter filtroDeposito = genericDao.createFilter(FilterType.EQUALS, "codigo",
					codDeposito);
			dep.setEstadoDeposito(genericDao.get(DDEstadoDeposito.class, filtroDeposito));
			genericDao.save(Deposito.class, dep);
			return true;
		}
		return false;
	}
	
	
	public DtoDeposito expedienteToDtoDeposito(ExpedienteComercial expediente) {
		DtoDeposito dto = new DtoDeposito();
		Oferta oferta = expediente.getOferta();
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		Deposito deposito = genericDao.get(Deposito.class, filterOferta);
		
		if (!Checks.esNulo(deposito)) {
			if (!Checks.esNulo(deposito.getImporte())) {
				dto.setImporteDeposito(deposito.getImporte());
			}
			if (!Checks.isFechaNula(deposito.getFechaIngreso())) {
				dto.setFechaIngresoDeposito(deposito.getFechaIngreso());
			}
			if (!Checks.esNulo(deposito.getEstadoDeposito())) {
				dto.setEstadoCodigo(deposito.getEstadoDeposito().getCodigo());
			}
			if (!Checks.isFechaNula(deposito.getFechaDevolucion())) {
				dto.setFechaDevolucionDeposito(deposito.getFechaDevolucion());
			}
			if (!Checks.esNulo(deposito.getIbanDevolucion())) {
				dto.setIbanDevolucionDeposito(deposito.getIbanDevolucion());
			}
			dto.setOfertaConDeposito(this.esOfertaConDeposito(oferta));
			dto.setUsuCrearOfertaDepositoExterno(this.esUsuarioCrearOfertaDepositoExterno(oferta));
		}
		
		return dto;
	}
	
	public boolean esOfertaConDeposito(Oferta oferta) {
		boolean ofertaConDeposito = false;
		
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		List <Deposito> deposito = genericDao.getList(Deposito.class, filterOferta);
		
		if (deposito != null && !deposito.isEmpty() && (DDTipoOferta.isTipoVenta(oferta.getTipoOferta()))) {
			ofertaConDeposito = true;
		}
		
		return ofertaConDeposito;
		
	}
	
	public boolean esUsuarioCrearOfertaDepositoExterno(Oferta oferta) {
		boolean usuCrearOfertaDepositoExterno = false;
		String usuCrearOfr = oferta.getAuditoria().getUsuarioCrear();
		if (("webcom").equalsIgnoreCase(usuCrearOfr) || ("-1").equalsIgnoreCase(usuCrearOfr)) {
			usuCrearOfertaDepositoExterno = true;
		}
		
		return usuCrearOfertaDepositoExterno;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveDeposito(DtoDeposito dto, Long idExpediente) {
		ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);
		Oferta oferta = expediente.getOferta();
		Filter filterOferta =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", oferta.getId());
		Deposito deposito = genericDao.get(Deposito.class, filterOferta);

		if (Checks.esNulo(deposito)) {
			deposito = new Deposito();
			deposito.setImporte(dto.getImporteDeposito());
			deposito.setIbanDevolucion(dto.getIbanDevolucionDeposito());
			deposito.setAuditoria(Auditoria.getNewInstance());
			deposito.setOferta(oferta);
			
			genericDao.save(Deposito.class, deposito);
		}
		
		if (!Checks.esNulo(deposito)) {
			if (dto.getImporteDeposito() != null) {
				deposito.setImporte(dto.getImporteDeposito());
			}
			if (dto.getIbanDevolucionDeposito() != null) {
				deposito.setIbanDevolucion(dto.getIbanDevolucionDeposito());
			}
			
			genericDao.update(Deposito.class, deposito);
		}

		return true;
	}
	
	@Override
	public boolean validarIban(String iban){
		IBANValidator ibanCheck = new IBANValidator();
		return ibanCheck.isValid(iban);
	}
	
}