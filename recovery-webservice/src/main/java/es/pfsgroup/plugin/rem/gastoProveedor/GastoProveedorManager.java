package es.pfsgroup.plugin.rem.gastoProveedor;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoImpugnacion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;
import es.pfsgroup.plugin.rem.model.GastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencionPago;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPagador;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;

@Service("gastoProveedorManager")
public class GastoProveedorManager implements GastoProveedorApi {
	
	protected static final Log logger = LogFactory.getLog(GastoProveedorManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DETALLE_ECONOMICO = "detalleEconomico";
	public final String PESTANA_CONTABILIDAD = "contabilidad";
	public final String PESTANA_GESTION = "gestion";
	public final String PESTANA_IMPUGNACION = "impugnacion";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private ReservaDao reservaDao;
	
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private GastoDao gastoDao;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	

	@Override
	public GastoProveedor findOne(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtro);

		return gasto;
	}

	@Override
	public Object getTabGasto(Long id, String tab) {
		
		GastoProveedor gasto = findOne(id);
		
		WebDto dto = null;

		try {
			
			if(PESTANA_FICHA.equals(tab)){
				dto = gastoToDtoFichaGasto(gasto);
			}
			if(PESTANA_DETALLE_ECONOMICO.equals(tab)){
				dto= detalleEconomicoToDtoDetalleEconomico(gasto);
			}
			if(PESTANA_CONTABILIDAD.equals(tab)){
				dto= infoContabilidadToDtoInfoContabilidad(gasto);
			}
			if(PESTANA_GESTION.equals(tab)){
				dto= gestionToDtoGestion(gasto);
			}
			if(PESTANA_IMPUGNACION.equals(tab)){
				dto= impugnaciontoDtoImpugnacion(gasto);
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

	}
	
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		return gastoDao.getListGastos(dtoGastosFilter);
	}
	
	private DtoFichaGastoProveedor gastoToDtoFichaGasto(GastoProveedor gasto) {

		DtoFichaGastoProveedor dto = new DtoFichaGastoProveedor();
		
		if(!Checks.esNulo(gasto)){
			
			dto.setIdGasto(gasto.getId());
			dto.setNumGastoHaya(gasto.getNumGastoHaya());
			dto.setNumGastoGestoria(gasto.getNumGastoGestoria());
			dto.setReferenciaEmisor(gasto.getReferenciaEmisor());
			
			if(!Checks.esNulo(gasto.getTipoGasto())){
				dto.setTipoGastoCodigo(gasto.getTipoGasto().getCodigo());
			}
			if(!Checks.esNulo(gasto.getSubtipoGasto())){
				dto.setSubtipoGastoCodigo(gasto.getSubtipoGasto().getCodigo());
			}
			
			if(!Checks.esNulo(gasto.getProveedor())){
				dto.setNifEmisor(gasto.getProveedor().getDocIdentificativo());
				dto.setBuscadorNifEmisor(gasto.getProveedor().getDocIdentificativo());
				dto.setNombreEmisor(gasto.getProveedor().getNombre());
				dto.setIdEmisor(gasto.getProveedor().getId());
				dto.setCodigoEmisor(gasto.getProveedor().getCodProveedorUvem());
			}
			
			if(!Checks.esNulo(gasto.getPropietario())){
				dto.setNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setBuscadorNifPropietario(gasto.getPropietario().getDocIdentificativo());
				dto.setNombrePropietario(gasto.getPropietario().getNombre());
			}
			
			if(!Checks.esNulo(gasto.getDestinatarioGasto())){
				dto.setDestinatario(gasto.getDestinatarioGasto().getCodigo());
			}
			
			dto.setFechaEmision(gasto.getFechaEmision());
			
			if(!Checks.esNulo(gasto.getTipoPeriocidad())){
				dto.setPeriodicidad(gasto.getTipoPeriocidad().getCodigo());
			}
			dto.setConcepto(gasto.getConcepto());
			dto.setAutorizado(DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo()));
			dto.setAsignadoATrabajos(!Checks.estaVacio(gasto.getGastoProveedorTrabajos()));
			dto.setAsignadoAActivos(Checks.estaVacio(gasto.getGastoProveedorTrabajos()) && !Checks.estaVacio(gasto.getGastoProveedorActivos()));
			
			
		}

		return dto;
	}
	
	@Override
	@Transactional(readOnly=false)
	public GastoProveedor createGastoProveedor(DtoFichaGastoProveedor dto) {
		
		GastoProveedor gastoProveedor = new GastoProveedor();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		gastoProveedor.setNumGastoHaya(gastoDao.getNextNumGasto());
			
		if(!Checks.esNulo(dto.getNifEmisor())){				
			ActivoProveedor proveedor = searchProveedorNif(dto.getNifEmisor());
			gastoProveedor.setProveedor(proveedor);
		}
		
		if(!Checks.esNulo(dto.getDestinatarioGastoCodigo())){
			DDDestinatarioGasto destinatarioGasto  = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, dto.getDestinatarioGastoCodigo());
			gastoProveedor.setDestinatarioGasto(destinatarioGasto);
		}

		if(!Checks.esNulo(dto.getTipoGastoCodigo())){
			DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTipoGastoCodigo());
			gastoProveedor.setTipoGasto(tipoGasto);
		}
		if(!Checks.esNulo(dto.getSubtipoGastoCodigo())){
			DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtipoGastoCodigo());
			gastoProveedor.setSubtipoGasto(subtipoGasto);
		}
			
		gastoProveedor.setFechaEmision(dto.getFechaEmision());
		gastoProveedor.setReferenciaEmisor(dto.getReferenciaEmisor());
		
		// Primero comprobamos que el gasto no está dado de alta.
		boolean existeGasto  = existeGasto(gastoProveedor);
			
		if(existeGasto) {
			throw new JsonViewerException("Gasto ya dado de alta");			
		} else {
			// Creamos el gasto y las entidades relacionadas
			genericDao.save(GastoProveedor.class, gastoProveedor);
			
			GastoDetalleEconomico detalleEconomico = new GastoDetalleEconomico();						
			detalleEconomico.setGastoProveedor(gastoProveedor);				
			genericDao.save(GastoDetalleEconomico.class, detalleEconomico);
			
			GastoGestion gestion = new GastoGestion();
			DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE);
			gestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
			gestion.setGastoProveedor(gastoProveedor);
			gestion.setFechaAlta(new Date());
			gestion.setUsuarioAlta(usuario);
			genericDao.save(GastoGestion.class, gestion);
			
			GastoInfoContabilidad contabilidad = new GastoInfoContabilidad();			
			Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", String.valueOf(new GregorianCalendar().get(GregorianCalendar.YEAR)));
			Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);			
			contabilidad.setEjercicio(ejercicio);
			contabilidad.setGastoProveedor(gastoProveedor);			
			genericDao.save(GastoInfoContabilidad.class, contabilidad);
			
			GastoImpugnacion impugnacion = new GastoImpugnacion();						
			impugnacion.setGastoProveedor(gastoProveedor);				
			genericDao.save(GastoImpugnacion.class, impugnacion);
		}
		
		return gastoProveedor;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long id){
		

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id );
			GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtro);			
			
			try {
				
				beanUtilNotNull.copyProperties(gastoProveedor, dto);
				
			} catch (Exception  ex) {
				logger.error(ex.getCause());
			}
			
			if(!Checks.esNulo(dto.getBuscadorNifEmisor())){
				Filter filtroNifEmisor = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dto.getBuscadorNifEmisor());
				ActivoProveedor proveedor = genericDao.get(ActivoProveedor.class, filtroNifEmisor);
				gastoProveedor.setProveedor(proveedor);
			}
			
			if(!Checks.esNulo(dto.getBuscadorNifPropietario())){
				Filter filtroNifPropietario= genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", dto.getBuscadorNifPropietario());
				ActivoPropietario propietario= genericDao.get(ActivoPropietario.class, filtroNifPropietario);
				gastoProveedor.setPropietario(propietario);
			}
			
			if(!Checks.esNulo(dto.getTipoGastoCodigo())){
				DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTipoGastoCodigo());
				gastoProveedor.setTipoGasto(tipoGasto);
			}
			if(!Checks.esNulo(dto.getSubtipoGastoCodigo())){
				DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtipoGastoCodigo());
				gastoProveedor.setSubtipoGasto(subtipoGasto);
			}
			if(!Checks.esNulo(dto.getDestinatario())){
				DDDestinatarioGasto destinatario = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, dto.getDestinatario());
				gastoProveedor.setDestinatarioGasto(destinatario);
			}
			if(!Checks.esNulo(dto.getPeriodicidad())){
				DDTipoPeriocidad periodicidad = (DDTipoPeriocidad) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPeriocidad.class, dto.getPeriodicidad());
				gastoProveedor.setTipoPeriocidad(periodicidad);
			}
			
			genericDao.update(GastoProveedor.class, gastoProveedor);	
			
		
		
		return true;
		
	}
	
	public boolean existeGasto(GastoProveedor gasto) {
		
		Filter filtroReferencia = genericDao.createFilter(FilterType.EQUALS, "referenciaEmisor", gasto.getReferenciaEmisor());
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.id", gasto.getTipoGasto().getId());
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", gasto.getSubtipoGasto().getId());
		Filter filtroEmisor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", gasto.getProveedor().getId());
		Filter filtroFechaEmision = genericDao.createFilter(FilterType.EQUALS, "fechaEmision", gasto.getFechaEmision());
		Filter filtroDestinatario = genericDao.createFilter(FilterType.EQUALS, "destinatarioGasto.id", gasto.getDestinatarioGasto().getId());
		
		List<GastoProveedor> lista = genericDao.getList(GastoProveedor.class, filtroReferencia, filtroTipo, filtroSubtipo, filtroEmisor, filtroFechaEmision ,filtroDestinatario);
		
		
		return !Checks.esNulo(lista) && !lista.isEmpty();
	}

	@Override
	public ActivoProveedor searchProveedorNif(String nifProveedor) {
		
		List<ActivoProveedor> listaProveedores= new ArrayList<ActivoProveedor>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nifProveedor);
		listaProveedores = genericDao.getList(ActivoProveedor.class, filtro);

		if(!Checks.estaVacio(listaProveedores)){
			return listaProveedores.get(0);
		}
		return null;
	}
	
	@Override
	public ActivoPropietario searchPropietarioNif(String nifPropietario) {
		
		List<ActivoPropietario> listaPropietarios= new ArrayList<ActivoPropietario>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", nifPropietario);
		listaPropietarios = genericDao.getList(ActivoPropietario.class, filtro);

		if(!Checks.estaVacio(listaPropietarios)){
			return listaPropietarios.get(0);
		}
		return null;
	}
	
	private DtoDetalleEconomicoGasto detalleEconomicoToDtoDetalleEconomico(GastoProveedor gasto) {

		DtoDetalleEconomicoGasto dto = new DtoDetalleEconomicoGasto();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
		GastoDetalleEconomico detalleGasto= genericDao.get(GastoDetalleEconomico.class, filtro);
		
		if(!Checks.esNulo(detalleGasto)){
			
			dto.setImportePrincipalSujeto(detalleGasto.getImportePrincipalSujeto());
			dto.setImportePrincipalNoSujeto(detalleGasto.getImportePrincipalNoSujeto());
			dto.setImporteRecargo(detalleGasto.getImporteRecargo());
			dto.setImporteInteresDemora(detalleGasto.getImporteInteresDemora());
			dto.setImporteCostas(detalleGasto.getImporteCostas());
			dto.setImporteOtrosIncrementos(detalleGasto.getImporteOtrosIncrementos());
			dto.setImporteProvisionesSuplidos(detalleGasto.getImporteProvisionesSuplidos());
			
			if(!Checks.esNulo(detalleGasto.getImpuestoIndirectoTipo())){
				dto.setImpuestoIndirectoTipoCodigo(detalleGasto.getImpuestoIndirectoTipo().getCodigo());
			}
			
			if(!Checks.esNulo(detalleGasto.getImpuestoIndirectoExento())){
				if(detalleGasto.getImpuestoIndirectoExento().equals(1)){
					dto.setImpuestoIndirectoExento(true);
				}
				if(detalleGasto.getImpuestoIndirectoExento().equals(0)){
					dto.setImpuestoIndirectoExento(false);
				}
				
			}
			
			if(!Checks.esNulo(detalleGasto.getRenunciaExencionImpuestoIndirecto())){
				if(detalleGasto.getRenunciaExencionImpuestoIndirecto().equals(1)){
					dto.setRenunciaExencionImpuestoIndirecto(true);
				}
				if(detalleGasto.getRenunciaExencionImpuestoIndirecto().equals(0)){
					dto.setRenunciaExencionImpuestoIndirecto(false);
				}
				
			}
			
			dto.setImpuestoIndirectoTipoImpositivo(detalleGasto.getImpuestoIndirectoTipoImpositivo());
			dto.setImpuestoIndirectoCuota(detalleGasto.getImpuestoIndirectoCuota());
			
			dto.setIrpfTipoImpositivo(detalleGasto.getIrpfTipoImpositivo());
			dto.setIrpfCuota(detalleGasto.getIrpfCuota());
			//TIPO IMPUESTO DIRECTO
			
			dto.setImporteTotal(detalleGasto.getImporteTotal());
			
			dto.setFechaTopePago(detalleGasto.getFechaTopePago());
			dto.setRepercutibleInquilino(detalleGasto.getRepercutibleInquilino());
			dto.setImportePagado(detalleGasto.getImportePagado());
			dto.setFechaPago(detalleGasto.getFechaPago());
			if(!Checks.esNulo(detalleGasto.getTipoPagador())){
				dto.setTipoPagadorCodigo(detalleGasto.getTipoPagador().getCodigo());
			}
			if(!Checks.esNulo(detalleGasto.getDestinatariosPago())){
				dto.setDestinatariosPagoCodigo(detalleGasto.getDestinatariosPago().getCodigo());
			}
			
			if(!Checks.esNulo(detalleGasto.getReembolsoTercero())){
				dto.setReembolsoTercero(detalleGasto.getReembolsoTercero()== 1 ? true : false);
			}
			if(!Checks.esNulo(detalleGasto.getIncluirPagoProvision())){
				dto.setIncluirPagoProvision(detalleGasto.getIncluirPagoProvision()== 1 ? true : false);
			}
			if(!Checks.esNulo(detalleGasto.getAbonoCuenta())){
				dto.setAbonoCuenta(detalleGasto.getAbonoCuenta() == 1 ? true : false);
			}
			
			
			if(!Checks.esNulo(detalleGasto.getIbanAbonar())){
				String ibanCompleto= detalleGasto.getIbanAbonar();
				String iban1="";
				String iban2="";
				String iban3="";
				String iban4="";
				String iban5="";
				String iban6="";
				for(int i=0; i<ibanCompleto.length();i++){
					if(i<=3){
						iban1= iban1+ibanCompleto.charAt(i);
					}
					else if(i>3 && i<=7){
						iban2= iban2+ibanCompleto.charAt(i);
					}
					else if(i>7 && i<=11){
						iban3= iban3+ibanCompleto.charAt(i);
					}
					else if(i>11 && i<=15){
						iban4= iban4+ibanCompleto.charAt(i);
					}
					else if(i>15 && i<=19){
						iban5= iban5+ibanCompleto.charAt(i);
					}
					else if(i>19 && i<=23){
						iban6= iban6+ibanCompleto.charAt(i);
					}
					
				}
				dto.setIban1(iban1);
				dto.setIban2(iban2);
				dto.setIban3(iban3);
				dto.setIban4(iban4);
				dto.setIban5(iban5);
				dto.setIban6(iban6);
			}
			
			dto.setIban(detalleGasto.getIbanAbonar());
			dto.setTitularCuenta(detalleGasto.getTitularCuentaAbonar());
			dto.setNifTitularCuenta(detalleGasto.getNifTitularCuentaAbonar());
			
			if(!Checks.esNulo(detalleGasto.getPagadoConexionBankia())){
				dto.setPagadoConexionBankia(detalleGasto.getPagadoConexionBankia() == 1 ? true : false);
			}
			dto.setOficina(detalleGasto.getOficinaBankia());
			dto.setNumeroConexion(detalleGasto.getNumeroConexionBankia());
			
			
		}
		

		return dto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveDetalleEconomico(DtoDetalleEconomicoGasto dto, Long idGasto){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		GastoDetalleEconomico detalleGasto= genericDao.get(GastoDetalleEconomico.class, filtro);
		
		try{
			if(!Checks.esNulo(detalleGasto)){
				try {
					beanUtilNotNull.copyProperties(detalleGasto, dto);
					
					if(!Checks.esNulo(dto.getImpuestoIndirectoExento())){
						if(dto.getImpuestoIndirectoExento()){
							detalleGasto.setImpuestoIndirectoExento(1);
						}
						if(!dto.getImpuestoIndirectoExento()){
							detalleGasto.setImpuestoIndirectoExento(0);
						}
					}
					
					if(!Checks.esNulo(dto.getRenunciaExencionImpuestoIndirecto())){
						if(dto.getRenunciaExencionImpuestoIndirecto()){
							detalleGasto.setRenunciaExencionImpuestoIndirecto(1);
						}
						if(!dto.getRenunciaExencionImpuestoIndirecto()){
							detalleGasto.setRenunciaExencionImpuestoIndirecto(0);
						}
					}
					
					if(!Checks.esNulo(dto.getImpuestoIndirectoTipoCodigo())){
						DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, dto.getImpuestoIndirectoTipoCodigo());
						detalleGasto.setImpuestoIndirectoTipo(tipoImpuesto);
					}
					
					if(!Checks.esNulo(dto.getDestinatariosPagoCodigo())){
						DDDestinatarioPago destinatarioPago = (DDDestinatarioPago) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioPago.class, dto.getDestinatariosPagoCodigo());
						detalleGasto.setDestinatariosPago(destinatarioPago);
					}
					if(!Checks.esNulo(dto.getTipoPagadorCodigo())){
						DDTipoPagador tipoPagador = (DDTipoPagador) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPagador.class, dto.getTipoPagadorCodigo());
						detalleGasto.setTipoPagador(tipoPagador);
					}
					
					if(!Checks.esNulo(dto.getReembolsoTercero())){
						detalleGasto.setReembolsoTercero(dto.getReembolsoTercero() ? 1 : 0);
					}
					
					
						if(!Checks.esNulo(dto.getIncluirPagoProvision())){
							detalleGasto.setIncluirPagoProvision(dto.getIncluirPagoProvision() ? 1 : 0);
						}
						
						if(!Checks.esNulo(dto.getAbonoCuenta())){
							detalleGasto.setAbonoCuenta(dto.getAbonoCuenta() ? 1 : 0);
						}
						if(!Checks.esNulo(dto.getIban())){
							detalleGasto.setIbanAbonar(dto.getIban());
						}
						if(!Checks.esNulo(dto.getTitularCuenta())){
							detalleGasto.setTitularCuentaAbonar(dto.getTitularCuenta());
						}
						if(!Checks.esNulo(dto.getNifTitularCuenta())){
							detalleGasto.setNifTitularCuentaAbonar(dto.getNifTitularCuenta());
						}
					
						if(!Checks.esNulo(dto.getPagadoConexionBankia())){
							detalleGasto.setPagadoConexionBankia(dto.getPagadoConexionBankia() ? 1 : 0);
						}
						if(!Checks.esNulo(dto.getOficina())){
							detalleGasto.setOficinaBankia(dto.getOficina());
						}
						if(!Checks.esNulo(dto.getNumeroConexion())){
							detalleGasto.setNumeroConexionBankia(dto.getNumeroConexion());
						}
							
						
					
					
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				genericDao.update(GastoDetalleEconomico.class, detalleGasto);				
			}
		}
		catch(Exception e) {
			return false;
		}
		
		return true;
		
	}
	
	@Override
	public List<VBusquedaGastoActivo> getListActivosGastos(Long idGasto){
		
		List<VBusquedaGastoActivo> gastosActivos= new ArrayList<VBusquedaGastoActivo>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		gastosActivos= genericDao.getList(VBusquedaGastoActivo.class, filtro);
		
		return gastosActivos;		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean createGastoActivo(Long idGasto, Long numActivo, Long numAgrupacion){
		

		if(!Checks.esNulo(idGasto) && !Checks.esNulo(numActivo)){
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
			Activo activo= genericDao.get(Activo.class, filtro);
			
			if(Checks.esNulo(activo)) {
				throw new JsonViewerException("Este activo no existe");	
			} else {
			
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
				GastoProveedor gasto= genericDao.get(GastoProveedor.class, filtroGasto);
				
				
				Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
				List<ActivoCatastro> activosCatastro= genericDao.getListOrdered(ActivoCatastro.class, order,filtroCatastro);
				
				GastoProveedorActivo gastoProveedorActivo= new GastoProveedorActivo();
				gastoProveedorActivo.setActivo(activo);
				gastoProveedorActivo.setGastoProveedor(gasto);
				if(!Checks.estaVacio(activosCatastro)) {
					gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
				}

				
				genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
				return true;
			}
			
		}
		else if(!Checks.esNulo(idGasto) && !Checks.esNulo(numAgrupacion)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", numAgrupacion);
			ActivoAgrupacion agrupacion= genericDao.get(ActivoAgrupacion.class, filtro);
			
			if(Checks.esNulo(agrupacion)) {
				throw new JsonViewerException("Esta agrupación no existe");	
			} else {
			
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
				GastoProveedor gasto= genericDao.get(GastoProveedor.class, filtroGasto);
				
				for(ActivoAgrupacionActivo activoAgrupacion: agrupacion.getActivos()){
					
					Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoAgrupacion.getActivo().getId());
					Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
					List<ActivoCatastro> activosCatastro= genericDao.getListOrdered(ActivoCatastro.class, order,filtroCatastro);
					
					GastoProveedorActivo gastoProveedorActivo= new GastoProveedorActivo();
					gastoProveedorActivo.setActivo(activoAgrupacion.getActivo());
					gastoProveedorActivo.setGastoProveedor(gasto);
					gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
					
					genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
				}
				return true;
			}

		}
		
		return false;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoActivo(DtoActivoGasto dtoActivoGasto){
		
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoGasto.getId());
			GastoProveedorActivo gastoActivo= genericDao.get(GastoProveedorActivo.class, filtro);
			
			if(!Checks.esNulo(dtoActivoGasto.getParticipacion())){
				gastoActivo.setParticipacionGasto(dtoActivoGasto.getParticipacion());
				
			}
			
			if(!Checks.esNulo(dtoActivoGasto.getReferenciaCatastral())){
				gastoActivo.setReferenciaCatastral(dtoActivoGasto.getReferenciaCatastral());
			}
			
			genericDao.update(GastoProveedorActivo.class, gastoActivo);
			
		}catch(Exception e) {
			return false;
		}
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoActivo(DtoActivoGasto dtoActivoGasto){
		
		try{
			genericDao.deleteById(GastoProveedorActivo.class, dtoActivoGasto.getId());

		}catch(Exception e) {
			return false;
		}
		
		return true;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoProveedor(Long id) {
		
		// TODO en el caso de utilizarse, se deberá tener en cuenta si se borran todas las referencias del gasto.
		try{
			genericDao.deleteById(GastoProveedor.class, id);

		}catch(Exception e) {
			return false;
		}
		
		return true;	
		
	}

	
	public DtoInfoContabilidadGasto infoContabilidadToDtoInfoContabilidad(GastoProveedor gasto){
		
		DtoInfoContabilidadGasto dto= new DtoInfoContabilidadGasto();
		
		if(!Checks.esNulo(gasto)){
		
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);
			
			if(!Checks.esNulo(contabilidadGasto)){
				if(!Checks.esNulo(contabilidadGasto.getEjercicio())){
					dto.setEjercicioImputaGasto(contabilidadGasto.getEjercicio().getId());
				}
				if(!Checks.esNulo(gasto.getTipoPeriocidad())){
					dto.setPeriodicidadDescripcion(gasto.getTipoPeriocidad().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getPartidaPresupuestaria())){
					dto.setPartidaPresupuestariaDescripcion(contabilidadGasto.getPartidaPresupuestaria().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getCuentaContable())){
					dto.setCuentaContableDescripcion(contabilidadGasto.getCuentaContable().getDescripcion());
				}
				
				dto.setFechaDevengo(contabilidadGasto.getFechaDevengoEspecial());
				if(!Checks.esNulo(contabilidadGasto.getTipoPeriocidadEspecial())){
					dto.setPeriodicidadEspecialDescripcion(contabilidadGasto.getTipoPeriocidadEspecial().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getPartidaPresupuestariaEspecial())){
					dto.setPartidaPresupuestariaEspecialDescripcion(contabilidadGasto.getPartidaPresupuestariaEspecial().getDescripcion());
				}
				if(!Checks.esNulo(contabilidadGasto.getCuentaContableEspecial())){
					dto.setCuentaContableEspecialDescripcion(contabilidadGasto.getCuentaContableEspecial().getDescripcion());
				}
				
				dto.setFechaContabilizacion(contabilidadGasto.getFechaContabilizacion());
				if(!Checks.esNulo(contabilidadGasto.getContabilizadoPor())){
					dto.setContabilizadoPorDescripcion(contabilidadGasto.getContabilizadoPor().getDescripcion());
				}
			}
			
		}

		return dto;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto, Long idGasto){
		
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);
			
			if(!Checks.esNulo(dtoContabilidadGasto.getEjercicioImputaGasto())){
				
				Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getEjercicioImputaGasto());
				Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
				
				contabilidadGasto.setEjercicio(ejercicio);
				
				genericDao.update(GastoInfoContabilidad.class, contabilidadGasto);
				
			}
			
			return true;
			
		}catch(Exception e) {
			return false;
		}
		
		
	}
	
	public DtoGestionGasto gestionToDtoGestion(GastoProveedor gasto){
		DtoGestionGasto dtoGestion= new DtoGestionGasto();
		
		if(!Checks.esNulo(gasto)){
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoGestion gastoGestion = genericDao.get(GastoGestion.class, filtro);
			
			if(!Checks.esNulo(gastoGestion)){
				
				dtoGestion.setNecesariaAutorizacionPropietario(gastoGestion.getAutorizaPropietario());
				if(!Checks.esNulo(gastoGestion.getMotivoAutorizacionPropietario())){
					dtoGestion.setComboMotivoAutorizacionPropietario(gastoGestion.getMotivoAutorizacionPropietario().getCodigo());
				}
				if(!Checks.esNulo(gasto.getProvision())){
					if(!Checks.esNulo(gasto.getProvision().getGestoria())){
						dtoGestion.setGestoria(gasto.getProvision().getGestoria().getNombre());
					}
					dtoGestion.setNumProvision(gasto.getProvision().getNumProvision());
				}
				dtoGestion.setObservaciones(gastoGestion.getObservaciones());
				//////
				dtoGestion.setFechaAltaRem(gastoGestion.getFechaAlta());
				
				if(!Checks.esNulo(gastoGestion.getUsuarioAlta())){
					dtoGestion.setGestorAltaRem(gastoGestion.getUsuarioAlta().getApellidoNombre());
				}
				////
				
				if(!Checks.esNulo(gastoGestion.getEstadoAutorizacionHaya())){
					dtoGestion.setComboEstadoAutorizacionHaya(gastoGestion.getEstadoAutorizacionHaya().getCodigo());
				}
				
				dtoGestion.setFechaAutorizacionHaya(gastoGestion.getFechaEstadoAutorizacionHaya());
				
				if(!Checks.esNulo(gastoGestion.getUsuarioEstadoAutorizacionHaya())){
					dtoGestion.setGestorAutorizacionHaya(gastoGestion.getUsuarioEstadoAutorizacionHaya().getApellidoNombre());
				}
				if(!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionHaya())){
					dtoGestion.setComboMotivoRechazoHaya(gastoGestion.getMotivoRechazoAutorizacionHaya().getCodigo());;
				}
				////
				
				if(!Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario())){
					dtoGestion.setComboEstadoAutorizacionPropietario(gastoGestion.getEstadoAutorizacionPropietario().getCodigo());
				}
				
				dtoGestion.setFechaAutorizacionPropietario(gastoGestion.getFechaEstadoAutorizacionPropietario());
				
				if(!Checks.esNulo(gastoGestion.getMotivoRechazoAutorizacionPropietario())){
					dtoGestion.setMotivoRechazoAutorizacionPropietario(gastoGestion.getMotivoRechazoAutorizacionPropietario());
				}
				
				////////////////
				
				dtoGestion.setFechaAnulado(gastoGestion.getFechaAnulacionGasto());
				
				if(!Checks.esNulo(gastoGestion.getUsuarioAnulacion())){
					dtoGestion.setGestorAnulado(gastoGestion.getUsuarioAnulacion().getApellidoNombre());
				}
				if(!Checks.esNulo(gastoGestion.getMotivoAnulacion())){
					dtoGestion.setComboMotivoAnulado(gastoGestion.getMotivoAnulacion().getCodigo());
				}
				////////////////
				
				dtoGestion.setFechaRetenerPago(gastoGestion.getFechaRetencionPago());
				
				if(!Checks.esNulo(gastoGestion.getUsuarioRetencionPago())){
					dtoGestion.setGestorRetenerPago(gastoGestion.getUsuarioRetencionPago().getApellidoNombre());
				}
				if(!Checks.esNulo(gastoGestion.getMotivoRetencionPago())){
					dtoGestion.setComboMotivoRetenerPago(gastoGestion.getMotivoRetencionPago().getCodigo());
				}
			}
		}
		return dtoGestion;
		
	}
	
	@Transactional(readOnly = false)
	public boolean updateGestionGasto(DtoGestionGasto dtoGestionGasto, Long idGasto){
		
		try{
			
			Usuario usuario = genericAdapter.getUsuarioLogado();
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoGestion gestionGasto = genericDao.get(GastoGestion.class, filtro);
			
			if(!Checks.esNulo(gestionGasto)){
				
				beanUtilNotNull.copyProperties(gestionGasto, dtoGestionGasto);
				
				if(!Checks.esNulo(dtoGestionGasto.getNecesariaAutorizacionPropietario())){
					gestionGasto.setAutorizaPropietario(dtoGestionGasto.getNecesariaAutorizacionPropietario());
				}
				if(("").equals(dtoGestionGasto.getComboMotivoAutorizacionPropietario())){
					gestionGasto.setMotivoAutorizacionPropietario(null);
				}
				if(!Checks.esNulo(dtoGestionGasto.getComboMotivoAutorizacionPropietario()) && !dtoGestionGasto.getComboMotivoAutorizacionPropietario().equals("")){
					DDMotivoAutorizacionPropietario motivoAutoPro= (DDMotivoAutorizacionPropietario) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAutorizacionPropietario.class, dtoGestionGasto.getComboMotivoAutorizacionPropietario());
					gestionGasto.setMotivoAutorizacionPropietario(motivoAutoPro);
					
				}
				if(!Checks.esNulo(dtoGestionGasto.getComboEstadoAutorizacionHaya())){
					DDEstadoAutorizacionHaya estadoAutoHaya= (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class, dtoGestionGasto.getComboEstadoAutorizacionHaya());
					gestionGasto.setEstadoAutorizacionHaya(estadoAutoHaya);
					gestionGasto.setFechaEstadoAutorizacionHaya(new Date());
					gestionGasto.setUsuarioEstadoAutorizacionHaya(usuario);
				}
				if(!Checks.esNulo(dtoGestionGasto.getComboMotivoRechazoHaya())){
					DDMotivoRechazoAutorizacionHaya motivoAutoHaya= (DDMotivoRechazoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRechazoAutorizacionHaya.class, dtoGestionGasto.getComboMotivoRechazoHaya());
					gestionGasto.setMotivoRechazoAutorizacionHaya(motivoAutoHaya);
				}
				if(!Checks.esNulo(dtoGestionGasto.getComboMotivoAnulado())){
					DDMotivoAnulacionGasto motivoAnulacion= (DDMotivoAnulacionGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoAnulacionGasto.class, dtoGestionGasto.getComboMotivoAnulado());
					gestionGasto.setMotivoAnulacion(motivoAnulacion);
					gestionGasto.setFechaAnulacionGasto(new Date());
					gestionGasto.setUsuarioAnulacion(usuario);
				}
				if(!Checks.esNulo(dtoGestionGasto.getComboMotivoRetenerPago())){
					DDMotivoRetencionPago retenerPago= (DDMotivoRetencionPago) utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoRetencionPago.class, dtoGestionGasto.getComboMotivoRetenerPago());
					gestionGasto.setMotivoRetencionPago(retenerPago);
					gestionGasto.setFechaRetencionPago(new Date());
					gestionGasto.setUsuarioRetencionPago(usuario);
				}
				
				genericDao.update(GastoGestion.class, gestionGasto);
				
				
				return true;
			}
			
		}catch(Exception e) {
			return false;
		}
		
		return false;
		
	}
	
	public DtoImpugnacionGasto impugnaciontoDtoImpugnacion(GastoProveedor gasto){
		
		DtoImpugnacionGasto dtoImpugnacion= new DtoImpugnacionGasto();
		
		if(!Checks.esNulo(gasto)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoImpugnacion gastoImpugnacion = genericDao.get(GastoImpugnacion.class, filtro);
			
			dtoImpugnacion.setFechaTope(gastoImpugnacion.getFechaTope());
			dtoImpugnacion.setFechaPresentacion(gastoImpugnacion.getFechaPresentacion());
			dtoImpugnacion.setFechaResolucion(gastoImpugnacion.getFechaResolucion());
			
			if(!Checks.esNulo(gastoImpugnacion.getResultadoImpugnacion())){
				dtoImpugnacion.setResultadoCodigo(gastoImpugnacion.getResultadoImpugnacion().getCodigo());
			}
			dtoImpugnacion.setObservaciones(gastoImpugnacion.getObservaciones());
		}
		
		return dtoImpugnacion;
	}
	
	@Transactional(readOnly = false)
	public boolean updateImpugnacionGasto(DtoImpugnacionGasto dto, Long idGasto){
		
		try{
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
			GastoImpugnacion gastoImpugnacion = genericDao.get(GastoImpugnacion.class, filtro);
			
			if(!Checks.esNulo(gastoImpugnacion)){
				beanUtilNotNull.copyProperties(gastoImpugnacion, dto);
				
				if(!Checks.esNulo(dto.getResultadoCodigo())){
					DDResultadoImpugnacionGasto resultado= (DDResultadoImpugnacionGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDResultadoImpugnacionGasto.class, dto.getResultadoCodigo());
					gastoImpugnacion.setResultadoImpugnacion(resultado);
				}
				
				genericDao.update(GastoImpugnacion.class, gastoImpugnacion);
				return true;
				
			}
			
			
		}catch(Exception e) {
			return false;
		}
		
		return false;
		
	}
	@Transactional(readOnly = false)
	public boolean asignarTrabajos(Long idGasto, Long[] trabajos) {
		
		GastoProveedor gasto = findOne(idGasto);	

		
		for(Long idTrabajo : trabajos) {
			
			Trabajo trabajo = trabajoApi.findOne(idTrabajo);
			// Asignamos el trabajo al gasto
			GastoProveedorTrabajo gastoTrabajo = new GastoProveedorTrabajo();
			gastoTrabajo.setTrabajo(trabajo);
			gastoTrabajo.setGastoProveedor(gasto);
			
			genericDao.save(GastoProveedorTrabajo.class, gastoTrabajo);
			gasto.getGastoProveedorTrabajos().add(gastoTrabajo);
			
			// Asignamos los activos del trabajo al gasto
			
			gasto = asignarActivos(gasto, trabajo);
			

		}
		
		gasto = calcularImportesDetalleEconomicoGasto(gasto);
		
		gasto = calcularParticipacionActivosGasto(gasto);
		
		genericDao.save(GastoProveedor.class, gasto);
		
		return true;
		
	}
	
	private GastoProveedor asignarActivos(GastoProveedor gasto, Trabajo trabajo) {
		
		for(ActivoTrabajo activo : trabajo.getActivosTrabajo()) {
			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getPrimaryKey().getActivo().getId());
			Filter filtroGasto= genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoProveedorActivo gastoActivo = genericDao.get(GastoProveedorActivo.class, filtroActivo, filtroGasto);
			
			// Si no existe ya 
			if(Checks.esNulo(gastoActivo)) {
				gastoActivo = new GastoProveedorActivo();
				gastoActivo.setActivo(activo.getPrimaryKey().getActivo());
				gastoActivo.setGastoProveedor(gasto);
				gastoActivo.setParticipacionGasto(activo.getParticipacion());
				
				genericDao.save(GastoProveedorActivo.class, gastoActivo);
				gasto.getGastoProveedorActivos().add(gastoActivo);
			}			
		}
		
		return gasto;
	}

	@Override
    @BusinessOperationDefinition("gastoProveedorManager.getAdjuntosGasto")
	public List<DtoAdjunto> getAdjuntos(Long id) {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		try{
			
			GastoProveedor gasto = findOne(id);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", id);
			List<AdjuntoGasto> adjuntosGasto = genericDao.getList(AdjuntoGasto.class, filtro);


			for (AdjuntoGasto adjunto : adjuntosGasto) {
				DtoAdjunto dto = new DtoAdjunto();
				
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdGasto(gasto.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoGasto().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());				
				
				listaAdjuntos.add(dto);
				
			}
		
		}catch(Exception ex){
			ex.printStackTrace();
		}

		return listaAdjuntos;
	}
	
	@Override
	@BusinessOperation(overrides = "gastoProveedorManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem fileItem) throws Exception {

			ActivoAdjuntoActivo adjuntoActivo= null;
			GastoProveedor gasto= findOne(Long.parseLong(fileItem.getParameter("idEntidad")));
			
			Adjunto adj = uploadAdapter.saveBLOB(fileItem.getFileItem());
			
			AdjuntoGasto adjuntoGasto= new AdjuntoGasto();
			adjuntoGasto.setAdjunto(adj);
			
			adjuntoGasto.setGastoProveedor(gasto);
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
			DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);
			adjuntoGasto.setTipoDocumentoGasto(tipoDocumento);
			
			adjuntoGasto.setContentType(fileItem.getFileItem().getContentType());
			
			adjuntoGasto.setTamanyo(fileItem.getFileItem().getLength());
			
			adjuntoGasto.setNombre(fileItem.getFileItem().getFileName());

			adjuntoGasto.setDescripcion(fileItem.getParameter("descripcion"));			
			
			adjuntoGasto.setFechaDocumento(new Date());

			Auditoria.save(adjuntoGasto);
	        
			genericDao.save(AdjuntoGasto.class, adjuntoGasto);
			
			for(GastoProveedorActivo g: gasto.getGastoProveedorActivos()){
				
				if(!Checks.esNulo(adjuntoGasto) && !Checks.esNulo(adjuntoGasto.getTipoDocumentoGasto()) 
						&& !Checks.esNulo(adjuntoGasto.getTipoDocumentoGasto().getMatricula())){
					activoAdapter.uploadDocumento(fileItem, g.getActivo(), adjuntoGasto.getTipoDocumentoGasto().getMatricula());
					adjuntoActivo= g.getActivo().getAdjuntos().get(g.getActivo().getAdjuntos().size()-1);
				}
				
			}
			
			if(!Checks.esNulo(adjuntoActivo)){
				adjuntoGasto.setIdDocRestClient(adjuntoActivo.getIdDocRestClient());
				genericDao.update(AdjuntoGasto.class, adjuntoGasto);
			}
			
			//Copia de adjunto al Activo
//			ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
//
//			adjuntoActivo.setAdjunto(adj);
//			adjuntoActivo.setActivo(trabajo.getActivo());
//			adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);
//			adjuntoActivo.setContentType(fileItem.getFileItem().getContentType());
//			adjuntoActivo.setTamanyo(fileItem.getFileItem().getLength());
//			adjuntoActivo.setNombre(fileItem.getFileItem().getFileName());
//			adjuntoActivo.setDescripcion(fileItem.getParameter("descripcion"));			
//			adjuntoActivo.setFechaDocumento(new Date());
//			Auditoria.save(adjuntoActivo);
//			trabajo.getActivo().getAdjuntos().add(adjuntoActivo);
			
	        
		return null;

	}
	
	@Override
	@BusinessOperation(overrides = "gastoProveedorManager.deleteAdjunto")
	@Transactional(readOnly = false)
    public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		try{
			GastoProveedor gasto= findOne(dtoAdjunto.getIdGasto());
			AdjuntoGasto adjuntoGasto= gasto.getAdjunto(dtoAdjunto.getId());
			
			
			
		    if (adjuntoGasto == null) { return false; }
		    gasto.getAdjuntos().remove(adjuntoGasto);
		    genericDao.save(GastoProveedor.class, gasto);
		    
		}catch (Exception e) {
			e.printStackTrace();
		}
	    
	    
	    return true;
	}
	
	@Override
    @BusinessOperationDefinition("gastoProveedorManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {
		
		GastoProveedor gasto= findOne(dtoAdjunto.getIdGasto());
		AdjuntoGasto adjuntoGasto= gasto.getAdjunto(dtoAdjunto.getId());
		
		FileItem fileItem = adjuntoGasto.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoGasto.getContentType());
		fileItem.setFileName(adjuntoGasto.getNombre());
		
		return adjuntoGasto.getAdjunto().getFileItem();
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean desasignarTrabajos(Long idGasto, Long[] ids) {
		
		GastoProveedor gasto = findOne(idGasto);
		
		//Desasignamos los trabajo del gasto
		for(Long id : ids) {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
			GastoProveedorTrabajo gastoTrabajoEliminado = genericDao.get(GastoProveedorTrabajo.class, filtro);
			gasto.getGastoProveedorTrabajos().remove(gastoTrabajoEliminado);
			gastoDao.deleteGastoTrabajoById(id);			
		}
		
		// Desasignamos TODOS los activos
		for(GastoProveedorActivo gastoActivo : gasto.getGastoProveedorActivos()) {
			genericDao.deleteById(GastoProveedorActivo.class, gastoActivo.getId());
		}
		gasto.getGastoProveedorActivos().clear();
		
		// Volvemos a asignar los activos de los trabajos que queden
		for(GastoProveedorTrabajo gastoTrabajo: gasto.getGastoProveedorTrabajos()) {
			
			asignarActivos(gasto, gastoTrabajo.getTrabajo());
		}
		
		// Calculamos importe y participación
		gasto = calcularImportesDetalleEconomicoGasto(gasto);
		
		gasto = calcularParticipacionActivosGasto(gasto);
		
		genericDao.save(GastoProveedor.class, gasto);
		
		
		return true;
		
	}
	
	@Override
	public List<VBusquedaGastoTrabajos> getListTrabajosGasto(Long idGasto){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		List<VBusquedaGastoTrabajos> gastoTrabajos= genericDao.getList(VBusquedaGastoTrabajos.class, filtro);
		
		return gastoTrabajos;
	}
	
	private GastoProveedor calcularImportesDetalleEconomicoGasto(GastoProveedor gasto) {
		
		Double importeGasto = new Double(0);
		Double importeProvisionesSuplidos = new Double(0);

		for(GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {
			importeGasto += gastoTrabajo.getTrabajo().getImporteTotal();
			importeProvisionesSuplidos += gastoTrabajo.getTrabajo().getImporteProvisionesSuplidos();			
		}
	
		gasto.getGastoDetalleEconomico().setImportePrincipalSujeto(importeGasto);
		gasto.getGastoDetalleEconomico().setImporteProvisionesSuplidos(importeProvisionesSuplidos);
		
		return gasto;
		
	}

	private GastoProveedor calcularParticipacionActivosGasto(GastoProveedor gasto) {
		
		Double importeTotal = gasto.getGastoDetalleEconomico().getImportePrincipalSujeto();
		Map<Long, Double> mapa = new HashMap<Long,Double>();
		
		for(GastoProveedorTrabajo gastoTrabajo : gasto.getGastoProveedorTrabajos()) {
			Double importeTrabajo = gastoTrabajo.getTrabajo().getImporteTotal();
			for(ActivoTrabajo activoTrabajo : gastoTrabajo.getTrabajo().getActivosTrabajo()) {
				Activo activo = activoTrabajo.getPrimaryKey().getActivo();
				Float participacion = activoTrabajo.getParticipacion();
				if(mapa.containsKey(activo.getId())) {
					Double importe = mapa.get(activo.getId());
					mapa.put(activo.getId(), importe + importeTrabajo * participacion / 100);					
				} else {
					mapa.put(activo.getId(), importeTrabajo * participacion / 100);
				}				
			}			
		}
		
		for(GastoProveedorActivo gastoActivo : gasto.getGastoProveedorActivos()) {
			Long idActivo = gastoActivo.getActivo().getId();
			gastoActivo.setParticipacionGasto((float) (mapa.get(idActivo)*100/importeTotal));
			//genericDao.save(GastoProveedorActivo.class, gastoActivo);
		}
		
		return gasto;
		
	}	

}
