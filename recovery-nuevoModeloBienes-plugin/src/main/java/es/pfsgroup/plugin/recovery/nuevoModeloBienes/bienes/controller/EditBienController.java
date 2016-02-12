package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.controller;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.diccionarios.comparator.DictionaryComparatorFactory;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDTO;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.NMBconfigTabs;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.NMBconfigTabsTipoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto.DtoNMBBienAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.NMBProjectContext;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.DtoNMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarClientes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.serder.BienAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.serder.BienesAdjudicaciones;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.InformePropuestaCancelacionBean;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDDocAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDImposicionVenta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionPosesoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDSituacionTitulo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTasadora;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoCarga;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoImposicion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoInmueble;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoProdBancario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoTributacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDimpuestoCompra;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDTipoBienContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBEmbargoProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.BienProcedimientoDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.ProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.util.DDTipoBienComparator;
import es.pfsgroup.recovery.geninformes.GENINFVisorInformeController;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

//import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;

@Controller
public class EditBienController {

	public static final String GET_CLIENTES_JSON = "plugin/nuevoModeloBienes/bienes/NMBclientesJSON";
	public static final String GET_CARGAS_JSON = "plugin/nuevoModeloBienes/bienes/NMBCargasJSON";
	private static final String CLIENTES_PAGE_KEY = "clientes";
	private static final String WIN_AGREGAR_EXCLUIR_BIEN_PRC = "plugin/nuevoModeloBienes/procedimientos/agregarExcluirBienPrc";
	private static final String BIENES_PRC_JSON = "plugin/nuevoModeloBienes/procedimientos/bienesJSON";
	private static final String BIENES_PROCEDIMIENTO_JSON = "plugin/nuevoModeloBienes/adjudicacion/marcadoBienesJSON";
	private static final String DEFAULT = "default";
	private static final String DICCIONARIO_JSON = "plugin/nuevoModeloBienes/bienes/diccionarioJSON";
	private static final String TIPO_USUARIO_JSON = "plugin/coreextension/asunto/tipoUsuarioJSON";
	private static final String JSON_LIST_LOCALIDADES = "plugin/nuevoModeloBienes/bienes/LocalidadesJSON";
	private static final String JSON_LIST_UNIDADES_POBLACIONALES = "plugin/nuevoModeloBienes/bienes/UnidadesPoblacionalesJSON";
	private static final String JSON_RESPUESTA_SERVICIO = "plugin/nuevoModeloBienes/adjudicacion/generico/respuestaJSON";
	private static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private NMBconfigTabs nmbConfigTabs;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private TareaExternaValorDao tareaExternaValorDao;

	@Autowired
	private NMBProjectContext nmbProjectContext;

	@Autowired
	private InformePropuestaCancelacionBean informePropuestaCancelacionBean;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getProcedimientos(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {

		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
		map.put("procedimientos", procedimientos);

		return "plugin/nuevoModeloBienes/bienes/procedimientoBienJSON";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaRelacionContrato(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "tPorce", required = true) Long tPorce,
			ModelMap map) {
		map.put("idBien", idBien);
		map.put("tPorce", tPorce);
		return "plugin/nuevoModeloBienes/bienes/NMBrelacionBienPersona";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaRelacionBienContrato(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "idContrato", required = false) Long idContrato,
			@RequestParam(value = "codTipoContratoBien", required = false) String codTipoContratoBien,
			ModelMap map) {
		map.put("idBien", idBien);
		List<NMBDDTipoBienContrato> tipoContratoBien = (List<NMBDDTipoBienContrato>) executor
				.execute("dictionaryManager.getList", "NMBDDTipoBienContrato");
		map.put("DDContratoBien", tipoContratoBien);
		map.put("codTipoContratoBien", codTipoContratoBien);
		map.put("idContrato", idContrato);
		return "plugin/nuevoModeloBienes/bienes/NMBrelacionBienContrato";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarRelacionBienContratoMultiple(
			@RequestParam(value = "codTipoContratoBien", required = false) String codTipoContratoBien,
			ModelMap map) {
		
		List<NMBDDTipoBienContrato> tipoContratoBien = (List<NMBDDTipoBienContrato>) executor
				.execute("dictionaryManager.getList", "NMBDDTipoBienContrato");
		map.put("DDContratoBien", tipoContratoBien);
		map.put("codTipoContratoBien", codTipoContratoBien);

		return "plugin/nuevoModeloBienes/bienes/NMEditarRelacionBienContratoMultiple";
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editaRelacionBienContrato(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {
		map.put("idBien", idBien);
		return "plugin/nuevoModeloBienes/bienes/NMBeditaRelacionBienContrato";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarAdjudicacion(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {
		map.put("idBien", idBien);
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		map.put("NMBbien", bien);
		List<DDTipoFondo> fondo = (List<DDTipoFondo>) executor.execute(
				"dictionaryManager.getList", "DDTipoFondo");
		map.put("fondo", fondo);
		// List<Usuario> gestoriaAdjudicataria =
		// getGestoresAdjudicadicatarios();
		// map.put("gestoriaAdjudicataria", gestoriaAdjudicataria);
		List<DDEntidadAdjudicataria> entidadAdjudicataria = (List<DDEntidadAdjudicataria>) executor
				.execute("dictionaryManager.getList", "DDEntidadAdjudicataria");
		map.put("entidadAdjudicataria", entidadAdjudicataria);
		List<DDDocAdjudicacion> tipoDocAdjudicacion = (List<DDDocAdjudicacion>) executor
				.execute("dictionaryManager.getList", "DDDocAdjudicacion");
		map.put("tipoDocAdjudicacion", tipoDocAdjudicacion);
		List<DDSituacionTitulo> situacionTitulo = (List<DDSituacionTitulo>) executor
				.execute("dictionaryManager.getList", "DDSituacionTitulo");
		map.put("situacionTitulo", situacionTitulo);
		List<DDFavorable> resolucionMoratoria = (List<DDFavorable>) executor
				.execute("dictionaryManager.getList", "DDFavorable");
		map.put("resolucionMoratoria", resolucionMoratoria);
		return "plugin/nuevoModeloBienes/bienes/EditarAdjudicacion";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarRevisionCargas(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {
		map.put("idBien", idBien);
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		map.put("NMBbien", bien);
		return "plugin/nuevoModeloBienes/bienes/EditarRevisionCargas";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarPropuestaCancelacionCargas(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {
		map.put("idBien", idBien);
		map.put("NMBbien", proxyFactory.proxy(BienApi.class).get(idBien));
		return "plugin/nuevoModeloBienes/bienes/EditarPropuestaCancelacionCargas";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editaRelacionContrato(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "idPersona", required = true) Long idPersona,
			@RequestParam(value = "porce", required = true) Long porce,
			@RequestParam(value = "tPorce", required = true) Long tPorce,
			@RequestParam(value = "nomPersona", required = true) String nomPersona,
			ModelMap map) {
		map.put("idBien", idBien);
		map.put("idPersona", idPersona);
		map.put("nomPersona", nomPersona);
		map.put("porce", porce);
		map.put("tPorce", tPorce);
		return "plugin/nuevoModeloBienes/bienes/NMBeditaRelacionBienPersona";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getClientesPaginados(ModelMap map,
			@RequestParam(value = "field", required = true) String field,
			@RequestParam(value = "query", required = true) String query,
			@RequestParam(value = "limit", required = true) Integer limit,
			@RequestParam(value = "start", required = true) Integer start) {

		NMBDtoBuscarClientes dto = new DynamicDTO<NMBDtoBuscarClientes>(
				NMBDtoBuscarClientes.class).put(field, query)
				.put("limit", limit).put("start", start).create();

		Page pagina = proxyFactory.proxy(BienApi.class).getClientesPaginados(
				dto);

		map.put(CLIENTES_PAGE_KEY, pagina);

		return GET_CLIENTES_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getContratosPaginados(
			ModelMap map,
			@RequestParam(value = "codigoContrato", required = true) String codigoContrato,
			@RequestParam(value = "limit", required = true) Integer limit,
			@RequestParam(value = "start", required = true) Integer start) {

		// BusquedaContratosDto dto = new DynamicDTO<BusquedaContratosDto>(
		// BusquedaContratosDto.class).put("limit",
		// limit).put("start", start).create();

		BusquedaContratosDto dto = new BusquedaContratosDto();
		dto.setLimit(limit);
		dto.setStart(start);

		dto.setDescripcion(codigoContrato);
		// Page pagina = (Page)
		// executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_BUSCAR_CONTRATOS,dto);

		Page pagina = proxyFactory.proxy(BienApi.class).getContratosPaginados(
				dto);

		map.put("pagina", pagina);

		return "contratos/listadoContratosJSON";
	}

	@RequestMapping
	public String saveParticipacionBien(WebRequest request, ModelMap map) {

		proxyFactory.proxy(BienApi.class).saveParticipacionNMB(
				Integer.parseInt(request.getParameter("NMBparticipacion")),
				Long.parseLong(request.getParameter("NMBBien")),
				Long.parseLong(request.getParameter("persona")));

		return DEFAULT;
	}

	@RequestMapping
	public String saveBienContrato(WebRequest request, ModelMap map) {

		proxyFactory.proxy(BienApi.class).saveBienContrato(
				Long.parseLong(request.getParameter("idContrato")),
				Long.parseLong(request.getParameter("idBien")),
				request.getParameter("tipoContratoBien"));

		return DEFAULT;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openByIdBien(
			@RequestParam(value = "id", required = true) Long id, ModelMap map) {
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(id);
		map.put("NMBbien", bien);

		List<DDTipoBien> tiposBien = (List<DDTipoBien>) executor.execute(
				"dictionaryManager.getList", "DDTipoBien");
		Collections.sort(tiposBien, new DDTipoBienComparator());
		map.put("tiposBien", tiposBien);
		List<DDTipoInmueble> tiposInmueble = (List<DDTipoInmueble>) executor
				.execute("dictionaryManager.getList", "DDTipoInmueble");
		map.put("tiposInmueble", tiposInmueble);
		List<DDTipoProdBancario> tiposProdBanco = (List<DDTipoProdBancario>) executor
				.execute("dictionaryManager.getList", "DDTipoProdBancario");
		map.put("tiposProdBanco", tiposProdBanco);
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute(
				"dictionaryManager.getList", "DDProvincia");
		map.put("provincias", provincias);
		List<DDSituacionPosesoria> situacionPosesoria = (List<DDSituacionPosesoria>) executor
				.execute("dictionaryManager.getList", "DDSituacionPosesoria");
		map.put("situacionPosesoria", situacionPosesoria);
		List<DDTasadora> tasadora = (List<DDTasadora>) executor.execute(
				"dictionaryManager.getList", "DDTasadora");
		map.put("tasadora", tasadora);
		
		List<DDTipoTributacion	> tributacion = (List<DDTipoTributacion>) executor
				.execute("dictionaryManager.getList", "DDTipoTributacion");
		//Para ordenar la lista por descripcion
		Comparator<DDTipoTributacion> comparador = new Comparator<DDTipoTributacion> () {
		    public int compare(DDTipoTributacion p1, DDTipoTributacion p2) {
		    	return new String(p1.getDescripcion()).compareTo(new String(p2.getDescripcion()));
		    }
		};
		Collections.sort(tributacion, comparador);
		map.put("tributacion", tributacion);
		
		Map<String, NMBconfigTabsTipoBien> mapaTabs = nmbConfigTabs
				.getMapaTabsTipoBien();
		List<DDimpuestoCompra> impuestoCompra = (List<DDimpuestoCompra>) executor
				.execute("dictionaryManager.getList", "DDimpuestoCompra");
		map.put("impuestoCompra", impuestoCompra);

		List<DDCicCodigoIsoCirbeBKP> paises = (List<DDCicCodigoIsoCirbeBKP>) executor
				.execute("dictionaryManager.getList", "DDCicCodigoIsoCirbeBKP");
		map.put("paises", paises);
		
		List<DDTipoVia> vias = (List<DDTipoVia>) executor
				.execute("dictionaryManager.getList", "DDTipoVia");
		map.put("vias", vias);
		
		List<DDTipoImposicion> imposicion = (List<DDTipoImposicion>) executor
				.execute("dictionaryManager.getList", "DDTipoImposicion");
		//HR-1316 Funcion provisional para que no muestre el valor 16 que debe desaparecer del diccionario
		for(int i=0; i<imposicion.size();i++)
			if(imposicion.get(i).getCodigo().equals("16") || imposicion.get(i).getCodigo().equals("20")) {
				imposicion.remove(i);
			}
		//Para ordenar la lista por codigo - Este tiene en cuenta si los codigos de Diccionario son Numeros y Letras
		Comparator<DDTipoImposicion> comparadorImp = new Comparator<DDTipoImposicion> () {
		    public int compare(DDTipoImposicion p1, DDTipoImposicion p2) {
		    	if((int)p1.getCodigo().charAt(0)>= 48 && (int)p1.getCodigo().charAt(0) <= 57 && 
		    			(int)p2.getCodigo().charAt(0)>= 48 && (int)p2.getCodigo().charAt(0)	<= 57) {
		    		return new Integer(Integer.parseInt(p1.getCodigo())).compareTo(new Integer(Integer.parseInt(p2.getCodigo())));
		    	}
		    	else
		    		return new String(p1.getCodigo()).compareTo(new String(p2.getCodigo()));
		    }
		};
		Collections.sort(imposicion, comparadorImp);
		map.put("imposicion", imposicion);
		
		List<DDImposicionVenta> imposicionVenta = (List<DDImposicionVenta>) executor
				.execute("dictionaryManager.getList", "DDImposicionVenta");
		//Para ordenar la lista por codigo - Este tiene en cuenta si los codigos de Diccionario son Numeros y Letras
		Comparator<DDImposicionVenta> comparadorImpVenta = new Comparator<DDImposicionVenta> () {
		    public int compare(DDImposicionVenta p1, DDImposicionVenta p2) {
		    	if((int)p1.getCodigo().charAt(0)>= 48 && (int)p1.getCodigo().charAt(0) <= 57 && 
		    			(int)p2.getCodigo().charAt(0)>= 48 && (int)p2.getCodigo().charAt(0)	<= 57) {
		    		return new Integer(Integer.parseInt(p1.getCodigo())).compareTo(new Integer(Integer.parseInt(p2.getCodigo())));
		    	}
		    	else
		    		return new String(p1.getCodigo()).compareTo(new String(p2.getCodigo()));
		    }
		};
		Collections.sort(imposicionVenta, comparadorImpVenta);
		map.put("imposicionVenta", imposicionVenta);
		
		List<DDSiNo> sino = (List<DDSiNo>) executor
				.execute("dictionaryManager.getList", "DDSiNo");
		map.put("sino", sino);
		
		map.put("tabs", mapaTabs);
		map.put("operacion", "editar");
		return "plugin/nuevoModeloBienes/clientes/bienes.js";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCargasAnteriores(
			@RequestParam(value = "id", required = true) Long id,
			@RequestParam(value = "anteriores", required = true) Boolean anteriores,
			ModelMap map) {
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(id);
		List<NMBBienCargas> cargas = bien.getBienCargas();
		List<NMBBienCargas> cargasAnteriares = new ArrayList<NMBBienCargas>();
		List<NMBBienCargas> cargasPosteriores = new ArrayList<NMBBienCargas>();
		for (NMBBienCargas carga : cargas) {
			if ("ANT".compareTo(carga.getTipoCarga().getCodigo()) == 0
					&& anteriores) {
				cargasAnteriares.add(carga);
			}
			if ("POS".compareTo(carga.getTipoCarga().getCodigo()) == 0
					&& !anteriores) {
				cargasPosteriores.add(carga);
			}

		}
		if (anteriores) {
			map.put("cargas", cargasAnteriares);
		} else {
			map.put("cargas", cargasPosteriores);
		}
		return GET_CARGAS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openByIdBienAndIdPersona(
			@RequestParam(value = "id", required = true) Long idBien,
			@RequestParam(value = "idPersona", required = true) Long idPersona,
			ModelMap map) {
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		map.put("NMBbien", bien);
		map.put("idPersona", idPersona);
		List<DDTipoBien> tiposBien = (List<DDTipoBien>) executor.execute(
				"dictionaryManager.getList", "DDTipoBien");
		Collections.sort(tiposBien, new DDTipoBienComparator());
		map.put("tiposBien", tiposBien);
		List<DDTipoInmueble> tiposInmueble = (List<DDTipoInmueble>) executor
				.execute("dictionaryManager.getList", "DDTipoInmueble");
		map.put("tiposInmueble", tiposInmueble);
		List<DDTipoProdBancario> tiposProdBanco = (List<DDTipoProdBancario>) executor
				.execute("dictionaryManager.getList", "DDTipoProdBancario");
		map.put("tiposProdBanco", tiposProdBanco);
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute(
				"dictionaryManager.getList", "DDProvincia");
		map.put("provincias", provincias);
		List<DDTipoTributacion> tributacion = (List<DDTipoTributacion>) executor
				.execute("dictionaryManager.getList", "DDTipoTributacion");
		map.put("tributacion", tributacion);
		Map<String, NMBconfigTabsTipoBien> mapaTabs = nmbConfigTabs
				.getMapaTabsTipoBien();
		map.put("tabs", mapaTabs);
		List<DDimpuestoCompra> impuestoCompra = (List<DDimpuestoCompra>) executor
				.execute("dictionaryManager.getList", "DDimpuestoCompra");
		map.put("impuestoCompra", impuestoCompra);

		List<DDCicCodigoIsoCirbeBKP> paises = (List<DDCicCodigoIsoCirbeBKP>) executor
				.execute("dictionaryManager.getList", "DDCicCodigoIsoCirbeBKP");
		map.put("paises", paises);
		
		List<DDTipoVia> vias = (List<DDTipoVia>) executor
				.execute("dictionaryManager.getList", "DDTipoVia");
		map.put("vias", vias);
		
		List<DDTipoImposicion> imposicion = (List<DDTipoImposicion>) executor
				.execute("dictionaryManager.getList", "DDTipoImposicion");
		map.put("imposicion", imposicion);
		
		List<DDImposicionVenta> imposicionVenta = (List<DDImposicionVenta>) executor
				.execute("dictionaryManager.getList", "DDImposicionVenta");
		map.put("imposicionVenta", imposicionVenta);
		
		List<DDSiNo> sino = (List<DDSiNo>) executor
				.execute("dictionaryManager.getList", "DDSiNo");
		map.put("sino", sino);

		map.put("operacion", "editar");
		return "plugin/nuevoModeloBienes/clientes/bienes.js";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevoBien(ModelMap map) {
		List<DDTipoBien> tiposBien = (List<DDTipoBien>) executor.execute(
				"dictionaryManager.getList", "DDTipoBien");
		Collections.sort(tiposBien, new DDTipoBienComparator());
		map.put("tiposBien", tiposBien);
		List<DDTipoInmueble> tiposInmueble = (List<DDTipoInmueble>) executor
				.execute("dictionaryManager.getList", "DDTipoInmueble");
		map.put("tiposInmueble", tiposInmueble);
		List<DDTipoProdBancario> tiposProdBanco = (List<DDTipoProdBancario>) executor
				.execute("dictionaryManager.getList", "DDTipoProdBancario");
		map.put("tiposProdBanco", tiposProdBanco);
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute(
				"dictionaryManager.getList", "DDProvincia");
		map.put("provincias", provincias);
		List<DDSituacionPosesoria> situacionPosesoria = (List<DDSituacionPosesoria>) executor
				.execute("dictionaryManager.getList", "DDSituacionPosesoria");
		map.put("situacionPosesoria", situacionPosesoria);
		List<DDTipoTributacion> tributacion = (List<DDTipoTributacion>) executor
				.execute("dictionaryManager.getList", "DDTipoTributacion");
		map.put("tributacion", tributacion);
		Map<String, NMBconfigTabsTipoBien> mapaTabs = nmbConfigTabs
				.getMapaTabsTipoBien();
		map.put("tabs", mapaTabs);
		List<DDimpuestoCompra> impuestoCompra = (List<DDimpuestoCompra>) executor
				.execute("dictionaryManager.getList", "DDimpuestoCompra");
		map.put("impuestoCompra", impuestoCompra);

		List<DDCicCodigoIsoCirbeBKP> paises = (List<DDCicCodigoIsoCirbeBKP>) executor
				.execute("dictionaryManager.getList", "DDCicCodigoIsoCirbeBKP");
		map.put("paises", paises);
		
		List<DDTipoVia> vias = (List<DDTipoVia>) executor
				.execute("dictionaryManager.getList", "DDTipoVia");
		map.put("vias", vias);
		
		List<DDTipoImposicion> imposicion = (List<DDTipoImposicion>) executor
				.execute("dictionaryManager.getList", "DDTipoImposicion");
		map.put("imposicion", imposicion);
		
		List<DDImposicionVenta> imposicionVenta = (List<DDImposicionVenta>) executor
				.execute("dictionaryManager.getList", "DDImposicionVenta");
		map.put("imposicionVenta", imposicionVenta);
		
		List<DDSiNo> sino = (List<DDSiNo>) executor
				.execute("dictionaryManager.getList", "DDSiNo");
		map.put("sino", sino);
		
		map.put("operacion", "nuevo");
		return "plugin/nuevoModeloBienes/clientes/bienes.js";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevoBienIdPersona(
			@RequestParam(value = "idPersona", required = true) Long idPersona,
			ModelMap map) {
		List<DDTipoBien> tiposBien = (List<DDTipoBien>) executor.execute(
				"dictionaryManager.getList", "DDTipoBien");
		Collections.sort(tiposBien, new DDTipoBienComparator());
		map.put("tiposBien", tiposBien);
		List<DDTipoInmueble> tiposInmueble = (List<DDTipoInmueble>) executor
				.execute("dictionaryManager.getList", "DDTipoInmueble");
		map.put("tiposInmueble", tiposInmueble);
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute(
				"dictionaryManager.getList", "DDProvincia");
		map.put("provincias", provincias);
		List<DDTipoProdBancario> tiposProdBanco = (List<DDTipoProdBancario>) executor
				.execute("dictionaryManager.getList", "DDTipoProdBancario");
		map.put("tiposProdBanco", tiposProdBanco);
		List<DDSituacionPosesoria> situacionPosesoria = (List<DDSituacionPosesoria>) executor
				.execute("dictionaryManager.getList", "DDSituacionPosesoria");
		map.put("situacionPosesoria", situacionPosesoria);
		List<DDTasadora> tasadora = (List<DDTasadora>) executor.execute(
				"dictionaryManager.getList", "DDTasadora");
		map.put("tasadora", tasadora);
		List<DDTipoTributacion> tributacion = (List<DDTipoTributacion>) executor
				.execute("dictionaryManager.getList", "DDTipoTributacion");
		map.put("tributacion", tributacion);
		map.put("idPersona", idPersona);
		Map<String, NMBconfigTabsTipoBien> mapaTabs = nmbConfigTabs
				.getMapaTabsTipoBien();
		map.put("tabs", mapaTabs);
		List<DDimpuestoCompra> impuestoCompra = (List<DDimpuestoCompra>) executor
				.execute("dictionaryManager.getList", "DDimpuestoCompra");
		map.put("impuestoCompra", impuestoCompra);

		List<DDCicCodigoIsoCirbeBKP> paises = (List<DDCicCodigoIsoCirbeBKP>) executor
				.execute("dictionaryManager.getList", "DDCicCodigoIsoCirbeBKP");
		map.put("paises", paises);
		
		List<DDTipoVia> vias = (List<DDTipoVia>) executor
				.execute("dictionaryManager.getList", "DDTipoVia");
		map.put("vias", vias);
		
		List<DDTipoImposicion> imposicion = (List<DDTipoImposicion>) executor
				.execute("dictionaryManager.getList", "DDTipoImposicion");
		map.put("imposicion", imposicion);
		
		List<DDImposicionVenta> imposicionVenta = (List<DDImposicionVenta>) executor
				.execute("dictionaryManager.getList", "DDImposicionVenta");
		map.put("imposicionVenta", imposicionVenta);
		
		List<DDSiNo> sino = (List<DDSiNo>) executor
				.execute("dictionaryManager.getList", "DDSiNo");
		map.put("sino", sino);
		
		map.put("operacion", "nuevo");
		return "plugin/nuevoModeloBienes/clientes/bienes.js";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String saveBien(WebRequest request, ModelMap map) {
		DtoNMBBien dtoNMBBien = creaDTOParaGuardarBien(request);
		NMBBien nmbBien = new NMBBien();
		if (!Checks.esNulo(request.getParameter("idPersona")))
			nmbBien = proxyFactory.proxy(BienApi.class).createOrUpdateNMB(
					dtoNMBBien,
					Long.parseLong(request.getParameter("idPersona")));
		else
			nmbBien = proxyFactory.proxy(BienApi.class).createOrUpdateNMB(
					dtoNMBBien, null);
		map.put("id", nmbBien.getId());
		map.put("tipo", nmbBien.getTipoBien().getDescripcion());
		return "plugin/nuevoModeloBienes/bienes/NMBidNuevoBienJSON";
	}

	@RequestMapping
	public String borrarRelacionContrato(
			@RequestParam(value = "id", required = true) Long id, ModelMap map) {
		proxyFactory.proxy(EditBienApi.class).borrarRelacionPersonaBien(id);
		return DEFAULT;
	}

	@RequestMapping
	public String borrarRelacionBienContrato(
			@RequestParam(value = "id", required = true) Long id, ModelMap map) {
		proxyFactory.proxy(EditBienApi.class).borrarRelacionBienContrato(id);
		return DEFAULT;
	}

	private DtoNMBBien creaDTOParaGuardarBien(final WebRequest request) {
		DtoNMBBien dto = new DtoNMBBien();

		if (!Checks.esNulo(request.getParameter("id")))
			dto.setId(Long.parseLong(request.getParameter("id")));

		/* Ficha antigua del bien */
		if (!Checks.esNulo(request.getParameter("oldTipoBien")))
			dto.setTipoBien(request.getParameter("oldTipoBien"));
		if (!Checks.esNulo(request.getParameter("oldPoblacion")))
			dto.setBiePoblacion(request.getParameter("oldPoblacion"));
		if (!Checks.esNulo(request.getParameter("oldDescripcionBien")))
			dto.setDescripcionBien(request.getParameter("oldDescripcionBien"));
		if (!Checks.esNulo(request.getParameter("oldParticipacion")))
			dto.setParticipacion(Integer.parseInt(request
					.getParameter("oldParticipacion")));
		if (!Checks.esNulo(request.getParameter("oldValorActual")))
			dto.setValorActual(new BigDecimal(request.getParameter("oldValorActual")));
		if (!Checks.esNulo(request.getParameter("oldImporteCargas")))
			dto.setImporteCargas(new Float(request
					.getParameter("oldImporteCargas")));
		if (!Checks.esNulo(request.getParameter("oldFechaVerificacion")))
			dto.setFechaVerificacion(request
					.getParameter("oldFechaVerificacion"));
		if (!Checks.esNulo(request.getParameter("oldReferenciaCatastral")))
			dto.setReferenciaCatastral(request
					.getParameter("oldReferenciaCatastral"));
		if (!Checks.esNulo(request.getParameter("oldSuperficie")))
			dto.setBieSuperficie(new Float(request
					.getParameter("oldSuperficie")));
		if (!Checks.esNulo(request.getParameter("oldDatosRegistrales")))
			dto.setDatosRegistrales(request.getParameter("oldDatosRegistrales"));

		/* NMB Datos principales */
		if (!Checks.esNulo(request.getParameter("participacionNMB")))
			dto.setParticipacionNMB(new Float(request
					.getParameter("participacionNMB")));
		if (!Checks.esNulo(request.getParameter("tipoBien")))
			dto.setTipoBien(request.getParameter("tipoBien"));
		if (!Checks.esNulo(request.getParameter("valorActual")))
			dto.setValorActual(new BigDecimal(request.getParameter("valorActual")));
		if (!Checks.esNulo(request.getParameter("importeCargas")))
			dto.setImporteCargas(new Float(request
					.getParameter("importeCargas")));
		if (!Checks.esNulo(request.getParameter("descripcionBien")))
			dto.setDescripcionBien(request.getParameter("descripcionBien"));
		if (!Checks.esNulo(request.getParameter("fechaVerificacion")))
			dto.setFechaVerificacion(request.getParameter("fechaVerificacion"));

		if (!Checks.esNulo(request.getParameter("observaciones")))
			dto.setObservaciones(request.getParameter("observaciones"));

		if (!Checks.esNulo(request.getParameter("situacionPosesoria")))
			dto.setSituacionPosesoria(request
					.getParameter("situacionPosesoria"));

		if (!Checks.esNulo(request.getParameter("viviendaHabitual")))
			dto.setViviendaHabitual(request.getParameter("viviendaHabitual"));

		if (!Checks.esNulo(request.getParameter("tipoSubasta")))
			dto.setTipoSubasta(new Float(request.getParameter("tipoSubasta")));

		if (!Checks.esNulo(request.getParameter("obraEnCurso")))
			dto.setObraEnCurso(new Boolean(request.getParameter("obraEnCurso")));

		if (!Checks.esNulo(request.getParameter("dueDilligence")))
			dto.setDueDilligence(new Boolean(request
					.getParameter("dueDilligence")));

		if (!Checks.esNulo(request.getParameter("numeroActivo")))
			dto.setNumeroActivo(request.getParameter("numeroActivo"));

		if (!Checks.esNulo(request.getParameter("licenciaPrimeraOcupacion")))
			dto.setLicenciaPrimeraOcupacion(request
					.getParameter("licenciaPrimeraOcupacion"));

		if (!Checks.esNulo(request.getParameter("transmitentePromotor")))
			dto.setTransmitentePromotor(request
					.getParameter("transmitentePromotor"));

		if (!Checks.esNulo(request.getParameter("arrendadoSinOpcCompra")))
			dto.setArrendadoSinOpcCompra(request
					.getParameter("arrendadoSinOpcCompra"));

		if (!Checks.esNulo(request.getParameter("usoPromotorMayorDosAnyos")))
			dto.setUsoPromotorMayorDosAnyos(request
					.getParameter("usoPromotorMayorDosAnyos"));

		if (!Checks.esNulo(request.getParameter("primeraTransmision")))
			dto.setPrimeraTransmision(request
					.getParameter("primeraTransmision"));

		if (!Checks.esNulo(request.getParameter("contratoAlquiler")))
			dto.setContratoAlquiler(request.getParameter("contratoAlquiler"));

		/* NMB Datos registrales */
		if (!Checks.esNulo(request.getParameter("referenciaCatastralBien")))
			dto.setReferenciaCatastralBien(request
					.getParameter("referenciaCatastralBien"));
		if (!Checks.esNulo(request.getParameter("superficie")))
			dto.setSuperficie(new Float(request.getParameter("superficie")));
		if (!Checks.esNulo(request.getParameter("superficieConstruida")))
			dto.setSuperficieConstruida(new Float(request
					.getParameter("superficieConstruida")));
		if (!Checks.esNulo(request.getParameter("tomo")))
			dto.setTomo(request.getParameter("tomo"));
		if (!Checks.esNulo(request.getParameter("libro")))
			dto.setLibro(request.getParameter("libro"));
		if (!Checks.esNulo(request.getParameter("folio")))
			dto.setFolio(request.getParameter("folio"));
		if (!Checks.esNulo(request.getParameter("inscripcion")))
			dto.setInscripcion(request.getParameter("inscripcion"));
		if (!Checks.esNulo(request.getParameter("fechaInscripcion")))
			dto.setFechaInscripcion(request.getParameter("fechaInscripcion"));
		if (!Checks.esNulo(request.getParameter("numRegistro")))
			dto.setNumRegistro(request.getParameter("numRegistro"));
		if (!Checks.esNulo(request.getParameter("municipoLibro")))
			dto.setMunicipoLibro(request.getParameter("municipoLibro"));
		if (!Checks.esNulo(request.getParameter("codigoRegistro")))
			dto.setCodigoRegistro(request.getParameter("codigoRegistro"));
		if (!Checks.esNulo(request.getParameter("municipioRegistro")))
			dto.setMunicipioRegistro(request.getParameter("municipioRegistro"));
		if (!Checks.esNulo(request.getParameter("provinciaRegistro")))
			dto.setProvinciaRegistro(request.getParameter("provinciaRegistro"));
		
		

		/* NMB Datos Localizacion */
		if (!Checks.esNulo(request.getParameter("poblacion")))
			dto.setPoblacion(request.getParameter("poblacion"));
		if (!Checks.esNulo(request.getParameter("direccion")))
			dto.setDireccion(request.getParameter("direccion"));
		if (!Checks.esNulo(request.getParameter("codPostal")))
			dto.setCodPostal(request.getParameter("codPostal"));
		if (!Checks.esNulo(request.getParameter("numFinca")))
			dto.setNumFinca(request.getParameter("numFinca"));
		if (!Checks.esNulo(request.getParameter("provincia")))
			dto.setProvincia(request.getParameter("provincia"));

		if (!Checks.esNulo(request.getParameter("tipoVia")))
			dto.setTipoVia(request.getParameter("tipoVia"));
		if (!Checks.esNulo(request.getParameter("nombreVia")))
			dto.setNombreVia(request.getParameter("nombreVia"));
		if (!Checks.esNulo(request.getParameter("numeroDomicilio")))
			dto.setNumeroDomicilio(request.getParameter("numeroDomicilio"));
		if (!Checks.esNulo(request.getParameter("portal")))
			dto.setPortal(request.getParameter("portal"));
		if (!Checks.esNulo(request.getParameter("bloque")))
			dto.setBloque(request.getParameter("bloque"));
		if (!Checks.esNulo(request.getParameter("escalera")))
			dto.setEscalera(request.getParameter("escalera"));
		if (!Checks.esNulo(request.getParameter("piso")))
			dto.setPiso(request.getParameter("piso"));
		if (!Checks.esNulo(request.getParameter("puerta")))
			dto.setPuerta(request.getParameter("puerta"));
		if (!Checks.esNulo(request.getParameter("barrio")))
			dto.setBarrio(request.getParameter("barrio"));
		if (!Checks.esNulo(request.getParameter("pais")))
			dto.setPais(request.getParameter("pais"));
		if (!Checks.esNulo(request.getParameter("localidad")))
			dto.setLocalidad(request.getParameter("localidad"));
		if (!Checks.esNulo(request.getParameter("unidadPoblacional")))
			dto.setUnidadPoblacional(request.getParameter("unidadPoblacional"));

		/* NMB Datos Valoracion */
		if (!Checks.esNulo(request.getParameter("fechaValorSubjetivo")))
			dto.setFechaValorSubjetivo(request
					.getParameter("fechaValorSubjetivo"));
		if (!Checks.esNulo(request.getParameter("importeValorSubjetivo")))
			dto.setImporteValorSubjetivo(new Float(request
					.getParameter("importeValorSubjetivo")));
		if (!Checks.esNulo(request.getParameter("fechaValorApreciacion")))
			dto.setFechaValorApreciacion(request
					.getParameter("fechaValorApreciacion"));
		if (!Checks.esNulo(request.getParameter("importeValorApreciacion")))
			dto.setImporteValorApreciacion(new Float(request
					.getParameter("importeValorApreciacion")));
		if (!Checks.esNulo(request.getParameter("fechaValorTasacion")))
			dto.setFechaValorTasacion(request
					.getParameter("fechaValorTasacion"));
		if (!Checks.esNulo(request.getParameter("importeValorTasacion")))
			dto.setImporteValorTasacion(new Float(request
					.getParameter("importeValorTasacion")));

		if (!Checks.esNulo(request.getParameter("solvenciaNoEncontrada")))
			dto.setSolvenciaNoEncontrada(new Boolean(request
					.getParameter("solvenciaNoEncontrada")));

		if (!Checks.esNulo(request.getParameter("valorTasacionExterna")))
			dto.setValorTasacionExterna(Float.parseFloat(request
					.getParameter("valorTasacionExterna")));

		if (!Checks.esNulo(request.getParameter("fechaTasacionExterna")))
			dto.setFechaTasacionExterna(request
					.getParameter("fechaTasacionExterna"));

		if (!Checks.esNulo(request.getParameter("tasadora")))
			dto.setTasadora(request.getParameter("tasadora"));

		if (!Checks.esNulo(request.getParameter("fechaSolicitudTasacion")))
			dto.setFechaSolicitudTasacion(request
					.getParameter("fechaSolicitudTasacion"));

		if (!Checks.esNulo(request.getParameter("respuestaConsulta")))
			dto.setRespuestaConsulta(request.getParameter("respuestaConsulta"));

		if (!Checks.esNulo(request.getParameter("tributacion")))
			dto.setTributacion(request.getParameter("tributacion"));
		
		if (!Checks.esNulo(request.getParameter("tributacionVenta")))
			dto.setTributacionVenta(request.getParameter("tributacionVenta"));
		
		if (!Checks.esNulo(request.getParameter("imposicionCompra")))
			dto.setTipoImposicionCompra(request.getParameter("imposicionCompra"));
		
		if (!Checks.esNulo(request.getParameter("imposicionVenta")))
			dto.setTipoImposicionVenta(request.getParameter("imposicionVenta"));
		
		if (!Checks.esNulo(request.getParameter("inversionRenuncia")))
			dto.setInversionPorRenuncia(request.getParameter("inversionRenuncia"));

		if (!Checks.esNulo(request.getParameter("fechaSolicitudDueD")))
			dto.setFechaSolicitudDueD(request
					.getParameter("fechaSolicitudDueD"));

		if (!Checks.esNulo(request.getParameter("fechaDueD")))
			dto.setFechaDueD(request.getParameter("fechaDueD"));

		if (!Checks.esNulo(request.getParameter("porcentajeImpuestoCompra")))
			dto.setPorcentajeImpuestoCompra(Float.parseFloat(request
					.getParameter("porcentajeImpuestoCompra")));

		if (!Checks.esNulo(request.getParameter("impuestoCompra")))
			dto.setImpuestoCompra(request.getParameter("impuestoCompra"));

		// /* NMB Datos Adicionales */
		if (!Checks.esNulo(request.getParameter("nomEmpresa")))
			dto.setNomEmpresa(request.getParameter("nomEmpresa"));
		if (!Checks.esNulo(request.getParameter("cifEmpresa")))
			dto.setCifEmpresa(request.getParameter("cifEmpresa"));
		if (!Checks.esNulo(request.getParameter("codIAE")))
			dto.setCodIAE(request.getParameter("codIAE"));
		if (!Checks.esNulo(request.getParameter("desIAE")))
			dto.setDesIAE(request.getParameter("desIAE"));
		if (!Checks.esNulo(request.getParameter("tipoProdBancario")))
			dto.setTipoProdBancario(request.getParameter("tipoProdBancario"));
		if (!Checks.esNulo(request.getParameter("tipoInmueble")))
			dto.setTipoInmueble(request.getParameter("tipoInmueble"));
		if (!Checks.esNulo(request.getParameter("valoracion")))
			dto.setValoracion(new Float(request.getParameter("valoracion")));
		if (!Checks.esNulo(request.getParameter("entidad")))
			dto.setEntidad(request.getParameter("entidad"));
		if (!Checks.esNulo(request.getParameter("numCuenta")))
			dto.setNumCuenta(request.getParameter("numCuenta"));
		if (!Checks.esNulo(request.getParameter("matricula")))
			dto.setMatricula(request.getParameter("matricula").toUpperCase());
		if (!Checks.esNulo(request.getParameter("bastidor")))
			dto.setBastidor(request.getParameter("bastidor").toUpperCase());
		if (!Checks.esNulo(request.getParameter("modelo")))
			dto.setModelo(request.getParameter("modelo"));
		if (!Checks.esNulo(request.getParameter("marca")))
			dto.setMarca(request.getParameter("marca"));
		if (!Checks.esNulo(request.getParameter("fechaMatricula")))
			dto.setFechaMatricula(request.getParameter("fechaMatricula"));

		return dto;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openEmbargoProcedimiento(
			@RequestParam(value = "idEmbargo", required = false) Long idEmbargo,
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {

		if (idEmbargo != null) {
			NMBEmbargoProcedimiento nmbEmbargoProcedimiento = proxyFactory
					.proxy(EditBienApi.class)
					.getEmbargoProcedimiento(idEmbargo);
			map.put("fechaAdjudicacion",
					nmbEmbargoProcedimiento.getFechaAdjudicacion());
			map.put("id", nmbEmbargoProcedimiento.getId());
			map.put("fechaDecreto", nmbEmbargoProcedimiento.getFechaDecreto());
			map.put("fechaRegistro", nmbEmbargoProcedimiento.getFechaRegistro());
			map.put("fechaSolicitud",
					nmbEmbargoProcedimiento.getFechaSolicitud());
			map.put("fechaAval", nmbEmbargoProcedimiento.getFechaAval());
			map.put("fechaTasacion", nmbEmbargoProcedimiento.getFechaTasacion());
			map.put("importeValor", nmbEmbargoProcedimiento.getImporteValor());
			map.put("importeAval", nmbEmbargoProcedimiento.getImporteAval());
			map.put("importeTasacion",
					nmbEmbargoProcedimiento.getImporteTasacion());
			map.put("importeAdjudicacion",
					nmbEmbargoProcedimiento.getImporteAdjudicacion());
			map.put("letra", nmbEmbargoProcedimiento.getLetra());
			map.put("fechaDenegacion",
					nmbEmbargoProcedimiento.getFechaDenegacion());
		}
		map.put("idProcedimiento", idProcedimiento);
		map.put("idBien", idBien);
		return "plugin/nuevoModeloBienes/procedimientos/embargoProcedimiento";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openEmbargoProcedimientoMultiple(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			ModelMap map) {

		map.put("idProcedimiento", idProcedimiento);
		return "plugin/nuevoModeloBienes/procedimientos/embargoProcedimientoMultiple";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEmbargoProcedimientoMultiple(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			ModelMap map) {

		List<Bien> listaBienes = proxyFactory.proxy(ProcedimientoApi.class)
				.getBienesDeUnProcedimiento(idProcedimiento);
		map.put("idProcedimiento", idProcedimiento);
		map.put("listado", listaBienes);
		return "plugin/nuevoModeloBienes/procedimientos/listadoEmbargoProcedimientoMultipleJSON_NMB";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getEmbargoProcedimientoAsuntoMultiple(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "idAsunto", required = false) Long idAsunto,
			ModelMap map) {

		List<Bien> listaBienes = proxyFactory.proxy(ProcedimientoApi.class)
				.getBienesDeUnProcedimiento(idProcedimiento);
		map.put("idProcedimiento", idProcedimiento);
		map.put("idAsunto", idAsunto);
		map.put("listado", listaBienes);
		return "plugin/nuevoModeloBienes/procedimientos/listadoEmbargoProcedimientoAsuntoMultipleJSON_NMB";
	}

	@RequestMapping
	public String saveAdjudicacion(WebRequest request, ModelMap map) {
		return saveAdjudicacion(request);
	}

	@RequestMapping
	public String saveRevisionCargas(WebRequest request, ModelMap map) {
		return saveRevisionCargas(request);
	}

	@RequestMapping
	public String savePropuestaCancelacionCargas(WebRequest request,
			ModelMap map) {
		return savePropuestaCancelacionCargas(request);
	}

	@RequestMapping
	public String saveEmbargo(WebRequest request, ModelMap map) {
		return saveEmbargo(request);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarInformePropCancelacionCargas(
			@RequestParam(value = "id", required = true) Long idBien,
			ModelMap model) {
		
		String plantilla = nmbProjectContext.getPlantillaReportPropuestaCancelacionCargas();

		// Obtener datos para rellenar el informe
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);

		List<Object> datos = informePropuestaCancelacionBean.create(bien);
		FileItem resultado = proxyFactory.proxy(GENINFInformesApi.class)
				.generarInforme(plantilla, null, datos);

		model.put("fileItem", resultado);
		return GENINFVisorInformeController.JSP_DOWNLOAD_FILE;
	}

	private String savePropuestaCancelacionCargas(WebRequest request) {
		String idBien = request.getParameter("id");
		String resumen = request.getParameter("resumen");
		String propuesta = request.getParameter("propuesta");

		NMBAdicionalBien adicional = new NMBAdicionalBien();
		NMBBien bien = null;

		if (!Checks.esNulo(idBien)) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(idBien));

			if (bien.getAdicional() != null) {
				adicional = bien.getAdicional();
				Auditoria auditoria = adicional.getAuditoria();
				auditoria.setFechaModificar(new Date());
				adicional.setAuditoria(auditoria);
			} else {
				Auditoria auditoria = Auditoria.getNewInstance();
				adicional.setAuditoria(auditoria);
			}
		} else {
			adicional.setBien(null);
		}

		if (!Checks.esNulo(resumen)) {
			adicional.setCancelacionResumen(resumen);
		} else {
			adicional.setCancelacionResumen(null);
		}

		if (!Checks.esNulo(propuesta)) {
			adicional.setCancelacionPropuesta(propuesta);
		} else {
			adicional.setCancelacionPropuesta(null);
		}

		bien.setAdicional(adicional);
		adicional.setBien(bien);

		// Se usa el metodo de revision de cargas que guarda datos adicionales.
		proxyFactory.proxy(EditBienApi.class).guardarRevisionCargas(adicional);
		return DEFAULT;
	}

	private String saveRevisionCargas(WebRequest request) {

		NMBAdicionalBien adicional = new NMBAdicionalBien();
		NMBBien bien = null;
		if (!Checks.esNulo(request.getParameter("id"))) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(request.getParameter("id")));

			if (bien.getAdicional() != null) {
				adicional = bien.getAdicional();
				Auditoria auditoria = adicional.getAuditoria();
				auditoria.setFechaModificar(new Date());
				adicional.setAuditoria(auditoria);
			} else {
				Auditoria auditoria = Auditoria.getNewInstance();
				adicional.setAuditoria(auditoria);
			}
		} else {
			adicional.setBien(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRevision"))) {
			try {
				adicional.setFechaRevision(DateFormat.toDate(request
						.getParameter("fechaRevision")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adicional.setFechaRevision(null);
		}

		if (!Checks.esNulo(request.getParameter("sinCargas"))) {
			adicional.setSinCargas(Boolean.parseBoolean(request
					.getParameter("sinCargas")));
		} else {
			adicional.setSinCargas(null);
		}

		if (!Checks.esNulo(request.getParameter("observaciones"))) {
			adicional.setObservaciones(request.getParameter("observaciones"));
		} else {
			adicional.setObservaciones(null);
		}

		bien.setAdicional(adicional);
		adicional.setBien(bien);

		proxyFactory.proxy(EditBienApi.class).guardarRevisionCargas(adicional);

		return DEFAULT;

	}

	private String saveAdjudicacion(WebRequest request) {
		NMBAdjudicacionBien adjudicacion = new NMBAdjudicacionBien();
		NMBBien bien = null;
		if (!Checks.esNulo(request.getParameter("id"))) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(request.getParameter("id")));
			if (bien.getAdjudicacion() != null) {
				adjudicacion = bien.getAdjudicacion();
				Auditoria auditoria = adjudicacion.getAuditoria();
				auditoria.setFechaModificar(new Date());
				adjudicacion.setAuditoria(auditoria);
			} else {
				Auditoria auditoria = Auditoria.getNewInstance();
				adjudicacion.setAuditoria(auditoria);
			}
		} else {
			adjudicacion.setBien(null);
		}

		if (!Checks.esNulo(request.getParameter("idAdjudicacion"))) {
			adjudicacion.setIdAdjudicacion(Long.parseLong(request
					.getParameter("idAdjudicacion")));
		} else {
			adjudicacion.setIdAdjudicacion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaDecretoNoFirme"))) {
			try {
				adjudicacion.setFechaDecretoNoFirme(DateFormat.toDate(request
						.getParameter("fechaDecretoNoFirme")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaDecretoNoFirme(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaDecretoFirme"))) {
			try {
				adjudicacion.setFechaDecretoFirme(DateFormat.toDate(request
						.getParameter("fechaDecretoFirme")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaDecretoFirme(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaEntregaGestor"))) {
			try {
				adjudicacion.setFechaEntregaGestor(DateFormat.toDate(request
						.getParameter("fechaEntregaGestor")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaEntregaGestor(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaPresentacionHacienda"))) {
			try {
				adjudicacion.setFechaPresentacionHacienda(DateFormat
						.toDate(request
								.getParameter("fechaPresentacionHacienda")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaPresentacionHacienda(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSegundaPresentacion"))) {
			try {
				adjudicacion.setFechaSegundaPresentacion(DateFormat
						.toDate(request
								.getParameter("fechaSegundaPresentacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSegundaPresentacion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRecepcionTitulo"))) {
			try {
				adjudicacion.setFechaRecepcionTitulo(DateFormat.toDate(request
						.getParameter("fechaRecepcionTitulo")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaRecepcionTitulo(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaInscripcionTitulo"))) {
			try {
				adjudicacion
						.setFechaInscripcionTitulo(DateFormat.toDate(request
								.getParameter("fechaInscripcionTitulo")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaInscripcionTitulo(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaEnvioAdicion"))) {
			try {
				adjudicacion.setFechaEnvioAdicion(DateFormat.toDate(request
						.getParameter("fechaEnvioAdicion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaEnvioAdicion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaPresentacionRegistro"))) {
			try {
				adjudicacion.setFechaPresentacionRegistro(DateFormat
						.toDate(request
								.getParameter("fechaPresentacionRegistro")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaPresentacionRegistro(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSolicitudPosesion"))) {
			try {
				adjudicacion
						.setFechaSolicitudPosesion(DateFormat.toDate(request
								.getParameter("fechaSolicitudPosesion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSolicitudPosesion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSenalamientoPosesion"))) {
			try {
				adjudicacion.setFechaSenalamientoPosesion(DateFormat
						.toDate(request
								.getParameter("fechaSenalamientoPosesion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSenalamientoPosesion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRealizacionPosesion"))) {
			try {
				adjudicacion.setFechaRealizacionPosesion(DateFormat
						.toDate(request
								.getParameter("fechaRealizacionPosesion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaRealizacionPosesion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSolicitudLanzamiento"))) {
			try {
				adjudicacion.setFechaSolicitudLanzamiento(DateFormat
						.toDate(request
								.getParameter("fechaSolicitudLanzamiento")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSolicitudLanzamiento(null);
		}

		if (!Checks
				.esNulo(request.getParameter("fechaSenalamientoLanzamiento"))) {
			try {
				adjudicacion.setFechaSenalamientoLanzamiento(DateFormat
						.toDate(request
								.getParameter("fechaSenalamientoLanzamiento")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSenalamientoLanzamiento(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRealizacionLanzamiento"))) {
			try {
				adjudicacion.setFechaRealizacionLanzamiento(DateFormat
						.toDate(request
								.getParameter("fechaRealizacionLanzamiento")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaRealizacionLanzamiento(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSolicitudMoratoria"))) {
			try {
				adjudicacion
						.setFechaSolicitudMoratoria(DateFormat.toDate(request
								.getParameter("fechaSolicitudMoratoria")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaSolicitudMoratoria(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaResolucionMoratoria"))) {
			try {
				adjudicacion.setFechaResolucionMoratoria(DateFormat
						.toDate(request
								.getParameter("fechaResolucionMoratoria")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaResolucionMoratoria(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaContratoArrendamiento"))) {
			try {
				adjudicacion.setFechaContratoArrendamiento(DateFormat
						.toDate(request
								.getParameter("fechaContratoArrendamiento")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaContratoArrendamiento(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaCambioCerradura"))) {
			try {
				adjudicacion.setFechaCambioCerradura(DateFormat.toDate(request
						.getParameter("fechaCambioCerradura")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaCambioCerradura(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaEnvioLLaves"))) {
			try {
				adjudicacion.setFechaEnvioLLaves(DateFormat.toDate(request
						.getParameter("fechaEnvioLLaves")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaEnvioLLaves(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRecepcionDepositario"))) {
			try {
				adjudicacion.setFechaRecepcionDepositario(DateFormat
						.toDate(request
								.getParameter("fechaRecepcionDepositario")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaRecepcionDepositario(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaEnvioDepositario"))) {
			try {
				adjudicacion.setFechaEnvioDepositario(DateFormat.toDate(request
						.getParameter("fechaEnvioDepositario")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaEnvioDepositario(null);
		}

		if (!Checks.esNulo(request
				.getParameter("fechaRecepcionDepositarioFinal"))) {
			try {
				adjudicacion
						.setFechaRecepcionDepositarioFinal(DateFormat.toDate(request
								.getParameter("fechaRecepcionDepositarioFinal")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaRecepcionDepositarioFinal(null);
		}

		// booleanos

		if (!Checks.esNulo(request.getParameter("ocupado"))) {
			adjudicacion.setOcupado(Boolean.parseBoolean(request
					.getParameter("ocupado")));
		} else {
			adjudicacion.setOcupado(null);
		}

		if (!Checks.esNulo(request.getParameter("posiblePosesion"))) {
			adjudicacion.setPosiblePosesion(Boolean.parseBoolean(request
					.getParameter("posiblePosesion")));
		} else {
			adjudicacion.setPosiblePosesion(null);
		}

		if (!Checks.esNulo(request.getParameter("ocupantesDiligencia"))) {
			adjudicacion.setOcupantesDiligencia(Boolean.parseBoolean(request
					.getParameter("ocupantesDiligencia")));
		} else {
			adjudicacion.setOcupantesDiligencia(null);
		}

		if (!Checks.esNulo(request.getParameter("lanzamientoNecesario"))) {
			adjudicacion.setLanzamientoNecesario(Boolean.parseBoolean(request
					.getParameter("lanzamientoNecesario")));
		} else {
			adjudicacion.setLanzamientoNecesario(null);
		}

		if (!Checks.esNulo(request.getParameter("entregaVoluntaria"))) {
			adjudicacion.setEntregaVoluntaria(Boolean.parseBoolean(request
					.getParameter("entregaVoluntaria")));
		} else {
			adjudicacion.setEntregaVoluntaria(null);
		}

		if (!Checks.esNulo(request.getParameter("necesariaFuerzaPublica"))) {
			adjudicacion.setNecesariaFuerzaPublica(Boolean.parseBoolean(request
					.getParameter("necesariaFuerzaPublica")));
		} else {
			adjudicacion.setNecesariaFuerzaPublica(null);
		}

		if (!Checks.esNulo(request.getParameter("existeInquilino"))) {
			adjudicacion.setExisteInquilino(Boolean.parseBoolean(request
					.getParameter("existeInquilino")));
		} else {
			adjudicacion.setExisteInquilino(null);
		}

		if (!Checks.esNulo(request.getParameter("llavesNecesarias"))) {
			adjudicacion.setLlavesNecesarias(Boolean.parseBoolean(request
					.getParameter("llavesNecesarias")));
		} else {
			adjudicacion.setLlavesNecesarias(null);
		}

		if (!Checks.esNulo(request.getParameter("cesionRemate"))) {
			adjudicacion.setCesionRemate(Boolean.parseBoolean(request
					.getParameter("cesionRemate")));
		} else {
			adjudicacion.setCesionRemate(null);
		}

		// selector persona
		if (!Checks.esNulo(request.getParameter("gestoriaAdjudicataria"))) {
			Usuario gestor = proxyFactory.proxy(UsuarioApi.class).get(
					Long.parseLong(request
							.getParameter("gestoriaAdjudicataria")));
			adjudicacion.setGestoriaAdjudicataria(gestor);
		} else {
			adjudicacion.setGestoriaAdjudicataria(null);
		}

		// textos

		if (!Checks.esNulo(request.getParameter("nombreArrendatario"))) {
			adjudicacion.setNombreArrendatario(request
					.getParameter("nombreArrendatario"));
		} else {
			adjudicacion.setNombreArrendatario(null);
		}

		if (!Checks.esNulo(request.getParameter("nombreDepositario"))) {
			adjudicacion.setNombreDepositario(request
					.getParameter("nombreDepositario"));
		} else {
			adjudicacion.setNombreDepositario(null);
		}

		if (!Checks.esNulo(request.getParameter("nombreDepositarioFinal"))) {
			adjudicacion.setNombreDepositarioFinal(request
					.getParameter("nombreDepositarioFinal"));
		} else {
			adjudicacion.setNombreDepositarioFinal(null);
		}

		if (!Checks.esNulo(request.getParameter("fondo"))) {
			DDTipoFondo fondo = (DDTipoFondo) proxyFactory.proxy(
					UtilDiccionarioApi.class).dameValorDiccionarioByCod(
					DDTipoFondo.class, request.getParameter("fondo"));
			adjudicacion.setFondo(fondo);
		} else {
			adjudicacion.setFondo(null);
		}

		// DICCIONARIOS

		if (!Checks.esNulo(request.getParameter("entidadAdjudicataria"))) {
			DDEntidadAdjudicataria entidadAdjudicataria = (DDEntidadAdjudicataria) proxyFactory
					.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(
							DDEntidadAdjudicataria.class,
							request.getParameter("entidadAdjudicataria"));
			adjudicacion.setEntidadAdjudicataria(entidadAdjudicataria);
		} else {
			adjudicacion.setEntidadAdjudicataria(null);
		}
		
		if (!Checks.esNulo(request.getParameter("tipoDocAdjudicacion"))) {
			DDDocAdjudicacion tipoDocAdjudicacion = (DDDocAdjudicacion) proxyFactory
					.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(
							DDDocAdjudicacion.class,
							request.getParameter("tipoDocAdjudicacion"));
			adjudicacion.setTipoDocAdjudicacion(tipoDocAdjudicacion);
		} else {
			adjudicacion.setTipoDocAdjudicacion(null);
		}

		if (!Checks.esNulo(request.getParameter("situacionTitulo"))) {
			DDSituacionTitulo situacionTitulo = (DDSituacionTitulo) proxyFactory
					.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(
							DDSituacionTitulo.class,
							request.getParameter("situacionTitulo"));
			adjudicacion.setSituacionTitulo(situacionTitulo);
		} else {
			adjudicacion.setSituacionTitulo(null);
		}

		if (!Checks.esNulo(request.getParameter("resolucionMoratoria"))) {
			DDFavorable resolucionMoratoria = (DDFavorable) proxyFactory.proxy(
					UtilDiccionarioApi.class).dameValorDiccionarioByCod(
					DDFavorable.class,
					request.getParameter("resolucionMoratoria"));
			adjudicacion.setResolucionMoratoria(resolucionMoratoria);
		} else {
			adjudicacion.setResolucionMoratoria(null);
		}

		if (!Checks.esNulo(request.getParameter("importeAdjudicacion"))) {
			adjudicacion.setImporteAdjudicacion(new BigDecimal(request
					.getParameter("importeAdjudicacion")));
		} else {
			adjudicacion.setImporteAdjudicacion(null);
		}

		if (!Checks.esNulo(request.getParameter("importeCesionRemate"))) {
			adjudicacion.setImporteCesionRemate(Float.parseFloat(request
					.getParameter("importeCesionRemate")));
		} else {
			adjudicacion.setImporteCesionRemate(null);
		}
		
		if (!Checks.esNulo(request.getParameter("fechaContabilidad"))) {
			try {
				adjudicacion.setFechaContabilidad(DateFormat.toDate(request
						.getParameter("fechaContabilidad")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			adjudicacion.setFechaContabilidad(null);
		}

		bien.setAdjudicacion(adjudicacion);
		adjudicacion.setBien(bien);

		proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(adjudicacion);

		return DEFAULT;

	}

	private String saveEmbargo(WebRequest request) {
		NMBEmbargoProcedimiento nmbEmbargoProcedimiento;

		if (!Checks.esNulo(request.getParameter("idEmbargo"))) {
			long idEmbargo = Long.parseLong(request.getParameter("idEmbargo"));
			nmbEmbargoProcedimiento = proxyFactory.proxy(EditBienApi.class)
					.getEmbargoProcedimiento(idEmbargo);
		} else {
			nmbEmbargoProcedimiento = new NMBEmbargoProcedimiento();
			long idBien = Long.parseLong(request.getParameter("idBien"));
			NMBBien bien;
			bien = proxyFactory.proxy(EditBienApi.class).getBien(idBien);
			nmbEmbargoProcedimiento.setBien(bien);
			Procedimiento procedimiento;
			long idProcedimiento = Long.parseLong(request
					.getParameter("idProcedimiento"));
			procedimiento = proxyFactory.proxy(EditBienApi.class)
					.getProcedimiento(idProcedimiento);
			nmbEmbargoProcedimiento.setProcedimiento(procedimiento);
		}

		if (!Checks.esNulo(request.getParameter("fechaAdjudicacion"))) {
			try {
				nmbEmbargoProcedimiento.setFechaAdjudicacion(DateFormat
						.toDate(request.getParameter("fechaAdjudicacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaAdjudicacion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaDecreto"))) {
			try {
				nmbEmbargoProcedimiento.setFechaDecreto(DateFormat
						.toDate(request.getParameter("fechaDecreto")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaDecreto(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaRegistro"))) {
			try {
				nmbEmbargoProcedimiento.setFechaRegistro(DateFormat
						.toDate(request.getParameter("fechaRegistro")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaRegistro(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaSolicitud"))) {
			try {
				nmbEmbargoProcedimiento.setFechaSolicitud(DateFormat
						.toDate(request.getParameter("fechaSolicitud")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaSolicitud(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaAval"))) {
			try {
				nmbEmbargoProcedimiento.setFechaAval(DateFormat.toDate(request
						.getParameter("fechaAval")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaAval(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaTasacion"))) {
			try {
				nmbEmbargoProcedimiento.setFechaTasacion(DateFormat
						.toDate(request.getParameter("fechaTasacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaTasacion(null);
		}

		if (!Checks.esNulo(request.getParameter("importeValor"))) {
			nmbEmbargoProcedimiento.setImporteValor(new Float(request
					.getParameter("importeValor")));
		} else {
			nmbEmbargoProcedimiento.setImporteValor(null);
		}
		if (!Checks.esNulo(request.getParameter("importeAval"))) {
			nmbEmbargoProcedimiento.setImporteAval(new Float(request
					.getParameter("importeAval")));
		} else {
			nmbEmbargoProcedimiento.setImporteAval(null);
		}
		if (!Checks.esNulo(request.getParameter("importeTasacion"))) {
			nmbEmbargoProcedimiento.setImporteTasacion(new Float(request
					.getParameter("importeTasacion")));
		} else {
			nmbEmbargoProcedimiento.setImporteTasacion(null);
		}
		if (!Checks.esNulo(request.getParameter("importeAdjudicacion"))) {
			nmbEmbargoProcedimiento.setImporteAdjudicacion(new Float(request
					.getParameter("importeAdjudicacion")));
		} else {
			nmbEmbargoProcedimiento.setImporteAdjudicacion(null);
		}

		if (!Checks.esNulo(request.getParameter("letra"))) {
			nmbEmbargoProcedimiento.setLetra(request.getParameter("letra"));
		} else {
			nmbEmbargoProcedimiento.setLetra(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaDenegacion"))) {
			try {
				nmbEmbargoProcedimiento.setFechaDenegacion(DateFormat
						.toDate(request.getParameter("fechaDenegacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			nmbEmbargoProcedimiento.setFechaDenegacion(null);
		}

		proxyFactory.proxy(EditBienApi.class).guardaEmbargoProcedimiento(
				nmbEmbargoProcedimiento);

		return DEFAULT;
	}

	/**
	 * 
	 * Agregar una carga a un bien
	 * 
	 * @param idBien
	 * @param idCarga
	 * @param tipoCarga
	 *            ("ANTERIOR" / "POSTERIOR"
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String agregarEditarCargas(
			@RequestParam(value = "idBien", required = true) Long idBien,
			Long idCarga, String tipoCarga, ModelMap map) {
		map.put("idBien", idBien);
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
		NMBBienCargas carga;

		// Agregar Carga
		if (idCarga == null) {
			carga = new NMBBienCargas();
		}
		// Editar Carga
		else {
			carga = (NMBBienCargas) proxyFactory.proxy(EditBienApi.class)
					.getCarga(idCarga);
		}
		;
		map.put("Carga", carga);
		map.put("NMBBien", bien);
		map.put("tipoCarga", tipoCarga);
		map.put("idCarga", idCarga);

		List<DDSituacionCarga> situacionCarga = (List<DDSituacionCarga>) executor
				.execute("dictionaryManager.getList", "DDSituacionCarga");
		map.put("situacionCarga", situacionCarga);

		List<DDSituacionCarga> situacionCargaEconomica = (List<DDSituacionCarga>) executor
				.execute("dictionaryManager.getList", "DDSituacionCarga");
		map.put("situacionCargaEconomica", situacionCargaEconomica);

		return "plugin/nuevoModeloBienes/bienes/AgregarEditarBienCargas";
	}

	/**
	 * Salvar carga de un bien
	 * 
	 * @param request
	 * @param map
	 * @return
	 */
	@RequestMapping
	public String saveCarga(WebRequest request, ModelMap map) {
		return saveCarga(request);
	}

	/**
	 * Salvar la carga de un bien
	 * 
	 * @param request
	 * @return
	 */

	private String saveCarga(WebRequest request) {

		NMBBienCargas carga;
		if (!Checks.esNulo(request.getParameter("idCarga"))) {
			carga = (NMBBienCargas) proxyFactory.proxy(EditBienApi.class)
					.getCarga(Long.parseLong(request.getParameter("idCarga")));
		} else {
			carga = new NMBBienCargas();
		}

		NMBBien bien = null;
		if (!Checks.esNulo(request.getParameter("id"))) {
			bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(request.getParameter("id")));
			carga.setBien(bien);
		}

		if (!Checks.esNulo(request.getParameter("fechaPresentacion"))) {
			try {
				carga.setFechaPresentacion(DateFormat.toDate(request
						.getParameter("fechaPresentacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaPresentacion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaInscripcion"))) {
			try {
				carga.setFechaInscripcion(DateFormat.toDate(request
						.getParameter("fechaInscripcion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaInscripcion(null);
		}

		if (!Checks.esNulo(request.getParameter("fechaCancelacion"))) {
			try {
				carga.setFechaCancelacion(DateFormat.toDate(request
						.getParameter("fechaCancelacion")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} else {
			carga.setFechaCancelacion(null);
		}

		if (!Checks.esNulo(request.getParameter("registral"))) {
			carga.setRegistral(Boolean.parseBoolean(request
					.getParameter("registral")));
		} else {
			carga.setRegistral(null);
		}

		if (!Checks.esNulo(request.getParameter("economica"))) {
			carga.setEconomica(Boolean.parseBoolean(request
					.getParameter("economica")));
		} else {
			carga.setEconomica(false);
		}

		if (!Checks.esNulo(request.getParameter("letra"))) {
			carga.setLetra(request.getParameter("letra"));
		} else {
			carga.setLetra(null);
		}

		if (!Checks.esNulo(request.getParameter("titular"))) {
			carga.setTitular(request.getParameter("titular"));
		} else {
			carga.setTitular(null);
		}

		if (!Checks.esNulo(request.getParameter("importeRegistral"))) {
			carga.setImporteRegistral(Float.parseFloat(request
					.getParameter("importeRegistral")));
		} else {
			carga.setImporteRegistral(null);
		}

		if (!Checks.esNulo(request.getParameter("importeEconomico"))) {
			carga.setImporteEconomico(Float.parseFloat(request
					.getParameter("importeEconomico")));
		} else {
			carga.setImporteEconomico(null);
		}

		DDSituacionCarga situacionCarga;
		DDSituacionCarga situacionCargaEconomica;

		if (!Checks.esNulo(request.getParameter("situacionCarga")))
			situacionCarga = genericDao.get(DDSituacionCarga.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo",
							request.getParameter("situacionCarga")));
		else {
			situacionCarga = null;
		}
		carga.setSituacionCarga(situacionCarga);

		if (!Checks.esNulo(request.getParameter("situacionCargaEconomica")))
			situacionCargaEconomica = genericDao.get(DDSituacionCarga.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo",
							request.getParameter("situacionCargaEconomica")));
		else {
			situacionCargaEconomica = null;
		}
		carga.setSituacionCargaEconomica(situacionCargaEconomica);

		DDTipoCarga tipoCarga;
		if (!Checks.esNulo(request.getParameter("tipoCarga")))
			tipoCarga = genericDao.get(DDTipoCarga.class, genericDao
					.createFilter(FilterType.EQUALS, "descripcion",
							request.getParameter("tipoCarga")));
		else {
			tipoCarga = null;
		}
		carga.setTipoCarga(tipoCarga);

		Auditoria auditoria = Auditoria.getNewInstance();
		carga.setAuditoria(auditoria);

		proxyFactory.proxy(EditBienApi.class).guardarCarga(carga);

		return DEFAULT;

	}

	/**
	 * Eliminar una carga
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String eliminarCarga(WebRequest request, ModelMap model) {

		proxyFactory.proxy(EditBienApi.class).borrarCarga(
				Long.parseLong(request.getParameter("idCarga")));

		return DEFAULT;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String winAgregarExcluirBien(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "accion", required = true) String accion,
			ModelMap map) {
		map.put("idProcedimiento", idProcedimiento);
		map.put("accion", accion);
		return WIN_AGREGAR_EXCLUIR_BIEN_PRC;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienesPrc(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "accion", required = true) String accion,
			@RequestParam(value = "numFinca", required = false) String numFinca,
			@RequestParam(value = "numActivo", required = false) String numActivo,
			ModelMap map) {
		List<BienProcedimientoDTO> bienes = proxyFactory.proxy(BienApi.class)
				.getBienesPersonasContratos(idProcedimiento, accion, numFinca,
						numActivo);
		map.put("bienes", bienes);
		return BIENES_PRC_JSON;
	}

	@RequestMapping
	public String guardarAgregarExcluirBienPrc(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "idsBien", required = true) String idsBien,
			@RequestParam(value = "codsSolvencia", required = true) String codsSolvencia,
			@RequestParam(value = "accion", required = true) String accion,
			ModelMap map) {

		String[] arrBien = idsBien.split(",");
		if ("AGREGAR".equals(accion)) {
			String[] arrCodSolvencia = codsSolvencia.split(",");
			try{
				proxyFactory.proxy(BienApi.class).agregarBienes(idProcedimiento, arrBien, arrCodSolvencia);
			}
			catch(DataIntegrityViolationException e){
				logger.error(new Date() + "guardarAgregarExcluirBienPrc: " + e);
			}
			catch (Exception e) {
				logger.error(new Date() + "guardarAgregarExcluirBienPrc: " + e);
			}
		} else {
			proxyFactory.proxy(BienApi.class).excluirBienes(idProcedimiento,
					arrBien);
		}

		return DEFAULT;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienesAsunto(
			@RequestParam(value = "idAsunto", required = true) Long idAsunto,
			ModelMap map) {
		List<Bien> bienes = proxyFactory.proxy(BienApi.class).getBienesAsunto(
				idAsunto);
		map.put("bienes", bienes);
		return BIENES_PROCEDIMIENTO_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getBienesTipoProcedimiento(
			@RequestParam(value = "idAsunto", required = true) Long idAsunto,
			@RequestParam(value = "tipoProcedimiento", required = true) String tipoProcedimiento,
			ModelMap map) {
		List<DtoNMBBienAdjudicacion> bienes = proxyFactory.proxy(BienApi.class)
				.getBienesAsuntoTipoPocedimiento(idAsunto, tipoProcedimiento,
						true);
		map.put("bienes", bienes);
		return BIENES_PROCEDIMIENTO_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDiccionario(
			@RequestParam(value = "diccionario", required = true) String diccionario,
			ModelMap map) throws ClassNotFoundException {

		List<?> data = proxyFactory.proxy(UtilDiccionarioApi.class)
				.dameValoresDiccionario(Class.forName(diccionario));
		map.put("data", data);
		return DICCIONARIO_JSON;
	}

	@RequestMapping
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false)
	public String saveAdjudicados(
			@RequestParam(value = "adjudicacion", required = true) String adjudicacion,
			@RequestParam(value = "saneamiento", required = true) String saneamiento,
			@RequestParam(value = "posesion", required = true) String posesion,
			@RequestParam(value = "llaves", required = true) String llaves,
			ModelMap map) {

		ObjectMapper mapper = new ObjectMapper();
		BienesAdjudicaciones bienesAdjudicacionesAdjudicacion = null;
		BienesAdjudicaciones bienesSaneamientosAdjudicacion = null;
		BienesAdjudicaciones bienesAdjudicacionesPosesion = null;
		BienesAdjudicaciones bienesAdjudicacionesLlaves = null;
		try {
			if (!Checks.esNulo(adjudicacion)) {
				bienesAdjudicacionesAdjudicacion = mapper.readValue(
						HtmlUtils.htmlUnescape(adjudicacion),
						BienesAdjudicaciones.class);
			}
			if (!Checks.esNulo(saneamiento)) {
				bienesSaneamientosAdjudicacion = mapper.readValue(
						HtmlUtils.htmlUnescape(saneamiento),
						BienesAdjudicaciones.class);
			}
			if (!Checks.esNulo(posesion)) {
				bienesAdjudicacionesPosesion = mapper.readValue(
						HtmlUtils.htmlUnescape(posesion),
						BienesAdjudicaciones.class);
			}
			if (!Checks.esNulo(llaves)) {
				bienesAdjudicacionesLlaves = mapper.readValue(
						HtmlUtils.htmlUnescape(llaves),
						BienesAdjudicaciones.class);
			}
		} catch (Throwable t) {
			t.printStackTrace();
			return null;
		}
		if (bienesAdjudicacionesAdjudicacion != null) {
			saveAdjudicaciones(bienesAdjudicacionesAdjudicacion);
		}
		if (bienesSaneamientosAdjudicacion != null) {
			saveAdjudicaciones(bienesSaneamientosAdjudicacion);
		}
		if (bienesAdjudicacionesPosesion != null) {
			saveAdjudicaciones(bienesAdjudicacionesPosesion);
		}
		if (bienesAdjudicacionesLlaves != null) {
			saveAdjudicaciones(bienesAdjudicacionesLlaves);
		}

		if (bienesAdjudicacionesAdjudicacion != null) {
			avanzaAdjudicaciones(bienesAdjudicacionesAdjudicacion);
		}
		if (bienesSaneamientosAdjudicacion != null) {
			avanzaSaneamientos(bienesSaneamientosAdjudicacion);
		}
		if (bienesAdjudicacionesPosesion != null) {
			avanzaPosesiones(bienesAdjudicacionesPosesion);
		}
		if (bienesAdjudicacionesLlaves != null) {
			avanzaLlaves(bienesAdjudicacionesLlaves);
		}

		return "default";
	}

	private void avanzaAdjudicaciones(BienesAdjudicaciones bienesAdjudicaciones) {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (BienAdjudicacion bienAdjudicacion : bienesAdjudicaciones
				.getArrayItems()) {
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(bienAdjudicacion.getId()));
			List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
			for (ProcedimientoBien prcBien : procedimientos) {
				Set<TareaNotificacion> tareas = null;
				Iterator<TareaNotificacion> it = null;
				TareaNotificacion tareaNotificacion = null;
				if ("P413".compareTo(prcBien.getProcedimiento()
						.getTipoProcedimiento().getCodigo()) == 0) {
					tareas = prcBien.getProcedimiento().getTareas();
					it = tareas.iterator();
					Long tareaAnterior = null;
					while (it.hasNext()) {
						try {
							tareaNotificacion = it.next();
							if (tareaAnterior != tareaNotificacion.getId()) {
								tareaAnterior = tareaNotificacion.getId();
							} else {
								break;
							}
							if ("P413_SolicitudDecretoAdjudicacion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fechaSolicitud");
								tev.setValor(formatter.format(bien
										.getAdjudicacion()
										.getFechaDecretoNoFirme()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_notificacionDecretoAdjudicacionAEntidad"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fecha");
								tev.setValor(formatter.format(bien
										.getAdjudicacion()
										.getFechaDecretoFirme()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboEntidadAdjudicataria");
								tev.setValor(bien.getAdjudicacion()
										.getEntidadAdjudicataria().getCodigo());
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fondo");
								tev.setValor(bien.getAdjudicacion().getFondo()
										.getCodigo());
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboSubsanacion");
								tev.setValor(bien.getAdjudicacion()
										.getRequiereSubsanacion() != null
										&& bien.getAdjudicacion()
												.getRequiereSubsanacion() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_notificacionDecretoAdjudicacionAlContrario"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fecha");
								tev.setValor(formatter.format(new Date()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboNotificacion");
								tev.setValor(bien.getAdjudicacion()
										.getNotificacionDemandados() != null
										&& bien.getAdjudicacion()
												.getNotificacionDemandados() ? DDSiNo.NO
										: DDSiNo.SI);
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_SolicitudTestimonioDecretoAdjudicacion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fecha");
								tev.setValor(formatter.format(new Date()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_ConfirmarTestimonio"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fecha");
								tev.setValor(formatter.format(new Date()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboNotificacion");
								tev.setValor(bien.getAdjudicacion()
										.getNotificacionDemandados() != null
										&& bien.getAdjudicacion()
												.getNotificacionDemandados() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaTestimonio");

								tev.setValor(formatter.format(new Date()));
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaEnvioGestoria");
								tev.setValor(formatter.format(new Date()));
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_RegistrarEntregaTitulo"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);

								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaEntregaGestor() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaEntregaGestor())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_RegistrarInscripcionDelTitulo"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaInscripcion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaInscripcionTitulo() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaInscripcionTitulo())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaEnvioDecretoAdicion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaEnvioAdicion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaEnvioAdicion()) : null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboSituacionTitulo");
								tev.setValor(bien.getAdjudicacion()
										.getSituacionTitulo().getCodigo());
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_RegistrarPresentacionEnHacienda"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaPresentacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaPresentacionHacienda() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaPresentacionHacienda())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);

							} else if ("P413_RegistrarPresentacionEnRegistro"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// titulo,fecha,observaciones,comboEntidadAdjudicataria,fondo,comboSubsanacion
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaPresentacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaPresentacionRegistro() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaPresentacionRegistro())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}

						} catch (Exception e) {
							e.printStackTrace();
						}
						/*
						 * Filter f1 =
						 * genericDao.createFilter(FilterType.EQUALS,
						 * "procedimiento.id",
						 * prcBien.getProcedimiento().getId()); Filter f2 =
						 * genericDao.createFilter(FilterType.EQUALS,
						 * "auditoria.borrado", false); List<TareaNotificacion>
						 * tareasNotificacion = (List<TareaNotificacion>)
						 * genericDao.getList(TareaNotificacion.class, f1, f2);
						 * if(tareasNotificacion != null){ it =
						 * tareasNotificacion.iterator(); }
						 */
					}
				}
			}
		}
	}

	private void avanzaSaneamientos(BienesAdjudicaciones bienesSaneamientos) {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (BienAdjudicacion bienAdjudicacion : bienesSaneamientos
				.getArrayItems()) {
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(bienAdjudicacion.getId()));
			List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
			for (ProcedimientoBien prcBien : procedimientos) {
				if ("P415".compareTo(prcBien.getProcedimiento()
						.getTipoProcedimiento().getCodigo()) == 0) {
					Set<TareaNotificacion> tareas = prcBien.getProcedimiento()
							.getTareas();
					Iterator<TareaNotificacion> it = tareas.iterator();
					TareaNotificacion tareaNotificacion = null;
					Long tareaAnterior = null;
					while (it.hasNext()) {
						try {
							tareaNotificacion = it.next();
							if (tareaAnterior != tareaNotificacion.getId()) {
								tareaAnterior = tareaNotificacion.getId();
							} else {
								break;
							}
							if ("P415_LiquidarCargas"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaLiquidacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaLiquidacion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaLiquidacion()) : null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaRecepcion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRecepcion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaRecepcion()) : null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaCancelacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaCancelacion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaCancelacion()) : null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RegInsCancelacionCargasEconomicas"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaInsEco");
								tev.setValor(bien.getAdjudicacion()
										.getFechaCancelacionEco() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaCancelacionEco())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RegInsCancelacionCargasReg"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaInscripcion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaCancelacionReg() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaCancelacionReg())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RegInsCancelacionCargasRegEco"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaInsReg");
								tev.setValor(bien.getAdjudicacion()
										.getFechaCancelacionRegEco() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaCancelacionRegEco())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RegistrarPresentacionInscripcion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaPresentacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaPresentacionIns() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaPresentacionIns())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RegistrarPresentacionInscripcionEco"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaPresentacion");
								tev.setValor(bien.getAdjudicacion()
										.getFechaPresentacionInsEco() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaPresentacionInsEco())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RevisarEstadoCargas"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaCargas");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRevisarCargas() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaRevisarCargas())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_PropuestaCancelacionCargas"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaPropuesta");
								tev.setValor(bien.getAdjudicacion()
										.getFechaPropuestaCancelacion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaPropuestaCancelacion())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
							if ("P415_RevisarPropuestaCancelacionCargas"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaRevisar");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRevisarPropuestaCancelacion() != null ? formatter
										.format(bien
												.getAdjudicacion()
												.getFechaRevisarPropuestaCancelacion())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								avanzaTarea(tareaExterna);
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

	private void avanzaTarea(TareaExterna tareaExterna) {
		// Actualizamos los valores
		final Long idToken = tareaExterna.getTokenIdBpm();
		// Activamos y avanzamos la tarea
		new Thread() {
			public void run() {
				try {
					executor.execute(
							ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
							idToken, "avanzaBPM");
				} catch (Exception e) {
					// e.printStackTrace();
				}
			}
		}.start();
	}

	private void avanzaLlaves(BienesAdjudicaciones bienesLlaves) {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (BienAdjudicacion bienAdjudicacion : bienesLlaves.getArrayItems()) {
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(bienAdjudicacion.getId()));
			List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
			for (ProcedimientoBien prcBien : procedimientos) {
				if ("P417".compareTo(prcBien.getProcedimiento()
						.getTipoProcedimiento().getCodigo()) == 0) {
					Set<TareaNotificacion> tareas = prcBien.getProcedimiento()
							.getTareas();
					Iterator<TareaNotificacion> it = tareas.iterator();
					TareaNotificacion tareaNotificacion = null;
					Long tareaAnterior = null;
					while (it.hasNext()) {
						try {
							tareaNotificacion = it.next();
							if (tareaAnterior != tareaNotificacion.getId()) {
								tareaAnterior = tareaNotificacion.getId();
							} else {
								break;
							}
							// P417_RegistrarCambioCerradura: titulo(label),
							// fecha(date), observaciones(textarea)
							if ("P417_RegistrarCambioCerradura"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaCambioCerradura() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaCambioCerradura())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P417_RegistrarEnvioLlaves: titulo(label),
							// nombre(text), fecha(date),
							// observaciones(textarea)
							if ("P417_RegistrarEnvioLlaves"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaEnvioLLaves() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaEnvioLLaves()) : null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Especifico para la tarea
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("nombre");
								tev.setValor(bien.getAdjudicacion()
										.getNombreDepositario());
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P417_RegistrarRecepcionLlaves: titulo(label),
							// fecha(date), observaciones(textarea)
							if ("P417_RegistrarRecepcionLlaves"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRecepcionDepositario() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaRecepcionDepositario())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P417_RegistrarEnvioLlavesDepFinal: titulo(label),
							// nombre(text), fecha(date),
							// observaciones(textarea)
							if ("P417_RegistrarEnvioLlavesDepFinal"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaEnvioDepositario() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaEnvioDepositario())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Especifico para la tarea
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("nombre");
								tev.setValor(bien.getAdjudicacion()
										.getNombreDepositarioFinal());
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P417_RegistrarEnvioLlavesDepFinal: titulo(label),
							// fecha(date), observaciones(textarea)
							if ("P417_RegistrarRecepcionLlavesDepFinal"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRecepcionDepositarioFinal() != null ? formatter
										.format(bien
												.getAdjudicacion()
												.getFechaRecepcionDepositarioFinal())
										: null);
								genericDao.save(TareaExternaValor.class, tev);
								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

	private void avanzaPosesiones(BienesAdjudicaciones bienesPosesiones) {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (BienAdjudicacion bienAdjudicacion : bienesPosesiones
				.getArrayItems()) {
			NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
					Long.parseLong(bienAdjudicacion.getId()));
			List<ProcedimientoBien> procedimientos = bien.getProcedimientos();
			for (ProcedimientoBien prcBien : procedimientos) {
				if ("P416".compareTo(prcBien.getProcedimiento()
						.getTipoProcedimiento().getCodigo()) == 0) {
					Set<TareaNotificacion> tareas = prcBien.getProcedimiento()
							.getTareas();
					Iterator<TareaNotificacion> it = tareas.iterator();
					TareaNotificacion tareaNotificacion = null;
					Long tareaAnterior = null;
					while (it.hasNext()) {
						try {
							tareaNotificacion = it.next();
							if (tareaAnterior != tareaNotificacion.getId()) {
								tareaAnterior = tareaNotificacion.getId();
							} else {
								break;
							}
							if ("P416_RegistrarSolicitudPosesion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboPosesion");
								tev.setValor(bien.getAdjudicacion()
										.getPosiblePosesion() != null
										&& bien.getAdjudicacion()
												.getPosiblePosesion() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaSolicitud");
								tev.setValor(bien.getAdjudicacion()
										.getFechaSolicitudPosesion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaSolicitudPosesion())
										: null);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboOcupado");
								tev.setValor(bien.getAdjudicacion()
										.getOcupado() != null
										&& bien.getAdjudicacion().getOcupado() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboMoratoria");
								tev.setValor(bien.getAdjudicacion()
										.getResolucionMoratoria().getCodigo());
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboViviendaHab");
								tev.setValor(bien.getViviendaHabitual());
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P416_RegistrarSenyalamientoPosesion:
							// titulo(label), fechaSenyalamiento(date),
							// observaciones(textarea)
							if ("P416_RegistrarSenyalamientoPosesion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fechaSenyalamiento");
								tev.setValor(bien.getAdjudicacion()
										.getFechaSenalamientoPosesion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaSenalamientoPosesion())
										: null);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P416_RegistrarPosesionYLanzamiento:
							// titulo(label), comboOcupado(combo), fecha(date),
							// comboFuerzaPublica(combo),
							// comboLanzamiento(combo), observaciones(textarea)
							if ("P416_RegistrarSolicitudPosesion"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboOcupado");
								tev.setValor(bien.getAdjudicacion()
										.getOcupado() != null
										&& bien.getAdjudicacion().getOcupado() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaRealizacionPosesion() != null ? formatter
										.format(bien.getAdjudicacion()
												.getFechaRealizacionPosesion())
										: null);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboFuerzaPublica");
								tev.setValor(bien.getAdjudicacion()
										.getNecesariaFuerzaPublica() != null
										&& bien.getAdjudicacion()
												.getNecesariaFuerzaPublica() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboLanzamiento");
								tev.setValor(bien.getAdjudicacion()
										.getLanzamientoNecesario() != null
										&& bien.getAdjudicacion()
												.getLanzamientoNecesario() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P416_RegistrarSenyalamientoLanzamiento:
							// titulo(label), fecha(date),
							// observaciones(textarea)
							if ("P416_RegistrarSenyalamientoLanzamiento"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaSenalamientoLanzamiento() != null ? formatter
										.format(bien
												.getAdjudicacion()
												.getFechaSenalamientoLanzamiento())
										: null);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P416_RegistrarLanzamientoEfectuado:
							// titulo(label), fecha(date),
							// comboFuerzaPublica(combo),
							// observaciones(textarea)
							if ("P416_RegistrarLanzamientoEfectuado"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("fecha");
								tev.setValor(bien.getAdjudicacion()
										.getFechaSenalamientoLanzamiento() != null ? formatter
										.format(bien
												.getAdjudicacion()
												.getFechaSenalamientoLanzamiento())
										: null);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboFuerzaPublica");
								tev.setValor(bien.getAdjudicacion()
										.getNecesariaFuerzaPublica() != null
										&& bien.getAdjudicacion()
												.getNecesariaFuerzaPublica() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

							// P416_RegistrarDecisionLlaves: titulo(label),
							// comboLlaves(combo), observaciones(textarea)
							if ("P416_RegistrarDecisionLlaves"
									.compareTo(tareaNotificacion
											.getTareaExterna()
											.getTareaProcedimiento()
											.getCodigo()) == 0) {
								// Comun a todas las tareas
								// titulo,fecha,observaciones
								TareaExterna tareaExterna = tareaNotificacion
										.getTareaExterna();
								TareaExternaValor tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("titulo");
								tev.setValor("titulo");
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("comboLlaves");
								tev.setValor(bien.getAdjudicacion()
										.getLlavesNecesarias() != null
										&& bien.getAdjudicacion()
												.getLlavesNecesarias() ? DDSiNo.SI
										: DDSiNo.NO);
								genericDao.save(TareaExternaValor.class, tev);

								tev = new TareaExternaValor();
								tev.setTareaExterna(tareaExterna);
								tev.setNombre("observaciones");
								tev.setValor(".");
								genericDao.save(TareaExternaValor.class, tev);

								// Actualizamos los valores
								Long idToken = tareaExterna.getTokenIdBpm();
								// Activamos y avanzamos la tarea
								executor.execute(
										ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_TOKEN,
										idToken, "avanzaBPM");

							}

						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

	private void saveAdjudicaciones(BienesAdjudicaciones bienesAdjudicaciones) {
		NMBAdjudicacionBien adjudicacion = new NMBAdjudicacionBien();
		NMBBien bien = null;
		SimpleDateFormat formatText = new SimpleDateFormat("dd/MM/yyyy");
		// 1901-05-23T00:00:00
		for (BienAdjudicacion bienAdjudicacion : bienesAdjudicaciones
				.getArrayItems()) {
			if (!Checks.esNulo(bienAdjudicacion.getId())) {
				bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(
						Long.parseLong(bienAdjudicacion.getId()));
				if (bien.getAdjudicacion() != null) {
					adjudicacion = bien.getAdjudicacion();
					Auditoria auditoria = adjudicacion.getAuditoria();
					auditoria.setFechaModificar(new Date());
					adjudicacion.setAuditoria(auditoria);
				} else {
					Auditoria auditoria = Auditoria.getNewInstance();
					adjudicacion.setAuditoria(auditoria);
				}
			} else {
				adjudicacion.setBien(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getIdAdjudicacion())) {
				adjudicacion.setIdAdjudicacion(Long.parseLong(bienAdjudicacion
						.getIdAdjudicacion()));
			} else {
				// adjudicacion.setIdAdjudicacion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaDecretoNoFirme())) {
				try {
					adjudicacion.setFechaDecretoNoFirme(formatText
							.parse(bienAdjudicacion.getFechaDecretoNoFirme()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaDecretoNoFirme(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaDecretoFirme())) {
				try {
					adjudicacion.setFechaDecretoFirme(formatText
							.parse(bienAdjudicacion.getFechaDecretoFirme()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaDecretoFirme(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaEntregaGestor())) {
				try {
					adjudicacion.setFechaEntregaGestor(formatText
							.parse(bienAdjudicacion.getFechaEntregaGestor()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaEntregaGestor(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaPresentacionHacienda())) {
				try {
					adjudicacion.setFechaPresentacionHacienda(formatText
							.parse(bienAdjudicacion
									.getFechaPresentacionHacienda()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaSegundaPresentacion())) {
				try {
					adjudicacion.setFechaSegundaPresentacion(formatText
							.parse(bienAdjudicacion
									.getFechaSegundaPresentacion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSegundaPresentacion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaRecepcionTitulo())) {
				try {
					adjudicacion.setFechaRecepcionTitulo(formatText
							.parse(bienAdjudicacion.getFechaRecepcionTitulo()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaRecepcionTitulo(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaInscripcionTitulo())) {
				try {
					adjudicacion
							.setFechaInscripcionTitulo(formatText
									.parse(bienAdjudicacion
											.getFechaInscripcionTitulo()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaInscripcionTitulo(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaEnvioAdicion())) {
				try {
					adjudicacion.setFechaEnvioAdicion(formatText
							.parse(bienAdjudicacion.getFechaEnvioAdicion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaEnvioAdicion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaPresentacionRegistro())) {
				try {
					adjudicacion.setFechaPresentacionRegistro(formatText
							.parse(bienAdjudicacion
									.getFechaPresentacionRegistro()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionRegistro(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaSolicitudPosesion())) {
				try {
					adjudicacion
							.setFechaSolicitudPosesion(formatText
									.parse(bienAdjudicacion
											.getFechaSolicitudPosesion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSolicitudPosesion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaSenalamientoPosesion())) {
				try {
					adjudicacion.setFechaSenalamientoPosesion(formatText
							.parse(bienAdjudicacion
									.getFechaSenalamientoPosesion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSenalamientoPosesion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaRealizacionPosesion())) {
				try {
					adjudicacion.setFechaRealizacionPosesion(formatText
							.parse(bienAdjudicacion
									.getFechaRealizacionPosesion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaRealizacionPosesion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaSolicitudLanzamiento())) {
				try {
					adjudicacion.setFechaSolicitudLanzamiento(formatText
							.parse(bienAdjudicacion
									.getFechaSolicitudLanzamiento()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSolicitudLanzamiento(null);
			}

			if (!Checks.esNulo(bienAdjudicacion
					.getFechaSenalamientoLanzamiento())) {
				try {
					adjudicacion.setFechaSenalamientoLanzamiento(formatText
							.parse(bienAdjudicacion
									.getFechaSenalamientoLanzamiento()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSenalamientoLanzamiento(null);
			}

			if (!Checks.esNulo(bienAdjudicacion
					.getFechaRealizacionLanzamiento())) {
				try {
					adjudicacion.setFechaRealizacionLanzamiento(formatText
							.parse(bienAdjudicacion
									.getFechaRealizacionLanzamiento()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaRealizacionLanzamiento(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaSolicitudMoratoria())) {
				try {
					adjudicacion.setFechaSolicitudMoratoria(formatText
							.parse(bienAdjudicacion
									.getFechaSolicitudMoratoria()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaSolicitudMoratoria(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaResolucionMoratoria())) {
				try {
					adjudicacion.setFechaResolucionMoratoria(formatText
							.parse(bienAdjudicacion
									.getFechaResolucionMoratoria()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaResolucionMoratoria(null);
			}

			if (!Checks
					.esNulo(bienAdjudicacion.getFechaContratoArrendamiento())) {
				try {
					adjudicacion.setFechaContratoArrendamiento(formatText
							.parse(bienAdjudicacion
									.getFechaContratoArrendamiento()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaContratoArrendamiento(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaCambioCerradura())) {
				try {
					adjudicacion.setFechaCambioCerradura(formatText
							.parse(bienAdjudicacion.getFechaCambioCerradura()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaCambioCerradura(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaEnvioLLaves())) {
				try {
					adjudicacion.setFechaEnvioLLaves(formatText
							.parse(bienAdjudicacion.getFechaEnvioLLaves()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaEnvioLLaves(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaRecepcionDepositario())) {
				try {
					adjudicacion.setFechaRecepcionDepositario(formatText
							.parse(bienAdjudicacion
									.getFechaRecepcionDepositario()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaRecepcionDepositario(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaEnvioDepositario())) {
				try {
					adjudicacion
							.setFechaEnvioDepositario(formatText
									.parse(bienAdjudicacion
											.getFechaEnvioDepositario()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaEnvioDepositario(null);
			}

			if (!Checks.esNulo(bienAdjudicacion
					.getFechaRecepcionDepositarioFinal())) {
				try {
					adjudicacion.setFechaRecepcionDepositarioFinal(formatText
							.parse(bienAdjudicacion
									.getFechaRecepcionDepositarioFinal()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaRecepcionDepositarioFinal(null);
			}

			if (!Checks.esNulo(bienAdjudicacion
					.getFechaRevisarPropuestaCancelacion())) {
				try {
					adjudicacion.setFechaRevisarPropuestaCancelacion(formatText
							.parse(bienAdjudicacion
									.getFechaRevisarPropuestaCancelacion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaPropuestaCancelacion())) {
				try {
					adjudicacion.setFechaPropuestaCancelacion(formatText
							.parse(bienAdjudicacion
									.getFechaPropuestaCancelacion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaRevisarCargas())) {
				try {
					adjudicacion.setFechaRevisarCargas(formatText
							.parse(bienAdjudicacion.getFechaRevisarCargas()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaPresentacionInsEco())) {
				try {
					adjudicacion.setFechaPresentacionInsEco(formatText
							.parse(bienAdjudicacion
									.getFechaPresentacionInsEco()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaPresentacionIns())) {
				try {
					adjudicacion.setFechaPresentacionIns(formatText
							.parse(bienAdjudicacion.getFechaPresentacionIns()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaCancelacionRegEco())) {
				try {
					adjudicacion
							.setFechaCancelacionRegEco(formatText
									.parse(bienAdjudicacion
											.getFechaCancelacionRegEco()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaCancelacionReg())) {
				try {
					adjudicacion.setFechaCancelacionReg(formatText
							.parse(bienAdjudicacion.getFechaCancelacionReg()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaCancelacionEco())) {
				try {
					adjudicacion.setFechaCancelacionEco(formatText
							.parse(bienAdjudicacion.getFechaCancelacionEco()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaLiquidacion())) {
				try {
					adjudicacion.setFechaLiquidacion(formatText
							.parse(bienAdjudicacion.getFechaLiquidacion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaRecepcion())) {
				try {
					adjudicacion.setFechaRecepcion(formatText
							.parse(bienAdjudicacion.getFechaRecepcion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFechaCancelacion())) {
				try {
					adjudicacion.setFechaCancelacion(formatText
							.parse(bienAdjudicacion.getFechaCancelacion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFechaPresentacionHacienda(null);
			}

			// booleanos

			if (!Checks.esNulo(bienAdjudicacion.getRequiereSubsanacion())) {
				adjudicacion
						.setRequiereSubsanacion(Boolean
								.parseBoolean(bienAdjudicacion
										.getRequiereSubsanacion())
								|| DDSiNo.SI.compareTo(bienAdjudicacion
										.getRequiereSubsanacion()) == 0);
			} else {
				// adjudicacion.setOcupado(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getNotificacion())) {
				adjudicacion.setNotificacionDemandados(Boolean
						.parseBoolean(bienAdjudicacion.getNotificacion())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getNotificacion()) == 0);
			} else {
				// adjudicacion.setOcupado(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getOcupado())) {
				adjudicacion
						.setOcupado(Boolean.parseBoolean(bienAdjudicacion
								.getOcupado())
								|| DDSiNo.SI.compareTo(bienAdjudicacion
										.getOcupado()) == 0);
			} else {
				// adjudicacion.setOcupado(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getPosiblePosesion())) {
				adjudicacion.setPosiblePosesion(Boolean
						.parseBoolean(bienAdjudicacion.getPosiblePosesion())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getPosiblePosesion()) == 0);
			} else {
				// adjudicacion.setPosiblePosesion(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getOcupantesDiligencia())) {
				adjudicacion
						.setOcupantesDiligencia(Boolean
								.parseBoolean(bienAdjudicacion
										.getOcupantesDiligencia())
								|| DDSiNo.SI.compareTo(bienAdjudicacion
										.getOcupantesDiligencia()) == 0);
			} else {
				// adjudicacion.setOcupantesDiligencia(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getLanzamientoNecesario())) {
				adjudicacion.setLanzamientoNecesario(Boolean
						.parseBoolean(bienAdjudicacion
								.getLanzamientoNecesario())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getLanzamientoNecesario()) == 0);
			} else {
				// adjudicacion.setLanzamientoNecesario(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getEntregaVoluntaria())) {
				adjudicacion.setEntregaVoluntaria(Boolean
						.parseBoolean(bienAdjudicacion.getEntregaVoluntaria())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getEntregaVoluntaria()) == 0);
			} else {
				// adjudicacion.setEntregaVoluntaria(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getNecesariaFuerzaPublica())) {
				adjudicacion.setNecesariaFuerzaPublica(Boolean
						.parseBoolean(bienAdjudicacion
								.getNecesariaFuerzaPublica())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getNecesariaFuerzaPublica()) == 0);
			} else {
				// adjudicacion.setNecesariaFuerzaPublica(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getExisteInquilino())) {
				adjudicacion.setExisteInquilino(Boolean
						.parseBoolean(bienAdjudicacion.getExisteInquilino())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getExisteInquilino()) == 0);
			} else {
				// adjudicacion.setExisteInquilino(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getLlavesNecesarias())) {
				adjudicacion.setLlavesNecesarias(Boolean
						.parseBoolean(bienAdjudicacion.getLlavesNecesarias())
						|| DDSiNo.SI.compareTo(bienAdjudicacion
								.getLlavesNecesarias()) == 0);
			} else {
				// adjudicacion.setLlavesNecesarias(null);
			}

			// selector persona
			if (!Checks.esNulo(bienAdjudicacion.getGestoriaAdjudicataria())) {
				Usuario gestor = proxyFactory.proxy(UsuarioApi.class).get(
						Long.parseLong(bienAdjudicacion
								.getGestoriaAdjudicataria()));
				adjudicacion.setGestoriaAdjudicataria(gestor);
			} else {
				// adjudicacion.setGestoriaAdjudicataria(null);
			}

			// textos

			if (!Checks.esNulo(bienAdjudicacion.getNombreArrendatario())) {
				adjudicacion.setNombreArrendatario(bienAdjudicacion
						.getNombreArrendatario());
			} else {
				// adjudicacion.setNombreArrendatario(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getNombreDepositario())) {
				adjudicacion.setNombreDepositario(bienAdjudicacion
						.getNombreDepositario());
			} else {
				// adjudicacion.setNombreDepositario(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getNombreDepositarioFinal())) {
				adjudicacion.setNombreDepositarioFinal(bienAdjudicacion
						.getNombreDepositarioFinal());
			} else {
				// adjudicacion.setNombreDepositarioFinal(null);
			}

			// DICCIONARIOS

			if (!Checks.esNulo(bienAdjudicacion.getEntidadAdjudicataria())) {
				try {
					DDEntidadAdjudicataria entidadAdjudicataria = (DDEntidadAdjudicataria) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByDes(
									DDEntidadAdjudicataria.class,
									bienAdjudicacion.getEntidadAdjudicataria());
					adjudicacion.setEntidadAdjudicataria(entidadAdjudicataria);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setEntidadAdjudicataria(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getFondo())) {
				try {
					DDTipoFondo fondo = (DDTipoFondo) proxyFactory.proxy(
							UtilDiccionarioApi.class)
							.dameValorDiccionarioByDes(DDTipoFondo.class,
									bienAdjudicacion.getFondo());
					adjudicacion.setFondo(fondo);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setFondo(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getSituacionTitulo())) {
				try {
					DDSituacionTitulo situacionTitulo = (DDSituacionTitulo) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByDes(DDSituacionTitulo.class,
									bienAdjudicacion.getSituacionTitulo());
					adjudicacion.setSituacionTitulo(situacionTitulo);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setSituacionTitulo(null);
			}

			if (!Checks.esNulo(bienAdjudicacion.getResolucionMoratoria())) {
				try {
					DDFavorable resolucionMoratoria = (DDFavorable) proxyFactory
							.proxy(UtilDiccionarioApi.class)
							.dameValorDiccionarioByDes(DDFavorable.class,
									bienAdjudicacion.getResolucionMoratoria());
					adjudicacion.setResolucionMoratoria(resolucionMoratoria);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				// adjudicacion.setResolucionMoratoria(null);
			}
			
			

			// BIEN
			if (!Checks.esNulo(bienAdjudicacion.getHabitual())) {
				bien.setViviendaHabitual(bienAdjudicacion.getHabitual());
			} else {
				// adjudicacion.setOcupado(null);
			}

			bien.setAdjudicacion(adjudicacion);
			adjudicacion.setBien(bien);

			proxyFactory.proxy(EditBienApi.class).guardarAdjudicacion(
					adjudicacion);

		}
	}

	/**
	 * Controlador que devuelve un JSON con la lista de usuarios para un
	 * despacho de adjudicacion.
	 * 
	 * @param model
	 * @return JSON
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUsuariosData(ModelMap model) {

		List<Usuario> listadoUsuarios = getGestoresAdjudicaciones();
		model.put("listadoUsuarios", listadoUsuarios);

		return TIPO_USUARIO_JSON;
	}

	private List<Usuario> getGestoresAdjudicaciones() {
		List<Usuario> listadoUsuarios = getGestoresAdjudicadicatarios();
		return listadoUsuarios;
	}

	private List<Usuario> getGestoresAdjudicadicatarios() {
		Long idTipoGestor = null;

		// Tipo de usuario Gestor
		List<EXTDDTipoGestor> listadoGestores = proxyFactory.proxy(
				coreextensionApi.class).getListTipoGestorAdicional();
		for (EXTDDTipoGestor tipoGestor : listadoGestores) {
			if ("GEST".compareTo(tipoGestor.getCodigo()) == 0) {
				idTipoGestor = tipoGestor.getId();
			}
		}

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);
		Filter filtroDefecto = genericDao.createFilter(FilterType.EQUALS,
				"gestorPorDefecto", true);

		// Se qeuda con el usuario por defecto para cada despacho.
		List<Usuario> listadoUsuarios = new ArrayList<Usuario>();
		if (idTipoGestor != null) {
			List<DespachoExterno> listadoDespachos = proxyFactory.proxy(
					coreextensionApi.class).getListDespachos(idTipoGestor);
			for (DespachoExterno tipoDespacho : listadoDespachos) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS,
						"despachoExterno.id", tipoDespacho.getId());
				List<GestorDespacho> listaGestorDespacho = genericDao.getList(
						GestorDespacho.class, filtro, filtroDefecto,
						filtroBorrado);
				for (GestorDespacho gestorDespacho : listaGestorDespacho) {
					listadoUsuarios.add(gestorDespacho.getUsuario());
				}
			}
		}

		return listadoUsuarios;
	}

	/**
	 * Inoca al servicio de tasación para recuperar un número de Activo.
	 * 
	 * @param idBien
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarNumActivo(WebRequest request,
			@RequestParam("id") Long idBien, ModelMap model) {
		// executor.execute(SubastasServicioTasacionDelegateApi.BO_UVEM_SOLICITUD_NUMERO_ACTIVO,
		// idBien);
		// proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class).solicitarNumeroActivo(idBien);
		String respuesta = proxyFactory.proxy(
				SubastasServicioTasacionDelegateApi.class)
				.solicitarNumeroActivoConRespuesta(idBien);
		model.put("msgError", respuesta);
		return JSON_RESPUESTA_SERVICIO;
	}

	/**
	 * Recupera los n�meros de activos de los bienes.
	 * 
	 * @param idBien
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarNumsActivosBienes(WebRequest request, @RequestParam(value = "idBien", required = false) String idsBien, ModelMap model) {
		String[] arrBien = null;
		try {
			arrBien = idsBien.split(",");
		} catch (Exception e) {
			e.printStackTrace();
		}

		Map<String, String> mapResults = proxyFactory.proxy(BienApi.class).getNumerosActivosBienes(arrBien);

		String respuesta = fomatearRespuestaSolicitarNumsActivosBienes(mapResults);
		
		model.put("msgError", respuesta);
		return JSON_RESPUESTA_SERVICIO;
	}

	private String fomatearRespuestaSolicitarNumsActivosBienes(final Map<String, String> mapResults) {
		if (mapResults.isEmpty()) {
			return "1";
		}
		
		final String errValidacion = "ERROR_VALIDACION";
		final StringBuilder sbErrorValidacion = new StringBuilder();
		final StringBuilder sbErrorSolicitud = new StringBuilder();
		for (Entry<String, String> result : mapResults.entrySet()) {
			if (errValidacion.equals(result.getValue())) {
				sbErrorValidacion.append(result.getKey());
				sbErrorValidacion.append(",");
			} else {
				sbErrorSolicitud.append(result.getKey());
				sbErrorSolicitud.append(",");
			}
		}
		
		final StringBuilder sbRespuesta = new StringBuilder();
		if(sbErrorValidacion.length() > 0){
			sbRespuesta.append("Los campos tipo de inmueble, provincia, localidad, n\u00FAmero de finca y n\u00FAmero de registro son obligatorios para solicitar el n\u00FAmero de activo de los siguientes bienes: ");
			sbErrorValidacion.setLength(sbErrorValidacion.length() -1);
			sbErrorValidacion.append(". \n");
			sbRespuesta.append(sbErrorValidacion);
		}			
		
		if(sbErrorSolicitud.length() > 0){
			sbRespuesta.append("No se pudo obtener el n\u00FAmero de activo de los siguientes bienes: ");
			sbErrorSolicitud.setLength(sbErrorSolicitud.length() -1);
			sbErrorSolicitud.append(". \n");
			sbRespuesta.append(sbErrorSolicitud);			
		}

		return sbRespuesta.toString();
	}

	/**
	 * Inoca al servicio de tasación para recuperar un número de Activo.
	 * 
	 * @param idBien
	 */
	@RequestMapping
	public String solicitarTasacion(@RequestParam("id") Long idBien) {
		// executor.execute(SubastasServicioTasacionDelegateApi.BO_UVEM_SOLICITUD_TASACION,
		// idBien);
		proxyFactory.proxy(SubastasServicioTasacionDelegateApi.class)
				.solicitarTasacion(idBien);
		return "default";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListLocalidades(ModelMap model, String codProvincia) {
		List<Localidad> list = proxyFactory.proxy(BienApi.class)
				.getListLocalidades(codProvincia);
		
		Collections.sort(list, DictionaryComparatorFactory.getInstance().create(DictionaryComparatorFactory.COMPARATOR_BY_DESCRIPCION));
		
		model.put("listLocalidades", list);
		return JSON_LIST_LOCALIDADES;
	}
		

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListUnidadesPoblacionales(ModelMap model, String codLocalidad) {
		List<DDUnidadPoblacional> list = proxyFactory.proxy(BienApi.class)
				.getListUnidadesPoblacionales(codLocalidad);
		model.put("listUnidadesPoblacionales", list);
		return JSON_LIST_UNIDADES_POBLACIONALES;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListPaises(ModelMap model) {
		List<DDCicCodigoIsoCirbeBKP> list = proxyFactory.proxy(BienApi.class)
				.getListPaises();
		model.put("data", list);
		return DICCIONARIO_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTiposVia(ModelMap model){
		List<DDTipoVia> list = proxyFactory.proxy(BienApi.class).getListTiposVia();
		model.put("data", list);
		return DICCIONARIO_JSON;
	}
	
	/**
	 * Comprueba si algunos de los bienes pasados por parámetro está incluido en un lote de la subasta asociado al procedimiento
	 * 
	 * @param idProcedimiento
	 * @param idsBien
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isBienAsociadoSubasta(
			@RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
			@RequestParam(value = "idsBien", required = true) String idsBien,
			ModelMap model) throws Exception 
	{
		try {
			String resultado = "OK";
			String[] arrBien = idsBien.split(",");
			Procedimiento procedimiento = proxyFactory.proxy(es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi.class).getProcedimiento(idProcedimiento);
			
			// Se recuperan los bienes asociados a la subasta del procedimiento y se comprueba si alguno de los que se quiere excluir está entre ellos
			Subasta subasta = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(procedimiento.getId());
			
			if(!Checks.esNulo(subasta)) {
				for(LoteSubasta loteSubasta : subasta.getLotesSubasta()) {
					for(Bien bien : loteSubasta.getBienes()) {
						if(ArrayUtils.contains(arrBien, bien.getId().toString())) {
							resultado = "KO";
						}
					}			
				}
			}
			
			model.put("okko", resultado);
	
			return OK_KO_RESPUESTA_JSON;
		}
		catch(Exception e) {
			logger.error("isBienAsociadoSubasta: " + e);
			throw e;
		}
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String isFondoTitulizado(String codigoFondo, ModelMap model) {

		if(!Checks.esNulo(codigoFondo)){
			DDTipoFondo fondo = genericDao.get(DDTipoFondo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoFondo), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	
			if (!Checks.esNulo(fondo.getCesionRemate()) && fondo.getCesionRemate()){
				model.put("okko","OK");
			}else{
				model.put("okko","KO");
			}
		}
		else{
			model.put("okko","OK");
		}
		
		return OK_KO_RESPUESTA_JSON;
	}
}
