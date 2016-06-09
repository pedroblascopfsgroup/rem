package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AcuerdoConfigAsuntoUsers;
import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDCondicionesRemuneracion;
import es.capgemini.pfs.contrato.model.DDSituacionGestion;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.termino.TerminoOperacionesManager;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.dto.TerminoAcuerdoDto;
import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;
import es.capgemini.pfs.termino.model.DDEstadoGestionTermino;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.termino.model.ValoresCamposTermino;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.ACDAcuerdoDerivaciones;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

@Controller
public class MEJAcuerdoController {
	
	static final String BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO = "acuerdoManager.rechazarAcuerdoMotivo";
	static final String JSON_LISTADO_CONTRATOS = "plugin/mejoras/acuerdos/listadoContratosAsuntoJSON";
	static final String JSON_LISTADO_TERMINOS = "plugin/mejoras/acuerdos/listadoTerminosAcuerdoJSON";	
	static final String JSP_ALTA_TERMINO_ACUERDO = "plugin/mejoras/acuerdos/altaTermino";
	static final String JSON_LIST_TIPO_ACUERDO  ="plugin/mejoras/acuerdos/tipoAcuerdoJSON";
	static final String JSON_LIST_SUB_TIPOS_ACUERDO  ="plugin/mejoras/acuerdos/subtiposAcuerdoJSON";
	static final String JSON_LIST_TIPO_PRODUCTO  ="plugin/mejoras/acuerdos/tipoProductoJSON";	
	static final String JSON_LISTADO_BIENES_ACUERDO = "plugin/mejoras/acuerdos/listadoBienesAcuerdoJSON";	
	static final String JSON_LIST_CAMPOS_DINAMICOS_TERMINOS_POR_TIPO_ACUERDO  ="plugin/mejoras/acuerdos/camposTerminosPorTipoAcuerdoJSON";
	static final String JSON_CONFIG_USERS_ACUERDO_ASUNTOS = "plugin/mejoras/acuerdos/configUsersAcuerdoAsuntoJSON";
	static final String JSP_FINALIZACION_ACUERDO = "plugin/mejoras/acuerdos/finalizacionAcuerdo";
	static final String JSON_LISTADO_DERIVACIONES = "plugin/mejoras/acuerdos/listadoDerivacionesAcuerdoJSON";	
	static final String JSP_EDITAR_TERMINO_ESTADO_GESTION = "plugin/mejoras/acuerdos/edicionEstadoGestionTermino";
	static final String JSP_RECHAZAR_ACUERDO = "plugin/mejoras/acuerdos/rechazarAcuerdo";
	static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	static final String JSON_LIST_DD_CONDICIONES_REMUNERACION ="plugin/mejoras/acuerdos/condicionesRemuneracionJSON";
	static final String JSON_LIST_DD_SITUACION_GESTION ="plugin/mejoras/acuerdos/situacionGestionJSON";
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioManager;

	@Autowired TerminoOperacionesManager terminoOperacionesManager;
	
	@Autowired MEJAcuerdoApi mejAcuerdoApi;
	
	@Autowired private UsuarioManager usuarioManager;
	
    /**
     * Pasa un acuerdo a estado Rechazado con motivo.
     * @param idAcuerdo el id del acuerdo a rechazar
     */
	@RequestMapping
    public String rechazarAcuerdoMotivo(Long idAcuerdo, Long idMotivo, String observaciones) {
		
		proxyFactory.proxy(MEJAcuerdoApi.class).rechazarAcuerdoMotivo(idAcuerdo, idMotivo, observaciones);
		
		return "default";
	}
	
	 /**
     * Obtiene la lista de Contratos asociados aun asunto.
     * @param idAsunto el id del asunto
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String obtenerListadoContratosAcuerdoByAsuId(ModelMap model, Long idAsunto) {
		List<Contrato> listadoContratosAsuntos = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoContratosAcuerdoByAsuId(idAsunto);
		model.put("listadoContratosAsuntos", listadoContratosAsuntos);
		
		return JSON_LISTADO_CONTRATOS;
	}
	
	 /**
     * Obtiene la lista de Terminos de una acuerdo
     * @param idAcuerdo el id del acuerdo
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String obtenerListadoTerminosAcuerdoByAcuId(ModelMap model, Long idAcuerdo) {
		List<ListadoTerminosAcuerdoDto> listadoTerminosAcuerdo = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoTerminosAcuerdoByAcuId(idAcuerdo);
		model.put("listadoTerminosAcuerdo", listadoTerminosAcuerdo);
		
		return JSON_LISTADO_TERMINOS;
	}
	
	
	 /**
     * Obtiene la lista de Derivaciones de los terminos de una acuerdo
     * @param idAcuerdo el id del acuerdo
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String obtenerListadoValidacionTramiteCorrespondienteDerivaciones(ModelMap model, Long idAcuerdo) {
		
		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
		if(!Checks.esNulo(acuerdo)){
			List<ACDAcuerdoDerivaciones> listadoDerivaciones = proxyFactory.proxy(MEJAcuerdoApi.class).getValidacionTramiteCorrespondiente(acuerdo,true);
			model.put("derivacionesTerminos", listadoDerivaciones);	
		}
		
		
		return JSON_LISTADO_DERIVACIONES;
	}
	
	 /**
     * Obtiene la configuracion de los usuarios en el acuerdo - asunto
     * @param idAcuerdo el id del acuerdo
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getConfigUsersAcuerdoAsunto(ModelMap model, Long idAsunto) {

		Usuario user = usuarioManager.getUsuarioLogado();
		model.put("idUsuario",user.getId());
		
		///Comprobamos si el usuario logado esta como proponente
		model.put("esUsuarioProponente",mejAcuerdoApi.usuarioEstaEnGAA(user,idAsunto,EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROPONENTE_ACUERDO));
		
		///Comprobamos si el usuario logado esta como validador
		model.put("esUsuarioValidador",mejAcuerdoApi.usuarioEstaEnGAA(user, idAsunto,EXTDDTipoGestor.CODIGO_TIPO_GESTOR_VALIDADOR_ACUERDO));
		
		///Comprobamos si el usuario logado esta como decisor
		model.put("esUsuarioDecisor",mejAcuerdoApi.usuarioEstaEnGAA(user, idAsunto,EXTDDTipoGestor.CODIGO_TIPO_GESTOR_DECISOR_ACUERDO));
		
		return JSON_CONFIG_USERS_ACUERDO_ASUNTOS;
	}
	
	/**
	 * 
	 * Devuelve la página de alta de terminos
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openAltaTermino(ModelMap map, 
			@RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo,
			String contratosIncluidos, Boolean esPropuesta, String ambito) {
			

		map.put("contratosIncluidos", contratosIncluidos);		
		map.put("idAcuerdo", idAcuerdo);
		map.put("esPropuesta", esPropuesta);
		map.put("ambito", ambito);
		
		if(esPropuesta){
			Acuerdo acuerdo = genericDao.get(Acuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", idAcuerdo));
			if(!Checks.esNulo(acuerdo)){
				map.put("idExpediente", acuerdo.getExpediente().getId());	
			}
		}
		
		// Obtenemos el tipo de acuerdo para PLAN_PAGO
		DDTipoAcuerdo tipoAcuerdoPlanPago = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAcuerdo.CODIGO_PLAN_PAGO));
		DDTipoAcuerdo tipoAcuerdoFondosPropios = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAcuerdo.TIPO_EFECTIVO_FONDOS_PROPIOS));
		DDTipoAcuerdo tipoAcuerdoRegulParcial = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAcuerdo.TIPO_REGUL_PARCIAL));
		
		// Obtenemos la lista de Terminos del acuerdo
		List<ListadoTerminosAcuerdoDto> listadoTerminosAcuerdo = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoTerminosAcuerdoByAcuId(idAcuerdo);
		boolean yaHayPlanPago = false;
		// y comprobamos si ya hay un plan de pago
		for (ListadoTerminosAcuerdoDto ta : listadoTerminosAcuerdo){
			if (ta.getTipoAcuerdo().getId() == tipoAcuerdoPlanPago.getId()){
				yaHayPlanPago = true;
				break;
			}		
		}
		
		List<String> contratos = new ArrayList<String>(Arrays.asList(contratosIncluidos.split(",")));
		List<String> fechasPaseMora = new ArrayList<String>();
		List<String> fechasPaseMoraFormated = new ArrayList<String>();
		for(String contrat : contratos) {
			fechasPaseMora.add(mejAcuerdoApi.getFechaPaseMora(Long.valueOf(contrat)));	
		}
		
		
		for(String fecha : fechasPaseMora){
			if(fecha == null){
				fechasPaseMoraFormated.add("0");
			}else{
				fechasPaseMoraFormated.add(fecha);
			}
		}
		
		Comparator<String> comparador = Collections.reverseOrder();
		Collections.sort(fechasPaseMoraFormated, comparador);
		
		String fechaPaseMora = null; 
		if(!Checks.estaVacio(fechasPaseMora)){
			fechaPaseMora = fechasPaseMora.get(0); 
		}
		
		Date fechaPaseMoraFormated = null;
		if (fechaPaseMora != null){
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			try {
				fechaPaseMoraFormated = sdf.parse(fechaPaseMora);
			} catch (ParseException e) {
				e.printStackTrace();
			} 
		}
		
		if(!Checks.esNulo(tipoAcuerdoPlanPago)){ map.put("idTipoAcuerdoPlanPago", tipoAcuerdoPlanPago.getId());}
		map.put("yaHayPlanPago", yaHayPlanPago);
		if(!Checks.esNulo(fechaPaseMoraFormated)){
			map.put("fechaPaseMora", fechaPaseMoraFormated.getTime());
		}else{
			map.put("fechaPaseMora", 0L);
		}
		if(!Checks.esNulo(tipoAcuerdoFondosPropios)){map.put("idTipoAcuerdoFondosPropios", tipoAcuerdoFondosPropios.getId());}
		if(!Checks.esNulo(tipoAcuerdoRegulParcial)){map.put("idTipoAcuerdoRegulParcial", tipoAcuerdoRegulParcial.getId());}
		
		return JSP_ALTA_TERMINO_ACUERDO;
	}	
	
	
	/**
	 * 
	 * Muestra el detalle de terminos
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openDetalleTermino(ModelMap map, @RequestParam(value = "ambito", required = true) String ambito ,@RequestParam(value = "id", required = true) Long id, 
							@RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo,
							@RequestParam(value = "contratosIncluidos", required = true) String contratosIncluidos,
							@RequestParam(value = "soloConsulta", required = true) String soloConsulta) {
		
		TerminoAcuerdo termino = proxyFactory.proxy(MEJAcuerdoApi.class).getTerminoAcuerdo(id);
		if (termino.getAcuerdo().getExpediente()!=null) {
			map.put("idExpediente", termino.getAcuerdo().getExpediente().getId());
			map.put("esPropuesta",true);
		} else {
			map.put("esPropuesta",false);
		}
			
		if (!contratosIncluidos.equals("")) {
			map.put("contratosIncluidos", contratosIncluidos);
		} else {
			String contratosDelTermino = "";
			for (TerminoContrato contrato : termino.getContratosTermino()) {
				contratosDelTermino += contrato.getId() + ",";
			}
			if (contratosDelTermino.length()>0) {
				contratosDelTermino = contratosDelTermino.substring(0,contratosDelTermino.length()-1);
			}
			map.put("contratosIncluidos", contratosDelTermino);
		}
		
		// Sacamos los bienes que tiene asignado este termino
		List<TerminoBien> tbList = genericDao.getList(TerminoBien.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", termino.getId()),genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		termino.setBienes(tbList);		
		map.put("termino", termino);
		
		//map.put("operacionesPorTipo", terminoOperacionesManager.getOperacionesPorTipoAcuerdo(termino.getOperaciones()));
		map.put("operacionesPorTipo", termino.getValoresCampos());
		
		map.put("idAcuerdo", idAcuerdo);
		map.put("ambito", ambito);
		
		map.put("soloConsulta", soloConsulta);
		
		// Obtenemos el tipo de acuerdo para PLAN_PAGO
		DDTipoAcuerdo tipoAcuerdoPlanPago = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAcuerdo.CODIGO_PLAN_PAGO));
		
		// Si estamos editando el plan de pago --> no cambiarmos el flag yaHayPlanPago = false para
		// que se puedan hacer las modificaciones
		boolean yaHayPlanPago = false;
		if (!termino.getTipoAcuerdo().getCodigo().equals(DDTipoAcuerdo.CODIGO_PLAN_PAGO)){
			// Obtenemos la lista de Terminos del acuerdo
			List<ListadoTerminosAcuerdoDto> listadoTerminosAcuerdo = proxyFactory.proxy(MEJAcuerdoApi.class).obtenerListadoTerminosAcuerdoByAcuId(idAcuerdo);
			// y comprobamos si ya hay un plan de pago
			for (ListadoTerminosAcuerdoDto ta : listadoTerminosAcuerdo){
				if (ta.getTipoAcuerdo().getId() == tipoAcuerdoPlanPago.getId()){
					yaHayPlanPago = true;
					break;
				}		
			}
		}
		
		List<TerminoContrato> contratos = termino.getContratosTermino();
		List<String> fechasPaseMora = new ArrayList<String>();
		List<String> fechasPaseMoraFormated = new ArrayList<String>();
		for(TerminoContrato contrat : contratos) {
			if(contrat.getContrato() != null){
				fechasPaseMora.add(mejAcuerdoApi.getFechaPaseMora(contrat.getContrato().getId()));
			}
		}
		
		
		for(String fecha : fechasPaseMora){
			if(fecha == null){
				fechasPaseMoraFormated.add("0");
			}else{
				fechasPaseMoraFormated.add(fecha);
			}
		}
		
		Comparator<String> comparador = Collections.reverseOrder();
		Collections.sort(fechasPaseMoraFormated, comparador);
		
		String fechaPaseMora = null; 
		if(!Checks.estaVacio(fechasPaseMora)){
			fechaPaseMora = fechasPaseMora.get(0); 
		}
		
		Date fechaPaseMoraFormated = null;
		if (fechaPaseMora != null){
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			try {
				fechaPaseMoraFormated = sdf.parse(fechaPaseMora);
			} catch (ParseException e) {
				e.printStackTrace();
			} 
		}
		
		if(!Checks.esNulo(fechaPaseMoraFormated)){
			map.put("fechaPaseMora", fechaPaseMoraFormated.getTime());
		} else {
			map.put("fechaPaseMora", null);
		}
		
		map.put("idTipoAcuerdoPlanPago", tipoAcuerdoPlanPago.getId());
		map.put("yaHayPlanPago", yaHayPlanPago);
		
		
		
		return JSP_ALTA_TERMINO_ACUERDO;
	}
	
	
	/**
	 * 
	 * Devuelve la página de finalizacion de acuerdo
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openFinalizacionAcuerdo(@RequestParam(value = "idAcuerdo", required = true) Long id, ModelMap map) {
				
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		map.put("acuerdo",acuerdo);
		
		List<DDSiNo> ddsino = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		map.put("ddSiNo", ddsino);
		
		return JSP_FINALIZACION_ACUERDO;
	}
	
	/**
	 * Obtener la lista de tipos de acuerdo
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoAcuerdosData(ModelMap model, String entidad){
		List<DDTipoAcuerdo> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListTipoAcuerdo(entidad);
		model.put("data", list);
		return JSON_LIST_TIPO_ACUERDO;
	}	
	
	/**
	 * Obtener la lista de los campos segun el tipo de acuerdo
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCamposDinamicosTerminosPorTipoAcuerdo(ModelMap model, Long idTipoAcuerdo){
		
		model.put("operacionesPorTipo", terminoOperacionesManager.getCamposOperacionesPorTipoAcuerdo(idTipoAcuerdo) );
		return JSON_LIST_CAMPOS_DINAMICOS_TERMINOS_POR_TIPO_ACUERDO;
	}
	
	
	/**
	 * Obtener la lista de sub-tipos de acuerdo
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListSubTiposAcuerdosData(ModelMap model){
		List<DDSubTipoAcuerdo> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListSubTipoAcuerdo();
		model.put("data", list);
		return JSON_LIST_SUB_TIPOS_ACUERDO;
	}
	
	/**
	 * Obtener la lista de tipos de producto
	 * 
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListTipoProductosData(ModelMap model){
		List<DDTipoProducto> list = proxyFactory.proxy(MEJAcuerdoApi.class).getListTipoProducto();
		model.put("data", list);
		return JSON_LIST_TIPO_PRODUCTO;
	}	
	
	/**
	 * Creación de un Término asociado a un objeto
	 * 
	 * @param model
	 * @return
	 * @throws ParseException 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String crearTerminoAcuerdo(TerminoOperacionesDto termOpDto, WebRequest request, ModelMap model) throws ParseException{
		
		TerminoAcuerdoDto taDTO = creaTerminoAcuerdoDTO(request);
		
		String contratosIncluidos = request.getParameter("contratosIncluidos"); 
		String bienesIncluidos = request.getParameter("bienesIncluidos"); 
		String terminoId = request.getParameter("idTermino");
		
		TerminoAcuerdo ta;
		if (terminoId != null && terminoId.length()>0){
			ta = genericDao.get(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", new Long(terminoId)));
		}
		else
			ta = new TerminoAcuerdo();
		
		EXTAcuerdo acuerdo = genericDao.get(EXTAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdAcuerdo()));
		ta.setAcuerdo(acuerdo);
		DDTipoAcuerdo tipoAcuerdo = genericDao.get(DDTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdTipoAcuerdo()));
		ta.setTipoAcuerdo(tipoAcuerdo);
		if(taDTO.getIdSubTipoAcuerdo()!=null){
			DDSubTipoAcuerdo subtipoAcuerdo = genericDao.get(DDSubTipoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdSubTipoAcuerdo()));
			ta.setSubtipoAcuerdo(subtipoAcuerdo);	
		}
		if (!Checks.esNulo(taDTO.getIdTipoProducto())) {
			DDTipoProducto tipoProducto = genericDao.get(DDTipoProducto.class, genericDao.createFilter(FilterType.EQUALS, "id", taDTO.getIdTipoProducto()));
			ta.setTipoProducto(tipoProducto);
		}
		ta.setModoDesembolso(taDTO.getModoDesembolso());
		ta.setFormalizacion(taDTO.getFormalizacion());
		ta.setImporte(taDTO.getImporte());
		ta.setComisiones(taDTO.getComisiones());		
		ta.setPeriodicidad(taDTO.getPeriodicidad());
		ta.setPeriodoFijo(taDTO.getPeriodoFijo());
		ta.setSistemaAmortizacion(taDTO.getSistemaAmortizacion());
		ta.setPeriodoVariable(taDTO.getPeriodoVariable());
		ta.setInformeLetrado(taDTO.getInformeLetrado());
		
		//Borramos los contratos incluidos en el termino
		/*
		if (ta.getContratosTermino()!=null) {
			for (TerminoContrato contrato : ta.getContratosTermino()) {
				mejAcuerdoApi.deleteTerminoContrato(contrato);
			}
		}*/
		
		//Borramos los bienes seleccionados previamente
		if (ta.getBienes()!=null) {
			for (TerminoBien bien : ta.getBienes()) {
				mejAcuerdoApi.deleteTerminoBien(bien);	
			}
		}
		
		//Borramos si tenia valores terminos antes
		mejAcuerdoApi.deleteAllValoresTermino(ta);
		
		TerminoAcuerdo taSaved = proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoAcuerdo(ta);
		
		//Y creamos los nuevos
		List<ValoresCamposTermino> valores = new ArrayList<ValoresCamposTermino>();
		List<CamposTerminoTipoAcuerdo> campos = terminoOperacionesManager.getCamposOperacionesPorTipoAcuerdo(ta.getTipoAcuerdo().getId());
		for (CamposTerminoTipoAcuerdo campo : campos) {
			if (request.getParameterMap().containsKey(campo.getNombreCampo())) {
				if (!Checks.esNulo(request.getParameter(campo.getNombreCampo()))) {
					ValoresCamposTermino va = new ValoresCamposTermino();
					va.setCampo(campo);
					va.setTermino(taSaved);
					if (!campo.getTipoCampo().equals("combobox")) {
						va.setValor(request.getParameter(campo.getNombreCampo()));
					} else {
						//Buscamos el value del text enviado
						for (List<String> value : campo.getArrayValoresCombo()) {
							if (value.get(0).equals(request.getParameter(campo.getNombreCampo()))) {
								va.setValor(value.get(0));
							}
						}
					}
					
					valores.add(va);
				}
			}
		}
		if (valores.size()>0) {
			taSaved.setValoresCampos(valores);
		} else {
			taSaved.setValoresCampos(null);
		}
		mejAcuerdoApi.saveAllValoresTermino(taSaved);		
		
		// Creamos los bienes asociados al termino
		if (bienesIncluidos.trim().length()>0) {	
			crearBienesTermino(taSaved, bienesIncluidos);
		}
		

		// Creamos los contratos asociados al termino
		if (contratosIncluidos.trim().length()>0) 
			crearContratosTermino(taSaved, contratosIncluidos);
		

		return "default";
	}	
	
	/**
	 * Creación del DTO de TerminoAcuerdo
	 * 
	 * @param model
	 * @return
	 */
	public TerminoAcuerdoDto creaTerminoAcuerdoDTO(WebRequest request){
		TerminoAcuerdoDto taDTO = new TerminoAcuerdoDto();
					
		if (!Checks.esNulo(request.getParameter("idAcuerdo"))) taDTO.setIdAcuerdo(Long.parseLong(request.getParameter("idAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idTipoAcuerdo"))) taDTO.setIdTipoAcuerdo(Long.parseLong(request.getParameter("idTipoAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idSubTipoAcuerdo"))) taDTO.setIdSubTipoAcuerdo(Long.parseLong(request.getParameter("idSubTipoAcuerdo")));
		if (!Checks.esNulo(request.getParameter("idTipoProducto"))) taDTO.setIdTipoProducto(Long.parseLong(request.getParameter("idTipoProducto")));		
		if (!Checks.esNulo(request.getParameter("modoDesembolso"))) taDTO.setModoDesembolso(request.getParameter("modoDesembolso"));
		if (!Checks.esNulo(request.getParameter("formalizacion"))) taDTO.setFormalizacion(request.getParameter("formalizacion"));
		if (!Checks.esNulo(request.getParameter("importe"))) taDTO.setImporte(Float.parseFloat(request.getParameter("importe")));
		if (!Checks.esNulo(request.getParameter("comisiones"))) taDTO.setComisiones(Float.parseFloat(request.getParameter("comisiones")));
		if (!Checks.esNulo(request.getParameter("periodoCarencia"))) taDTO.setPeriodoCarencia(request.getParameter("periodoCarencia"));
		if (!Checks.esNulo(request.getParameter("periodicidad"))) taDTO.setPeriodicidad(request.getParameter("periodicidad"));
		if (!Checks.esNulo(request.getParameter("periodoFijo"))) taDTO.setPeriodoFijo(request.getParameter("periodoFijo"));
		if (!Checks.esNulo(request.getParameter("sistemaAmortizacion"))) taDTO.setSistemaAmortizacion(request.getParameter("sistemaAmortizacion"));
		if (!Checks.esNulo(request.getParameter("interes"))) taDTO.setInteres(Float.parseFloat(request.getParameter("interes")));
		if (!Checks.esNulo(request.getParameter("periodoVariable"))) taDTO.setPeriodoVariable(request.getParameter("periodoVariable"));
		if (!Checks.esNulo(request.getParameter("informeLetrado"))) taDTO.setInformeLetrado(request.getParameter("informeLetrado"));		
			
		return taDTO;
	}
	
	/**
	 * Creción de los Contratos asociados al Término
	 * 
	 * @param ta TerminoAcuerdo guardado
	 * @param contratosIncluidos Cadena con los códigos de los contratos
	 * 
	 */
	public void crearContratosTermino(TerminoAcuerdo ta, String contratosIncluidos){
		StringTokenizer tokens = new StringTokenizer(contratosIncluidos, ",");
		Contrato cnt; 
		TerminoContrato tc;
		while (tokens.hasMoreTokens()){
			cnt = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(tokens.nextElement()+"")));
			tc = new TerminoContrato();
			tc.setContrato(cnt);
			tc.setTermino(ta);
			
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoContrato(tc);			
			
		}
	}
	
	/**
	 * Creción de los Bienes asociados al Término
	 * 
	 * @param ta TerminoAcuerdo guardado
	 * @param bienesIncluidos Cadena con los códigos de los bienes
	 * 
	 */
	public void crearBienesTermino(TerminoAcuerdo ta, String bienesIncluidos){
		StringTokenizer tokens = new StringTokenizer(bienesIncluidos, ",");
		Bien bien; 
		TerminoBien tb;
		while (tokens.hasMoreTokens()){
			bien = genericDao.get(Bien.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(tokens.nextElement()+"")));
			tb = new TerminoBien();
			tb.setBien(bien);
			tb.setTermino(ta);
			
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoBien(tb);			
			
		}
	}	
	
	 /**
     * Obtiene la lista de Bienes asociados a todos los procedimientos de un asunto
     * 
     * @param idAcuerdo el id del acuerdo
     */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping
    public String obtenerListadoBienesAcuerdoByAsuId(ModelMap model, Long idAsunto) {
		List<Bien> listadoBienesAcuerdoRep = proxyFactory.proxy(AsuntoApi.class).getBienesDeUnAsunto(idAsunto);
	    
		// En este punto tenemos una lista de bienes que puede estar repetida
		// Vamos a procesarla para quedarnos solo con los no repetidos
	    TreeMap<Long, Bien> bienesAsuntoMap = new TreeMap<Long, Bien>();
    	for (Bien bien : listadoBienesAcuerdoRep){
    		bienesAsuntoMap.put(bien.getId(), bien);
    	}	
    	
        // Convertir el Map con los bienes en una lista
        List<Bien> listadoBienesAcuerdo = new ArrayList<Bien>();
        Bien bienL;
        for(Iterator it = bienesAsuntoMap.keySet().iterator(); it.hasNext();) {
        	bienL = (Bien) bienesAsuntoMap.get(it.next());
        	listadoBienesAcuerdo.add(bienL);
       	}  
        
		model.put("listadoBienesAcuerdo", listadoBienesAcuerdo);
		
		return JSON_LISTADO_BIENES_ACUERDO;
	}	
	
	 /**
     * Obtiene la lista de Bienes asociados a los contratos de un termino
     * 
     * @param idTermino el id del termino
     * @param contratosIncluidos Lista contratos incluidos en el termino cuando es un alta
     * 
     */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping
    public String obtenerListadoBienesContratosAcuerdo(ModelMap model, Long idTermino, String contratosIncluidos) {
		
		List<Bien> listadoBienesAcuerdoRep = new ArrayList<Bien>();
		List<Long> listaContratosId = new ArrayList<Long>();
		
		// Obtenemos los contratos de ese termino.
		// Si lo estamos dando de alta 
		if (idTermino == null){
			StringTokenizer tokens = new StringTokenizer(contratosIncluidos, ",");
			while (tokens.hasMoreTokens()){
				listaContratosId.add(new Long(tokens.nextToken()));
			}
		}
		// Si lo estamos editando
		else {
	     	List<TerminoContrato> listaContratosTermino = (List<TerminoContrato>) genericDao.getList(TerminoContrato.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTermino));
	     	for (TerminoContrato tc : listaContratosTermino){
	     		listaContratosId.add(tc.getContrato().getId());
	     	}
		}
		
	     // Obtenemos los bienes de cada uno de los contratos
     	for (Long lCntIds : listaContratosId){     		
    		List<NMBContratoBien> listaBienesContrato = (List<NMBContratoBien>) genericDao.getList(NMBContratoBien.class,
    				genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "contrato.id", lCntIds));
    		
    		for (NMBContratoBien nb : listaBienesContrato){
    			listadoBienesAcuerdoRep.add(nb.getBien());
    		}
     	}
     	    
		// En este punto tenemos una lista de bienes que puede estar repetida
		// Vamos a procesarla para quedarnos solo con los no repetidos
	    TreeMap<Long, Bien> bienesTerminoMap = new TreeMap<Long, Bien>();
    	for (Bien bien : listadoBienesAcuerdoRep){
    		bienesTerminoMap.put(bien.getId(), bien);
    	}	
    	
        // Convertir el Map con los bienes en una lista
        List<Bien> listadoBienesAcuerdo = new ArrayList<Bien>();
        Bien bienL;
        for(Iterator it = bienesTerminoMap.keySet().iterator(); it.hasNext();) {
        	bienL = (Bien) bienesTerminoMap.get(it.next());
        	listadoBienesAcuerdo.add(bienL);
       	}  
        
		model.put("listadoBienesAcuerdo", listadoBienesAcuerdo);
		
		return JSON_LISTADO_BIENES_ACUERDO;
	}		
	
	/**
	 * Eliminar un Término asociado a un objeto
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String eliminarTerminoAcuerdo(WebRequest request, ModelMap model){			
		String idTerminoAcuerdo = request.getParameter("idTerminoAcuerdo");
		
		// eliminar los Contratos asociados al Termino
		eliminarContratosTermino(Long.parseLong(idTerminoAcuerdo));
		
		// eliminar los Bienes asociados al Termino
		eliminarBienesTermino(Long.parseLong(idTerminoAcuerdo));
		
		TerminoAcuerdo ta = genericDao.get(TerminoAcuerdo.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(idTerminoAcuerdo)));

		//eliminar los Valores asociados al Termino
		mejAcuerdoApi.deleteAllValoresTermino(ta);
		
		
		proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoAcuerdo(ta);
		
		return "default";		
	}
	
	
	/**
	 * 
	 * Eliminar los contratos asociados a un Termino
	 * 
	 * @param idTerminoAcuerdo
	 * 
	 */
	public void eliminarContratosTermino(Long idTerminoAcuerdo){
		
		 List<TerminoContrato> tcList = genericDao.getList(TerminoContrato.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTerminoAcuerdo));
		 
		 for (TerminoContrato tc : tcList){
			 proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoContrato(tc);
		 }		
	}
	
	/**
	 * 
	 * Eliminar los bienes asociados a un Termino
	 * 
	 * @param idTerminoAcuerdo
	 * 
	 */
	public void eliminarBienesTermino(Long idTerminoAcuerdo){
		
		 List<TerminoBien> tbList = genericDao.getList(TerminoBien.class, genericDao.createFilter(FilterType.EQUALS, "termino.id", idTerminoAcuerdo));
		 
		 for (TerminoBien tb : tbList){
			 proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoBien(tb);
		 }		
	}	

	/**
	 * 
	 * Muestra la ventana de modificación de Estado de Gestión del Término
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openEstadoGestion(ModelMap map, @RequestParam(value = "id", required = true) Long id,
							@RequestParam(value = "idAcuerdo", required = true) Long idAcuerdo,
							@RequestParam(value = "soloConsulta", required = true) String soloConsulta) {
		
		List<DDEstadoGestionTermino> listaEstados=diccionarioManager.dameValoresDiccionario(DDEstadoGestionTermino.class);

		TerminoAcuerdo termino = proxyFactory.proxy(MEJAcuerdoApi.class).getTerminoAcuerdo(id);

		map.put("termino", termino);		
		map.put("idAcuerdo", idAcuerdo);
		map.put("soloConsulta", soloConsulta);
		map.put("listaEstados", listaEstados);		
			
		return JSP_EDITAR_TERMINO_ESTADO_GESTION;
	}
	
	/**
	 * Se realizan las acciones pertinentes para cambiar el estado de gestion del termino
	 * @param request
	 * @param map
	 * @param idTermino
	 * @param nuevoEstadoGestion
	 * @return
	 */
	@RequestMapping
	private String guardarEstadoGestion(WebRequest request, ModelMap map,Long idTermino,Long nuevoEstadoGestion){

		proxyFactory.proxy(MEJAcuerdoApi.class).guardarEstadoGestion(idTermino, nuevoEstadoGestion);
		
		return "default";
	}
		
	/**
	 * 
	 * Devuelve la página de rechazo de acuerdo
	 * 
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openRechazarAcuerdo(@RequestParam(value = "idAcuerdo", required = true) Long id, ModelMap map) {
				
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		List<DDMotivoRechazoAcuerdo> motivosRechazo=diccionarioManager.dameValoresDiccionario(DDMotivoRechazoAcuerdo.class);
		map.put("motivosRechazo", motivosRechazo);
		map.put("acuerdo",acuerdo);
		
		return JSP_RECHAZAR_ACUERDO;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String tieneConfiguracionProponerAcuerdo(ModelMap map) {
		
		Usuario user = usuarioManager.getUsuarioLogado();
		
    	GestorDespacho gestorDespacho = null;
    	Order order = new Order(OrderType.ASC, "id");
    	List<GestorDespacho> usuariosDespacho =  genericDao.getListOrdered(GestorDespacho.class,order, genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId()));
    	
    	if(usuariosDespacho.size()==1){
			
    		gestorDespacho = usuariosDespacho.get(0);
			
		}else if(usuariosDespacho.size()>1){
			
			gestorDespacho = usuariosDespacho.get(0);
			
			for(GestorDespacho gesDes : usuariosDespacho){
				if(gesDes.getGestorPorDefecto()){
					gestorDespacho = gesDes;
					break;
				}
			}
			
		}
    	
    	List<AcuerdoConfigAsuntoUsers> configs = null;
    	
    	if(!Checks.esNulo(gestorDespacho)){
    		configs = genericDao.getList(AcuerdoConfigAsuntoUsers.class, genericDao.createFilter(FilterType.EQUALS, "proponente.id", gestorDespacho.getDespachoExterno().getTipoDespacho().getId() ));	
        	if(configs != null && configs.size() > 0){
        		map.put("okko",true);
        	}else{
        		map.put("okko",false);	
        	}
    	}else{
    		map.put("okko",false);
    	}   	
    	
		
		return OK_KO_RESPUESTA_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListDDCondicionesRemuneracionData(ModelMap model){
		List<DDCondicionesRemuneracion> list = diccionarioManager.dameValoresDiccionario(DDCondicionesRemuneracion.class);
		model.put("data", list);
		return JSON_LIST_DD_CONDICIONES_REMUNERACION;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListSituacionGestion(ModelMap model){
		List<DDSituacionGestion> list = diccionarioManager.dameValoresDiccionario(DDSituacionGestion.class);
		model.put("data", list);
		return JSON_LIST_DD_SITUACION_GESTION;
	}

}
