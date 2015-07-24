package es.pfsgroup.plugin.precontencioso.documento.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentosUGPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.IncluirDocumentoDto;
import es.pfsgroup.plugin.precontencioso.documento.dto.InformarDocumentoDto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SaveInfoSolicitudDTO;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDResultadoSolicitudPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDSiNoNoAplica;
import es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDUnidadGestionPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;


@Controller
public class DocumentoPCOController {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private DocumentoPCOApi documentoPCOApi;

	private static final String DEFAULT = "default";
	private static final String SOLICITUDES_DOC_PCO_JSON = "plugin/precontencioso/documento/json/solicitudesDocumentoJSON";
	private static final String AGREGAR_UGESTION_DOC_PCO_JSON = "plugin/precontencioso/documento/json/agregarDocsUGestionJSON";
	private static final String INFORMAR_DOC = "plugin/precontencioso/documento/popups/informarDocumento";
	private static final String INCLUIR_DOC = "plugin/precontencioso/documento/popups/incluirDocumento";
	private static final String EDITAR_DOC = "plugin/precontencioso/documento/popups/editarDocumento";
	private static final String CREAR_SOLICITUDES = "plugin/precontencioso/documento/popups/crearSolicitudes";
	private static final String TIPO_GESTOR_JSON = "plugin/coreextension/asunto/tipoGestorJSON";

	protected final Log logger = LogFactory.getLog(getClass());

	List<DocumentosUGPCODto> documentosUG = null;
	Long idProcPCO;
	private static SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");

	@RequestMapping
	public String getSolicitudesDocumentosPorProcedimientoId(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {

		idProcPCO = new Long(idProcedimientoPCO);
		
		boolean esDocumento;	// marca para la primera solicitud de cada documento
		
		List<SolicitudDocumentoPCODto> solicitudesDoc = new ArrayList<SolicitudDocumentoPCODto>();
		
		List<DocumentoPCO> documentos = documentoPCOApi.getDocumentosPorIdProcedimientoPCO(idProcedimientoPCO);
		List<SolicitudDocumentoPCO> solicitudes; 
		for (DocumentoPCO doc : documentos) {
			solicitudes = doc.getSolicitudes();
			esDocumento = true;
			for (SolicitudDocumentoPCO sol : solicitudes) {
				solicitudesDoc.add(documentoPCOApi.crearSolicitudDocumentoDto(doc,sol, esDocumento));
				if (esDocumento) esDocumento = false;
			}			
		}
		
		model.put("solicitudesDocumento", solicitudesDoc);
		
		return SOLICITUDES_DOC_PCO_JSON;
	}

	/**
	 * Agreaar documentos de las unidades de gestion seleccionadas
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String agregarDocumentosUG(
			@RequestParam(value = "uniGestionIds", required = true) String uniGestionIds,ModelMap model) {

		List<DocumentosUGPCODto> ugsDto = new ArrayList<DocumentosUGPCODto>();
		StringTokenizer st;
	
		st = new StringTokenizer(uniGestionIds,",");
		String codUG;
		while (st.hasMoreElements()){
			codUG = st.nextToken();
			ugsDto.addAll(documentoPCOApi.getDocumentosUG(idProcPCO, codUG));
		}
				
		// Devolvemos los documentos asociados
		model.put("documentosUG", ugsDto);
		
		return AGREGAR_UGESTION_DOC_PCO_JSON;
	}
	

	/**
	 * Informar Documento
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String informarSolicitud(
			@RequestParam(value = "idSolicitud", required = true) String idSolicitud, 
			@RequestParam(value = "actor", required = true) String actor, 
			@RequestParam(value = "idDoc", required = true) String idDoc, 
			@RequestParam(value = "fechaResultado", required = true) String fechaResultado, 
			@RequestParam(value = "resultado", required = true) String resultado, 
			@RequestParam(value = "fechaEnvio", required = true) String fechaEnvio, 
			@RequestParam(value = "fechaRecepcion", required = true) String fechaRecepcion, 
			ModelMap model) {

		InformarDocumentoDto dto = new InformarDocumentoDto();

		Long idDocumento = Long.valueOf(idDoc);
		
		DocumentoPCODto doc = documentoPCOApi.getDocumentoPorIdDocumentoPCO(idDocumento);
		
		dto.setIdSolicitud(Long.parseLong(idSolicitud));
		dto.setActor(obtenerCodigoDiccionario(DDTipoActorPCO.class, actor));
		dto.setIdDoc(idDocumento);
		dto.setEstado(obtenerCodigoDiccionario(DDEstadoDocumentoPCO.class, doc.getEstado()));
		String adjuntado = doc.getAdjunto();
		dto.setAdjuntado(obtenerCodigoDiccionario(DDSiNo.class, adjuntado));
		if ("".equals(dto.getAdjuntado()) && !"".equals(adjuntado)) {
			if ("NO".equalsIgnoreCase(adjuntado) || DDSiNo.NO.equals(adjuntado)) {
				dto.setAdjuntado(DDSiNo.NO);
			} else if ("Sí".equalsIgnoreCase(adjuntado) || DDSiNo.SI.equals(adjuntado)) {
				dto.setAdjuntado(DDSiNo.SI);
			}
		}

		String ejecutivo = doc.getEjecutivo();
		dto.setEjecutivo(obtenerCodigoDiccionario(DDSiNoNoAplica.class, ejecutivo));
		if ("".equals(dto.getEjecutivo()) && !"".equals(ejecutivo)) {
			if ("NO".equalsIgnoreCase(ejecutivo) || DDSiNoNoAplica.NO.equals(ejecutivo)) {
				dto.setEjecutivo(DDSiNoNoAplica.NO);
			} else if ("Sí".equalsIgnoreCase(ejecutivo) || DDSiNoNoAplica.SI.equals(ejecutivo)) {
				dto.setEjecutivo(DDSiNoNoAplica.SI);
			}
		}

		dto.setFechaResultado(fechaResultado);
		dto.setRespuesta(obtenerCodigoDiccionario(DDResultadoSolicitudPCO.class, resultado));
		dto.setFechaEnvio(fechaEnvio);
		dto.setFechaRecepcion(fechaRecepcion);
		dto.setComentario(doc.getComentario());
		
		List<DDEstadoDocumentoPCO> estadosDocumento = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDEstadoDocumentoPCO.class);
		List<DDResultadoSolicitudPCO> respuestasSolicitud = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoSolicitudPCO.class);
		List<DDSiNo> ddsino = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		List<DDSiNoNoAplica> ddsinonoaplica = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNoNoAplica.class);
		
		model.put("solicitud", dto);
		model.put("estadosDocumento", estadosDocumento);
		model.put("respuestasSolicitud", respuestasSolicitud);		
		model.put("ddSiNo", ddsino);
		model.put("ddSiNoNoAplica", ddsinonoaplica);
		
		return INFORMAR_DOC;
	}
	
	
	// METODO PROVISIONAL
	/**
	 * Incluir Documento
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirIncluirDocumento(ModelMap model) {

		List<DDTipoFicheroAdjunto> listaTipoDocumentos = null;
		List<DDUnidadGestionPCO> listaUG = null;
		
		IncluirDocumentoDto dto = new IncluirDocumentoDto();
		
//		dto.setAsiento("test_asiento");
//		dto.setFinca("test_finca");
//		dto.setFolio("test_folio");
//		dto.setIdufir("test_idufir");
//		dto.setLibro("test_libro");
//		dto.setNotario("test_notario");
//		dto.setNumFinca("test_numfinca");
//		dto.setNumRegistro("test_numRegistro");
//		dto.setProtocolo("test_protocolo");
//		dto.setTomo("test_tomo");
		
		// Lista tipo documentos
		listaTipoDocumentos = documentoPCOApi.getTiposDocumento();
		
		// Lista Unidades Gestion
		listaUG = documentoPCOApi.getUnidadesGestion();
		
		model.put("tiposDocumento", listaTipoDocumentos);
		model.put("unidadesGestion", listaUG);
		
		model.put("dtoDoc", dto);
		
		return INCLUIR_DOC;
	}
	
	/**
	 * Abrir Editar Documento
	 * 
	 * @param idDocumento
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirEditarDocumento(
			@RequestParam(value = "idDocumento", required = true) Long idDocumento, ModelMap model) {
		DocumentoPCODto docDto = new DocumentoPCODto();
		docDto = documentoPCOApi.getDocumentoPorIdDocumentoPCO(idDocumento);
		
		model.put("dtoDoc", docDto);
		
		return EDITAR_DOC;
	}
		
	/**
	 * Abrir Crear Solicitudes
	 * 
	 * @param idDocumento
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirCrearSolicitudes(
			@RequestParam(value = "idDocumento", required = true) Long idDocumento, ModelMap model) {
		DocumentoPCODto docDto = new DocumentoPCODto();
		docDto = documentoPCOApi.getDocumentoPorIdDocumentoPCO(idDocumento);
		
		model.put("dtoDoc", docDto);
		model.put("DDResultado", proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDResultadoSolicitudPCO.class));
		
		return CREAR_SOLICITUDES;
	}
		
	/**
	 * Excluir Documentos
	 * 
	 * @param idDocumento
	 * @param solicitudes
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String excluirDocumentos(
			@RequestParam(value = "idDocumento", required = true) Long idDocumento, ModelMap model) {
		
		documentoPCOApi.excluirDocumentosPorIdDocumentoPCO(idDocumento);

		return DEFAULT;
	}
		
	/**
	 * Descartar Documento
	 * 
	 * @param idDocumento
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String descartarDocumentos(
			@RequestParam(value = "idDocumento", required = true) Long idDocumento, ModelMap model) {
		
		documentoPCOApi.descartarDocumentos(idDocumento);
		
		return DEFAULT;
	}
	
	/**
	 * Anular Solicitudes
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String anularSolicitudes(
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, ModelMap model) {
		
		documentoPCOApi.anularSolicitudes(idSolicitud);
		
		return DEFAULT;
	}
		
	/**
	 * Actualizar Documento Editado
	 * 
	 * @param idDocumento
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarDocumento(WebRequest webRequest,ModelMap model) {

		Long idDoc = new Long(webRequest.getParameter("id"));
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		docDto.setId(idDoc);
		docDto.setProtocolo(webRequest.getParameter("protocolo"));
		docDto.setNotario(webRequest.getParameter("notario"));
		docDto.setFechaEscritura(webRequest.getParameter("fechaEscritura"));
		docDto.setAsiento(webRequest.getParameter("asiento"));
		docDto.setFinca(webRequest.getParameter("finca"));
		docDto.setTomo(webRequest.getParameter("tomo"));
		docDto.setLibro(webRequest.getParameter("libro"));
		docDto.setFolio(webRequest.getParameter("folio"));
		docDto.setNumFinca(webRequest.getParameter("numFinca"));
		docDto.setNumRegistro(webRequest.getParameter("numRegistro"));
		docDto.setPlaza(webRequest.getParameter("plaza"));
		docDto.setIdufir(webRequest.getParameter("idufir"));
		
		documentoPCOApi.editarDocumento(docDto);
		
		return DEFAULT;
	}
	
	/**
	 * Salvar los documentos incluidos
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping	
	private String saveIncluirDocumentos(WebRequest request ,ModelMap model) {
		
		String arrayIdDocumentos=request.getParameter("arrayIdDocumentos");
		String arrayIdUG=request.getParameter("arrayIdUG");
		
		// Las cadenas de los arrays vienen con formato [1,2,...] - Quitaremos los corchetes para procesar esta cadenas.
		arrayIdDocumentos = arrayIdDocumentos.substring(1, arrayIdDocumentos.length()-1);		
		arrayIdUG = arrayIdUG.substring(1, arrayIdUG.length()-1);
		
		StringTokenizer stIdDoc;
		StringTokenizer stIdUG;
		DDUnidadGestionPCO unidadGestion = null;
		
		// Tratamos los documentos a incluir	
		stIdDoc = new StringTokenizer(arrayIdDocumentos,",");
		stIdUG = new StringTokenizer(arrayIdUG,",");
		
		Long idDocUG;
		String contrato = "";
		String descripcionUG;
		String tipoUG = ""; 
		while (stIdDoc.hasMoreElements()){
			idDocUG = new Long(stIdDoc.nextToken());
			// Quitamos las " iniciales y finales
			tipoUG = stIdUG.nextToken();
			tipoUG = tipoUG.substring(1, tipoUG.length()-1);

			// Por cada documento de UG elegido tenemos que crear un documento y una solicitud (vacia)				
			// Crear DOCUMENTO
			
			DocumentoPCODto docDto = new DocumentoPCODto();
			SolicitudDocumentoPCODto solDto = new SolicitudDocumentoPCODto();
			
			docDto.setAdjunto("0");
			docDto.setAsiento(request.getParameter("asiento"));
			docDto.setFinca(request.getParameter("finca"));
			docDto.setFolio(request.getParameter("folio"));
			docDto.setIdufir(request.getParameter("idufir"));
			docDto.setLibro(request.getParameter("libro"));
			docDto.setNotario(request.getParameter("notario"));
			docDto.setNumFinca(request.getParameter("numFinca"));
			docDto.setNumRegistro(request.getParameter("numRegistro"));
			docDto.setProtocolo(request.getParameter("protocolo"));
			docDto.setTomo(request.getParameter("tomo"));	
			docDto.setTipoDocumento(request.getParameter("comboTipoDocumento"));
			docDto.setPlaza(request.getParameter("plaza"));
			docDto.setFechaEscritura(request.getParameter("fechaEscritura"));					
			docDto.setTipoUG(tipoUG);
			docDto.setIdProc(idProcPCO);
			docDto.setEstado(DDEstadoDocumentoPCO.PENDIENTE_SOLICITAR);
			docDto.setContrato(contrato);
			docDto.setId(idDocUG);
			
			// TODO - DATOS PROVISIONALES - REVISAR
			docDto.setActor("1");
			docDto.setTipoActor(DDTipoActorPCO.PREPARADOR);

			documentoPCOApi.saveCrearDocumento(docDto);			
		}

		return DEFAULT;
	}

	/**
	 Salvar la creacion de solicitudes
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping	
	public String saveCrearSolicitudes(WebRequest request ,ModelMap model) {
		//SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
		
		String idDoc = request.getParameter("id");
		String fechaSolicitud = request.getParameter("fechaSolicitud");
		//String fechaResultado = request.getParameter("fechaResultado");
		//String fechaEnvio = request.getParameter("fechaEnvio");
		//String fechaRecepcion = request.getParameter("fecharecepcion");
		String idTipoGestor = request.getParameter("tipogestor");
		String idDespacho = request.getParameter("idDespacho");
		
		Date fechaSolicitudDate = null;
//		Date fechaResultadoDate = null;
//		Date fechaEnvioDate = null;
//		Date fechaRecepcionDate = null;

		try {
			fechaSolicitudDate = webDateFormat.parse(fechaSolicitud);
			//fechaResultadoDate = webDateFormat.parse(fechaResultado);
			//fechaEnvioDate = webDateFormat.parse(fechaEnvio);
			//fechaRecepcionDate = webDateFormat.parse(fechaRecepcion);
		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
			return DEFAULT;
		}
		
		SolicitudPCODto solDto;	
		solDto = new SolicitudPCODto();		
		solDto.setIdDoc(new Long(idDoc));
		solDto.setActor(request.getParameter("actor"));
		solDto.setFechaSolicitud(fechaSolicitudDate);
		//solDto.setFechaResultado(fechaResultadoDate);
		//solDto.setFechaEnvio(fechaEnvioDate);
		//solDto.setFechaRecepcion(fechaRecepcionDate);
		solDto.setResultado(request.getParameter("resultado"));
		solDto.setIdTipoGestor(new Long(idTipoGestor));
		solDto.setIdDespachoExterno(new Long(idDespacho)); 

		documentoPCOApi.saveCrearSolicitudes(solDto);
			
		return DEFAULT;
	}

	private String obtenerCodigoDiccionario(Class claseDiccionario, String descripcion) {
		
		String respuesta = "";
		if (!Checks.esNulo(descripcion)) {
			Dictionary diccionario = (Dictionary) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByDes(claseDiccionario, descripcion);
			if (!Checks.esNulo(diccionario)) {
				respuesta = diccionario.getCodigo();
			}
		}
		return respuesta;

	}

	private Long obtenerIdDiccionario(Class claseDiccionario, String descripcion) {
		
		Long respuesta = null;
		if (!Checks.esNulo(descripcion)) {
			Dictionary diccionario = (Dictionary) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByDes(claseDiccionario, descripcion);
			if (!Checks.esNulo(diccionario)) {
				respuesta = diccionario.getId();
			}
		}
		return respuesta;

	}

	/**
	 * Informarlas solicitudes de los documentos
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping 
	private String saveInformarSolicitud(WebRequest request, ModelMap model) {
        
		SaveInfoSolicitudDTO dto = new SaveInfoSolicitudDTO();
        
        dto.setIdDoc(request.getParameter("idDoc"));
        dto.setActor(request.getParameter("actor"));
        dto.setIdSolicitud(request.getParameter("idSolicitud"));
        dto.setEstado(request.getParameter("estado"));
        dto.setAdjuntado(request.getParameter("adjuntado"));
        dto.setEjecutivo(obtenerIdDiccionario(DDSiNoNoAplica.class, request.getParameter("ejecutivo")));
        dto.setFechaResultado(parseaFecha(request.getParameter("fechaResultado")));
        dto.setResultado(request.getParameter("resultado"));
        dto.setFechaEnvio(parseaFecha(request.getParameter("fechaEnvio")));
        dto.setFechaRecepcion(parseaFecha(request.getParameter("fechaRecepcion")));
        dto.setComentario(request.getParameter("comentario"));
        
        documentoPCOApi.saveInformarSolicitud(dto);
        
        return DEFAULT;
        
	}
	
	private Date parseaFecha(String fecha) {

		Date fechaSalida = null;
		
		if (!Checks.esNulo(fecha)) {
			try {
				fechaSalida = webDateFormat.parse(fecha);
			} catch (ParseException e) {
				logger.error(e.getLocalizedMessage());
			}
		}
		return fechaSalida;

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getTiposGestorActores(ModelMap model){
		
		model.put("listadoGestores", documentoPCOApi.getTiposGestorActores());
		return TIPO_GESTOR_JSON;
	}

 }