package es.pfsgroup.plugin.rem.gasto.linea.detalle;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionCuentasContables;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionPtdasPrep;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImporte;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Service("gastoLineaDetalleManager")
public class GastoLineaDetalleManager implements GastoLineaDetalleApi {
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GastoLineaDetalleDao gastoLineaDetalleDao;

	
	@Override
	public List<DtoLineaDetalleGasto> getGastoLineaDetalle(Long idGasto) throws Exception{
		List<DtoLineaDetalleGasto> dtoLineaDetalleGastoLista = new ArrayList<DtoLineaDetalleGasto>();
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", idGasto);
		List<GastoLineaDetalle> gastoLineaDetalleLista = genericDao.getList(GastoLineaDetalle.class,filtro);
		GastoProveedor gasto = genericDao.get(GastoProveedor.class,genericDao.createFilter(FilterType.EQUALS, "id", idGasto));
		
		if(gastoLineaDetalleLista == null || gastoLineaDetalleLista.isEmpty()) {
			return dtoLineaDetalleGastoLista;
		}
		
		
		if(gasto.getCartera() != null && DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getCartera().getCodigo())) {
			GastoLineaDetalle gld = gastoLineaDetalleLista.get(0);
			gastoLineaDetalleLista.clear();
			gastoLineaDetalleLista.add(gld);
		}
		
		for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleLista) {
			DtoLineaDetalleGasto dto = new DtoLineaDetalleGasto();
			
			dto.setId(gastoLineaDetalle.getId());
			dto.setIdGasto(idGasto);
			
			if(gastoLineaDetalle.getSubtipoGasto() !=null) {
				dto.setSubtipoGasto(gastoLineaDetalle.getSubtipoGasto().getCodigo());
			}
			
			dto.setBaseSujeta(gastoLineaDetalle.getPrincipalSujeto());
			dto.setBaseNoSujeta(gastoLineaDetalle.getPrincipalNoSujeto());
			dto.setRecargo(gastoLineaDetalle.getRecargo());
			
			
			if(gastoLineaDetalle.getTipoRecargoGasto() != null) {
				dto.setTipoRecargo(gastoLineaDetalle.getTipoRecargoGasto().getCodigo());
			}
			
			dto.setInteres(gastoLineaDetalle.getInteresDemora());
			dto.setCostas(gastoLineaDetalle.getCostas());
			dto.setOtros(gastoLineaDetalle.getOtrosIncrementos());
			dto.setProvSupl(gastoLineaDetalle.getProvSuplidos());
			
			
			if(gastoLineaDetalle.getTipoImpuesto() != null) {
				dto.setTipoImpuesto(gastoLineaDetalle.getTipoImpuesto().getCodigo());
			}
			

			dto.setOperacionExentaImp(gastoLineaDetalle.getEsImporteIndirectoExento());
			dto.setEsRenunciaExenta(gastoLineaDetalle.getEsImporteIndirectoRenunciaExento());
			dto.setTipoImpositivo(gastoLineaDetalle.getImporteIndirectoTipoImpositivo());

			dto.setCuota(gastoLineaDetalle.getImporteIndirectoCuota());
			
			dto.setCcBase(gastoLineaDetalle.getCccBase());
			dto.setPpBase(gastoLineaDetalle.getCppBase());
			dto.setCcEsp(gastoLineaDetalle.getCccEsp());
			dto.setPpEsp(gastoLineaDetalle.getCppEsp());
			dto.setCcTasas(gastoLineaDetalle.getCccTasas());
			dto.setPpTasas(gastoLineaDetalle.getCppTasas());
			dto.setCcRecargo(gastoLineaDetalle.getCccRecargo());
			dto.setPpRecargo(gastoLineaDetalle.getCppRecargo());	
			dto.setCcInteres(gastoLineaDetalle.getCccIntereses());
			dto.setPpInteres(gastoLineaDetalle.getCppIntereses());
			
			dto.setSubcuentaBase(gastoLineaDetalle.getSubcuentaBase());
			dto.setApartadoBase(gastoLineaDetalle.getApartadoBase());
			dto.setCapituloBase(gastoLineaDetalle.getCapituloBase());
			dto.setSubcuentaRecargo(gastoLineaDetalle.getSubcuentaRecargo());
			dto.setApartadoRecargo(gastoLineaDetalle.getApartadoRecargo());
			dto.setCapituloRecargo(gastoLineaDetalle.getCapituloRecargo());
			dto.setSubcuentaTasa(gastoLineaDetalle.getSubcuentaTasa());
			dto.setApartadoTasa(gastoLineaDetalle.getApartadoTasa());
			dto.setCapituloTasa(gastoLineaDetalle.getCapituloTasa());
			dto.setSubcuentaIntereses(gastoLineaDetalle.getSubcuentaIntereses());
			dto.setApartadoIntereses(gastoLineaDetalle.getApartadoIntereses());
			dto.setCapituloIntereses(gastoLineaDetalle.getCapituloIntereses());
			
			dto.setImporteTotal(gastoLineaDetalle.getImporteTotal());
			
			
			dtoLineaDetalleGastoLista.add(dto);
		}
		
		return dtoLineaDetalleGastoLista;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean saveGastoLineaDetalle(DtoLineaDetalleGasto dto) throws Exception {
		GastoLineaDetalle gastoLineaDetalle;
		GastoProveedor gasto = null;
		Filter filtro;
		
		if(dto.getId() != null) {
			gastoLineaDetalle = genericDao.get(GastoLineaDetalle.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getId()));
		}else {
			gastoLineaDetalle = new GastoLineaDetalle();
			gastoLineaDetalle.setAuditoria(Auditoria.getNewInstance());
		}
		
		if(dto.getIdGasto() != null) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdGasto());
			gasto = genericDao.get(GastoProveedor.class, filtro);
			gastoLineaDetalle.setGastoProveedor(gasto);
		}
		
		if(dto.getSubtipoGasto() != null) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSubtipoGasto());
			gastoLineaDetalle.setSubtipoGasto(genericDao.get(DDSubtipoGasto.class, filtro));
		}
		
		gastoLineaDetalle.setPrincipalSujeto(dto.getBaseSujeta());
		gastoLineaDetalle.setPrincipalNoSujeto(dto.getBaseNoSujeta());
		gastoLineaDetalle.setRecargo(dto.getRecargo());
		
		if(dto.getTipoRecargo() != null) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoRecargo());
			gastoLineaDetalle.setTipoRecargoGasto(genericDao.get(DDTipoRecargoGasto.class, filtro));
		}

		gastoLineaDetalle.setInteresDemora(dto.getInteres());
		gastoLineaDetalle.setCostas(dto.getCostas());
		gastoLineaDetalle.setOtrosIncrementos(dto.getOtros());
		gastoLineaDetalle.setProvSuplidos(dto.getProvSupl());
		
		if(dto.getTipoImpuesto() != null) {
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoImpuesto());
			gastoLineaDetalle.setTipoImpuesto(genericDao.get(DDTiposImpuesto.class, filtro));
		}
		

		gastoLineaDetalle.setEsImporteIndirectoExento(dto.getOperacionExentaImp());
		gastoLineaDetalle.setEsImporteIndirectoRenunciaExento(dto.getEsRenunciaExenta());
		gastoLineaDetalle.setImporteIndirectoTipoImpositivo(dto.getTipoImpositivo());
		
		gastoLineaDetalle.setImporteIndirectoCuota(dto.getCuota());

			
		gastoLineaDetalle.setCccBase(dto.getCcBase());
		gastoLineaDetalle.setCppBase(dto.getPpBase());
		gastoLineaDetalle.setCccEsp(dto.getCcEsp());
		gastoLineaDetalle.setCppEsp(dto.getPpEsp());
		gastoLineaDetalle.setCccTasas(dto.getCcTasas());
		gastoLineaDetalle.setCppTasas(dto.getPpTasas());
		gastoLineaDetalle.setCccRecargo(dto.getCcRecargo());
		gastoLineaDetalle.setCppRecargo(dto.getPpRecargo());	
		gastoLineaDetalle.setCccIntereses(dto.getCcInteres());
		gastoLineaDetalle.setCppIntereses(dto.getPpInteres());
		
		gastoLineaDetalle.setSubcuentaBase(dto.getSubcuentaBase());
		gastoLineaDetalle.setApartadoBase(dto.getApartadoBase());
		gastoLineaDetalle.setCapituloBase(dto.getCapituloBase());
		gastoLineaDetalle.setSubcuentaRecargo(dto.getSubcuentaRecargo());
		gastoLineaDetalle.setApartadoRecargo(dto.getApartadoRecargo());
		gastoLineaDetalle.setCapituloRecargo(dto.getCapituloRecargo());
		gastoLineaDetalle.setSubcuentaTasa(dto.getSubcuentaTasa());
		gastoLineaDetalle.setApartadoTasa(dto.getApartadoTasa());
		gastoLineaDetalle.setCapituloTasa(dto.getCapituloTasa());
		gastoLineaDetalle.setSubcuentaIntereses(dto.getSubcuentaIntereses());
		gastoLineaDetalle.setApartadoIntereses(dto.getApartadoIntereses());
		gastoLineaDetalle.setCapituloIntereses(dto.getCapituloIntereses());
		
		
		gastoLineaDetalle.setImporteTotal(dto.getImporteTotal());
		
		
		if(dto.getId() != null) {
			genericDao.update(GastoLineaDetalle.class, gastoLineaDetalle);	
		}else {
			genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
		}
		
		if(gasto != null && gasto.getGastoDetalleEconomico() != null) {
			gasto.getGastoDetalleEconomico().setImporteTotal(gastoProveedorApi.recalcularImporteTotalGasto(gasto.getGastoDetalleEconomico()));
			genericDao.update(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
		}
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoLineaDetalle(Long idLineaDetalleGasto) throws Exception{
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idLineaDetalleGasto);
		GastoLineaDetalle gastoLineaDetalle = genericDao.get(GastoLineaDetalle.class, filtro);
		
		gastoLineaDetalle.getAuditoria().setBorrado(true);
		gastoLineaDetalle.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
		gastoLineaDetalle.getAuditoria().setFechaBorrar(new Date());
		
		
		genericDao.update(GastoLineaDetalle.class, gastoLineaDetalle);

		filtro = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", idLineaDetalleGasto);
		List<GastoLineaDetalleTrabajo> gastoLineaDetalleTrabajoLista = genericDao.getList(GastoLineaDetalleTrabajo.class, filtro);
		
		if(gastoLineaDetalleTrabajoLista != null && !gastoLineaDetalleTrabajoLista.isEmpty()) {
			for (GastoLineaDetalleTrabajo gastoLineaDetalleTrabajo : gastoLineaDetalleTrabajoLista) {
				gastoLineaDetalleTrabajo.getAuditoria().setBorrado(true);
				gastoLineaDetalleTrabajo.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
				gastoLineaDetalleTrabajo.getAuditoria().setFechaBorrar(new Date());
						
				genericDao.update(GastoLineaDetalleTrabajo.class, gastoLineaDetalleTrabajo);
			}
		}
		
		GastoProveedor gasto = gastoLineaDetalle.getGastoProveedor();
		if( gasto != null && gasto.getGastoDetalleEconomico() != null) {
			gasto.getGastoDetalleEconomico().setImporteTotal(gastoProveedorApi.recalcularImporteTotalGasto(gasto.getGastoDetalleEconomico()));
			genericDao.update(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
		}
		
		
		return true;
	}
	
	@Override
	public Double calcularPrincipioSujetoLineasDetalle(GastoProveedor gasto) {
		Double importePrincipalSujeto = 0.0;
	
		if(gasto != null) {
			List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
			if(gastoLineaDetalleList != null && gastoLineaDetalleList.isEmpty()) {
				for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
					importePrincipalSujeto+=gastoLineaDetalle.getPrincipalSujeto();
				}
			}
		}
	
		return importePrincipalSujeto;
	}
	
	@Override
	public DtoLineaDetalleGasto calcularCuentasYPartidas(Long idGasto, Long idLineaDetalleGasto, String subtipoGastoCodigo) {

		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		DtoLineaDetalleGasto dtoLineaDetalleGasto = new DtoLineaDetalleGasto();
		
		if(gasto == null) {
			return dtoLineaDetalleGasto;
		}
		
		GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
		boolean todosActivoAlquilados= false;
		DDCartera cartera = null;
		DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, subtipoGastoCodigo);
		
		
		if (gasto.getPropietario() != null) {
			cartera = gasto.getPropietario().getCartera();
		}else{
			cartera = (DDCartera) utilDiccionarioApi.dameValorDiccionarioByCod(DDCartera.class, DDCartera.CODIGO_CARTERA_SAREB);
		}
		
		if (cartera != null && gastoInfoContabilidad !=null) {

			Ejercicio ejercicio = gastoInfoContabilidad.getEjercicio();
			
			Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroEjercicioCuentaContable= genericDao.createFilter(FilterType.EQUALS, "ejercicio", ejercicio.getId());
			Filter filtroSubtipoGasto= genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera= genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId());
			Filter filtroSubcartera = null;
			if(gasto.getSubcartera() != null) {
				filtroSubcartera= genericDao.createFilter(FilterType.EQUALS, "subCartera.id", gasto.getSubcartera().getId());
			}
			Filter filtroSubcarteraNull= genericDao.createFilter(FilterType.NULL, "subCartera.id");
			Filter filtroCuentaArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 1);
			Filter filtroCuentaNoArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 0);
			
			
			int filtrarRefacturar = 0;
			if(gastoProveedorApi.esGastoRefacturable(gasto)) {
				filtrarRefacturar = 1;
			} 
			
			Filter filtroRefacturablePP = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
			Filter filtroRefacturableCC = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
	
			if(idLineaDetalleGasto != null) {
				todosActivoAlquilados = gastoProveedorApi.estanTodosActivosAlquilados(gasto); 
			}
				
			ActivoConfiguracionPtdasPrep partidaArrendada = null;
			ActivoConfiguracionPtdasPrep partidaNoArrendada = null;
				
				if(!Checks.esNulo(gasto.getSubcartera())) {
					partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcartera,filtroCuentaArrendamiento,filtroBorrado, filtroRefacturablePP);
					partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento ,filtroBorrado, filtroRefacturablePP);
				}else {
					partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaArrendamiento  ,filtroBorrado, filtroRefacturablePP);
					partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcarteraNull,filtroCuentaNoArrendamiento ,filtroBorrado, filtroRefacturablePP);
				}
				
				if(partidaArrendada !=null || partidaNoArrendada != null){
					if(!todosActivoAlquilados){
						if(partidaNoArrendada != null){
							setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaNoArrendada);
						}
					} else {
						if(partidaArrendada != null){
							setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaArrendada);

						}
					}
				} else {
					if(partidaArrendada == null || partidaNoArrendada == null){
						if(!todosActivoAlquilados){
							if(partidaNoArrendada == null){
								partidaNoArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcarteraNull,filtroCuentaNoArrendamiento,  filtroBorrado, filtroRefacturablePP);
								if(partidaNoArrendada != null){
									setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaNoArrendada);
								}
							}
						} else {
							if(partidaArrendada == null){
								partidaArrendada = genericDao.get(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcarteraNull,filtroCuentaArrendamiento,  filtroBorrado, filtroRefacturablePP);
								if(partidaArrendada != null){
									setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaArrendada);		
								}
							}
						}			
					}
				}

				ActivoConfiguracionCuentasContables cuentaArrendada= null;
				ActivoConfiguracionCuentasContables cuentaNoArrendada= null;
					
				if(!Checks.esNulo(gasto.getSubcartera())) {
					cuentaArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcartera,filtroCuentaArrendamiento,filtroBorrado, filtroRefacturableCC);
					cuentaNoArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento, filtroBorrado, filtroRefacturableCC);
				}else {
					cuentaArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaArrendamiento ,filtroBorrado, filtroRefacturableCC, filtroSubcarteraNull);
					cuentaNoArrendada= genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaNoArrendamiento ,filtroBorrado, filtroRefacturableCC, filtroSubcarteraNull);
				}
				
				if(cuentaArrendada != null ||  cuentaNoArrendada != null){
					if(!todosActivoAlquilados){
						if(cuentaNoArrendada != null){
							setCuentasContables(dtoLineaDetalleGasto, cuentaNoArrendada);		
						}
					} else {
						if(cuentaArrendada != null){
							setCuentasContables(dtoLineaDetalleGasto, cuentaArrendada);						
						}
					}
				} else {
					if(cuentaArrendada == null || cuentaNoArrendada == null){
						if(!todosActivoAlquilados){
							if(cuentaNoArrendada == null){
								cuentaNoArrendada = genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcarteraNull,filtroCuentaNoArrendamiento ,filtroBorrado, filtroRefacturableCC);
								if(cuentaNoArrendada != null){
									setCuentasContables(dtoLineaDetalleGasto, cuentaNoArrendada);
								} 
							}
						} else {
							if(cuentaArrendada == null){
								cuentaArrendada = genericDao.get(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcarteraNull,filtroCuentaArrendamiento ,filtroBorrado, filtroRefacturableCC);
								if(cuentaArrendada != null){
									setCuentasContables(dtoLineaDetalleGasto, cuentaArrendada);
								} 
							}
						}		
					}
				}

		}
	
		return dtoLineaDetalleGasto;
	}
	
	
	private DtoLineaDetalleGasto setCuentasContables (DtoLineaDetalleGasto dtoLineaDetalleGasto, ActivoConfiguracionCuentasContables cuenta) {
		
		if(cuenta == null || cuenta.getTipoImporte() == null) {
			return null;
		}
		String tipoImporte = cuenta.getTipoImporte().getCodigo();
		if(DDTipoImporte.CODIGO_BASE.equals(tipoImporte)) {
			dtoLineaDetalleGasto.setCcBase(cuenta.getCuentaContable());
		}else if(DDTipoImporte.CODIGO_TASA.equals(tipoImporte)){
			dtoLineaDetalleGasto.setCcTasas(cuenta.getCuentaContable());
		}else if(DDTipoImporte.CODIGO_RECARGO.equals(tipoImporte)){
			dtoLineaDetalleGasto.setCcRecargo(cuenta.getCuentaContable());
		}else if(DDTipoImporte.CODIGO_INTERES.equals(tipoImporte)) {
			dtoLineaDetalleGasto.setCcInteres(cuenta.getCuentaContable());
		}

		return dtoLineaDetalleGasto;
	}
	
	private DtoLineaDetalleGasto setPartidasPresupuestarias (DtoLineaDetalleGasto dtoLineaDetalleGasto, ActivoConfiguracionPtdasPrep partida) {
		
		
		if(partida == null || partida.getTipoImporte() == null) {
			return null;
		}
		String tipoImporte = partida.getTipoImporte().getCodigo();
		if(DDTipoImporte.CODIGO_BASE.equals(tipoImporte)) {
			dtoLineaDetalleGasto.setPpBase(partida.getPartidaPresupuestaria());
		}else if(DDTipoImporte.CODIGO_TASA.equals(tipoImporte)){
			dtoLineaDetalleGasto.setPpTasas(partida.getPartidaPresupuestaria());
		}else if(DDTipoImporte.CODIGO_RECARGO.equals(tipoImporte)){
			dtoLineaDetalleGasto.setPpRecargo(partida.getPartidaPresupuestaria());
		}else if(DDTipoImporte.CODIGO_INTERES.equals(tipoImporte)) {
			dtoLineaDetalleGasto.setPpInteres(partida.getPartidaPresupuestaria());
		}
		
		return dtoLineaDetalleGasto;
	}
	
	@Override
	public List<Activo> devolverActivosDeLineasDeGasto (GastoProveedor gasto){
		List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
		List<Activo> activos = new ArrayList<Activo>();
	
		DDEntidadGasto tipoEntidad = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, DDEntidadGasto.CODIGO_ACTIVO);
		if(tipoEntidad == null || gastoLineaDetalleList == null || gastoLineaDetalleList.isEmpty()) {
			return activos;
		}
		List<GastoLineaDetalleEntidad> gastoLineaDetalleActivoList;
		Filter filtroEntidadActivo = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.id", tipoEntidad.getId());
				
		for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
			Filter filtroGastoDetalleLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", gastoLineaDetalle.getId());
			gastoLineaDetalleActivoList = genericDao.getList(GastoLineaDetalleEntidad.class, filtroGastoDetalleLinea, filtroEntidadActivo);
			if(gastoLineaDetalleActivoList != null && !gastoLineaDetalleActivoList.isEmpty()) {
				for (GastoLineaDetalleEntidad gastoLineaDetalleActivo : gastoLineaDetalleActivoList) {
					Activo activo = activoDao.getActivoById(gastoLineaDetalleActivo.getEntidad());
					if(activo != null) {
						activos.add(activo);
					}
				}
			}
	
		}
		
		return activos;
	}
	
	@Override
	@Transactional(readOnly = false)
	public HashSet<String> devolverNumeroLineas(List<GastoLineaDetalle> gastoLineaDetalleList, HashSet<String>  tipoGastoImpuestoList) {
			
		String tipoGastoImpuestoString;
			
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				if(gastoLineaDetalle.getSubtipoGasto() != null) {
					tipoGastoImpuestoString = devolverSubGastoImpuestImpositivo(gastoLineaDetalle);
					tipoGastoImpuestoList.add(tipoGastoImpuestoString);
					gastoLineaDetalle.setMatriculaRefacturado(tipoGastoImpuestoString);
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
				}
				
			}
			return tipoGastoImpuestoList;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void createLineasDetalleGastosRefacturados(List<String>  tipoGastoImpuestoList, List<String> listaNumerosGasto, GastoProveedor gastoProveedor) {
		
		List<Long>  listaIdGastosId = new ArrayList<Long>();
		for (String numGasto : listaNumerosGasto) {
			Filter filtraGastos = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.valueOf(numGasto));
			GastoProveedor gasto = genericDao.get(GastoProveedor.class, filtraGastos);
			listaIdGastosId.add(gasto.getId());
		}
		
		if(listaIdGastosId.isEmpty()) {
			return;
		}
		
		Long tipoImpuestoId = null;
		DDTiposImpuesto tipoImpuesto = null;
		Double tipoImpositivo = null;
		for (String tipoGastoImporte : tipoGastoImpuestoList) {
			List<String> partes = Arrays.asList(tipoGastoImporte.split("-"));
			if(!partes.isEmpty()) {
				DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, partes.get(0));
				if(partes.size() > 1) {
					tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, partes.get(1));
					if(tipoImpuesto != null) {
						tipoImpuestoId = tipoImpuesto.getId();
					}
					if(partes.size() > 2) {
						tipoImpositivo = Double.parseDouble(partes.get(2));
					}
					
				}
				
				List<GastoLineaDetalle> gastoDetalleLineaList = gastoLineaDetalleDao.getGastoLineaDetalleBySubtipoGastoAndImpuesto(listaIdGastosId, tipoGastoImporte);
				GastoLineaDetalle gastoLineaDetalleNueva = new GastoLineaDetalle();
				
				gastoLineaDetalleNueva.setGastoProveedor(gastoProveedor);
				gastoLineaDetalleNueva.setSubtipoGasto(subtipoGasto); 
				gastoLineaDetalleNueva.setTipoImpuesto(tipoImpuesto); 
				
				if(tipoImpuestoId != null) {
					gastoLineaDetalleNueva.setEsImporteIndirectoExento(false);
					gastoLineaDetalleNueva.setImporteIndirectoTipoImpositivo(tipoImpositivo);
					gastoLineaDetalleNueva.setEsImporteIndirectoRenunciaExento(false);
				}else {
					gastoLineaDetalleNueva.setEsImporteIndirectoExento(null);
					gastoLineaDetalleNueva.setEsImporteIndirectoRenunciaExento(null);
				}
				
				DtoLineaDetalleGasto dto= calcularCuentasYPartidas(gastoProveedor.getId(), null, subtipoGasto.getCodigo());
				gastoLineaDetalleNueva = calcularCamposLineaRefacturada(gastoDetalleLineaList, gastoLineaDetalleNueva, dto);
				gastoLineaDetalleNueva.setAuditoria(Auditoria.getNewInstance());
				
				gastoLineaDetalleNueva.setMatriculaRefacturado(devolverSubGastoImpuestImpositivo(gastoLineaDetalleNueva));
				
				genericDao.save(GastoLineaDetalle.class, gastoLineaDetalleNueva);

				crearRelacionGastoActivoRefacturado(gastoDetalleLineaList, gastoLineaDetalleNueva);
				
				tipoImpuestoId = null;
				tipoImpositivo = null;
				tipoImpuesto = null;
			}
		}	
	}
	
	private GastoLineaDetalle calcularCamposLineaRefacturada (List<GastoLineaDetalle> gastoDetalleLineaList, GastoLineaDetalle gastoLineaDetalleNueva, DtoLineaDetalleGasto dto ) {
		
		Double principalSujeto = 0.0;
		Double principalNoSujeto = 0.0;
		Double recargo = 0.0;
		boolean evitable = false;
		Double interesDemora = 0.0;
		Double costas = 0.0;
		Double provSuplidos = 0.0;
		Double importeTotal = 0.0;
		Double cuota = 0.0;
		
		for (GastoLineaDetalle gastoDetalleLinea : gastoDetalleLineaList) {
			if(gastoDetalleLinea.getPrincipalSujeto() != null) {
				principalSujeto+=gastoDetalleLinea.getPrincipalSujeto();
			}
			if(gastoDetalleLinea.getPrincipalNoSujeto() != null) {
				principalNoSujeto+=gastoDetalleLinea.getPrincipalNoSujeto();
			}
			if(gastoDetalleLinea.getRecargo() != null) {
				recargo+= gastoDetalleLinea.getRecargo();
			}
			if(gastoDetalleLinea.getTipoRecargoGasto() != null) {
				if(DDTipoRecargoGasto.CODIGO_EVITABLE.equals(gastoDetalleLinea.getTipoRecargoGasto().getCodigo())){
					evitable = true;
				}
			}
			if(gastoDetalleLinea.getInteresDemora() != null) {
				interesDemora+= gastoDetalleLinea.getInteresDemora();
			}
			if(gastoDetalleLinea.getCostas() != null) {
				costas += gastoDetalleLinea.getCostas();
			}
			if(gastoDetalleLinea.getProvSuplidos() != null) {
				provSuplidos += gastoDetalleLinea.getProvSuplidos();
			}
			if(gastoDetalleLinea.getImporteIndirectoCuota() != null) {
				cuota += gastoDetalleLinea.getImporteIndirectoCuota();
			}
			
			if(gastoDetalleLinea.getImporteTotal() != null) {
				importeTotal += gastoDetalleLinea.getImporteTotal();
			}
			
		}
		
		
		gastoLineaDetalleNueva.setPrincipalSujeto(principalSujeto);
		gastoLineaDetalleNueva.setPrincipalNoSujeto(principalNoSujeto);
		gastoLineaDetalleNueva.setRecargo(recargo);
		
		String codigoDiccionario = DDTipoRecargoGasto.CODIGO_NO_EVITABLE;
		if(evitable) {
			codigoDiccionario = DDTipoRecargoGasto.CODIGO_EVITABLE;
		}
		DDTipoRecargoGasto tipoRecargoGasto = (DDTipoRecargoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoRecargoGasto.class, codigoDiccionario);
		gastoLineaDetalleNueva.setTipoRecargoGasto(tipoRecargoGasto);
		
		gastoLineaDetalleNueva.setInteresDemora(interesDemora);
		gastoLineaDetalleNueva.setCostas(costas);
		gastoLineaDetalleNueva.setProvSuplidos(provSuplidos);
		gastoLineaDetalleNueva.setImporteIndirectoCuota(cuota);
		gastoLineaDetalleNueva.setImporteTotal(importeTotal);
		
		
		gastoLineaDetalleNueva.setCccBase(dto.getCcBase());
		gastoLineaDetalleNueva.setCppBase(dto.getPpBase());
		gastoLineaDetalleNueva.setCccEsp(dto.getCcEsp());
		gastoLineaDetalleNueva.setCppEsp(dto.getPpEsp());
		gastoLineaDetalleNueva.setCccTasas(dto.getCcTasas());
		gastoLineaDetalleNueva.setCppTasas(dto.getPpTasas());
		gastoLineaDetalleNueva.setCccRecargo(dto.getCcRecargo());
		gastoLineaDetalleNueva.setCppRecargo(dto.getPpRecargo());
		gastoLineaDetalleNueva.setCccIntereses(dto.getCcInteres());
		gastoLineaDetalleNueva.setCppIntereses(dto.getPpInteres());
		
		
		return gastoLineaDetalleNueva;
	}
	
	@Transactional(readOnly = false)
	private void crearRelacionGastoActivoRefacturado(List<GastoLineaDetalle> gastoDetalleLineaList, GastoLineaDetalle gastoLineaDetalleNueva) {
		HashSet<String> idsActivos = new HashSet<String>();
		GastoProveedor gastoProveedor = gastoLineaDetalleNueva.getGastoProveedor();
		if (gastoProveedorApi.isGastoSareb(gastoProveedor)) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoDetalleLineaList) {
				Filter filtroIdGastoLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", gastoLineaDetalle.getId());
				List<GastoLineaDetalleEntidad> listaEntidades= genericDao.getList(GastoLineaDetalleEntidad.class, filtroIdGastoLinea);
				if(listaEntidades != null && !listaEntidades.isEmpty()) {
					for (GastoLineaDetalleEntidad entidad : listaEntidades) {
						if(entidad.getEntidad() != null && entidad.getEntidadGasto() != null )
						idsActivos.add(entidad.getEntidad().toString() + "-"+ entidad.getEntidadGasto().getCodigo());
					}
				}
			}
			
			List<String> idsEntidadList = new ArrayList<String>(idsActivos);
			if(!idsEntidadList.isEmpty()) {
				for (String entidadString : idsEntidadList) {
					List<String> partes = Arrays.asList(entidadString.split("-"));	
					
					GastoLineaDetalleEntidad nuevaRelacionActivoGasto = new GastoLineaDetalleEntidad();
					nuevaRelacionActivoGasto.setGastoLineaDetalle(gastoLineaDetalleNueva);
					nuevaRelacionActivoGasto.setEntidad(Long.valueOf(partes.get(0)));
					DDEntidadGasto entidad = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, partes.get(1));
					nuevaRelacionActivoGasto.setEntidadGasto(entidad);
					nuevaRelacionActivoGasto.setParticipacionGasto(100.0 / Double.valueOf(idsActivos.size()));
					//nuevaRelacionActivoGasto.setReferenciaCatastral(referenciaCatastral);
					nuevaRelacionActivoGasto.setAuditoria(Auditoria.getNewInstance());
					
					
					genericDao.save(GastoLineaDetalleEntidad.class, nuevaRelacionActivoGasto);
				}
			}
		}
	}
	
	@Override
	public boolean tieneLineaDetalle(GastoProveedor gasto) {
		boolean tieneLinea = true;
		
		Filter filterLineaDetalle = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gasto.getId());
		List<GastoLineaDetalle> gastoLineaDetalleList = genericDao.getList(GastoLineaDetalle.class,filterLineaDetalle );
		
		if(gastoLineaDetalleList == null || gastoLineaDetalleList.isEmpty()) {
			tieneLinea = false;
		}
		
		return tieneLinea;
	}
		
	@Override 
	public String devolverSubGastoImpuestImpositivo(GastoLineaDetalle gastoLineaDetalle) {
		String subGastoImpuestImpositivo = null;
		
		if(gastoLineaDetalle.getSubtipoGasto() == null) {
			return null;
		
		}
		boolean exento = false;
		subGastoImpuestImpositivo = gastoLineaDetalle.getSubtipoGasto().getCodigo();

		if(gastoLineaDetalle.getEsImporteIndirectoExento() != null && gastoLineaDetalle.getEsImporteIndirectoExento()) {
			exento = true;
		}
		if(gastoLineaDetalle.getEsImporteIndirectoRenunciaExento() != null && gastoLineaDetalle.getEsImporteIndirectoRenunciaExento()) {
			exento = false;
		}
		if(gastoLineaDetalle.getTipoImpuesto() != null && !exento && gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null) {
			subGastoImpuestImpositivo = subGastoImpuestImpositivo + "-" +gastoLineaDetalle.getTipoImpuesto().getCodigo();
			subGastoImpuestImpositivo = subGastoImpuestImpositivo + "-" + gastoLineaDetalle.getImporteIndirectoTipoImpositivo().toString();
		}
		
		
		return subGastoImpuestImpositivo;
	}
	
	@Override
	public GastoLineaDetalle devolverLineaBk(GastoProveedor gasto) {
		List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
		
		if(gastoLineaDetalleList == null || gastoLineaDetalleList.isEmpty() || gastoLineaDetalleList.size() > 1) {
			return null;
		}
		
		return gastoLineaDetalleList.get(0);
	}
	
	@Override 
	@Transactional(readOnly = false)
	public void eliminarLineasRefacturadas(Long idGasto) {
		GastoProveedor gastoPadre = gastoProveedorApi.findOne(idGasto);
	
		List<GastoLineaDetalle> gastoLineaDetalleList  = gastoPadre.getGastoLineaDetalleList();
		
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList = gastoLineaDetalle.getGastoLineaEntidadList();
				if(gastoLineaDetalleEntidadList != null && !gastoLineaDetalleEntidadList.isEmpty()) {
					for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalleEntidadList) {
						gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
						gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
						gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
						
						genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
					}
				}
				
				gastoLineaDetalle.getAuditoria().setBorrado(true);
				gastoLineaDetalle.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
				gastoLineaDetalle.getAuditoria().setFechaBorrar(new Date());
				
				genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
			}
		}
		Filter filtroRefacturable = genericDao.createFilter(FilterType.EQUALS, "idGastoProveedor", gastoPadre.getId());
		List<GastoRefacturable> listaGastosRefacturables = genericDao.getList(GastoRefacturable.class,filtroRefacturable);
		List<String> listaGastosHijosNumeros = new ArrayList<String>();
		HashSet<String>  tipoGastoImpuestoHash = new HashSet<String>();
		for (GastoRefacturable gastoRefacturable : listaGastosRefacturables) {
			GastoProveedor  gasto = gastoProveedorApi.findOne(gastoRefacturable.getGastoProveedorRefacturado());
			if(gasto != null && gasto.getNumGastoHaya() != null) {
				listaGastosHijosNumeros.add(gasto.getNumGastoHaya().toString());
				GastoProveedor gastoProveedor = gastoProveedorApi.findOne(gastoRefacturable.getGastoProveedorRefacturado());
				List<GastoLineaDetalle> gastoLineaDetalleListPorGasto  = gastoProveedor.getGastoLineaDetalleList();
				if(gastoLineaDetalleListPorGasto != null && !gastoLineaDetalleListPorGasto.isEmpty()) {
					tipoGastoImpuestoHash = devolverNumeroLineas(gastoLineaDetalleListPorGasto, tipoGastoImpuestoHash);
				}
			}
		}
		
		List<String> tipoGastoImpuestoList = new ArrayList<String>(tipoGastoImpuestoHash);
		if(!listaGastosHijosNumeros.isEmpty() && !tipoGastoImpuestoList.isEmpty()) {
			createLineasDetalleGastosRefacturados(tipoGastoImpuestoList, listaGastosHijosNumeros, gastoPadre);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void recalcularPorcentajeParticipacion(GastoProveedor gasto) {
		List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
		Double porcentajeParticipacion= 0.0;
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				Filter filtroIdGastoLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", gastoLineaDetalle.getId());
				List<GastoLineaDetalleEntidad> activoRelacionList = genericDao.getList(GastoLineaDetalleEntidad.class, filtroIdGastoLinea);
				if(activoRelacionList != null && !activoRelacionList.isEmpty()) {	
					porcentajeParticipacion = 100.0 / Double.valueOf(activoRelacionList.size());
					for (GastoLineaDetalleEntidad activoRelacion : activoRelacionList) {
						activoRelacion.setParticipacionGasto(porcentajeParticipacion);
						genericDao.save(GastoLineaDetalleEntidad.class, activoRelacion);
					}
				}

			}
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public List<String> crearLineasRefacturadasAGastosExistentes(Long idGastoPadre, GastoLineaDetalle lineaGastoDetalle, List<String> lineasDetallePadreListString, boolean esSareb) throws IllegalAccessException, InvocationTargetException {
		String tipoLinea = devolverSubGastoImpuestImpositivo(lineaGastoDetalle);
		List<String> lineasCreadasMatricula = new ArrayList<String>();
		boolean crearLinea = true;
		List<Long> idGastoPadreList = new ArrayList<Long>();
		idGastoPadreList.add(idGastoPadre);
		GastoProveedor gastoPadre = gastoProveedorApi.findOne(idGastoPadre);
		
		for (String lineaDetalleString : lineasDetallePadreListString) {
			if(lineaDetalleString.equals(tipoLinea)) {
							
				List<String> partes = Arrays.asList(lineaDetalleString.split("-"));	
				if(!partes.isEmpty()) {
					DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, partes.get(0));
					
					List<GastoLineaDetalle> lineaDetalleGastoPadreList = gastoLineaDetalleDao.getGastoLineaDetalleBySubtipoGastoAndImpuesto( idGastoPadreList, lineaDetalleString);
					if(lineaDetalleGastoPadreList != null && !lineaDetalleGastoPadreList.isEmpty()) {
						GastoLineaDetalle lineaDetalleGastoPadre=lineaDetalleGastoPadreList.get(0);
						
						DtoLineaDetalleGasto dto= calcularCuentasYPartidas(gastoPadre.getId(), null, subtipoGasto.getCodigo());
						lineaDetalleGastoPadreList.add(lineaGastoDetalle);
						lineaDetalleGastoPadre = calcularCamposLineaRefacturada(lineaDetalleGastoPadreList, lineaDetalleGastoPadreList.get(0), dto);
						lineaDetalleGastoPadre.setAuditoria(Auditoria.getNewInstance());
						
						lineasCreadasMatricula.add(lineaDetalleString);
						genericDao.save(GastoLineaDetalle.class, lineaDetalleGastoPadre);
						
						if(esSareb) {
							Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", lineaDetalleGastoPadre.getId());
							List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadPadreList = genericDao.getList(GastoLineaDetalleEntidad.class, filter );
							Filter filterHijo = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", lineaGastoDetalle.getId());
							List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadHijoList = genericDao.getList(GastoLineaDetalleEntidad.class, filterHijo);
							boolean nuevaRelacion = true;
							for (GastoLineaDetalleEntidad gastoLineaDetalleEntidadHijo : gastoLineaDetalleEntidadHijoList) {
								for (GastoLineaDetalleEntidad gastoLineaDetalleEntidadPadre : gastoLineaDetalleEntidadPadreList) {
									if(gastoLineaDetalleEntidadHijo.getEntidad().equals(gastoLineaDetalleEntidadPadre.getEntidad())){
										nuevaRelacion = false;
										break;
									}
								}
								
								if(nuevaRelacion) {
									GastoLineaDetalleEntidad gastoLineaDetalleEntidadNueva= new GastoLineaDetalleEntidad();
									gastoLineaDetalleEntidadNueva = copiarGastoLineaDetalleEntidad(gastoLineaDetalleEntidadNueva, gastoLineaDetalleEntidadHijo);
									gastoLineaDetalleEntidadNueva.setGastoLineaDetalle(lineaDetalleGastoPadre);
									gastoLineaDetalleEntidadNueva.setAuditoria(Auditoria.getNewInstance());
									genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidadNueva);
								}
								nuevaRelacion = true;
							}
						}
					}
					crearLinea = false;
					break;
				
				}
			}
		}
		if(crearLinea) {
			GastoLineaDetalle lineaDetalleGastoNueva= new GastoLineaDetalle();
				
				lineaDetalleGastoNueva = copiarGastoLineaDetalle( gastoPadre, lineaDetalleGastoNueva, lineaGastoDetalle);
				lineaDetalleGastoNueva.setGastoProveedor(gastoPadre);
				lineaDetalleGastoNueva.setAuditoria(Auditoria.getNewInstance());
				genericDao.save(GastoLineaDetalle.class, lineaDetalleGastoNueva);
				String nuevasLineasCreadas = devolverSubGastoImpuestImpositivo(lineaDetalleGastoNueva);
				lineaDetalleGastoNueva.setMatriculaRefacturado(nuevasLineasCreadas);
				if(nuevasLineasCreadas != null) {
					lineasCreadasMatricula.add(nuevasLineasCreadas);
				}
			if(esSareb) {
				List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList  = lineaGastoDetalle.getGastoLineaEntidadList();
				if(gastoLineaDetalleEntidadList != null && !gastoLineaDetalleEntidadList.isEmpty()) {
					for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalleEntidadList) {
						GastoLineaDetalleEntidad gastoLineaDetalleEntidadNueva= new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidadNueva = copiarGastoLineaDetalleEntidad(gastoLineaDetalleEntidadNueva, gastoLineaDetalleEntidad );
						gastoLineaDetalleEntidadNueva.setGastoLineaDetalle(lineaDetalleGastoNueva);
						gastoLineaDetalleEntidadNueva.setAuditoria(Auditoria.getNewInstance());
						genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidadNueva);
						
					}
				}
			}
		}
		recalcularPorcentajeParticipacion(gastoPadre);
		
		return lineasCreadasMatricula;
	}
	
	@Transactional(readOnly = false)
	void eliminarLineasDetalleGastoVacias(GastoProveedor gastoPadre) {
		List<GastoLineaDetalle> gastoLineaDetalleList = gastoPadre.getGastoLineaDetalleList();
		
		if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				if(gastoLineaDetalle.getImporteTotal() != null && gastoLineaDetalle.getImporteTotal() == 0.0) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", gastoLineaDetalle.getId());
					List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList = genericDao.getList(GastoLineaDetalleEntidad.class, filter);
					if(gastoLineaDetalleEntidadList != null && !gastoLineaDetalleEntidadList.isEmpty()) {
						for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalleEntidadList) {
							gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
							gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
							gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
							
							genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
						}
					}
					gastoLineaDetalle.getAuditoria().setBorrado(true);
					gastoLineaDetalle.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
					gastoLineaDetalle.getAuditoria().setFechaBorrar(new Date());
					
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
				}
			}
		}
	}
	
	GastoLineaDetalle copiarGastoLineaDetalle(GastoProveedor gastoPadre, GastoLineaDetalle gastoLineaDetallePadre, GastoLineaDetalle gastoLineaDetalleHija) {
		
		DtoLineaDetalleGasto dto= calcularCuentasYPartidas(gastoPadre.getId(), null, gastoLineaDetalleHija.getSubtipoGasto().getCodigo());
		
		gastoLineaDetallePadre.setSubtipoGasto(gastoLineaDetalleHija.getSubtipoGasto());
		gastoLineaDetallePadre.setPrincipalSujeto(gastoLineaDetalleHija.getPrincipalSujeto());
		gastoLineaDetallePadre.setPrincipalNoSujeto(gastoLineaDetalleHija.getPrincipalNoSujeto());
		gastoLineaDetallePadre.setTipoRecargoGasto(gastoLineaDetalleHija.getTipoRecargoGasto());
		gastoLineaDetallePadre.setRecargo(gastoLineaDetalleHija.getRecargo());
		gastoLineaDetallePadre.setInteresDemora(gastoLineaDetalleHija.getInteresDemora());
		gastoLineaDetallePadre.setCostas(gastoLineaDetalleHija.getCostas());
		gastoLineaDetallePadre.setProvSuplidos(gastoLineaDetalleHija.getProvSuplidos());
		gastoLineaDetallePadre.setImporteIndirectoCuota(gastoLineaDetalleHija.getImporteIndirectoCuota());
		gastoLineaDetallePadre.setImporteTotal(gastoLineaDetalleHija.getImporteTotal());
		
		gastoLineaDetallePadre.setCccBase(dto.getCcBase());
		gastoLineaDetallePadre.setCppBase(dto.getPpBase());
		gastoLineaDetallePadre.setCccEsp(dto.getCcEsp());
		gastoLineaDetallePadre.setCppEsp(dto.getPpEsp());
		gastoLineaDetallePadre.setCccTasas(dto.getCcTasas());
		gastoLineaDetallePadre.setCppTasas(dto.getPpTasas());
		gastoLineaDetallePadre.setCccRecargo(dto.getCcRecargo());
		gastoLineaDetallePadre.setCppRecargo(dto.getPpRecargo());
		gastoLineaDetallePadre.setCccIntereses(dto.getCcInteres());
		gastoLineaDetallePadre.setCppIntereses(dto.getPpInteres());
		
		return gastoLineaDetallePadre;
	}
	
	GastoLineaDetalleEntidad copiarGastoLineaDetalleEntidad(GastoLineaDetalleEntidad gastoLineaDetalleEntidadPadre, GastoLineaDetalleEntidad gastoLineaDetalleEntidadHija) {
		
		gastoLineaDetalleEntidadPadre.setEntidadGasto(gastoLineaDetalleEntidadHija.getEntidadGasto());
		gastoLineaDetalleEntidadPadre.setEntidad(gastoLineaDetalleEntidadHija.getEntidad());
		gastoLineaDetalleEntidadPadre.setParticipacionGasto(gastoLineaDetalleEntidadHija.getParticipacionGasto());
		gastoLineaDetalleEntidadPadre.setReferenciaCatastral(gastoLineaDetalleEntidadHija.getReferenciaCatastral());
		
		return gastoLineaDetalleEntidadPadre;
	}
}