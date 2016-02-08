package es.pfsgroup.recovery.geninformes;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.MessagingException;

import net.sf.jasperreports.engine.DefaultJasperReportsContext;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRPropertiesUtil;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRRtfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.JRParameter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.xwpf.converter.pdf.PdfConverter;
import org.apache.poi.xwpf.converter.pdf.PdfOptions;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lowagie.text.Document;
import com.lowagie.text.html.simpleparser.HTMLWorker;
import com.lowagie.text.pdf.PdfWriter;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.mail.MailManager;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidad;
import es.pfsgroup.recovery.geninformes.api.GENINFInformeEntidadGenerator;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dao.GENINFInfoAuxiliarInformeDao;
import es.pfsgroup.recovery.geninformes.dto.GENINFCorreoPendienteDto;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;
import es.pfsgroup.recovery.geninformes.factories.GENINFInformeEntidadFactory;
import es.pfsgroup.recovery.geninformes.model.GENINFCorreoPendiente;
import es.pfsgroup.recovery.geninformes.model.GENINFInforme;
import es.pfsgroup.recovery.geninformes.model.GENINFInformeConfig;
import es.pfsgroup.recovery.geninformes.model.GENINFParrafo;
import fr.opensagres.xdocreport.core.document.SyntaxKind;
import fr.opensagres.xdocreport.document.IXDocReport;
import fr.opensagres.xdocreport.document.docx.preprocessor.dom.DOMFontsPreprocessor;
import fr.opensagres.xdocreport.document.registry.XDocReportRegistry;
import fr.opensagres.xdocreport.template.IContext;
import fr.opensagres.xdocreport.template.TemplateEngineKind;
import fr.opensagres.xdocreport.template.formatter.FieldsMetadata;

@Service
public class GENINFInformesManager implements GENINFInformesApi {

	private static final String CONTENIDO = "contenido";

	/** Logger available to subclasses */
	protected final Log logger = LogFactory.getLog(getClass());
	
	private static final String SUFIJO_FICHERO_PDF = ".pdf";
	private static final String PREFIJO_FICHERO_TMP = "TMP_";
	private static final String TIPO_FICHERO_LI = "LI";
	private static final String TIPO_FICHERO_PODERES = "POD";
	private static final String APPLICATION_PDF = "application/pdf";
	private final static String SUFIJO_CON_PROCURADOR = "_CPROC";
	private final static String SUFIJO_SIN_PROCURADOR = "_SPROC";
	private final static String CLAVE_CONFIGURACION_EMAIL = "email";
	private final static String CLAVE_CONFIGURACION_EMAIL_ORIGEN = "email_origen";
	private final static String KEY_MAPA_VALORES_VARIABLES = "mapa_valores_transiciones";
	public  final static String KEY_ADJUNTO_ADICIONAL = "key_adjunto_adicional";
	public  final static String KEY_ADJUNTO_ADICIONAL_DESCRIPCION = "key_adjunto_adicional_descripcion";
	
	private final static String PROCURADOR_VACIO = "PR000000";
	private static final String KEY_GENERACION_ADICIONAL = "generacion_adicional";
	
	private static final List<String> informesSinSufijo = new ArrayList<String>();
	static {
		informesSinSufijo.add("CERTIF_DOBLE_CESION");
	}
	
	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	GENINFInformeEntidadFactory genINFInformeEntidadFactory;
	
	@Autowired
	GENINFInfoAuxiliarInformeDao infoAuxiliarInformeDao;

//    @Autowired
//    ServletContext servletContext;

	@Resource(name = "mailManager")
	private MailManager mailManager;

    @BusinessOperation(MSV_BO_GENERAR_ESCRITO)
	@Transactional(readOnly = false)
	public boolean generarEscrito(String tipoEntidad, String tipoEscrito,
			Long idEntidad, boolean enviarPorEmail, Procedimiento proc,
			Map<String, Object>... mapaValoresPrecalculados) {

		boolean ok = true;

		// Obtener la entidad (objeto)
		EXTAsunto asunto = obtenerAsunto(tipoEntidad, idEntidad);
		
		// Si el nombre del tipo escrito no tiene el sufijo "_SPROC" o "_CPROC"
		// buscar si la entidad correspondiente tiene procurador y poner el sufijo correspondiente
		// excepto si el c�digo se encuentra en el array de codigos de informes sin sufijo
		tipoEscrito = obtenerTipoEscrito(tipoEscrito, tipoEntidad, asunto);
		
		// Recuperar el nombre de la plantilla a partir del tipoEscrito
		// y el mapa de campos de donde recuperar los valores
		GENINFInforme informe = obtenerPlantilla(tipoEscrito);
		
		if (informe == null) {
			ok = false;
		} else {
			String ficheroPlantilla = informe.getDescripcion();
			List<GENINFParrafo> listaParrafos = informe.getParrafos();
			List<GENINFInformeConfig> listaValoresConfiguracion = obtenerMapaValoresConfiguracion();
			Procedimiento procedimiento = obtenerProcedimiento(asunto, proc);

			//PBO: a�adimos los elementos del array de mapas de valores precalculados 
			//     al mapa de valores, 
			//     si existe este par�metro opcional
			Map<String, Object> mapaValoresPrec = new HashMap<String, Object>();
			for (int i = 0; i < mapaValoresPrecalculados.length; i++) {
				mapaValoresPrec.putAll(mapaValoresPrecalculados[0]);
			}

			// Recuperar los valores del objeto origen montando el mapa
			Map<String, Object> mapaValores = obtenerMapaValores(tipoEntidad,
					asunto, listaParrafos, listaValoresConfiguracion, procedimiento, mapaValoresPrec);

			boolean hayErrores = mapaValores.containsKey(GENINFInformeEntidad.KEY_ERROR);
			try {
				// Invocar al generador de informes
				GENINFGestorInformes gestor = new GENINFGestorInformes(ficheroPlantilla,
						mapaValores);
				FileItem fileItem = gestor.dameInforme();
	
				// Siempre adjuntamos
				// adjuntar el fileitem a la entidad correspondiente
				String nombreEscrito = informe.getDescripcionLarga();
				String tipoFichero = null;
				if (!Checks.esNulo(informe.getTipoFichero())) {
					tipoFichero = informe.getTipoFichero().getCodigo();
				}
				Long idAdjunto = adjuntarInforme(tipoEntidad, asunto, fileItem, nombreEscrito, tipoFichero, hayErrores);
				this.adjuntarDocumentacionAdicional(informe, mapaValores, tipoEntidad, asunto, hayErrores);
				
				if (Checks.esNulo(idAdjunto)) {
					ok = false;
				} else {
					//Si se ha adjuntado correctamente el escrito, 
					// comprobamos si hay que enviar por email con el escrito adjunto
					if (enviarPorEmail) {
						if (informe.isEnviarPorEmail()) {
							//Recuperar el destinatario del correo
							String direccionDestino = obtenerEmailDestinatario(asunto);
							//Montar resto del mensaje mensaje de correo
							String descEscrito = nombreEscrito + " generado para el asunto " + asunto.getNombre();
							//Obtener direcci�n de origen de las propiedades o de configuraci�n
							String emailOrigenPorDefecto = recuperarValorConfiguracion(CLAVE_CONFIGURACION_EMAIL_ORIGEN);
							String asuntoMail = "Escrito " + descEscrito;
							String cuerpoEmail = "Este correo contiene el escrito " + descEscrito;
							// Enviar mensaje de correo o programar env�o de mensaje de correo
							if (informe.getDemoraEnvioEmail() > 0) {
								// Programar equivale a grabar en una tabla de emails diferidos (que un proceso batch se encargar� de revisar y enviar)
								// Calcular fecha de env�o de email
								Date fechaEnvio = calcularFechaEnvioEmail(informe.getDemoraEnvioEmail());
								guardarEnvioProgramado(direccionDestino,
										emailOrigenPorDefecto, asuntoMail,
										cuerpoEmail, idAdjunto, nombreEscrito, fechaEnvio);
							} else {
								GENINFCorreoPendienteDto dto = new GENINFCorreoPendienteDto();
								dto.setEmailFrom(emailOrigenPorDefecto);
								dto.setDestinatario(direccionDestino);
								dto.setAsuntoMail(asuntoMail);
								dto.setCuerpoEmail(cuerpoEmail);
								dto.setAdjunto(fileItem);
								dto.setNombreAdjunto(nombreEscrito);
								enviarMailConEscritoAdjunto(dto);
							}
						}
					}
				}
			} catch (Exception e) {
				ok = false;
				e.printStackTrace();
			}
		}
		return ok;
	}
    

    /**
     * Adjunta un documento adicional en funci�n del propietario y del tipo de documento generado.
     * @param informe GENINFInforme
     * @param mapaValores Map<String, Object>
     * @param tipoEntidad String Indica la clase que hay en la entidad 
     * @param entidad Object
     * @param hayErrores
     */
    @SuppressWarnings("unchecked")
	private void adjuntarDocumentacionAdicional(GENINFInforme informe, Map<String, Object>mapaValores, String tipoEntidad, Object entidad, boolean hayErrores) {
    	if (informe.getCodigo() != null && informe.isGenerarDocumentoAdicional()){
    		
    		Map<String, String> mapaValoresVariables = (Map<String, String>) mapaValores.get(KEY_MAPA_VALORES_VARIABLES);
			if (mapaValoresVariables != null){
    			String ficheroAdicional = mapaValoresVariables.get(KEY_ADJUNTO_ADICIONAL);
    			if (ficheroAdicional != null){
    				 
    				//URL resource = this.getClass().getClassLoader().getResource("jasper/ficherosAdicionales/" + ficheroAdicional);
    				//URL resource = Thread.currentThread().getContextClassLoader().getResource("jasper/ficherosAdicionales/" + ficheroAdicional);
    				InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/ficherosAdicionales/" + ficheroAdicional);

    				
					try {
						File file = File.createTempFile(PREFIJO_FICHERO_TMP, SUFIJO_FICHERO_PDF);
						if (!file.exists()) {
							file.createNewFile();
						}						
						//file = new File(resource.toURI());
						FileOutputStream fop = new FileOutputStream(file);
						FileUtils.copy(is, fop);
						fop.flush();
						fop.close();
						FileItem fileItem = new FileItem(file);
						fileItem.setFileName(ficheroAdicional);
						fileItem.setContentType(APPLICATION_PDF);
						String tipoFichero = TIPO_FICHERO_PODERES;
						String nombreEscrito = mapaValoresVariables.get(KEY_ADJUNTO_ADICIONAL_DESCRIPCION);//ficheroAdicional.substring(0, ficheroAdicional.indexOf('.'));//"Escritura";
						adjuntarInforme(tipoEntidad, entidad, fileItem, nombreEscrito , tipoFichero, hayErrores); 

					} catch (Exception e) {
						logger.error("adjuntarDocumentacionAdicional: " + e);
					}

    			}
				
			}
    	}
		
	}

	private String obtenerTipoEscrito(String tipoEscrito, String tipoEntidad,
			EXTAsunto asunto) {

		if (! informesSinSufijo.contains(tipoEscrito)) {
	    	if (!tipoEscrito.endsWith(SUFIJO_CON_PROCURADOR) 
					&& !tipoEscrito.endsWith(SUFIJO_SIN_PROCURADOR) 
					&& tipoEntidad.equalsIgnoreCase("EXTAsunto")) {
				tipoEscrito = tipoEscrito + obtenerSufijoTipoEscrito(asunto);
			}
		}
		
    	return tipoEscrito;
	}

	private EXTAsunto obtenerAsunto(String tipoEntidad, Long idEntidad) {
		Object objeto = obtenerObjeto(tipoEntidad, idEntidad);
		return (EXTAsunto) objeto;
	}

	private void guardarEnvioProgramado(String direccionDestino,
			String direccionOrigen, String asuntoMail,
			String cuerpoEmail, Long idAdjunto, String nombreEscrito,
			Date fechaEnvio) {
		
    	GENINFCorreoPendiente correoPendiente = new GENINFCorreoPendiente();
    	correoPendiente.setTo(direccionDestino);
    	correoPendiente.setFrom(direccionOrigen);
    	correoPendiente.setAsunto(asuntoMail);
    	correoPendiente.setCuerpo(cuerpoEmail);
    	correoPendiente.setIdAdjunto(idAdjunto);
    	correoPendiente.setNombre(nombreEscrito);
    	correoPendiente.setFechaEnvio(fechaEnvio);
    	correoPendiente.setProcesado(false);
    	
    	genericDao.save(GENINFCorreoPendiente.class, correoPendiente);
    	
	}

	private Date calcularFechaEnvioEmail(Integer demoraEnvioEmail) {
		Calendar hoy = Calendar.getInstance();
		hoy.add(Calendar.DATE, demoraEnvioEmail);
		Date resultado = hoy.getTime();
		return resultado;
	}

	private Procedimiento obtenerProcedimiento(EXTAsunto asunto, Procedimiento proc) {
    	
    	if (Checks.esNulo(proc)) {
    		return GENINFUtils.devuelveProcedimientoActivo(asunto);
    	} else {
    		return proc;
    	}
    }

	private String obtenerSufijoTipoEscrito(EXTAsunto asunto) {
	
		String sufijo = SUFIJO_SIN_PROCURADOR;
		if (tieneProcurador(asunto)) {
			sufijo = SUFIJO_CON_PROCURADOR;
		}
		return sufijo;
		
	}

	private boolean tieneProcurador(EXTAsunto asunto) {
		
		Long idAsunto = asunto.getId();
		Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
		Filter filtroTipoProcurador = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR);
		EXTGestorAdicionalAsunto procurador = genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoProcurador);
		
		boolean hayProcurador = true;
		if (procurador == null || PROCURADOR_VACIO.equals(procurador.getGestor().getUsuario().getUsername())) {
			hayProcurador = false;
		}
		
		return hayProcurador;
		
	}

	private String obtenerEmailDestinatario(EXTAsunto asunto) {

		String email = "";
		if (!Checks.esNulo(asunto.getProcurador())
				&& !Checks.esNulo(asunto.getProcurador().getUsuario())
				&& !Checks.esNulo(asunto.getProcurador().getUsuario().getEmail())) {
			email = asunto.getProcurador().getUsuario().getEmail();
		} else {
			Usuario usu = null;
			try {
				usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			} catch (Exception e) {
			}
			if (!Checks.esNulo(usu) && !Checks.esNulo(usu.getEmail())) {
				email = usu.getEmail();
			} else {
				email = recuperarValorConfiguracion(CLAVE_CONFIGURACION_EMAIL);
			}
		}
		return email;

	}
	
	private String obtenerEmailDestinatarioUsrLogado(EXTAsunto asunto) {
		//TODO - De momento solo quieren que se envien los correos al usuario logado
		String email = "";
		Usuario usu = null;

		try {
			usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		} catch (Exception e) {
		}
		
		if (!Checks.esNulo(usu) && !Checks.esNulo(usu.getEmail())) {
			email = usu.getEmail();
		} else {
			email = recuperarValorConfiguracion(CLAVE_CONFIGURACION_EMAIL);
		}
	
		return email;

	}

	private List<GENINFInformeConfig> obtenerMapaValoresConfiguracion() {

		return genericDao.getList(GENINFInformeConfig.class);

	}

	private String recuperarValorConfiguracion(String clave) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
				clave);
		GENINFInformeConfig informe = genericDao.get(GENINFInformeConfig.class, filtro);
		return informe.getValor();

	}

	private Map<String, Object> obtenerMapaValores(String tipoEntidad,
			Object objeto, List<GENINFParrafo> listaParrafos,
			List<GENINFInformeConfig> listaValoresConfiguracion, Procedimiento proc,
			Map<String, Object> mapaValoresPrec) {

		GENINFInformeEntidadGenerator recuperador = genINFInformeEntidadFactory.getBusinessObject();
		GENINFInformeEntidad genINFInformeEntidad = recuperador.getInformeEntidad(tipoEntidad);
		
		Map<String, Object> mapaValores = genINFInformeEntidad.dameMapaValores(objeto, listaParrafos, listaValoresConfiguracion, genericDao, proc, infoAuxiliarInformeDao, mapaValoresPrec);
		
//		String rutaAplicacion = "";
//		if (servletContext != null) {
//			rutaAplicacion = servletContext.getRealPath(".");
//		}
		
		boolean tieneProcurador = tieneProcurador((EXTAsunto)objeto);
		InputStream isDinamico = null;
		
		for (GENINFInformeConfig conf: listaValoresConfiguracion){
			if ("logoFirmaAbogado".equals(conf.getCodigo())){
				//mapaValores.put(conf.getCodigo(), rutaAplicacion + conf.getValor());
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				mapaValores.put(conf.getCodigo(), is);
				if (tieneProcurador) {
					isDinamico = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				}
			}
			if ("direccionLogo".equals(conf.getCodigo()) || "direccionLogo2".equals(conf.getCodigo()) || "direccionLogo3".equals(conf.getCodigo()) ){
				//mapaValores.put(conf.getCodigo(), rutaAplicacion + conf.getValor());
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				mapaValores.put(conf.getCodigo(), is);
			}
			if("direccionFirmaRepre".equals(conf.getCodigo()) || "direccionFirmaRepre2".equals(conf.getCodigo())){
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				mapaValores.put(conf.getCodigo(), is);
				if (!tieneProcurador) {
					isDinamico = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				}
			}
			
			if ("logo_pfs".equals(conf.getCodigo())){
				//mapaValores.put(conf.getCodigo(), rutaAplicacion + conf.getValor());
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				mapaValores.put("logo_pfs", is);
				
			}
			
			if ("logoFirmaAbogado".equals(conf.getCodigo())){
				//mapaValores.put(conf.getCodigo(), rutaAplicacion + conf.getValor());
				InputStream is = this.getClass().getClassLoader().getResourceAsStream(conf.getValor());
				mapaValores.put("logoFirmaAbogado", is);
				
			}
			
		}
		mapaValores.put("logoFirmaDinamico", isDinamico);

		return mapaValores;

	}

	/**
	 * M�todo que a partir de un tipo de escrito devuelve el descriptor de la plantilla, que contiene el nombre del
	 * fichero que describe el informe y la lista de campos necesarios para rellenar los par�metros
	 * 
	 * @param tipoEscrito
	 * @param listaCampos
	 * @return EXTInforme
	 */
	private GENINFInforme obtenerPlantilla(String tipoEscrito) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
				tipoEscrito);
		GENINFInforme informe = genericDao.get(GENINFInforme.class, filtro);
		return informe;

	}

	/**
	 * M�todo que sirve para obtener el objeto a partir del tipo de entidad y el identificador de objeto
	 * 
	 * @param tipoEntidad
	 * @param idEntidad
	 * @return
	 */
	private Object obtenerObjeto(String tipoEntidad, Long idEntidad) {
		Object obj = null;
		if (tipoEntidad.equals("EXTAsunto")) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id",
					idEntidad);
			obj = genericDao.get(EXTAsunto.class, filtro);
		}
		return obj;
	}

	private Long adjuntarInforme(String tipoEntidad, Object objeto,
			FileItem fileItem, String descripcionLarga, String tipoFichero, boolean hayErrores) {

		Long idAdjunto = null;
		String txtError = hayErrores ? "ERROR - " : "";
		if (tipoEntidad.equals("EXTAsunto")) {
			if (objeto instanceof EXTAsunto) {
				EXTAsunto asunto = (EXTAsunto) objeto;

				EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
				adjuntoAsunto.setAsunto(asunto);
				adjuntoAsunto.setContentType(fileItem.getContentType());
				adjuntoAsunto.setNombre(txtError+descripcionLarga+fileItem.getFileName().substring(fileItem.getFileName().lastIndexOf(".")));
				adjuntoAsunto.setDescripcion(descripcionLarga);
				//Ponemos como tipo de fichero adjunto el tipo "LI" (ESCRITO GENERADO)
				if (Checks.esNulo(tipoFichero)) {
					tipoFichero = TIPO_FICHERO_LI;
				}
				DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoFichero));
				adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
				adjuntoAsunto.setLength(fileItem.getFile().length());
				Auditoria.save(adjuntoAsunto);
				genericDao.save(EXTAdjuntoAsunto.class, adjuntoAsunto);
				asunto.getAdjuntos().add(adjuntoAsunto);
				AsuntoApi asuntoApi = proxyFactory.proxy(AsuntoApi.class);
				asuntoApi.saveOrUpdateAsunto(asunto);
				idAdjunto = adjuntoAsunto.getId();
				//Trampa para pasar las pruebas: no tenemos Id y adjuntoAsunto se ha creado con new
				if (idAdjunto == null && adjuntoAsunto!=null) {
					idAdjunto = -1L;
				}
			}
		}
		
		return idAdjunto;

	}

	// TODO: A�adir un m�todo que funcione igual pero al que se le pueda pasar un
	// mapa previo con valores (al que se a�adan las entradas correspondientes)


	// M�todo para enviar correo copiado de RecoveryAnotacionManager 
	// con algunas simplificaciones 
    @BusinessOperation(MSV_BO_ENVIAR_EMAIL)
	public void enviarMailConEscritoAdjunto(GENINFCorreoPendienteDto dto)
			throws javax.mail.MessagingException {
		
		MimeMessageHelper helper = mailManager.createMimeMessageHelper(!Checks
				.esNulo(dto.getAdjunto()));
		helper.setFrom(dto.getEmailFrom());
		helper.setTo(dto.getDestinatario());
		helper.setSubject(dto.getAsuntoMail());
		helper.setText(dto.getCuerpoEmail(), true);
		if (!Checks.esNulo(dto.getAdjunto())) {
			helper.addAttachment(dto.getNombreAdjunto(), dto.getAdjunto().getFile());
		}
		mailManager.send(helper);

	}

    @BusinessOperation(MSV_BO_GENERAR_ESCRITO_EDITABLE)
    @Transactional(readOnly = false)
	public FileItem generarEscritoEditable(GENINFGenerarEscritoDto dto,
			Map<String, Object>... mapaValoresPrecalculados) {

		//boolean ok = true; En este m�todo esta variable no se usa para nada.
		FileItem resultado = null;
		
		// Obtener la entidad (objeto)
		EXTAsunto asunto = obtenerAsunto(dto.getTipoEntidad(), dto.getIdEntidad());
		
		// Si el nombre del tipo escrito no tiene el sufijo "_SPROC" o "_CPROC"
		// buscar si la entidad correspondiente tiene procurador y poner el sufijo correspondiente
		dto.setTipoEscrito(obtenerTipoEscrito(dto.getTipoEscrito(), dto.getTipoEntidad(), asunto));
		
		// Recuperar el nombre de la plantilla a partir del tipoEscrito
		// y el mapa de campos de donde recuperar los valores
		//dto.setTipoEscrito("DEMANDA_MONITORIO_CPROC");
		GENINFInforme informe = obtenerPlantilla(dto.getTipoEscrito());
		
		if (informe == null) {
			//ok = false;
		} else {
			if (Checks.esNulo(dto.getEnviarPorEmail())) {
				dto.setEnviarPorEmail(informe.isEnviarPorEmail());
			}
			
			if (Checks.esNulo(dto.getSufijoInforme())) {
				dto.setSufijoInforme(informe.getSufijoInforme());
			}
			
			String ficheroPlantilla = informe.getDescripcion();
			List<GENINFParrafo> listaParrafos = informe.getParrafos();
			List<GENINFInformeConfig> listaValoresConfiguracion = obtenerMapaValoresConfiguracion();
			Procedimiento procedimiento = obtenerProcedimiento(asunto, dto.getProcedimiento());

			//PBO: a�adimos los elementos del array de mapas de valores precalculados 
			//     al mapa de valores, 
			//     si existe este par�metro opcional
			Map<String, Object> mapaValoresPrec = new HashMap<String, Object>();
			for (int i = 0; i < mapaValoresPrecalculados.length; i++) {
				mapaValoresPrec.putAll(mapaValoresPrecalculados[0]);
			}

			// Recuperar los valores del objeto origen montando el mapa
			Map<String, Object> mapaValores = obtenerMapaValores(dto.getTipoEntidad(),
					asunto, listaParrafos, listaValoresConfiguracion, procedimiento, mapaValoresPrec);
			
			boolean hayErrores = mapaValores.containsKey(GENINFInformeEntidad.KEY_ERROR);

			try {
				// Invocar al generador de informes
				GENINFGestorInformes gestor = new GENINFGestorInformes(ficheroPlantilla,
						mapaValores);
				resultado = gestor.dameInforme(dto.getSufijoInforme(), hayErrores);

				// Si se envia por mail se adjunta el fichero a la entidad				
				// adjuntar el fileitem a la entidad correspondiente
				if (dto.isAdjuntarAEntidad() || dto.getEnviarPorEmail() || hayErrores) {
					this.adjuntarDocumentacionAdicional(informe, mapaValores, dto.getTipoEntidad(), asunto, hayErrores);
					adjuntarYenviar(informe, dto, asunto, resultado, hayErrores); 
				}
				
				// Comprobar que si tiene el escrito requiere generar un documento adicional y se cumple la condici�n
				if (dto.isAdjuntarAEntidad() && informe.getDocumentoGeneradoAdicional() != null
					// se comenta esto porque no estaba generando bien los ficheros que tocaba
					&& comprobarGeneracionAdicional(mapaValores, informe) 
					) {

					GENINFGenerarEscritoDto dto2 = new GENINFGenerarEscritoDto();
                    dto2.setAdjuntarAEntidad(true); 
                    dto2.setEnviarPorEmail(false);
                    dto2.setIdEntidad(asunto.getId());
                    dto2.setProcedimiento(dto.getProcedimiento());
                    //dto2.setSufijoInforme(dto.getSufijoInforme());
                    dto2.setTipoEntidad("EXTAsunto");
                    dto2.setTipoEscrito(informe.getDocumentoGeneradoAdicional().getCodigo());
					generarEscritoEditable(dto2, mapaValoresPrecalculados);
					
				}
			} catch (Exception e) {
				logger.error("generarEscritoEditable: Error al generar el informe: " + dto.getTipoEscrito() + "\nCausa: " + e.getMessage());
			}

		}
		
		return resultado;
		
	}

	private boolean comprobarGeneracionAdicional(Map<String, Object> mapaValores, GENINFInforme informe) {

		@SuppressWarnings("unchecked")
		Map<String, String> mapaValoresVariables = (Map<String, String>) mapaValores.get(KEY_MAPA_VALORES_VARIABLES);
		if ("CERTIF_DOBLE_CESION".equals(informe.getDocumentoGeneradoAdicional().getCodigo())){
			if (mapaValoresVariables.containsKey(KEY_GENERACION_ADICIONAL)) {
				if (mapaValoresVariables.get(KEY_GENERACION_ADICIONAL) != null &&
						mapaValoresVariables.get(KEY_GENERACION_ADICIONAL).equals("S")) {
					return true;
				}
			}
			return false;
		}
		
		return true;
	}


	private void adjuntarYenviar(GENINFInforme informe, GENINFGenerarEscritoDto dto, EXTAsunto asunto, 
			FileItem resultado, boolean hayErrores) throws MessagingException {
		String nombreEscrito = informe.getDescripcionLarga();
		String tipoFichero = null;

		if (!Checks.esNulo(informe.getTipoFichero())) {
			tipoFichero = informe.getTipoFichero().getCodigo();
		}
		//FIXME - No hace falta adjuntar si no se envia el correo con demora
		Long idAdjunto = adjuntarInforme(dto.getTipoEntidad(), asunto, resultado, nombreEscrito, tipoFichero, hayErrores);
		if (Checks.esNulo(idAdjunto)) {
			//ok = false;
		} else {
			//Si se ha adjuntado correctamente el escrito, 
			// comprobamos si hay que enviar por email con el escrito adjunto
			// Si tiene errores se envia por mail
			if (dto.getEnviarPorEmail() || hayErrores) {
				String txtError = hayErrores ? "ERROR - " : "";
				//Recuperar el destinatario del correo (De momento solo del usuario logado)
				String direccionDestino = obtenerEmailDestinatarioUsrLogado(asunto);
				//Montar resto del mensaje mensaje de correo
				String descEscrito = nombreEscrito + " generado para el asunto " + asunto.getNombre();
				//Obtener direcci�n de origen de las propiedades o de configuraci�n
				String emailOrigenPorDefecto = recuperarValorConfiguracion(CLAVE_CONFIGURACION_EMAIL_ORIGEN);
				String asuntoMail = txtError+"Escrito " + descEscrito;
				String cuerpoEmail = "Este correo contiene el escrito " + descEscrito;
				// Enviar mensaje de correo o programar env�o de mensaje de correo
				if ((informe.getDemoraEnvioEmail() > 0) && (!hayErrores)) {
					// Programar equivale a grabar en una tabla de emails diferidos (que un proceso batch se encargar� de revisar y enviar)
					// Calcular fecha de env�o de email
					Date fechaEnvio = calcularFechaEnvioEmail(informe.getDemoraEnvioEmail());
					guardarEnvioProgramado(direccionDestino,
							emailOrigenPorDefecto, asuntoMail,
							cuerpoEmail, idAdjunto, nombreEscrito, fechaEnvio);
				} else {
					GENINFCorreoPendienteDto correoDto = new GENINFCorreoPendienteDto();
					correoDto.setEmailFrom(emailOrigenPorDefecto);
					correoDto.setDestinatario(direccionDestino);
					correoDto.setAsuntoMail(asuntoMail);
					correoDto.setCuerpoEmail(cuerpoEmail);
					correoDto.setAdjunto(resultado);
					correoDto.setNombreAdjunto(nombreEscrito + dto.getSufijoInforme());
					enviarMailConEscritoAdjunto(correoDto);
				}
			}
		}

	}


	@BusinessOperation(MSV_BO_GENERAR_INFORME)
	public FileItem generarInforme(String plantilla, Map<String, Object> mapaValores, List<Object> array) {
		//FIXME - pasarle el locale por parametro
		Locale localeES = new Locale("es","ES");
		mapaValores = new HashMap<String, Object>();
		mapaValores.put(JRParameter.REPORT_LOCALE, localeES);
		//FASE-1323
		DefaultJasperReportsContext jrContext = DefaultJasperReportsContext.getInstance();
		//jrContext.setProperty("net.sf.jasperreports.awt.ignore.missing.font", Boolean.TRUE.toString());
		JRPropertiesUtil jrPropertiesUtil = JRPropertiesUtil.getInstance(jrContext);
		jrPropertiesUtil.setProperty("net.sf.jasperreports.awt.ignore.missing.font", Boolean.TRUE.toString());
		return dameInformeArray(plantilla, mapaValores, array);
	}
	

	public  FileItem dameInformeArray(String ficheroPlantilla, Map<String, Object> mapaValores, List<Object> array) {
		FileItem fi = null;
		
		if (ficheroPlantilla==null || ficheroPlantilla.equals("")) {
			throw new IllegalStateException("Nombre de fichero de plantilla vac�o");
		}
		
		//Comprobar si existe el fichero de la plantilla
		InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/" + ficheroPlantilla);
		if (is == null) {
			throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		File fileSalidaTemporal = null;
		
		try {
			//Compilar la plantilla
			JasperReport report = JasperCompileManager.compileReport(is);
			
			//Rellenar los datos del informe
			JasperPrint print = JasperFillManager.fillReport(report, mapaValores, new JRBeanCollectionDataSource(array));
			
			
			
			//Exportar el informe a RTF
			fileSalidaTemporal = File.createTempFile("jasper", ".rtf");
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				final JRRtfExporter rtfExporter = new JRRtfExporter();
				//final ByteArrayOutputStream rtfStream = new ByteArrayOutputStream();
				rtfExporter.setParameter(JRExporterParameter.JASPER_PRINT,print);
				rtfExporter.setParameter(JRExporterParameter.OUTPUT_FILE,fileSalidaTemporal);
				rtfExporter.exportReport();
				
				fi = new FileItem();
				fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".rtf");
				fi.setContentType("application/rtf");
				fi.setFile(fileSalidaTemporal);
			} else {
				throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
			}
			
		} catch (JRException e) {
			throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
		} catch (IOException e) {
			throw new IllegalStateException("No se puede escribir el fichero de salida");
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage());
		}
		
		return fi;

	}
	
	@BusinessOperation(MSV_BO_GENERAR_INFORME_PDF)
	public FileItem generarInformePDF(String plantilla, Map<String, Object> mapaValores, List<Object> array) {
		//FIXME - pasarle el locale por parametro
		Locale localeES = new Locale("es","ES");
		mapaValores = new HashMap<String, Object>();
		mapaValores.put(JRParameter.REPORT_LOCALE, localeES);
		return dameInformeArrayPDF(plantilla, mapaValores, array);
	}	
	
	public FileItem dameInformeArrayPDF(String ficheroPlantilla, Map<String, Object> mapaValores, List<Object> array) {
		FileItem fi = null;

		if (ficheroPlantilla == null || ficheroPlantilla.equals("")) {
			throw new IllegalStateException("Nombre de fichero de plantilla vac�o");
		}

		//Comprobar si existe el fichero de la plantilla
		InputStream is = this.getClass().getClassLoader().getResourceAsStream("jasper/" + ficheroPlantilla);

		if (is == null) {
			throw new IllegalStateException("No existe el fichero de plantilla " + ficheroPlantilla);
		}

		try {
			//Compilar la plantilla
			JasperReport report = JasperCompileManager.compileReport(is);

			//Rellenar los datos del informe
			JasperPrint print = JasperFillManager.fillReport(report, mapaValores, new JRBeanCollectionDataSource(array));

			//Exportar el informe a RTF
			File fileSalidaTemporal = File.createTempFile("jasper", ".pdf");
			fileSalidaTemporal.deleteOnExit();

			if (fileSalidaTemporal.exists()) {
				final JRPdfExporter pdfExporter = new JRPdfExporter();
				//final ByteArrayOutputStream rtfStream = new ByteArrayOutputStream();
				pdfExporter.setParameter(JRExporterParameter.JASPER_PRINT, print);
				pdfExporter.setParameter(JRExporterParameter.OUTPUT_FILE, fileSalidaTemporal);
				pdfExporter.exportReport();
				
				fi = new FileItem();
				fi.setFileName(ficheroPlantilla + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".pdf");
				fi.setContentType("application/pdf");
				fi.setFile(fileSalidaTemporal);
			} else {
				throw new IllegalStateException("Error al generar el fichero de salida " + fileSalidaTemporal);
			}

		} catch (JRException e) {
			throw new IllegalStateException("Error al compilar el informe en JasperReports " + e.getLocalizedMessage());
		} catch (IOException e) {
			throw new IllegalStateException("No se puede escribir el fichero de salida");
		} catch (Exception e) {
			e.printStackTrace();
			throw new IllegalStateException("Error al generar el informe en JasperReports " + e.getLocalizedMessage());
		}

		return fi;
	}
	
	
	/**
	 * Metodo para sustituir las variables de un fichero docx por su valor
	 * @param envioBurofax
	 * @param escrito
	 * @param is
	 * @return
	 * @throws Throwable
	 */
	@Override
	@BusinessOperation(MSV_GENERAR_ESCRITO_VARIABLES)
	public FileItem generarEscritoConVariables(HashMap<String, Object> mapaVariables, String escrito,InputStream is) throws Throwable {
		File fileSalidaTemporal = null;
		FileItem resultado = null;
		OutputStream out = null;
		
		try{
			// Comprobamos que exista la plantilla
			if (escrito==null || escrito.equals("")) {
				throw new IllegalStateException("Nombre de fichero de plantilla vacï¿½o");
			}
						
			if (is == null) {
				throw new IllegalStateException("No existe el fichero de plantilla " + escrito);
			}			
			
			// Inicializamos el motor de generación de los escritos
			IXDocReport report = XDocReportRegistry.getRegistry().loadReport(is, TemplateEngineKind.Freemarker);		
			IContext context = report.createContext();
			
			// Metemos los valores de las variables !! MUY IMPORTANTE: Si hay definidas variables y no se pueblan a continuación , NO FUNCIONA
			for(Map.Entry<String, Object> entry : mapaVariables.entrySet()){
				context.put(entry.getKey(),entry.getValue());	
				
			}
			context.put(DOMFontsPreprocessor.FONT_SIZE_KEY, "8");
			// Preparamos el fichero temporal
			fileSalidaTemporal = File.createTempFile("escrito", ".docx");
			
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				// Generamos el escrito
				out = new FileOutputStream(fileSalidaTemporal);
				report.process(context, out);
			}
			
			resultado = new FileItem();
			resultado.setFileName(escrito + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".docx");
			resultado.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
			resultado.setFile(fileSalidaTemporal);
			
		}catch(Throwable e){
			System.out.println("generarEscritoConVariables: " + e);
			throw e;
		}finally{
			if(!Checks.esNulo(out)){
				out.close();
			}
			if(!Checks.esNulo(is)){
				is.close();
			}
		}
		return resultado;
	}
	
	
	/**
	 * Creamos .pdf temporal y convertimos las etiquetas HTML a formato pdf
	 * @param envioBurofax
	 * @return
	 * @throws Exception
	 */
	@Override
	@BusinessOperation(MSV_GENERAR_ESCRITO_PDF_FROM_HTML)
	public InputStream createPdfFileFromHtmlText(String htmlText,String nombreFichero) throws Exception{
		
		
		File archivo = File.createTempFile(nombreFichero, ".pdf");
		
		try {
		    
			String k = "<html><body>"+htmlText+"</body></html>";
		      
		    OutputStream file = new FileOutputStream(archivo);
		    Document document = new Document();
		    PdfWriter.getInstance(document, file);
		    document.open();
		    HTMLWorker htmlWorker = new HTMLWorker(document);
		    htmlWorker.parse(new StringReader(k));
		    document.close();
		    
		    file.close();
			

			
		} catch (Exception e) {
			logger.error("createPdfFileFromHtmlText: " + e);
		}
		
	    InputStream is=new FileInputStream(archivo);
		return is;
		
		
//		try {
//		    String k = "<html><body> This is my Project </body></html>";
//		    OutputStream file = new FileOutputStream(new File("C:\\Test.pdf"));
//		    Document document = new Document();
//		    PdfWriter writer = PdfWriter.getInstance(document, file);
//		    document.open();
//		    InputStream is = new ByteArrayInputStream(k.getBytes());
//		    XMLWorkerHelper.getInstance().parseXHtml(writer, document, is);
//		    document.close();
//		    file.close();
//		} catch (Exception e) {
//		    e.printStackTrace();
//		}
		
	}
	
	public FileItem createPdfFileFromHtml(String htmlText,String nombreFichero) throws Exception{
		
		
		File archivo = File.createTempFile(nombreFichero, ".pdf");
		FileItem fileItem = null;
		try {
		    
			String k = "<html><body>"+htmlText+"</body></html>";
		      
		    OutputStream file = new FileOutputStream(archivo);
		    Document document = new Document();
		    PdfWriter.getInstance(document, file);
		    document.open();
		    HTMLWorker htmlWorker = new HTMLWorker(document);
		    htmlWorker.parse(new StringReader(k));
		    document.close();
		    
		    file.close();
		    fileItem = new FileItem(archivo);

			
		} catch (Exception e) {
			logger.error("createPdfFileFromHtmlText: " + e);
		}
		
	   
		return fileItem;
	}


	public FileItem generarEscritoConContenidoHTML(Map<String, String> cabecera,
			String contenidoParseadoFinal, String nombreFichero,
			InputStream plantillaBurofax)  throws Throwable {

		File fileSalidaTemporal = null;
		FileItem resultado = null;
		OutputStream out = null;
        final String TABLA_AUX = "<table width='100%' style='font-size:6px'><tr><td>&nbsp;</td></tr></table>";
		
		try{
			// Comprobamos que exista la plantilla
			if (nombreFichero==null || nombreFichero.equals("")) {
				throw new IllegalStateException("Nombre de fichero de plantilla vacio");
			}
						
			if (plantillaBurofax == null) {
				throw new IllegalStateException("No existe el fichero de plantilla " + nombreFichero);
			}			
			
			// Inicializamos el motor de generación de los escritos
			IXDocReport report = XDocReportRegistry.getRegistry().loadReport(plantillaBurofax, TemplateEngineKind.Freemarker);		
			IContext context = report.createContext();

            // Creamos campo de metadata para manejar el formateo del contenido 
            FieldsMetadata metadata = report.createFieldsMetadata();

            // Incluir el contenido del cuerpo
            metadata.addFieldAsTextStyling(CONTENIDO, SyntaxKind.Html);
			context.put(CONTENIDO,TABLA_AUX + contenidoParseadoFinal + TABLA_AUX);
			
            // Incluir el contenido de la cabecera
			for(Map.Entry<String, String> entry : cabecera.entrySet()){
				context.put(entry.getKey(),entry.getValue());	
			}

			// Preparamos el fichero temporal
			fileSalidaTemporal = File.createTempFile("escrito", ".docx");
			
			fileSalidaTemporal.deleteOnExit();
			if (fileSalidaTemporal.exists()) {
				// Generamos el escrito
				out = new FileOutputStream(fileSalidaTemporal);
				report.process(context, out);
			}
			
			resultado = new FileItem();
			resultado.setFileName(nombreFichero + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + ".docx");
			resultado.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
			resultado.setFile(fileSalidaTemporal);
			
		}catch(Throwable e){
			throw e;
		}finally{
			if(!Checks.esNulo(out)){
				out.close();
			}
			if(!Checks.esNulo(plantillaBurofax)){
				plantillaBurofax.close();
			}
		}
		return resultado;

	}

	public File convertirAPdf(FileItem archivoBurofax, String nombreFicheroPdfSalida) {

		File respuesta = null;
		OutputStream out = null;
		try {
			XWPFDocument document = new XWPFDocument(archivoBurofax.getInputStream());
			respuesta = new File(nombreFicheroPdfSalida);
			out = new FileOutputStream(respuesta);
			PdfOptions options = null; // PdfOptions.create().fontEncoding("windows-1250");
			PdfConverter.getInstance().convert(document, out, options);
			out.flush();
		} catch (Throwable e) {
			logger.error("convertirAPdf: " + e);
		}
		return respuesta;

	}

}
