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

import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.documento.api.DocumentoPCOApi;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentosUGPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.IncluirDocumentoDto;
import es.pfsgroup.plugin.precontencioso.documento.dto.InformarDocumentoDto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudDocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.dto.SolicitudPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;


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

	protected final Log logger = LogFactory.getLog(getClass());
	List<DocumentoPCODto> documentos = null;
	List<SolicitudPCODto> solicitudes = null;
	List<DocumentosUGPCODto> documentosUG = null;
	List<DDTipoDocumento> listaTipoDocumentos = null;
	List<DDTipoEntidad> listaUG = null;
	int lastKeyDocumentos; 
	int lastKeySolicitudes;
	List<SolicitudDocumentoPCODto> solicitudesDoc;
	
	@RequestMapping
	//public String getSolicitudesDocumentos(@RequestParam(value = "idProcPCO", required = true) Long idProcPCO, ModelMap map) {
	public String getSolicitudesDocumentos(ModelMap map) {
		//logger.error(".....................Inicio getSolicitudesDocumentos");
		if (documentos == null){
			documentos = datosDocumentos();
			lastKeyDocumentos = documentos.size()+1;
			solicitudes = datosSolicitudes();
			lastKeySolicitudes = solicitudes.size()+1;
		}
		
		//solicitudesDoc = new ArrayList<SolicitudDocumentoPCODto>();
		
		//List<SolicitudDocumentoPCO> solicitudesDoc = documentoPCOApi.getSolicitudesDocProcPCO(idProcPCO);
		//List<SolicitudDocumentoPCO> solicitudesDoc = proxyFactory.proxy(DocumentoPCOApi.class).getSolicitudesDocProcPCO(idProcPCO);
						
		// Construimos el DTO
		crearSolicitudDocumentosDto();
		
		map.put("solicitudesDocumento", solicitudesDoc);
		
		return SOLICITUDES_DOC_PCO_JSON;
	}

	/**
	 * crearSolicitudDocumentosDto
	 * 
	 */
	private void crearSolicitudDocumentosDto() {
		solicitudesDoc = new ArrayList<SolicitudDocumentoPCODto>();
				
		
		logger.error("..............CREACION DATOS");
		logger.error("..............documentos.size: "+documentos.size());
		logger.error("..............solicitudes.size: "+solicitudes.size());
		Long antIdDoc = new Long(0);
		String antTipoUG = "";
		String actTipoUG = "";
		String antTipoDoc = "";
		SolicitudDocumentoPCODto solDocDto;
		for (DocumentoPCODto doc : documentos) {
			for (SolicitudPCODto sol : solicitudes){
				if (sol.getIdDoc().equals(doc.getId())){
					solDocDto = new SolicitudDocumentoPCODto();
					solDocDto.setId(sol.getId());
					solDocDto.setIdDoc(doc.getId());
					if (!antIdDoc.equals(doc.getId()) || antTipoUG != doc.getTipoUG() || antTipoDoc != doc.getTipoDocumento()){
						solDocDto.setContrato(doc.getContrato());
						solDocDto.setDescripcionUG(doc.getDescripcionUG());
						solDocDto.setTipoDocumento(doc.getTipoDocumento());
						solDocDto.setEstado(doc.getEstado());
						solDocDto.setAdjunto(doc.getAdjunto());
						solDocDto.setComentario(doc.getComentario());
						
						antIdDoc = doc.getId();
						antTipoUG = doc.getTipoUG();
						antTipoDoc = doc.getTipoDocumento();
					}
					solDocDto.setActor(sol.getActor());
					solDocDto.setFechaSolicitud(sol.getFechaSolicitud());
					solDocDto.setFechaResultado(sol.getFechaResultado());
					solDocDto.setFechaEnvio(sol.getFechaEnvio());
					solDocDto.setFechaRecepcion(sol.getFechaRecepcion());
					solDocDto.setResultado(sol.getResultado());
					
					solicitudesDoc.add(solDocDto);
				}
			}
		}
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
		DocumentosUGPCODto ugDto = new DocumentosUGPCODto();
		// TODO - Recorrer las unidades de gestion para sacar los documentos asociados
		
		st = new StringTokenizer(uniGestionIds,",");
		Long idUG;
		while (st.hasMoreElements()){
			idUG = new Long(st.nextToken());
			ugsDto.addAll(datosPrueba2(idUG));
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
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {

		InformarDocumentoDto dto = new InformarDocumentoDto();
		dto.setEstado("test_estado");
		
		model.put("documento", dto);
		return INFORMAR_DOC;
	}	
	
	/**
	 * Incluir Documento
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String incluirDocumento(
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {

		IncluirDocumentoDto dto = new IncluirDocumentoDto();
		
		dto.setAsiento("test_asiento");
		dto.setFinca("test_finca");
		dto.setFolio("test_folio");
		dto.setIdufir("test_idufir");
		dto.setLibro("test_libro");
		dto.setNotario("test_notario");
		dto.setNumFinca("test_numfinca");
		dto.setNumRegistro("test_numRegistro");
		dto.setProtocolo("test_protocolo");
		dto.setTomo("test_tomo");
		
		// Lista tipo documentos
		listaTipoDocumentos = getTiposDocumento();
		
		// Lista Unidades Gestion
		listaUG = getUnidadesGestion();
		
		model.put("tiposDocumento", listaTipoDocumentos);
		model.put("unidadesGestion", listaUG);
		
		model.put("dtoDoc", dto);
		
		return INCLUIR_DOC;
	}
	
	/**
	 * Editar Documento
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarDocumento(
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {

		SolicitudPCODto solDto = new SolicitudPCODto();
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		// Averiguamos el dto de solicitud para de ahi sacar el id del documento
		for (SolicitudPCODto sol : solicitudes) {
			if (sol.getId().equals(idSolicitud))
				solDto = sol;
			
				// Averiguamos el documento a editar
				for (DocumentoPCODto doc : documentos) {
					if (doc.getId().equals(solDto.getIdDoc()))
						docDto = doc;
				}
		}
		
		model.put("dtoDoc", docDto);
		
	
		
		return EDITAR_DOC;
	}
	
	/**
	 * Crear Solicitudes
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String crearSolicitudes(@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {
		
		logger.error(".............idSolicitud: "+idSolicitud);
		
		SolicitudPCODto solDto = new SolicitudPCODto();
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		// Averiguamos el dto de solicitud para de ahi sacar el id del documento
		for (SolicitudPCODto sol : solicitudes) {
			if (sol.getId().equals(idSolicitud))
				solDto = sol;
			
				// Averiguamos el documento a editar
				for (DocumentoPCODto doc : documentos) {
					if (doc.getId().equals(solDto.getIdDoc()))
						docDto = doc;
				}
		}
		
		model.put("dtoDoc", docDto);
		
		return CREAR_SOLICITUDES;
	}	
	
	/**
	 * Excluir Documentos
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String excluirDocumentos(
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {
		Long idDoc = new Long(0);
		SolicitudPCODto solDto = new SolicitudPCODto();
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		// Averiguamos el dto de solicitud para de ahi sacar el id del documento
		for (SolicitudPCODto sol : solicitudes) {
			if (sol.getId().equals(idSolicitud))
				solDto = sol;
			
				// Averiguamos el documento a excluir
				for (DocumentoPCODto doc : documentos) {
					if (doc.getId().equals(solDto.getIdDoc()))
						docDto = doc;
				}
		}
		
		// Aqui ya tenemos los datos del documento a exlcuir
		// Hay que borrar el documento --> antes guardamos el id
		idDoc = docDto.getId();
		documentos.remove(docDto);
		 
		// Hay borrar las solicitudes de ese documento
//		logger.error("............solicitudes.size-antes for: "+solicitudes.size());
//		int indexSol = 0;
//		int indexSolOK;
//		for (SolicitudPCODto sol : solicitudes) {
//			logger.error("............idSolicitud-2-2-sol.getIdDoc(): "+sol.getIdDoc());
//			if (sol.getIdDoc().equals(idDoc)) {
//				logger.error("............idSolicitud-2-3: "+idSolicitud);
//				solDto = sol;
//				indexSolOK = indexSol;
//				logger.error("............indexSolOK: "+indexSolOK);
//				solicitudes.remove(indexSolOK);
//
//				logger.error("............solicitudes.size-despues remove: "+solicitudes.size());
//				logger.error("............idSolicitud-2-4: "+idSolicitud);				
//			}
//			indexSol++;
//		}
		
		// Construimos el DTO
		crearSolicitudDocumentosDto();
		
		model.put("solicitudesDocumento", solicitudesDoc);
		
		return SOLICITUDES_DOC_PCO_JSON;
	}
	
	/**
	 * Descartar Documentos
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String descartarDocumentos(
			@RequestParam(value = "idSolicitud", required = true) Long idSolicitud, 
			ModelMap model) {
		Long idDoc = new Long(0);
		SolicitudPCODto solDto = new SolicitudPCODto();
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		// Averiguamos el documento a editar
		int indexOK = 0;
		int index;
		// Averiguamos el dto de solicitud para de ahi sacar el id del documento
		for (SolicitudPCODto sol : solicitudes) {
			if (sol.getId().equals(idSolicitud))
				solDto = sol;
			
				// Averiguamos el documento a excluir
				index = 0;			
				for (DocumentoPCODto doc : documentos) {
					if (doc.getId().equals(solDto.getIdDoc())){
						docDto = doc;
						indexOK = index;
					}
					index++;
				}
		}

		docDto.setEstado("Descartado");
		documentos.set(indexOK, docDto);
		
		// Construimos el DTO del grid principal con los nuevos datos
		crearSolicitudDocumentosDto();

		return DEFAULT;
	}	
	
	/**
	 * Actualizar Documento
	 * 
	 * @param idSolicitud
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String updateDocumentos(WebRequest webRequest,ModelMap model) {

		Long idDoc = new Long(webRequest.getParameter("id"));
		SolicitudPCODto solDto = new SolicitudPCODto();
		DocumentoPCODto docDto = new DocumentoPCODto();
		
		// Averiguamos el documento a editar
		int index = 0;
		int indexOK = 0;
		for (DocumentoPCODto doc : documentos) {
			
			if (doc.getId().equals(idDoc)) {
				docDto = doc;
				indexOK = index;
			}
			index++;
		}
		
		// Actualizamos el docDto con los valores de la edicion
		docDto.setProtocolo(webRequest.getParameter("protocolo"));
		docDto.setNotario(webRequest.getParameter("notario"));
		//docDto.setFechaEscritura(webRequest.getParameter("fechaEscritura"));
		docDto.setAsiento(webRequest.getParameter("asiento"));
		docDto.setFinca(webRequest.getParameter("finca"));
		docDto.setTomo(webRequest.getParameter("tomo"));
		docDto.setLibro(webRequest.getParameter("libro"));
		docDto.setFolio(webRequest.getParameter("folio"));
		docDto.setNumFinca(webRequest.getParameter("numFinca"));
		docDto.setNumRegistro(webRequest.getParameter("numRegistro"));
		//docDto.setPlaza(webRequest.getParameter("plaza"));
		docDto.setIdufir(webRequest.getParameter("idufir"));
		
		documentos.set(indexOK, docDto);
				
		// Construimos el DTO del grid principal con los nuevos datos
		crearSolicitudDocumentosDto();
		
		model.put("solicitudesDocumento", solicitudesDoc);
			
		return SOLICITUDES_DOC_PCO_JSON;
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
		String idDoc = request.getParameter("id");
		// La cadena viene con formato [1,2,...] - Quitaremos los corchetes para procesar esta cadena.
		arrayIdDocumentos = arrayIdDocumentos.substring(1, arrayIdDocumentos.length()-1);
		logger.error("arrayIdDocumentos: "+arrayIdDocumentos);
		logger.error("idDoc: "+idDoc);
			
		StringTokenizer st;
		DocumentoPCODto doc;
		
		// Tratamos los documentos a incluir
		// TODO - Recorrer las unidades de gestion para sacar los documentos asociados	
		st = new StringTokenizer(arrayIdDocumentos,",");
		Long idDocUG;
		while (st.hasMoreElements()){
			idDocUG = new Long(st.nextToken());			
			logger.error("idDocUG: "+idDocUG);
			
			doc = new DocumentoPCODto();
			
			// Por cada documento de UG elegido tenemos que crear un documento y una solicitud (vacia)	
			// CREAR DOCUMENTO
			
			// TODO - Temporal - Averiguar los valores de varios objetos
			// Descripcion de la UG - Nos llegan los codigos de los documento UG - A partir de ahí averiguar
			// la UG y su descripcion	
			logger.error(".............documentosUG: "+documentosUG);
			logger.error(".............listaUG: "+listaUG);
			logger.error(".............listaTipoDocumentos: "+listaTipoDocumentos);
			
			for (DocumentosUGPCODto docUG : documentosUG) {		
				logger.error(".............docUG.getId(): "+docUG.getId());				
				if (docUG.getId().equals(new Long(idDocUG))) {
					doc.setContrato(docUG.getContrato());
					doc.setDescripcionUG(docUG.getDescripcionUG());
					
					// A partir del id de la unidad de gestion, sacar la descripcion
					for (DDTipoEntidad tipoUG : listaUG) {	
						logger.error(".............tipoUG.getId(): "+tipoUG.getId());
						if (tipoUG.getId().equals(docUG.getUnidadGestionId())){							
							doc.setTipoUG(tipoUG.getDescripcion());
						}
							
					}
				}
			}
			
			logger.error(".......................comboTipoDocumento: "+request.getParameter("comboTipoDocumento"));
			// Obtener la descripcion del Tio de Documento
			for (DDTipoDocumento tipoDoc : listaTipoDocumentos) {
				if (tipoDoc.getId().equals(new Long(request.getParameter("comboTipoDocumento")))){
					doc.setTipoDocumento(tipoDoc.getDescripcion());
				}
			}
				
			
			doc.setId(new Long(lastKeyDocumentos+""));
logger.error("lastKeyDocumentos: "+lastKeyDocumentos);				
			doc.setIdProc(new Long(1));
			doc.setEstado("Disponible");
			doc.setAdjunto("No");
			doc.setComentario("");
			doc.setAsiento(request.getParameter("asiento"));
			doc.setFinca(request.getParameter("finca"));
			doc.setFolio(request.getParameter("folio"));
			doc.setIdufir(request.getParameter("idufir"));
			doc.setLibro(request.getParameter("libro"));
			doc.setNotario(request.getParameter("notario"));
			doc.setNumFinca(request.getParameter("numFinca"));
			doc.setNumRegistro(request.getParameter("numRegistro"));
			doc.setProtocolo(request.getParameter("protocolo"));
			doc.setTomo(request.getParameter("tomo"));
			
			documentos.add(doc);
			lastKeyDocumentos++;
	logger.error("Antes crear solicitud");			
			// CREAR SOLICITUD
			SolicitudPCODto sol;
			
			sol = new SolicitudPCODto();		
			sol.setId(new Long(lastKeySolicitudes));
			sol.setIdDoc(new Long(doc.getId()));
			//sol.setActor("Archivo");
			//sol.setFechaSolicitud(new Date());
			//sol.setFechaResultado(new Date());
			//sol.setFechaEnvio(new Date());
			//sol.setFechaRecepcion(new Date());
			sol.setResultado("");
			
			solicitudes.add(sol);
			lastKeySolicitudes++;
		}

		logger.error("ya creado doc y sol ");
		// Construimos el DTO del grid principal con los nuevos datos
		crearSolicitudDocumentosDto();
		
		model.put("solicitudesDocumento", solicitudesDoc);
			
		return SOLICITUDES_DOC_PCO_JSON;
	}
	
	/**
	 * Salvar la creacion de solicitudes
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping	
	private String saveCrearSolicitudes(WebRequest request ,ModelMap model) {
		SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String idDoc = request.getParameter("id");
		logger.error("Antes crear solicitud");
		
		String fechaSolicitud = request.getParameter("fechaSolicitud");
		Date fechaSolicitudDate = null;

		try {
			fechaSolicitudDate = webDateFormat.parse(fechaSolicitud);
		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
			return DEFAULT;
		}
		
		// CREAR SOLICITUD
		SolicitudPCODto sol;
			
		sol = new SolicitudPCODto();		
		sol.setId(new Long(lastKeySolicitudes));
		sol.setIdDoc(new Long(idDoc));
		sol.setActor(request.getParameter("actor"));
		sol.setFechaSolicitud(fechaSolicitudDate);
		sol.setResultado("Pendiente Resultado");
			
		solicitudes.add(sol);
		lastKeySolicitudes++;
		
		logger.error("ya creado la solicitud ");
		// Construimos el DTO del grid principal con los nuevos datos
		crearSolicitudDocumentosDto();
		
		model.put("solicitudesDocumento", solicitudesDoc);
			
		return SOLICITUDES_DOC_PCO_JSON;
	}		
	
	/**
	 * Tipos de Documento
	 * @param model
	 * @return
	 */
	@RequestMapping
	private List<DDTipoDocumento> getTiposDocumento() {
		
		List<DDTipoDocumento> listaTipoDoc = new ArrayList<DDTipoDocumento>();
		DDTipoDocumento tipoDoc =new DDTipoDocumento();
		tipoDoc.setId(new Long(1));
		tipoDoc.setCodigo("1");
		tipoDoc.setDescripcion("Tipo doc 1");
		listaTipoDoc.add(tipoDoc);
		
		tipoDoc = new DDTipoDocumento();
		tipoDoc.setId(new Long(2));
		tipoDoc.setCodigo("2");
		tipoDoc.setDescripcion("Tipo doc 2");
		listaTipoDoc.add(tipoDoc);

		return listaTipoDoc;
	}
	
	/**
	 * Unidades de Gestion
	 * @param model
	 * @return
	 */
	@RequestMapping
	private List<DDTipoEntidad> getUnidadesGestion() {
		
		List<DDTipoEntidad> listaTipoEnt = new ArrayList<DDTipoEntidad>();
		DDTipoEntidad tipoEnt =new DDTipoEntidad();
		tipoEnt.setId(new Long(1));
		tipoEnt.setCodigo("1");
		tipoEnt.setDescripcion("Contrato");
		listaTipoEnt.add(tipoEnt);
		
		tipoEnt = new DDTipoEntidad();
		tipoEnt.setId(new Long(2));
		tipoEnt.setCodigo("2");
		tipoEnt.setDescripcion("Persona");
		listaTipoEnt.add(tipoEnt);
		
		tipoEnt = new DDTipoEntidad();
		tipoEnt.setId(new Long(3));
		tipoEnt.setCodigo("3");
		tipoEnt.setDescripcion("Bien");
		listaTipoEnt.add(tipoEnt);		

		return listaTipoEnt;
	}	
		
	
	
	public List<DocumentosUGPCODto> datosPrueba2 (Long idUG){
		
		List<DocumentosUGPCODto> datos = new ArrayList<DocumentosUGPCODto>();
		List<DocumentosUGPCODto> datosSinFiltrar = new ArrayList<DocumentosUGPCODto>();
		DocumentosUGPCODto dato = new DocumentosUGPCODto();
		
		dato.setId(new Long(1));
		dato.setUnidadGestionId(new Long(1));
		dato.setContrato("1234 56789 012345");
		dato.setDescripcionUG("PRESTECS");
		
		if (dato.getUnidadGestionId().equals(idUG))
			datos.add(dato);
		
		datosSinFiltrar.add(dato);
		
		dato = new DocumentosUGPCODto();
		
		dato.setId(new Long(2));
		dato.setUnidadGestionId(new Long(2));
		dato.setContrato("2438457R");
		dato.setDescripcionUG("AMALIO LAZARO NOCEDO");
		
		if (dato.getUnidadGestionId().equals(idUG))
			datos.add(dato);
		
		datosSinFiltrar.add(dato);
		
		dato = new DocumentosUGPCODto();
		
		
		dato.setId(new Long(3));
		dato.setUnidadGestionId(new Long(3));
		dato.setContrato("Finca 223254");
		dato.setDescripcionUG("Madrid - Madrid- C/Denia 50 6");
		
		if (dato.getUnidadGestionId().equals(idUG))
			datos.add(dato);
		
		datosSinFiltrar.add(dato);
		
		documentosUG = datosSinFiltrar;
		
		return datos;
	}
	
	public List<DocumentoPCODto> datosDocumentos(){
		List<DocumentoPCODto> docs = new ArrayList<DocumentoPCODto>();
		DocumentoPCODto doc;
		
		doc = new DocumentoPCODto();
		doc.setId(new Long(1));
		doc.setIdProc(new Long(1));
		doc.setTipoUG("Contrato");
		doc.setContrato("1234 4667 1234567890");
		doc.setDescripcionUG("PRESTECS");
		doc.setTipoDocumento("Estructura Hipotecaria");
		doc.setEstado("Disponible");
		doc.setAdjunto("Si");
		doc.setComentario("test1_coment1");
		doc.setAsiento("test1_asiento");
		doc.setFinca("test1_finca");
		doc.setFolio("test1_folio");
		doc.setIdufir("test1_idufir");
		doc.setLibro("test1_libro");
		doc.setNotario("test1_notario");
		doc.setNumFinca("test1_numfinca");
		doc.setNumRegistro("test1_numRegistro");
		doc.setProtocolo("test1_protocolo");
		doc.setTomo("test1_tomo");
		
		docs.add(doc);
		
		doc = new DocumentoPCODto();
		doc.setId(new Long(2));
		doc.setTipoUG("Contrato");	
		doc.setIdProc(new Long(1));
		doc.setContrato("1234 4667 1234567890");
		doc.setDescripcionUG("PRESTECS");
		doc.setTipoDocumento("Garantia Pignorable");
		doc.setEstado("Disponible");
		doc.setAdjunto("Si");
		doc.setComentario("test2_coment1");
		doc.setAsiento("test2_asiento");
		doc.setFinca("test2_finca");
		doc.setFolio("test2_folio");
		doc.setIdufir("test2_idufir");
		doc.setLibro("test2_libro");
		doc.setNotario("test2_notario");
		doc.setNumFinca("test2_numfinca");
		doc.setNumRegistro("test2_numRegistro");
		doc.setProtocolo("test2_protocolo");
		doc.setTomo("test2_tomo");
		
		docs.add(doc);
		
		doc = new DocumentoPCODto();
		doc.setId(new Long(3));
		doc.setTipoUG("Persona");	
		doc.setIdProc(new Long(1));
		doc.setContrato("20412587G");
		doc.setDescripcionUG("EMILIO PEREZ SANCHEZ");
		doc.setTipoDocumento("Certificado de Deuda");
		doc.setEstado("Descartado");
		doc.setAdjunto("No");
		doc.setComentario("test3_coment1");
		doc.setAsiento("test3_asiento");
		doc.setFinca("test3_finca");
		doc.setFolio("test3_folio");
		doc.setIdufir("test3_idufir");
		doc.setLibro("test3_libro");
		doc.setNotario("test3_notario");
		doc.setNumFinca("test3_numfinca");
		doc.setNumRegistro("test3_numRegistro");
		doc.setProtocolo("test3_protocolo");
		doc.setTomo("test3_tomo");
		
		docs.add(doc);
		
		doc = new DocumentoPCODto();
		doc.setId(new Long(4));
		doc.setTipoUG("Bien");	
		doc.setIdProc(new Long(1));
		doc.setContrato("Finca 374643");
		doc.setDescripcionUG("Madrid - Madrid - Calle Alcala, 24");
		doc.setTipoDocumento("Certificado de Deuda");
		doc.setEstado("Solicitado");
		doc.setAdjunto("No");
		doc.setComentario("test4_coment1");
		doc.setAsiento("test3_asiento");
		doc.setFinca("test4_finca");
		doc.setFolio("test4_folio");
		doc.setIdufir("test4_idufir");
		doc.setLibro("test4_libro");
		doc.setNotario("test4_notario");
		doc.setNumFinca("test4_numfinca");
		doc.setNumRegistro("test4_numRegistro");
		doc.setProtocolo("test4_protocolo");
		doc.setTomo("test4_tomo");
		
		docs.add(doc);
			
		return docs;
	}
	
	public List<SolicitudPCODto> datosSolicitudes(){
		List<SolicitudPCODto> sols = new ArrayList<SolicitudPCODto>();
		SolicitudPCODto sol;
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(1));
		sol.setIdDoc(new Long(1));
		sol.setActor("Archivo");
		sol.setFechaSolicitud(new Date());
		sol.setFechaResultado(new Date());
		sol.setFechaEnvio(new Date());
		sol.setFechaRecepcion(new Date());
		sol.setResultado("OK");
		
		sols.add(sol);
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(2));
		sol.setIdDoc(new Long(2));
		sol.setActor("Gestoria");
		sol.setFechaSolicitud(new Date());
		sol.setFechaResultado(new Date());
		sol.setFechaEnvio(new Date());
		sol.setFechaRecepcion(new Date());
		sol.setResultado("OK");
		
		sols.add(sol);		
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(3));
		sol.setIdDoc(new Long(2));
		sol.setActor("Archivo");
		sol.setFechaSolicitud(new Date());
		sol.setFechaResultado(new Date());
		//sol.setFechaEnvio(new Date());
		//sol.setFechaRecepcion(new Date());
		sol.setResultado("Documento no encontrado");
		
		sols.add(sol);	
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(4));
		sol.setIdDoc(new Long(2));
		sol.setActor("Archivo");
		sol.setFechaSolicitud(new Date());
		sol.setFechaResultado(new Date());
		//sol.setFechaEnvio(new Date());
		//sol.setFechaRecepcion(new Date());
		sol.setResultado("Falta informacion");
		
		sols.add(sol);	
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(5));
		sol.setIdDoc(new Long(3));
		sol.setActor("Gestoria");
		//sol.setFechaSolicitud(new Date());
		//sol.setFechaResultado(new Date());
		//sol.setFechaEnvio(new Date());
		//sol.setFechaRecepcion(new Date());
		//sol.setResultado("OK");
		
		sols.add(sol);	
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(6));
		sol.setIdDoc(new Long(4));
		sol.setActor("Oficina");
		sol.setFechaSolicitud(new Date());
		//sol.setFechaResultado(new Date());
		//sol.setFechaEnvio(new Date());
		//sol.setFechaRecepcion(new Date());
		//sol.setResultado("OK");
		
		sols.add(sol);	
		
		sol = new SolicitudPCODto();		
		sol.setId(new Long(7));
		sol.setIdDoc(new Long(4));
		sol.setActor("Archivo");
		sol.setFechaSolicitud(new Date());
		//sol.setFechaResultado(new Date());
		//sol.setFechaEnvio(new Date());
		sol.setFechaRecepcion(new Date());
		sol.setResultado("Documento no encontrado");
		
		sols.add(sol);		
		
		return sols;
	}

	
	

 }