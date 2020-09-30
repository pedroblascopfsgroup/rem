package es.pfsgroup.plugin.rem.gasto.linea.detalle;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionCuentasContables;
import es.pfsgroup.plugin.rem.model.ActivoConfiguracionPtdasPrep;
import es.pfsgroup.plugin.rem.model.ActivoGenerico;
import es.pfsgroup.plugin.rem.model.ActivoSubtipoGastoProveedorTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoSubtipoTrabajoGastoImpuesto;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoComboLineasDetalle;
import es.pfsgroup.plugin.rem.model.DtoElementosAfectadosLinea;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VElementosLineaDetalle;
import es.pfsgroup.plugin.rem.model.VParticipacionElementosLinea;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEmisorGLD;
import es.pfsgroup.plugin.rem.model.dd.DDTipoImporte;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;

@Service("gastoLineaDetalleManager")
public class GastoLineaDetalleManager implements GastoLineaDetalleApi {
	
	private static final String ERROR_GASTO_MAL_ESTADO = "Gasto con errores";
	private static final String ERROR_NO_EXISTE_AGRUPACION = "La agrupación no existe";
	private static final String ERROR_NO_EXISTE_ACTIVO = "El activo no existe";
	private static final String ERROR_NO_EXISTE_ACTIVO_GENERICO= "El activo genérico no existe";
	private static final String ERROR_CARTERA_DIFERENTE  ="El elemento es de una cartera diferente al gasto.";
	
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

	@Autowired
	private TrabajoApi trabajoApi;

	
	@Override 
	public GastoLineaDetalle getLineaDetalleByIdLinea(Long idLinea) {
		return genericDao.get(GastoLineaDetalle.class, genericDao.createFilter(FilterType.EQUALS, "id", idLinea));
	}
	
	@Override 
	public GastoLineaDetalleEntidad getLineaDetalleEntidadByIdLineaEntidad(Long idEntidad) {
		return genericDao.get(GastoLineaDetalleEntidad.class, genericDao.createFilter(FilterType.EQUALS, "id", idEntidad));
	}
	
	@Override
	public List<DtoLineaDetalleGasto> getGastoLineaDetalle(Long idGasto) throws Exception{
		List<DtoLineaDetalleGasto> dtoLineaDetalleGastoLista = new ArrayList<DtoLineaDetalleGasto>();		
		GastoProveedor gasto = genericDao.get(GastoProveedor.class,genericDao.createFilter(FilterType.EQUALS, "id", idGasto));
		List<GastoLineaDetalle> gastoLineaDetalleLista = gasto.getGastoLineaDetalleList();
		
		
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
			
			dto.setTieneCuentaContable(Boolean.FALSE);
					
			if(gastoLineaDetalle.getCppBase() != null) {
				dto.setSubPartidas(gastoLineaDetalle.getCppBase());
				if(gastoLineaDetalle.getCccBase() != null){
					dto.setTieneCuentaContable(Boolean.TRUE);
				}
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
			if(!Checks.esNulo(gastoLineaDetalle.getGastoProveedor().getProveedor()) && !Checks.esNulo(gastoLineaDetalle.getGastoProveedor().getProveedor().getCriterioCajaIVA())) {
				if(gastoLineaDetalle.getGastoProveedor().getProveedor().getCriterioCajaIVA() >= 1) {
					dto.setOptaCriterio(Boolean.TRUE);
				}
				else{
					dto.setOptaCriterio(Boolean.FALSE);
				}
			}
			
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
		
		if(dto.getBaseSujeta() != null) {
			gastoLineaDetalle.setPrincipalSujeto(dto.getBaseSujeta());
		}
		if(dto.getBaseNoSujeta() != null) {
			gastoLineaDetalle.setPrincipalNoSujeto(dto.getBaseNoSujeta());
		}
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
		
		if(!Checks.esNulo(dto.getOptaCriterio()) && !Checks.esNulo(gastoLineaDetalle.getGastoProveedor().getProveedor())) {
			gastoLineaDetalle.getGastoProveedor().getProveedor().setCriterioCajaIVA(Boolean.valueOf(dto.getOptaCriterio()).compareTo( false ));
		}
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
			Double importeTotal = gastoProveedorApi.recalcularImporteTotalGasto(gasto.getGastoDetalleEconomico());
			if(dto.getId() == null) {
				importeTotal = importeTotal+ dto.getImporteTotal();
			}
			gasto.getGastoDetalleEconomico().setImporteTotal(importeTotal);
			genericDao.update(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
		}
		
		if(gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
		DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
			actualizarDiariosLbk(gasto.getId());
		}
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean deleteGastoLineaDetalle(Long idLineaDetalleGasto) throws Exception{
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idLineaDetalleGasto);
		GastoLineaDetalle gastoLineaDetalle = genericDao.get(GastoLineaDetalle.class, filtro);
		Double importeLinea;
		if(gastoLineaDetalle == null || gastoLineaDetalle.getGastoProveedor() == null) {
			return false;
		}
		importeLinea = gastoLineaDetalle.getImporteTotal();
		gastoLineaDetalle.getAuditoria().setBorrado(true);
		gastoLineaDetalle.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
		gastoLineaDetalle.getAuditoria().setFechaBorrar(new Date());
		
		
		genericDao.update(GastoLineaDetalle.class, gastoLineaDetalle);

		List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList = gastoLineaDetalle.getGastoLineaEntidadList();
		if(gastoLineaDetalleEntidadList != null && !gastoLineaDetalleEntidadList.isEmpty()) {
			for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalleEntidadList) {
				gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
				gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
				gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
						
				genericDao.update(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
			}
		}
		
		List<GastoLineaDetalleTrabajo> gastoLineaDetalleTrabajoLista = gastoLineaDetalle.getGastoLineaTrabajoList();
		
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
			Double importeTotal = gastoProveedorApi.recalcularImporteTotalGasto(gasto.getGastoDetalleEconomico());
			importeTotal = importeTotal - importeLinea;
			gasto.getGastoDetalleEconomico().setImporteTotal(importeTotal);
			genericDao.update(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
		}
		
		if(gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
		DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
			actualizarDiariosLbk(gasto.getId());
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
		
		if(gasto == null || gasto.getPropietario() == null) {
			return dtoLineaDetalleGasto;
		}
		
		GastoInfoContabilidad gastoInfoContabilidad = gasto.getGastoInfoContabilidad();
		boolean todosActivoAlquilados= false;
		DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, subtipoGastoCodigo);
		boolean isLbk = false;

		if (gastoInfoContabilidad !=null) {

			Ejercicio ejercicio = gastoInfoContabilidad.getEjercicio();
			
			Filter filtroEjercicioCuentaContable= genericDao.createFilter(FilterType.EQUALS, "ejercicio", ejercicio.getId());
			Filter filtroSubtipoGasto= genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", subtipoGasto.getId());
			Filter filtroCartera= genericDao.createFilter(FilterType.NULL, "cartera");
			Filter filtroSubcartera= genericDao.createFilter(FilterType.NULL, "subCartera.id");
			Filter filtroCuentaArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 1);
			Filter filtroCuentaNoArrendamiento= genericDao.createFilter(FilterType.EQUALS, "arrendamiento", 0);
			
			
			int filtrarRefacturar = 0;
			if(gastoProveedorApi.esGastoRefacturable(gasto)) {
				filtrarRefacturar = 1;
			}
			
			Filter filtroPropietario= genericDao.createFilter(FilterType.EQUALS, "activoPropietario.id", gasto.getPropietario().getId());
			
			Filter filtroRefacturablePP = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
			Filter filtroRefacturableCC = genericDao.createFilter(FilterType.EQUALS, "refacturable", filtrarRefacturar);
			Filter planVisitasCpp = genericDao.createFilter(FilterType.EQUALS, "cppPlanVisitas", 1);
			Filter planVisitasCcc = genericDao.createFilter(FilterType.EQUALS, "cccPlanVisitas", 1);
			Filter activableCpp = genericDao.createFilter(FilterType.EQUALS, "cppActivable", 1);
			Filter activableCcc = genericDao.createFilter(FilterType.EQUALS, "cccActivable", 1);
			Filter tipoComisionadoCcc = genericDao.createFilter(FilterType.NULL, "ccctipoComisionado.id");
			Filter tipoComisionadoCpp = genericDao.createFilter(FilterType.NULL, "cpptipoComisionado.id");
			Filter tipoActivoBDE = genericDao.createFilter(FilterType.NULL, "tipoActivoBDE");
			Filter cccvendido = genericDao.createFilter(FilterType.EQUALS, "cccVendido", 0);
			Filter cppvendido = genericDao.createFilter(FilterType.EQUALS, "cppVendido", 0);

			if(gastoInfoContabilidad.getGicPlanVisitas() == null || DDSinSiNo.CODIGO_NO.equals(gastoInfoContabilidad.getGicPlanVisitas().getCodigo())){
				planVisitasCpp = genericDao.createFilter(FilterType.EQUALS, "cppPlanVisitas", 0);
				planVisitasCcc = genericDao.createFilter(FilterType.EQUALS, "cccPlanVisitas", 0);
			}
			
			if(gastoInfoContabilidad.getActivable() == null || DDSinSiNo.CODIGO_NO.equals(gastoInfoContabilidad.getActivable().getCodigo())){
				activableCpp = genericDao.createFilter(FilterType.EQUALS, "cppActivable", 0);
				activableCcc = genericDao.createFilter(FilterType.EQUALS, "cccActivable", 0);
			}

			if(gastoInfoContabilidad.getTipoComisionadoHre() != null) {
				tipoComisionadoCcc = genericDao.createFilter(FilterType.EQUALS, "ccctipoComisionado.id", gastoInfoContabilidad.getTipoComisionadoHre().getId());
				tipoComisionadoCpp = genericDao.createFilter(FilterType.EQUALS, "cpptipoComisionado.id", gastoInfoContabilidad.getTipoComisionadoHre().getId());
			}
			
			if(gasto.getCartera() != null) {
				filtroCartera= genericDao.createFilter(FilterType.EQUALS, "cartera.id", gasto.getCartera().getId());
				if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(gasto.getCartera().getCodigo())){
					isLbk = true;
				}
			}
			if(idLineaDetalleGasto != null) {
				todosActivoAlquilados = this.estanTodosActivosAlquilados(idLineaDetalleGasto); 
				GastoLineaDetalle gastoLineaDetalle = getLineaDetalleByIdLinea(idLineaDetalleGasto);
				if(gastoLineaDetalle != null) {
					DDSubcartera subcartera  = this.getSubcarteraLinea(gastoLineaDetalle);
					if(subcartera != null) {
						filtroSubcartera= genericDao.createFilter(FilterType.EQUALS, "subCartera.id", subcartera.getId());
					}
				}
				
				boolean todosActivosVendidos = this.estanTodosActivosVendidos(idLineaDetalleGasto);
				if(todosActivosVendidos && isLbk) {
					cccvendido = genericDao.createFilter(FilterType.EQUALS, "cccVendido", 1);
					cppvendido = genericDao.createFilter(FilterType.EQUALS, "cppVendido", 1);
				}
			}
				
			List<ActivoConfiguracionPtdasPrep> partidaArrendadaList = null;
			List<ActivoConfiguracionPtdasPrep> partidaNoArrendadaList = null;
			
			
			partidaArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroPropietario,filtroCuentaArrendamiento, filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
			partidaNoArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroPropietario,filtroCuentaNoArrendamiento , filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
				
			if(partidaArrendadaList.isEmpty() && partidaNoArrendadaList.isEmpty()) {
				partidaArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroSubcartera,filtroCuentaArrendamiento, filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
				partidaNoArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento , filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
				if(partidaArrendadaList.isEmpty() && partidaNoArrendadaList.isEmpty()) {
					partidaArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroCuentaArrendamiento, filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
					partidaNoArrendadaList = genericDao.getList(ActivoConfiguracionPtdasPrep.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroCuentaNoArrendamiento , filtroRefacturablePP, planVisitasCpp,activableCpp,tipoComisionadoCpp, tipoActivoBDE, cppvendido);
				}
			}
			
			
			List<ActivoConfiguracionPtdasPrep> partidaArrendadaFinales = elegirPartidasByPrincipales(partidaArrendadaList);
			List<ActivoConfiguracionPtdasPrep> partidaNoArrendadaFinales = elegirPartidasByPrincipales(partidaNoArrendadaList);
			if(!partidaArrendadaFinales.isEmpty() || !partidaNoArrendadaFinales.isEmpty()){
				if(!todosActivoAlquilados && !partidaNoArrendadaFinales.isEmpty()){
					for (ActivoConfiguracionPtdasPrep partidaNoArrendada : partidaArrendadaFinales) {
						setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaNoArrendada);
					}
				} else if(partidaArrendadaFinales.isEmpty()){
					for (ActivoConfiguracionPtdasPrep partidaArrendada : partidaArrendadaFinales) {
						setPartidasPresupuestarias(dtoLineaDetalleGasto, partidaArrendada);
					}
				}
			}

			List<ActivoConfiguracionCuentasContables> cuentaArrendadaList= null;
			List<ActivoConfiguracionCuentasContables> cuentaNoArrendadaList= null;
			
			
			cuentaArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroPropietario,filtroCuentaArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
			cuentaNoArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroPropietario,filtroCuentaNoArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
	
			if(cuentaArrendadaList.isEmpty() && cuentaNoArrendadaList.isEmpty()) {
				cuentaArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroSubcartera,filtroCuentaArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
				cuentaNoArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroSubcartera,filtroCuentaNoArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
				if(cuentaArrendadaList.isEmpty() && cuentaNoArrendadaList.isEmpty()) {
					cuentaArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto,filtroCartera,filtroCuentaArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
					cuentaNoArrendadaList= genericDao.getList(ActivoConfiguracionCuentasContables.class, filtroEjercicioCuentaContable,filtroSubtipoGasto, filtroCartera,filtroCuentaNoArrendamiento, filtroRefacturableCC,planVisitasCcc,activableCcc,tipoComisionadoCcc, tipoActivoBDE, cccvendido);
				}
			}
			
			
			List<ActivoConfiguracionCuentasContables> cuentaArrendadaFinal = elegirCuentasByPrincipales(cuentaArrendadaList);
			List<ActivoConfiguracionCuentasContables> cuentaNoArrendadaFinal = elegirCuentasByPrincipales(cuentaNoArrendadaList);
			
			if(!cuentaArrendadaFinal.isEmpty() ||  !cuentaNoArrendadaFinal.isEmpty()){
				if(!todosActivoAlquilados && !cuentaNoArrendadaFinal.isEmpty()){
					for (ActivoConfiguracionCuentasContables cuentaNoArrendada : cuentaNoArrendadaFinal) {
						setCuentasContables(dtoLineaDetalleGasto, cuentaNoArrendada);
					}	
				} else if(!cuentaArrendadaFinal.isEmpty()){
					for (ActivoConfiguracionCuentasContables cuentaArrendada : cuentaArrendadaFinal) {
						setCuentasContables(dtoLineaDetalleGasto, cuentaArrendada);	
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
	public List<Activo> devolverActivosDeLineasDeGasto (Long idLineaDetalleGasto){
		List<Activo> activos = new ArrayList<Activo>();
	
		DDEntidadGasto tipoEntidad = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, DDEntidadGasto.CODIGO_ACTIVO);
		GastoLineaDetalle gastoLineaDetalle =  this.getLineaDetalleByIdLinea(idLineaDetalleGasto);
		if(tipoEntidad == null || gastoLineaDetalle == null ) {
			return activos;
		}
		List<GastoLineaDetalleEntidad> gastoLineaDetalleActivoList;
		Filter filtroEntidadActivo = genericDao.createFilter(FilterType.EQUALS, "entidadGasto.id", tipoEntidad.getId());	
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
	
	
	@Override
	public List<VElementosLineaDetalle> getElementosAfectados (Long idLinea){
		
		List<VElementosLineaDetalle> elementosLineaDetalleList = new ArrayList<VElementosLineaDetalle>();
		GastoLineaDetalle gastoLineaDetalle = getLineaDetalleByIdLinea(idLinea);
		if(gastoLineaDetalle != null) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "idLinea", idLinea);	
			elementosLineaDetalleList = genericDao.getList(VElementosLineaDetalle.class, filter);
			if(elementosLineaDetalleList.isEmpty()) {
				VElementosLineaDetalle vElementoLineaDetalle  = new VElementosLineaDetalle();	
				if(!gastoLineaDetalle.esAutorizadoSinActivos()) {
					vElementoLineaDetalle.setDescripcionLinea("Línea sin elementos asignados");

				}else {
					vElementoLineaDetalle.setDescripcionLinea("Línea marcada sin activos");	
					
				}		
				vElementoLineaDetalle.setImporteProporcinalTotal(100.0);
				vElementoLineaDetalle.setParticipacion(100.0);
				vElementoLineaDetalle.setImporteProporcinalTotal(0.0);
				vElementoLineaDetalle.setImporteTotalLinea(0.0);
				vElementoLineaDetalle.setIdElemento("");
				
				elementosLineaDetalleList.add(vElementoLineaDetalle);
			}
		}
		return elementosLineaDetalleList;		
	}
	
	@Override
	public List<DtoComboLineasDetalle> getLineasDetalleGastoCombo(Long idGasto){
		List<DtoComboLineasDetalle> comboLineasDetalle = new ArrayList<DtoComboLineasDetalle>();
		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		
		if(gasto != null && gasto.getGastoLineaDetalleList() != null && !gasto.getGastoLineaDetalleList().isEmpty()) {
			List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				DtoComboLineasDetalle dto = new DtoComboLineasDetalle();
				dto.setCodigo(gastoLineaDetalle.getId());
				dto.setId(gastoLineaDetalle.getId());
				dto.setDescripcion(getDescripcionLineaUsuario(gastoLineaDetalle));
				
				comboLineasDetalle.add(dto);		
			}
		}else {
			DtoComboLineasDetalle dto = new DtoComboLineasDetalle();
			dto.setCodigo(-1L);
			dto.setId(-1L);
			dto.setDescripcion("No hay líneas para este gasto");
			
			comboLineasDetalle.add(dto);
		}
		
		return comboLineasDetalle;
	}
	
	private String getDescripcionLineaUsuario(GastoLineaDetalle gastoLineaDetalle) {
		String descripcion ="";
		
		descripcion = gastoLineaDetalle.getSubtipoGasto().getDescripcion();
		if(gastoLineaDetalle.getSubtipoGasto() != null) {
			descripcion = gastoLineaDetalle.getSubtipoGasto().getDescripcion();
		}else {
			descripcion = descripcion + "-";
		}
		descripcion = descripcion + " ";
		if(gastoLineaDetalle.getTipoImpuesto() != null) {
			descripcion = descripcion + gastoLineaDetalle.getTipoImpuesto().getDescripcion();
		}else {
			descripcion = descripcion + "-";
		}
		descripcion = descripcion + " ";
		if(gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null) {
			descripcion = descripcion + gastoLineaDetalle.getImporteIndirectoTipoImpositivo() + "%";
		}else {
			descripcion = descripcion + "-";
		}
		
		return descripcion;
	}
	
	@Override
	@Transactional(readOnly = false)
	public String asociarElementosAgastos(DtoElementosAfectadosLinea dto){
		String error = "";
		if(dto.getIdElemento() != null && dto.getIdLinea() != null && dto.getTipoElemento() != null) {
			
			DDEntidadGasto tipoElemento = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, dto.getTipoElemento());
			GastoLineaDetalle gastoLineaDetalle = getLineaDetalleByIdLinea(dto.getIdLinea());
			if(tipoElemento == null || gastoLineaDetalle == null || gastoLineaDetalle.getGastoProveedor() == null ) {
				error = ERROR_GASTO_MAL_ESTADO;
				return error;
			}
			
			gastoLineaDetalle.setLineaSinActivos(false);
			genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);

			
			GastoProveedor gasto = gastoLineaDetalle.getGastoProveedor();
			List<GastoLineaDetalleEntidad>  gastoLineaDetalleEntidadList = gastoLineaDetalle.getGastoLineaEntidadList();
			if(DDEntidadGasto.CODIGO_AGRUPACION.equals(dto.getTipoElemento())){
				Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", dto.getIdElemento());
				ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtroAgrupacion);
				if(agrupacion == null) {
					error = ERROR_NO_EXISTE_AGRUPACION;
					return error;
				}
				List<ActivoAgrupacionActivo> activosAgrupacionList= agrupacion.getActivos();
				if(!activosAgrupacionList.isEmpty()) {
					if(gasto.getPropietario() == null || activosAgrupacionList.get(0).getActivo().getCartera() == null 
						|| !activosAgrupacionList.get(0).getActivo().getCartera().equals(gasto.getPropietario().getCartera())) {
						error = ERROR_CARTERA_DIFERENTE;
						return error;
					}
					DDEntidadGasto tipoElementoActivo = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, DDEntidadGasto.CODIGO_ACTIVO);
					BigDecimal participacion = recalcularParticipacionElementos(dto.getIdLinea(), gastoLineaDetalleEntidadList, activosAgrupacionList.size());
					for (ActivoAgrupacionActivo activoAgrupacionActivo : activosAgrupacionList) {
						GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidad.setGastoLineaDetalle(gastoLineaDetalle);
						gastoLineaDetalleEntidad.setEntidadGasto(tipoElementoActivo);
						gastoLineaDetalleEntidad.setEntidad(activoAgrupacionActivo.getActivo().getId());
						gastoLineaDetalleEntidad.setParticipacionGasto(participacion.doubleValue());
						gastoLineaDetalleEntidad.setAuditoria(Auditoria.getNewInstance());
						genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
					}
					return error;
				}
			}else{
				
				GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
				gastoLineaDetalleEntidad.setGastoLineaDetalle(gastoLineaDetalle);
				gastoLineaDetalleEntidad.setEntidadGasto(tipoElemento);
				if(DDEntidadGasto.CODIGO_ACTIVO.equals(dto.getTipoElemento())) {
					Activo activo = activoDao.getActivoByNumActivo(dto.getIdElemento());
					if(activo == null) {
						error = ERROR_NO_EXISTE_ACTIVO;
						return error;
					}else if(gasto.getPropietario() == null || activo.getCartera() == null 
						|| !activo.getCartera().equals(gasto.getPropietario().getCartera())) {
						error = ERROR_CARTERA_DIFERENTE;
						return error;
					}
					gastoLineaDetalleEntidad.setEntidad(activo.getId());
				}else if(DDEntidadGasto.CODIGO_ACTIVO_GENERICO.contentEquals(dto.getTipoElemento())) {
					Filter filtroNumActivoGen = genericDao.createFilter(FilterType.EQUALS, "numActivoGenerico", dto.getIdElemento());
					Filter filtroSubtipoGasto = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo", gastoLineaDetalle.getSubtipoGasto().getCodigo());
					Filter filtroPropietario= genericDao.createFilter(FilterType.EQUALS, "propietario.id", gasto.getPropietario().getId());
					Filter filtroAnyo;
					if(gasto.getFechaEmision() != null) {
						SimpleDateFormat fyear = new SimpleDateFormat("yyyy");
						String year = fyear.format(gasto.getFechaEmision());
						filtroAnyo = genericDao.createFilter(FilterType.EQUALS, "anyoActivoGenerico", Integer.parseInt(year));
					}else {
						filtroAnyo = genericDao.createFilter(FilterType.NULL, "anyoActivoGenerico");
					}
					ActivoGenerico activoGenerico =  genericDao.get(ActivoGenerico.class, filtroNumActivoGen, filtroSubtipoGasto,filtroPropietario, filtroAnyo);
					if(activoGenerico == null) {
						filtroAnyo = genericDao.createFilter(FilterType.NULL, "anyoActivoGenerico");
						activoGenerico =  genericDao.get(ActivoGenerico.class, filtroNumActivoGen, filtroSubtipoGasto,filtroPropietario,filtroAnyo);
						if(activoGenerico == null) {
							error = ERROR_NO_EXISTE_ACTIVO_GENERICO;
							return error;
						}
					}
					gastoLineaDetalleEntidad.setEntidad(activoGenerico.getId());
				}else {
					gastoLineaDetalleEntidad.setEntidad(dto.getIdElemento());
				}
				BigDecimal participacion = recalcularParticipacionElementos(dto.getIdLinea(), gastoLineaDetalleEntidadList, 1);
				gastoLineaDetalleEntidad.setAuditoria(Auditoria.getNewInstance());
				gastoLineaDetalleEntidad.setParticipacionGasto(participacion.doubleValue());
				genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
				

			}
		
			if(DDEntidadGasto.CODIGO_AGRUPACION.equals(dto.getTipoElemento()) || DDEntidadGasto.CODIGO_ACTIVO.equals(dto.getTipoElemento())) {
				DtoLineaDetalleGasto dtoLineaDetalleGasto = 
					this.calcularCuentasYPartidas(gastoLineaDetalle.getGastoProveedor().getId(),dto.getIdLinea(), gastoLineaDetalle.getSubtipoGasto().getCodigo());
					gastoLineaDetalle = this.updatearCuentasYPartidasVacias(dtoLineaDetalleGasto, gastoLineaDetalle);
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);		
			}
			
			if(gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
			DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
				actualizarDiariosLbk(gasto.getId());
			}
			
			return error;
		}
		
		error = ERROR_GASTO_MAL_ESTADO;
		return error;
	}
	
	@Transactional(readOnly = false)
	public BigDecimal recalcularParticipacionElementos(Long idLinea, List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList, int numeroEntidades){
		BigDecimal participacion = BigDecimal.valueOf(100L);
		
		if(!gastoLineaDetalleEntidadList.isEmpty()) {

			BigDecimal participacionMedia = BigDecimal.valueOf(100).divide(BigDecimal.valueOf(gastoLineaDetalleEntidadList.size() + numeroEntidades), 2, RoundingMode.HALF_UP);
			BigDecimal sumaParticipacion = participacionMedia.multiply(BigDecimal.valueOf(gastoLineaDetalleEntidadList.size() + numeroEntidades));
			BigDecimal participacionConDecimales = null;
			
			if(!sumaParticipacion.equals(BigDecimal.valueOf(100))) {
				BigDecimal decimal = sumaParticipacion.subtract(BigDecimal.valueOf(100));
				if(decimal.compareTo(BigDecimal.ZERO) < 0) {
					participacionConDecimales = participacionMedia.add(decimal);
				}else if(decimal.compareTo(BigDecimal.ZERO) > 0) {
					participacionConDecimales = participacionMedia.subtract(decimal);
				}
			}
			participacion = participacionMedia;
			gastoLineaDetalleDao.updateParticipacionEntidadesLineaDetalle(idLinea, participacionMedia.doubleValue(), genericAdapter.getUsuarioLogado().getUsername());
			
			if(participacionConDecimales != null) {
				gastoLineaDetalleEntidadList.get(0).setParticipacionGasto(participacionConDecimales.doubleValue());
				genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidadList.get(0));
			}
		}
		
		return participacion;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean desasociarElementosAgastos(Long idElemento){
		GastoLineaDetalleEntidad gastoLineaDetalleEntidad = getLineaDetalleEntidadByIdLineaEntidad(idElemento);
	
		if(gastoLineaDetalleEntidad != null && gastoLineaDetalleEntidad.getGastoLineaDetalle()  != null
		&& gastoLineaDetalleEntidad.getGastoLineaDetalle().getGastoProveedor() != null) {			
			GastoLineaDetalle gastoLineaDetalle = gastoLineaDetalleEntidad.getGastoLineaDetalle();
			if(gastoLineaDetalle != null && !gastoLineaDetalle.getGastoLineaEntidadList().isEmpty()) {
				List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList =  gastoLineaDetalle.getGastoLineaEntidadList();
				int indice = gastoLineaDetalleEntidadList.indexOf(gastoLineaDetalleEntidad);
				gastoLineaDetalleEntidadList.remove(indice);
				recalcularParticipacionElementos(gastoLineaDetalle.getId(), gastoLineaDetalleEntidadList, 0);
			}
			gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
			gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
			gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
			
			genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
			
			if(gastoLineaDetalleEntidad.getGastoLineaDetalle() != null) {
				GastoProveedor gasto = gastoLineaDetalleEntidad.getGastoLineaDetalle().getGastoProveedor();
				if(gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
					DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
						actualizarDiariosLbk(gasto.getId());
				}
			}
		
		}
		
		return false;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateElementosDetalle(DtoElementosAfectadosLinea dto){
		GastoLineaDetalleEntidad gastoLineaDetalleEntidad = getLineaDetalleEntidadByIdLineaEntidad(dto.getId());
		if(gastoLineaDetalleEntidad == null || gastoLineaDetalleEntidad.getGastoLineaDetalle()  == null
		|| gastoLineaDetalleEntidad.getGastoLineaDetalle().getGastoProveedor() == null) {
			return false;
		}
		
		if(dto.getReferenciaCatastral() == null || dto.getReferenciaCatastral().isEmpty()) {
			gastoLineaDetalleEntidad.setReferenciaCatastral(null);
		}else {
			gastoLineaDetalleEntidad.setReferenciaCatastral(dto.getReferenciaCatastral());
		}
		
		gastoLineaDetalleEntidad.setParticipacionGasto(dto.getParticipacion());
		gastoLineaDetalleEntidad.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gastoLineaDetalleEntidad.getAuditoria().setFechaModificar(new Date());
		
		genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
		
		if(gastoLineaDetalleEntidad.getGastoLineaDetalle() != null) {
			GastoProveedor gasto = gastoLineaDetalleEntidad.getGastoLineaDetalle().getGastoProveedor();
			if(gasto != null && gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
				DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
					actualizarDiariosLbk(gasto.getId());
			}
		}
		
		
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean updateLineaSinActivos(Long idLinea){
		GastoLineaDetalle gastoLineaDetalle = getLineaDetalleByIdLinea(idLinea);
		if(gastoLineaDetalle == null || gastoLineaDetalle.getGastoProveedor() == null) {
			return false;
		}
		gastoLineaDetalle.setLineaSinActivos(true);
		genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
		
		GastoProveedor gasto = gastoLineaDetalle.getGastoProveedor();
		if(gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
		DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
			actualizarDiariosLbk(gasto.getId());
		}

		return true;
	}

	private List<ActivoConfiguracionCuentasContables> elegirCuentasByPrincipales(List<ActivoConfiguracionCuentasContables> cuentasList) {
		List<ActivoConfiguracionCuentasContables> listaCuentasBase = new ArrayList<ActivoConfiguracionCuentasContables>();
		List<ActivoConfiguracionCuentasContables> listaCuentasTasa = new ArrayList<ActivoConfiguracionCuentasContables>();
		List<ActivoConfiguracionCuentasContables> listaCuentasRecargo = new ArrayList<ActivoConfiguracionCuentasContables>();
		List<ActivoConfiguracionCuentasContables> listaCuentasInteres = new ArrayList<ActivoConfiguracionCuentasContables>();
		boolean volverAEntrarBase=true;	
		boolean volverAEntrarTasa=true;	
		boolean volverAEntrarRecargo=true;	
		boolean volverAEntrarInteres=true;	
		List<ActivoConfiguracionCuentasContables> cuentasFinales = new ArrayList<ActivoConfiguracionCuentasContables>();
		
		if(cuentasList != null && !cuentasList.isEmpty()) {
			for (ActivoConfiguracionCuentasContables ccc : cuentasList) {
				if(ccc.getTipoImporte() != null && ccc.getGastosCuentasPrincipal() != null) {
					if(DDTipoImporte.CODIGO_BASE.equals(ccc.getTipoImporte().getCodigo()) && volverAEntrarBase) {
						listaCuentasBase = devolverCuentasContablesPrincipales(listaCuentasBase,ccc);
						if(listaCuentasBase.isEmpty()) {
							volverAEntrarBase = false;
						}
					}else if(DDTipoImporte.CODIGO_TASA.equals(ccc.getTipoImporte().getCodigo()) && volverAEntrarTasa) {
						listaCuentasTasa = devolverCuentasContablesPrincipales(listaCuentasTasa,ccc);
						if(listaCuentasTasa.isEmpty()) {
							volverAEntrarTasa = false;
						}
					}else if(DDTipoImporte.CODIGO_RECARGO.equals(ccc.getTipoImporte().getCodigo()) && volverAEntrarRecargo){
						listaCuentasRecargo = devolverCuentasContablesPrincipales(listaCuentasRecargo,ccc);
						if(listaCuentasRecargo.isEmpty()) {
							volverAEntrarRecargo = false;
						}
					}else if(DDTipoImporte.CODIGO_INTERES.equals(ccc.getTipoImporte().getCodigo()) && volverAEntrarInteres){
						listaCuentasInteres = devolverCuentasContablesPrincipales(listaCuentasInteres,ccc);
						if(listaCuentasInteres.isEmpty()) {
							volverAEntrarInteres = false;
						}
					}
				}
			}
			
			if(!listaCuentasBase.isEmpty() && listaCuentasBase.size() == 1) {
				cuentasFinales.addAll(listaCuentasBase);
			}
			if(!listaCuentasTasa.isEmpty() && listaCuentasTasa.size() == 1) {
				cuentasFinales.addAll(listaCuentasTasa);
			}
			if(!listaCuentasRecargo.isEmpty() && listaCuentasRecargo.size() == 1) {
				cuentasFinales.addAll(listaCuentasRecargo);
			}
			if(!listaCuentasInteres.isEmpty() && listaCuentasInteres.size() == 1) {
				cuentasFinales.addAll(listaCuentasInteres);
			}
			
		}
		
		
		return cuentasFinales;
	}
	
	List<ActivoConfiguracionCuentasContables> devolverCuentasContablesPrincipales(List<ActivoConfiguracionCuentasContables> listaCuentas,ActivoConfiguracionCuentasContables ccc ){

		if(listaCuentas.isEmpty()) {
			listaCuentas.add(ccc);
		}else{
			if(ccc.getGastosCuentasPrincipal().equals(listaCuentas.get(0).getGastosCuentasPrincipal()) && !ccc.getGastosCuentasPrincipal()) {
				listaCuentas.add(ccc);
			}else if(ccc.getGastosCuentasPrincipal().equals(listaCuentas.get(0).getGastosCuentasPrincipal()) && ccc.getGastosCuentasPrincipal()){
				listaCuentas.clear();
			}else if(!ccc.getGastosCuentasPrincipal().equals(listaCuentas.get(0).getGastosCuentasPrincipal()) && !ccc.getGastosCuentasPrincipal()) {
				listaCuentas.clear();
				listaCuentas.add(ccc);
			}
		}	
		
		return listaCuentas;
	}
	
	private List<ActivoConfiguracionPtdasPrep> elegirPartidasByPrincipales(List<ActivoConfiguracionPtdasPrep> partidasList) {
		List<ActivoConfiguracionPtdasPrep> listaPartidasBase = new ArrayList<ActivoConfiguracionPtdasPrep>();
		List<ActivoConfiguracionPtdasPrep> listaPartidasTasa = new ArrayList<ActivoConfiguracionPtdasPrep>();
		List<ActivoConfiguracionPtdasPrep> listaPartidasRecargo = new ArrayList<ActivoConfiguracionPtdasPrep>();
		List<ActivoConfiguracionPtdasPrep> listaPartirasInteres = new ArrayList<ActivoConfiguracionPtdasPrep>();
		boolean volverAEntrarBase=true;	
		boolean volverAEntrarTasa=true;	
		boolean volverAEntrarRecargo=true;	
		boolean volverAEntrarInteres=true;	
		List<ActivoConfiguracionPtdasPrep> partidasFinales = new ArrayList<ActivoConfiguracionPtdasPrep>();
		
		if(partidasList != null && !partidasList.isEmpty()) {
			for (ActivoConfiguracionPtdasPrep ppp : partidasList) {
				if(ppp.getTipoImporte() != null && ppp.getGastosPartidasPresupuestariasPrincipal() != null) {
					if(DDTipoImporte.CODIGO_BASE.equals(ppp.getTipoImporte().getCodigo()) && volverAEntrarBase) {
						listaPartidasBase = devolverPartidasPresupuestariasPrincipales(listaPartidasBase,ppp);
						if(listaPartidasBase.isEmpty()) {
							volverAEntrarBase = false;
						}
					}else if(DDTipoImporte.CODIGO_TASA.equals(ppp.getTipoImporte().getCodigo()) && volverAEntrarTasa) {
						listaPartidasTasa = devolverPartidasPresupuestariasPrincipales(listaPartidasTasa,ppp);
						if(listaPartidasTasa.isEmpty()) {
							volverAEntrarTasa = false;
						}
					}else if(DDTipoImporte.CODIGO_RECARGO.equals(ppp.getTipoImporte().getCodigo()) && volverAEntrarRecargo){
						listaPartidasRecargo = devolverPartidasPresupuestariasPrincipales(listaPartidasRecargo,ppp);
						if(listaPartidasRecargo.isEmpty()) {
							volverAEntrarRecargo = false;
						}
					}else if(DDTipoImporte.CODIGO_INTERES.equals(ppp.getTipoImporte().getCodigo()) && volverAEntrarInteres){
						listaPartirasInteres = devolverPartidasPresupuestariasPrincipales(listaPartirasInteres,ppp);
						if(listaPartirasInteres.isEmpty()) {
							volverAEntrarInteres = false;
						}
					}
				}
			}
			
			if(!listaPartidasBase.isEmpty() && listaPartidasBase.size() == 1) {
				partidasFinales.addAll(listaPartidasBase);
			}
			if(!listaPartidasTasa.isEmpty() && listaPartidasTasa.size() == 1) {
				partidasFinales.addAll(listaPartidasTasa);
			}
			if(!listaPartidasRecargo.isEmpty() && listaPartidasRecargo.size() == 1) {
				partidasFinales.addAll(listaPartidasRecargo);
			}
			if(!listaPartirasInteres.isEmpty() && listaPartirasInteres.size() == 1) {
				partidasFinales.addAll(listaPartirasInteres);
			}
			
		}
		
		
		return partidasFinales;
	}
	
	List<ActivoConfiguracionPtdasPrep> devolverPartidasPresupuestariasPrincipales(List<ActivoConfiguracionPtdasPrep> listaPartidas,ActivoConfiguracionPtdasPrep ppp ){

		if(listaPartidas.isEmpty()) {
			listaPartidas.add(ppp);
		}else{
			if(ppp.getGastosPartidasPresupuestariasPrincipal().equals(listaPartidas.get(0).getGastosPartidasPresupuestariasPrincipal()) && !ppp.getGastosPartidasPresupuestariasPrincipal()) {
				listaPartidas.add(ppp);
			}else if(ppp.getGastosPartidasPresupuestariasPrincipal().equals(listaPartidas.get(0).getGastosPartidasPresupuestariasPrincipal()) && ppp.getGastosPartidasPresupuestariasPrincipal()){
				listaPartidas.clear();
			}else if(!ppp.getGastosPartidasPresupuestariasPrincipal().equals(listaPartidas.get(0).getGastosPartidasPresupuestariasPrincipal()) && ppp.getGastosPartidasPresupuestariasPrincipal()) {
				listaPartidas.clear();
				listaPartidas.add(ppp);
			}
		}	
		
		return listaPartidas;
	}
	
	@Override
	public DDCartera getCarteraLinea(GastoLineaDetalle gastoLineaDetalle) {
		DDCartera cartera =  null;
		if(gastoLineaDetalle.getGastoLineaEntidadList() != null) {
			for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalle.getGastoLineaEntidadList()) {
				if(gastoLineaDetalleEntidad.getEntidadGasto() != null 
				&& DDEntidadGasto.CODIGO_ACTIVO.equals(gastoLineaDetalleEntidad.getEntidadGasto().getCodigo())) {
					Activo activo = activoDao.getActivoById(gastoLineaDetalleEntidad.getEntidad());
					if(activo != null) {
						cartera = activo.getCartera();
						break;
					}
				}
			}
		}
		
		return cartera;
	}
	
	@Override
	public DDSubcartera getSubcarteraLinea(GastoLineaDetalle gastoLineaDetalle) {
		DDSubcartera subcartera =  null;
		if(gastoLineaDetalle.getGastoLineaEntidadList() != null) {
			for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalle.getGastoLineaEntidadList()) {
				if(gastoLineaDetalleEntidad.getEntidadGasto() != null 
				&& DDEntidadGasto.CODIGO_ACTIVO.equals(gastoLineaDetalleEntidad.getEntidadGasto().getCodigo())) {
					Activo activo = activoDao.getActivoById(gastoLineaDetalleEntidad.getEntidad());
					if(activo != null) {
						subcartera = activo.getSubcartera();
						break;
					}
				}
			}
		}
		
		return subcartera;
	}
	
	
	@Override
	@Transactional(readOnly = false)
	public boolean actualizarReparto(Long idLinea) {
		Filter filtroGastoLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", idLinea);
		Filter filtroBorrado= genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
	    BigDecimal totalAdquisicion= new BigDecimal("0.0");
	    List<GastoLineaDetalleEntidad> gastoLineaDetalleActivoList = genericDao.getList(GastoLineaDetalleEntidad.class, filtroGastoLinea, filtroBorrado);
		for(GastoLineaDetalleEntidad gastoLinea: gastoLineaDetalleActivoList ){
			if(gastoLinea.getEntidadGasto().getCodigo().equals(DDEntidadGasto.CODIGO_ACTIVO)){
				Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "activo.id", gastoLinea.getEntidad());
				ActivoAdjudicacionNoJudicial actNJ = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtroEntidad, filtroBorrado);
				if(!Checks.esNulo(actNJ) && !Checks.esNulo(actNJ.getValorAdquisicion()) && (actNJ.getValorAdquisicion() > 0) ) {
					BigDecimal valorAdquisicion = new BigDecimal(actNJ.getValorAdquisicion());
					totalAdquisicion = totalAdquisicion.add(valorAdquisicion);
				}
				else {
					return Boolean.FALSE;
				}
				
			}
			else {
				return Boolean.FALSE;
			}
		}
		for(GastoLineaDetalleEntidad gastoLinea: gastoLineaDetalleActivoList ){
			Filter filtroEntidad = genericDao.createFilter(FilterType.EQUALS, "activo.id", gastoLinea.getEntidad());
			ActivoAdjudicacionNoJudicial actNJ = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtroEntidad, filtroBorrado);
			BigDecimal valorAdquisicion = new BigDecimal(actNJ.getValorAdquisicion());
			BigDecimal porcentaje =valorAdquisicion.multiply(new BigDecimal(100)).divide(totalAdquisicion, RoundingMode.HALF_DOWN);
			gastoLinea.setParticipacionGasto(porcentaje.doubleValue());
			genericDao.update(GastoLineaDetalleEntidad.class, gastoLinea);
		}
		
		return Boolean.TRUE;
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean actualizarRepartoTrabajo(Long idLinea) {
		Filter filtroLinea = genericDao.createFilter(FilterType.EQUALS, "idLinea", idLinea);
		List<VParticipacionElementosLinea> vParticipacionElementosLineaList = genericDao.getList(VParticipacionElementosLinea.class, filtroLinea);
		GastoLineaDetalle linea = this.getLineaDetalleByIdLinea(idLinea);
		
		if(linea != null && vParticipacionElementosLineaList != null && !vParticipacionElementosLineaList.isEmpty()) {
			this.actualizarParticipacionTrabajos(linea.getGastoProveedor(), vParticipacionElementosLineaList);
		}
		
		GastoProveedor gasto = linea.getGastoProveedor();
		if(gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null &&
				DDCartera.CODIGO_CARTERA_LIBERBANK.equalsIgnoreCase(gasto.getPropietario().getCartera().getCodigo())) {
					actualizarDiariosLbk(gasto.getId());
		}
		return Boolean.TRUE;
	}
	
	private String getTipoLineaByTrabajo(Trabajo trabajo) {
		String stringLinea = null;
		ActivoSubtipoGastoProveedorTrabajo activoStgProvTrabajo = gastoProveedorApi.getSubtipoGastoBySubtipoTrabajo(trabajo);
		if(activoStgProvTrabajo != null && activoStgProvTrabajo.getSubtipoGasto() != null) {
			stringLinea = activoStgProvTrabajo.getSubtipoGasto().getCodigo();
			Activo activo = null;
			if(trabajo.getActivosTrabajo() != null && !trabajo.getActivosTrabajo().isEmpty()) {
				activo = trabajo.getActivosTrabajo().get(0).getActivo();
			}
			if(activo != null)  {
				Long comAutonoma = activoDao.getComunidadAutonomaId(activo);
				List<ActivoSubtipoTrabajoGastoImpuesto> actStbjGpvImpList = null;
				Filter activoComunidadFilter = genericDao.createFilter(FilterType.EQUALS, "comunidadAutonoma.id", comAutonoma);
				Filter activoStgProvTbjFilter = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.id", activoStgProvTrabajo.getSubtipoGasto().getId());

				if(comAutonoma != null) {
					activoComunidadFilter = genericDao.createFilter(FilterType.EQUALS, "comunidadAutonoma.id", comAutonoma);
					actStbjGpvImpList = genericDao.getList(ActivoSubtipoTrabajoGastoImpuesto.class, activoStgProvTbjFilter, activoComunidadFilter);
				}
				if(actStbjGpvImpList == null || actStbjGpvImpList.isEmpty()) {
					activoComunidadFilter = genericDao.createFilter(FilterType.NULL, "comunidadAutonoma.id");
					actStbjGpvImpList = genericDao.getList(ActivoSubtipoTrabajoGastoImpuesto.class, activoStgProvTbjFilter, activoComunidadFilter);

				}
					
				if(actStbjGpvImpList != null && !actStbjGpvImpList.isEmpty() && actStbjGpvImpList.size() == 1 
				&& (actStbjGpvImpList.get(0).getTipoImpositivo() != null && actStbjGpvImpList.get(0).getTiposImpuesto() != null)) {
					stringLinea = stringLinea + "-" + actStbjGpvImpList.get(0).getTiposImpuesto().getCodigo();
					stringLinea = stringLinea + "-" + actStbjGpvImpList.get(0).getTipoImpositivo();
				}	
			}					
		}
		
		return stringLinea;
	}
	public boolean trabajoRepetidoEnLinea(Long idTrabajo, Long idLinea) {
		boolean trabajoRepetido = false;
		Filter filtroTrabajo = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", idTrabajo);
		Filter filtroLinea = genericDao.createFilter(FilterType.EQUALS, "gastoLineaDetalle.id", idLinea);
		GastoLineaDetalleTrabajo relacionLineaTrabajo = genericDao.get(GastoLineaDetalleTrabajo.class, filtroLinea, filtroTrabajo);
		
		if(relacionLineaTrabajo != null) {
			trabajoRepetido = true;
		}
		
		return trabajoRepetido;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean asignarTrabajosLineas(Long idGasto, Long[] trabajos) {
		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		
		if(gasto == null) {
			return false;
		}
		
		List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList(); 
		GastoLineaDetalle lineaAnyadirTrabajo = null;
		String stringLinea = null;
		for (Long trabajoLong : trabajos) {
			Trabajo trabajo = trabajoApi.findOne(trabajoLong);
			if(trabajo != null) {
				stringLinea = getTipoLineaByTrabajo(trabajo);
				if(stringLinea != null) {
					List<String> lineaParte = Arrays.asList(stringLinea.split("-"));
					if(gastoLineaDetalleList.isEmpty()) {
						
						GastoLineaDetalle gastoLineaDetalleNueva = crearGastoLineaDetalleParaTrabajos(gasto, trabajo,lineaParte);
						if(gastoLineaDetalleNueva.getSubtipoGasto() != null && gastoLineaDetalleNueva.getGastoProveedor() != null) {
							genericDao.save(GastoLineaDetalle.class, gastoLineaDetalleNueva);
							gastoLineaDetalleList.add(gastoLineaDetalleNueva);
							crearRelacionTrabajoLinea(gastoLineaDetalleNueva, trabajo);
							List<ActivoTrabajo> activoTrabajoList = trabajo.getActivosTrabajo();
							if(!activoTrabajoList.isEmpty()) {
								crearRelacionesActivoTrabajoLinea(gastoLineaDetalleNueva,activoTrabajoList, true);
							}
						}
					}else {
						if(lineaParte.size() == 1) {
							for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
								if(gastoLineaDetalle.getSubtipoGasto().getCodigo().equals(lineaParte.get(0)) && 
									gastoLineaDetalle.getTipoImpuesto() == null && gastoLineaDetalle.getImporteIndirectoTipoImpositivo() == null) {
									lineaAnyadirTrabajo = gastoLineaDetalle;
									break;
								}
							}
						}else {
							for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
								if(gastoLineaDetalle.getTipoImpuesto() != null && gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null
									&& gastoLineaDetalle.getSubtipoGasto().getCodigo().equals(lineaParte.get(0))
									&& gastoLineaDetalle.getTipoImpuesto().getCodigo().equals(lineaParte.get(1)) 
									&& gastoLineaDetalle.getImporteIndirectoTipoImpositivo().toString().equals(lineaParte.get(2))) {
									lineaAnyadirTrabajo = gastoLineaDetalle;
									gastoLineaDetalleList.remove(gastoLineaDetalle);
									break;
								}
							}
						}
						
						if(lineaAnyadirTrabajo == null) {
							if(gasto.getPropietario() != null && gasto.getPropietario().getCartera() != null
							&& DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getPropietario().getCartera().getCodigo())) {
								return false;
							}
							GastoLineaDetalle gastoLineaDetalleNueva = crearGastoLineaDetalleParaTrabajos(gasto, trabajo,lineaParte);
							if(gastoLineaDetalleNueva.getSubtipoGasto() != null && gastoLineaDetalleNueva.getGastoProveedor() != null) {
								genericDao.save(GastoLineaDetalle.class, gastoLineaDetalleNueva);
								gastoLineaDetalleList.add(gastoLineaDetalleNueva);
								crearRelacionTrabajoLinea(gastoLineaDetalleNueva, trabajo);
								List<ActivoTrabajo> activoTrabajoList = trabajo.getActivosTrabajo();
								
								if(!activoTrabajoList.isEmpty()) {
									crearRelacionesActivoTrabajoLinea(gastoLineaDetalleNueva,activoTrabajoList, true);
								}
							}
							
							
						}else {
							if(!trabajoRepetidoEnLinea(trabajo.getId(), lineaAnyadirTrabajo.getId())){
								lineaAnyadirTrabajo = updateGastoLineaDetalleParaTrabajos(gasto, trabajo,  lineaAnyadirTrabajo);
								genericDao.save(GastoLineaDetalle.class, lineaAnyadirTrabajo);
								gastoLineaDetalleList.add(lineaAnyadirTrabajo);
								crearRelacionTrabajoLinea(lineaAnyadirTrabajo, trabajo);
								List<ActivoTrabajo> activoTrabajoList = trabajo.getActivosTrabajo();
								
								if(!activoTrabajoList.isEmpty()) {
									crearRelacionesActivoTrabajoLinea(lineaAnyadirTrabajo,activoTrabajoList, false);
								}
							}
						}
						lineaAnyadirTrabajo = null;
					}
				}
			}
		}
		boolean actualizarParticipacionCorrectamente = true;
		BigDecimal importeTotalGDE = new BigDecimal(0.0);
		for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
			if(!actualizarParticipacionCorrectamente) {
				return false;
			}
			if(gastoLineaDetalle.getImporteTotal() != null) {
				importeTotalGDE = importeTotalGDE.add(new BigDecimal(gastoLineaDetalle.getImporteTotal()));
			}
		}
		
		if(gasto.getGastoDetalleEconomico() != null) {
			gasto.getGastoDetalleEconomico().setImporteTotal(importeTotalGDE.doubleValue());
			genericDao.save(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
		}
		
		
		return true;
	}
	
	
	
	private GastoLineaDetalle updateGastoLineaDetalleParaTrabajos(GastoProveedor gasto, Trabajo trabajo, GastoLineaDetalle lineaAnyadirTrabajo) {
		BigDecimal baseSujeta = new BigDecimal(0.0);
		BigDecimal importeTotal = new BigDecimal(0.0);
		BigDecimal cuota = new BigDecimal(0.0);
		BigDecimal baseSujetaFinal = new BigDecimal(0.0);
		if(gasto.getDestinatarioGasto() !=  null && DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())
			&& trabajo.getImportePresupuesto() != null) {
			baseSujeta = new BigDecimal(trabajo.getImportePresupuesto());
		}else if(trabajo.getImporteTotal() != null){
			baseSujeta = new BigDecimal(trabajo.getImporteTotal());
		}

		if(lineaAnyadirTrabajo.getImporteTotal() != null) {
			importeTotal = importeTotal.add(new BigDecimal(lineaAnyadirTrabajo.getImporteTotal()));
		}
		if(lineaAnyadirTrabajo.getPrincipalSujeto() != null) {
			baseSujetaFinal = baseSujeta.add(new BigDecimal(lineaAnyadirTrabajo.getPrincipalSujeto()));
			if(baseSujeta.compareTo(BigDecimal.ZERO) != 0 && lineaAnyadirTrabajo.getImporteIndirectoTipoImpositivo() != null
			&& lineaAnyadirTrabajo.getImporteIndirectoTipoImpositivo() != 0.0) {
				cuota = (new BigDecimal(lineaAnyadirTrabajo.getImporteIndirectoTipoImpositivo()).multiply(baseSujeta));
				cuota = cuota.divide(new BigDecimal(100));
			}
		}
		
		importeTotal = importeTotal.add(cuota);
		importeTotal = importeTotal.add(baseSujeta);
		lineaAnyadirTrabajo.setImporteTotal(importeTotal.doubleValue());
		lineaAnyadirTrabajo.setPrincipalSujeto(baseSujetaFinal.doubleValue());
		
		return lineaAnyadirTrabajo;
	}
	
	
	
	private GastoLineaDetalle crearGastoLineaDetalleParaTrabajos(GastoProveedor gasto, Trabajo trabajo, List<String> lineaParte) {
		GastoLineaDetalle gastoLineaDetalleNueva = new GastoLineaDetalle();
		gastoLineaDetalleNueva.setAuditoria(Auditoria.getNewInstance());
		gastoLineaDetalleNueva.setGastoProveedor(gasto);
		
		if(gasto.getDestinatarioGasto() !=  null && DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())
				&& trabajo.getImportePresupuesto() != null) {
			gastoLineaDetalleNueva.setPrincipalSujeto(trabajo.getImportePresupuesto());
		}else if(trabajo.getImporteTotal() != null){
			gastoLineaDetalleNueva.setPrincipalSujeto(trabajo.getImporteTotal());
		}else {
			gastoLineaDetalleNueva.setPrincipalSujeto(0.0);
		}
		DDSubtipoGasto subtipoGasto = (DDSubtipoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDSubtipoGasto.class, lineaParte.get(0));
		gastoLineaDetalleNueva.setSubtipoGasto(subtipoGasto);
		BigDecimal cuota = new BigDecimal (0.0);
		if(lineaParte.size() > 1) {
			DDTiposImpuesto tipoImpuesto = (DDTiposImpuesto) utilDiccionarioApi.dameValorDiccionarioByCod(DDTiposImpuesto.class, lineaParte.get(1));
			if(tipoImpuesto != null) {
				gastoLineaDetalleNueva.setTipoImpuesto(tipoImpuesto);
				gastoLineaDetalleNueva.setImporteIndirectoTipoImpositivo(Double.valueOf(lineaParte.get(2)));
				
				if(gastoLineaDetalleNueva.getPrincipalSujeto() != null && gastoLineaDetalleNueva.getPrincipalSujeto() != 0.0) {
					cuota = (new BigDecimal(gastoLineaDetalleNueva.getImporteIndirectoTipoImpositivo()).multiply(new BigDecimal(gastoLineaDetalleNueva.getPrincipalSujeto())));
					cuota = cuota.divide(new BigDecimal(100));
					gastoLineaDetalleNueva.setImporteIndirectoCuota(cuota.doubleValue());
				}else {
					gastoLineaDetalleNueva.setImporteIndirectoCuota(cuota.doubleValue());
				}
			}
		}
		BigDecimal importeTotal = (new BigDecimal (gastoLineaDetalleNueva.getPrincipalSujeto())).add(cuota);
		gastoLineaDetalleNueva.setImporteTotal(importeTotal.doubleValue());
		DtoLineaDetalleGasto dto = calcularCuentasYPartidas(gasto.getId(), null,lineaParte.get(0));

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
	private void crearRelacionTrabajoLinea(GastoLineaDetalle linea, Trabajo trabajo) {
		GastoLineaDetalleTrabajo gastoLineaDetalleTrabajo = new GastoLineaDetalleTrabajo(); 
		gastoLineaDetalleTrabajo.setGastoLineaDetalle(linea);
		gastoLineaDetalleTrabajo.setTrabajo(trabajo);
		if(trabajo.getImporteTotal() == trabajo.getImportePresupuesto()) { 
			DDTipoEmisorGLD tipoEmisorGLD = (DDTipoEmisorGLD) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoEmisorGLD.class, DDTipoEmisorGLD.CODIGO_OTROS);
			gastoLineaDetalleTrabajo.setTipoEmisor(tipoEmisorGLD);
		}else {
			DDTipoEmisorGLD tipoEmisorGLD = (DDTipoEmisorGLD) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoEmisorGLD.class, DDTipoEmisorGLD.CODIGO_HAYA);
			gastoLineaDetalleTrabajo.setTipoEmisor(tipoEmisorGLD);
		}
		gastoLineaDetalleTrabajo.setAuditoria(Auditoria.getNewInstance());
		genericDao.save(GastoLineaDetalleTrabajo.class, gastoLineaDetalleTrabajo);
	}
	
	private void crearRelacionesActivoTrabajoLinea(GastoLineaDetalle linea, List<ActivoTrabajo> activoTrabajoList, boolean lineaNueva) {
		DDEntidadGasto entidad = (DDEntidadGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEntidadGasto.class, DDEntidadGasto.CODIGO_ACTIVO);
		List<Long> idActivosList = new ArrayList();
		if(!lineaNueva) {
			List<GastoLineaDetalleEntidad> entidadesLinea = linea.getGastoLineaEntidadList();
			if(entidadesLinea != null && !entidadesLinea.isEmpty()) {
				for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : entidadesLinea) {
					if(DDEntidadGasto.CODIGO_ACTIVO.equals(gastoLineaDetalleEntidad.getEntidadGasto().getCodigo())){
						idActivosList.add(gastoLineaDetalleEntidad.getEntidad());
					}
				}
			}
		}
		
		for (ActivoTrabajo activoTrabajo : activoTrabajoList) {
			if(activoTrabajo.getActivo() != null && !idActivosList.contains(activoTrabajo.getActivo().getId())) {
				GastoLineaDetalleEntidad gldEnt = new GastoLineaDetalleEntidad();
				gldEnt.setAuditoria(Auditoria.getNewInstance());
				gldEnt.setEntidad(activoTrabajo.getActivo().getId());
				gldEnt.setEntidadGasto(entidad);
				gldEnt.setGastoLineaDetalle(linea);
				genericDao.save(GastoLineaDetalleEntidad.class, gldEnt);
			}
		}
	}
	
	@Override
	@Transactional(readOnly = false)
	public boolean eliminarTrabajoLinea (Long idTrabajo, Long idGasto) throws Exception {
		
		Trabajo trabajo = trabajoApi.findOne(idTrabajo);
		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		if(trabajo == null || gasto == null) {
			return false;
		}
		

		Filter trabajoLineaFilter = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
		List<GastoLineaDetalleTrabajo> gastoTrabajoList = genericDao.getList(GastoLineaDetalleTrabajo.class,trabajoLineaFilter);
	
		if(gastoTrabajoList != null && !gastoTrabajoList.isEmpty()) {
			for (GastoLineaDetalleTrabajo gastoLineaDetalleTrabajo : gastoTrabajoList) {
				if(gastoLineaDetalleTrabajo.getGastoLineaDetalle() != null && gasto.equals(gastoLineaDetalleTrabajo.getGastoLineaDetalle().getGastoProveedor())) {	
					gastoTrabajoList.remove(gastoLineaDetalleTrabajo);
					List<GastoLineaDetalleTrabajo> gastoLineaTrabajo = gastoLineaDetalleTrabajo.getGastoLineaDetalle().getGastoLineaTrabajoList();
					gastoLineaTrabajo.remove(gastoLineaDetalleTrabajo);
					gastoLineaDetalleTrabajo.getAuditoria().setBorrado(true);
					gastoLineaDetalleTrabajo.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
					gastoLineaDetalleTrabajo.getAuditoria().setFechaBorrar(new Date());
					if(gastoLineaTrabajo.isEmpty()) {
						this.deleteGastoLineaDetalle(gastoLineaDetalleTrabajo.getGastoLineaDetalle().getId());
					}else {
						GastoLineaDetalle gastoLineaDetalle = gastoLineaDetalleTrabajo.getGastoLineaDetalle();
						if(gastoLineaDetalle.getPrincipalSujeto() != null && gastoLineaDetalle.getImporteTotal() != null) {
							BigDecimal principalSujetoLinea = new BigDecimal(gastoLineaDetalle.getPrincipalSujeto());
							BigDecimal importeTotalLinea = new BigDecimal(gastoLineaDetalle.getImporteTotal());
							BigDecimal importeTotalTrabajo = null;
							
							if(gasto.getDestinatarioGasto() !=  null && DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())
									&& trabajo.getImportePresupuesto() != null) {
									importeTotalTrabajo = new BigDecimal(trabajo.getImportePresupuesto());
							}else if(trabajo.getImporteTotal() != null){
								importeTotalTrabajo = new BigDecimal(trabajo.getImporteTotal());
							}
							if(importeTotalTrabajo != null) {
								principalSujetoLinea = principalSujetoLinea.subtract(importeTotalTrabajo);
								gastoLineaDetalle.setPrincipalSujeto(principalSujetoLinea.doubleValue());
								importeTotalLinea = importeTotalLinea.subtract(importeTotalTrabajo);
								gastoLineaDetalle.setPrincipalSujeto(importeTotalLinea.doubleValue());
							}
							
							genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
						}
					}
					break;
				}
			}
		}

	

		return true;
		
	}
	
	private GastoLineaDetalle updatearCuentasYPartidasVacias(DtoLineaDetalleGasto dtoLineaDetalleGasto, GastoLineaDetalle gastoLineaDetalle) {
		if(dtoLineaDetalleGasto != null) {
			if(gastoLineaDetalle.getCccBase() == null) {
				gastoLineaDetalle.setCccBase(dtoLineaDetalleGasto.getCcBase());
			}
			if(gastoLineaDetalle.getCppBase() == null) {
				gastoLineaDetalle.setCppBase(dtoLineaDetalleGasto.getPpBase());
			}
			if(gastoLineaDetalle.getCccEsp() == null) {
				gastoLineaDetalle.setCccEsp(dtoLineaDetalleGasto.getCcEsp());
			}
			if(gastoLineaDetalle.getCppEsp() == null) {
				gastoLineaDetalle.setCppEsp(dtoLineaDetalleGasto.getPpEsp());
			}
			if(gastoLineaDetalle.getCccTasas() == null) {
				gastoLineaDetalle.setCccTasas(dtoLineaDetalleGasto.getCcTasas());
			}
			if(gastoLineaDetalle.getCppTasas() == null) {
				gastoLineaDetalle.setCppTasas(dtoLineaDetalleGasto.getPpTasas());
			}
			if(gastoLineaDetalle.getCccRecargo() == null) {
				gastoLineaDetalle.setCccRecargo(dtoLineaDetalleGasto.getCcRecargo());
			}
			if(gastoLineaDetalle.getCppRecargo() == null) {
				gastoLineaDetalle.setCppRecargo(dtoLineaDetalleGasto.getPpRecargo());
			}
			if(gastoLineaDetalle.getCccIntereses() == null) {
				gastoLineaDetalle.setCccIntereses(dtoLineaDetalleGasto.getCcInteres());
			}
			if(gastoLineaDetalle.getCppIntereses() == null) {
				gastoLineaDetalle.setCppIntereses(dtoLineaDetalleGasto.getPpInteres());
			}
		}
		return gastoLineaDetalle;
	}
	
	@Transactional(readOnly = false)
	private List<Long> actualizarParticipacionTrabajos(GastoProveedor gasto, List<VParticipacionElementosLinea> vParticipacionElementosLineaList) {
		List<Long> idActivosLista = new ArrayList<Long>();
		if(gasto != null && gasto.getDestinatarioGasto() != null && DDDestinatarioGasto.CODIGO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo())) {
			if(vParticipacionElementosLineaList != null && !vParticipacionElementosLineaList.isEmpty()) {
				for (VParticipacionElementosLinea vParticipacionElementosLinea : vParticipacionElementosLineaList) {
					GastoLineaDetalleEntidad gastoLineaDetalleEntidad = this.getLineaDetalleEntidadByIdLineaEntidad(vParticipacionElementosLinea.getId());
					if(gastoLineaDetalleEntidad != null) {
						idActivosLista.add(vParticipacionElementosLinea.getId());
						gastoLineaDetalleEntidad.setParticipacionGasto(vParticipacionElementosLinea.getParticipacionCli());
						genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
					}
				}
			}
		}else {
			if(vParticipacionElementosLineaList != null && !vParticipacionElementosLineaList.isEmpty()) {
				for (VParticipacionElementosLinea vParticipacionElementosLinea : vParticipacionElementosLineaList) {
					GastoLineaDetalleEntidad gastoLineaDetalleEntidad = this.getLineaDetalleEntidadByIdLineaEntidad(vParticipacionElementosLinea.getId());
					if(gastoLineaDetalleEntidad != null) {
						idActivosLista.add(vParticipacionElementosLinea.getId());
						gastoLineaDetalleEntidad.setParticipacionGasto(vParticipacionElementosLinea.getParticipacionPve());
						genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
					}
				}
			}
		}
		
		return idActivosLista;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void actualizarParticipacionTrabajosAfterInsert(Long idGasto) {
		GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
		if(gasto == null) {
			return;
		}
		Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "idGasto", idGasto);
		List<VParticipacionElementosLinea> vParticipacionElementosLineaList = genericDao.getList(VParticipacionElementosLinea.class, filtroGasto);
		List<Long> idActivosVista = this.actualizarParticipacionTrabajos(gasto, vParticipacionElementosLineaList);
		List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList = new ArrayList<GastoLineaDetalleEntidad>();
		List<GastoLineaDetalle> gastoLineaDetalleList = gasto.getGastoLineaDetalleList();
		if(!gastoLineaDetalleList.isEmpty()) {
			for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
				if(!gastoLineaDetalle.getGastoLineaEntidadList().isEmpty()) {
					gastoLineaDetalleEntidadList.addAll(gastoLineaDetalle.getGastoLineaEntidadList());
				}
			}
		}
		
		for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad : gastoLineaDetalleEntidadList) {
			if(!idActivosVista.contains(gastoLineaDetalleEntidad.getId())) {
				gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
				gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
				gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
				genericDao.save(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
				
			}	
		}
		
	}
	
	
	@Override 
	@Transactional(readOnly = false)
	public void actualizarDiariosLbk(Long idGasto) {
		activoDao.hibernateFlush();
		gastoLineaDetalleDao.actualizarDiariosLbk(idGasto, genericAdapter.getUsuarioLogado().getUsername());
	}
	
	
	@Override
	public boolean estanTodosActivosVendidos(Long idLineaDetalleGasto) {
		boolean estanTodosVendidos = false;
		boolean auxiliarSalir = true;
		
		List<Activo> activos = this.devolverActivosDeLineasDeGasto(idLineaDetalleGasto);

		if(activos != null && !activos.isEmpty()) {
			for (Activo activo : activos) {
				if(activo.getSituacionComercial() != null && DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())) {
					estanTodosVendidos = true;
					auxiliarSalir = false;
				}
				if(auxiliarSalir) {
					estanTodosVendidos = false;
					break;
				}
				
				auxiliarSalir = true;
			}
		}

		return estanTodosVendidos;
	}
	
	@Override
	public boolean estanTodosActivosAlquilados(Long idLineaDetalleGasto) {
		boolean todosActivoAlquilados = false;
		boolean auxiliarSalir = true;
		
		List<Activo> activos = this.devolverActivosDeLineasDeGasto(idLineaDetalleGasto);

		if(activos != null && !activos.isEmpty()) {
			for (Activo activo : activos) {
				
				if(activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getOcupado() != null
						&& activo.getSituacionPosesoria().getConTitulo() != null &&  activo.getSituacionPosesoria().getOcupado() == 1
						&& DDTipoTituloActivoTPA.tipoTituloSi.equals(activo.getSituacionPosesoria().getConTitulo().getCodigo())
						&& activo.getSituacionPosesoria().getTipoTituloPosesorio() != null 
						&&  DDTipoTituloPosesorio.CODIGO_ARRENDAMIENTO.equals(activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo())) {
							todosActivoAlquilados = true;
							auxiliarSalir = false;
				}
				if(auxiliarSalir) {
					todosActivoAlquilados = false;
					break;
				}
				
				auxiliarSalir = true;
			}
		}

		return todosActivoAlquilados;
	}
}