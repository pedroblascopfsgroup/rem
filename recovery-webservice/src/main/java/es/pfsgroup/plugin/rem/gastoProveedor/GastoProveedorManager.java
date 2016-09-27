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
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioPago;
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
	
	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	

	@Override
	public GastoProveedor findOne(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtro);

		return gasto;
	}

	@Override
	public Object getTabExpediente(Long id, String tab) {
		
		GastoProveedor gasto = findOne(id);
		
		WebDto dto = null;

		try {
			
			if(PESTANA_FICHA.equals(tab)){
				dto = gastoToDtoFichaGasto(gasto);
			}
			if(PESTANA_DETALLE_ECONOMICO.equals(tab)){
				dto= detalleEconomicoToDtoDetalleEconomico(gasto);
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

	}
	
	private DtoFichaGastoProveedor gastoToDtoFichaGasto(GastoProveedor gasto) {

		DtoFichaGastoProveedor dto = new DtoFichaGastoProveedor();
		
		if(!Checks.esNulo(gasto)){
			
			dto.setNumGastoHaya(gasto.getNumGastoHaya());
			dto.setNumGastoGestoria(gasto.getNumGastoGestoria());
			dto.setReferenciaEmisor(gasto.getReferenciaEmisor());
			
			if(!Checks.esNulo(gasto.getTipoGasto())){
				dto.setTiposGasto(gasto.getTipoGasto().getCodigo());
			}
			if(!Checks.esNulo(gasto.getSubtipoGasto())){
				dto.setSubtiposGasto(gasto.getSubtipoGasto().getCodigo());
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
	public boolean saveGastosProveedor(DtoFichaGastoProveedor dto, Long idGasto){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idGasto);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtro);
		
		try{
			if(!Checks.esNulo(gastoProveedor)){
				try {
					beanUtilNotNull.copyProperties(gastoProveedor, dto);
					
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
					
					if(!Checks.esNulo(dto.getTiposGasto())){
						DDTipoGasto tipoGasto = (DDTipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoGasto.class, dto.getTiposGasto());
						gastoProveedor.setTipoGasto(tipoGasto);
					}
					if(!Checks.esNulo(dto.getSubtiposGasto())){
						DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, dto.getSubtiposGasto());
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
					
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				genericDao.update(GastoProveedor.class, gastoProveedor);				
			}
		}
		catch(Exception e) {
			return false;
		}
		
		return true;
		
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
	

	

}
