package es.pfsgroup.plugin.rem.gastoProveedor;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoProveedorActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
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
//	public final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";
//	public final String PESTANA_RESERVA = "reserva";
//	public final String PESTANA_CONDICIONES = "condiciones";
//	public final String PESTANA_FORMALIZACION= "formalizacion";

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
	private GastoDao gastoDao;
	
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

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

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
			
			
		}

		return dto;
	}
	
	@Override
	@Transactional(readOnly = false)
	public GastoProveedor saveGastosProveedor(DtoFichaGastoProveedor dto){
		
		GastoProveedor gastoProveedor = null;
		
		DDDestinatarioGasto destinatarioGasto = null;		
		
		if(Checks.esNulo(dto.getIdGasto())) {
			

			// TODO Ver si es necesario añadir más datos al nuevo gasto.
			gastoProveedor = new GastoProveedor();
			
			gastoProveedor.setNumGastoHaya(gastoDao.getNextNumGasto());
			
			if(!Checks.esNulo(dto.getNifEmisor())){				
				ActivoProveedor proveedor = searchProveedorNif(dto.getNifEmisor());
				gastoProveedor.setProveedor(proveedor);
			}
			
			if(!Checks.esNulo(dto.getDestinatarioGastoCodigo())){
				destinatarioGasto = (DDDestinatarioGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDDestinatarioGasto.class, dto.getDestinatarioGastoCodigo());
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
				// Creamos el gasto
				genericDao.save(GastoProveedor.class, gastoProveedor);	
				GastoGestion gestion = new GastoGestion();
				DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE);
				gestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
				gestion.setGastoProveedor(gastoProveedor);	
				
				genericDao.save(GastoGestion.class, gestion);			
			}
			
		} else {
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdGasto());
			gastoProveedor = genericDao.get(GastoProveedor.class, filtro);			
			
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
			
		}
		
		return gastoProveedor;
		
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
			
			dto.setIrpfTipoImpositivo(detalleGasto.getIrpfCuota());
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
		
		try{
			if(!Checks.esNulo(idGasto) && !Checks.esNulo(numActivo)){
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
				Activo activo= genericDao.get(Activo.class, filtro);
				
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
				GastoProveedor gasto= genericDao.get(GastoProveedor.class, filtroGasto);
				
				
				Filter filtroCatastro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				Order order = new Order(OrderType.DESC, "fechaRevValorCatastral");
				List<ActivoCatastro> activosCatastro= genericDao.getListOrdered(ActivoCatastro.class, order,filtroCatastro);
				
				GastoProveedorActivo gastoProveedorActivo= new GastoProveedorActivo();
				gastoProveedorActivo.setActivo(activo);
				gastoProveedorActivo.setGastoProveedor(gasto);
				gastoProveedorActivo.setReferenciaCatastral(activosCatastro.get(0).getRefCatastral());
				
				genericDao.save(GastoProveedorActivo.class, gastoProveedorActivo);
				return true;
				
			}
			else if(!Checks.esNulo(idGasto) && !Checks.esNulo(numAgrupacion)){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", numAgrupacion);
				ActivoAgrupacion agrupacion= genericDao.get(ActivoAgrupacion.class, filtro);
				
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
		
		catch(Exception e) {
			return false;
		}
		
		return false;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateGastoActivo(DtoActivoGasto dtoActivoGasto){
		
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoActivoGasto.getId());
			GastoProveedorActivo gastoActivo= genericDao.get(GastoProveedorActivo.class, filtro);
			
			if(!Checks.esNulo(dtoActivoGasto.getParticipacionGasto())){
				gastoActivo.setParticipacionGasto(dtoActivoGasto.getParticipacionGasto());
				
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
	
	public DtoInfoContabilidadGasto infoContabilidadToDtoInfoContabilidad(GastoProveedor gasto){
		
		DtoInfoContabilidadGasto dto= new DtoInfoContabilidadGasto();
		
		if(!Checks.esNulo(gasto)){
		
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);
			
			if(!Checks.esNulo(contabilidadGasto)){
				if(!Checks.esNulo(contabilidadGasto.getEjercicio())){
					dto.setEjercicioImputaGasto(contabilidadGasto.getEjercicio().getAnyo());
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
	public boolean updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidadGasto){
		
		try{
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoContabilidadGasto.getId());
			GastoInfoContabilidad contabilidadGasto = genericDao.get(GastoInfoContabilidad.class, filtro);
			
			if(!Checks.esNulo(dtoContabilidadGasto.getEjercicioImputaGasto())){
				Ejercicio ejercicio= contabilidadGasto.getEjercicio();
				if(!Checks.esNulo(ejercicio)){
					ejercicio.setAnyo(dtoContabilidadGasto.getEjercicioImputaGasto());
					genericDao.update(Ejercicio.class, ejercicio);
				}
			}
			
			return true;
			
		}catch(Exception e) {
			return false;
		}
		
		
	}
	

	

}
