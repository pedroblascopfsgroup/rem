package es.pfsgroup.plugin.rem.gasto.linea.detalle;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;

import org.aspectj.apache.bcel.generic.NEW;
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
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
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
		
		if(gastoLineaDetalle.getTipoRecargoGasto() != null) {
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
	public HashSet<String> devolverNumeroLineas(List<GastoLineaDetalle> gastoLineaDetalleList, HashSet<String>  tipoGastoImpuestoList) {
			
		String tipoGastoImpuestoString;
			
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				if(gastoLineaDetalle.getSubtipoGasto() != null) {
					tipoGastoImpuestoString = devolverSubGastoImpuestImpositivo(gastoLineaDetalle);

					tipoGastoImpuestoList.add(tipoGastoImpuestoString);
				}
				
			}
			return tipoGastoImpuestoList;
	}
	
	@Override
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
					tipoImpositivo = Double.parseDouble(partes.get(2));
					
				}
				
				List<GastoLineaDetalle> gastoDetalleLineaList = gastoLineaDetalleDao.getGastoLineaDetalleBySubtipoGastoAndImpuesto(listaIdGastosId, subtipoGasto.getId(), tipoImpuestoId, tipoImpositivo);
				GastoLineaDetalle gastoLineaDetalleNueva = new GastoLineaDetalle();
				
				gastoLineaDetalleNueva.setGastoProveedor(gastoProveedor);
				gastoLineaDetalleNueva.setSubtipoGasto(subtipoGasto);
				gastoLineaDetalleNueva.setTipoImpuesto(tipoImpuesto);
				gastoLineaDetalleNueva.setImporteIndirectoTipoImpositivo(tipoImpositivo);
				if(tipoImpuestoId == null) {
					gastoLineaDetalleNueva.setEsImporteIndirectoExento(true);
				}else {
					gastoLineaDetalleNueva.setEsImporteIndirectoExento(false);
				}
				gastoLineaDetalleNueva.setEsImporteIndirectoRenunciaExento(false);
				DtoLineaDetalleGasto dto= calcularCuentasYPartidas(gastoProveedor.getId(), null, subtipoGasto.getCodigo());
				gastoLineaDetalleNueva = calcularCamposLineaRefacturada(gastoDetalleLineaList, gastoLineaDetalleNueva, dto);
				gastoLineaDetalleNueva.setAuditoria(Auditoria.getNewInstance());
				
				genericDao.save(GastoLineaDetalle.class, gastoLineaDetalleNueva);

				crearRelacionGastoActivoRefacturado(gastoDetalleLineaList, gastoLineaDetalleNueva);
				
				tipoImpuestoId = null;
				tipoImpositivo = null;
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
	
	private void crearRelacionGastoActivoRefacturado(List<GastoLineaDetalle> gastoDetalleLineaList, GastoLineaDetalle gastoLineaDetalleNueva) {
		HashSet<Long> idsActivos = new HashSet<Long>();
		GastoProveedor gastoProveedor = gastoLineaDetalleNueva.getGastoProveedor();
		if (gastoProveedor.getPropietario() != null && gastoProveedor.getPropietario().getCartera() != null	
				&& DDCartera.CODIGO_CARTERA_SAREB.equals(gastoProveedor.getPropietario().getCartera().getCodigo())) {
			Filter filtroEntidadActivo = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.codigo", DDEntidadGasto.CODIGO_ACTIVO);
			for (GastoLineaDetalle gastoLineaDetalle : gastoDetalleLineaList) {
				Filter filtroIdGastoLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", gastoLineaDetalle.getId());
				List<GastoLineaDetalleEntidad> listaEntidades= genericDao.getList(GastoLineaDetalleEntidad.class, filtroIdGastoLinea, filtroEntidadActivo);
				if(listaEntidades != null && !listaEntidades.isEmpty()) {
					for (GastoLineaDetalleEntidad entidad : listaEntidades) {
						idsActivos.add(entidad.getEntidad());
					}
				}
			}
			
			List<Long> idsActivosList = new ArrayList<Long>(idsActivos);
			if(!idsActivosList.isEmpty()) {
				for (Long idActivo : idsActivosList) {
					GastoLineaDetalleEntidad nuevaRelacionActivoGasto = new GastoLineaDetalleEntidad();
					nuevaRelacionActivoGasto.setGastoLineaDetalle(gastoLineaDetalleNueva);
					nuevaRelacionActivoGasto.setEntidad(idActivo);
					DDEntidadGasto entidad = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, DDEntidadGasto.CODIGO_ACTIVO);
					nuevaRelacionActivoGasto.setEntidadGasto(entidad);
					//nuevaRelacionActivoGasto.setParticipacionGasto(100.0 / Double.valueOf(idsActivos.size())); => Calcular
					//nuevaRelacionActivoGasto.setReferenciaCatastral(referenciaCatastral);
					nuevaRelacionActivoGasto.setAuditoria(Auditoria.getNewInstance());
					
					
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalleNueva);
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
		if(gastoLineaDetalle.getTipoImpuesto() != null && !exento) {
			subGastoImpuestImpositivo = subGastoImpuestImpositivo + "-" +gastoLineaDetalle.getTipoImpuesto().getCodigo();
			if(gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null) {
				subGastoImpuestImpositivo = subGastoImpuestImpositivo + "-" + gastoLineaDetalle.getImporteIndirectoTipoImpositivo().toString();
			}else {
				subGastoImpuestImpositivo = subGastoImpuestImpositivo + "-" + "0";

			}
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
}