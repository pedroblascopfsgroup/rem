package es.pfsgroup.recovery.cajamar.gestorDocumental.manager;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.expediente.dao.AdjuntoExpedienteDao;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.AdjuntoGridAssembler;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.ConstantesGestorDocumental;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputListDto;
import es.pfsgroup.recovery.cajamar.serviciosonline.GestorDocumentalWSApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.expediente.EXTExpedienteManager;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;
import es.pfsgroup.tipoFicheroAdjunto.MapeoTipoFicheroAdjunto;

@Component
public class GestorDocumentalCajamarManager implements GestorDocumentalApi {

	private static final String ALTA_GESTOR_DOC = "A";
	private static final String CONSULTA_GESTOR_DOC = "C";
	private static final String LISTADO_GESTOR_DOC = "L";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;

	@Autowired
	private ContratoDao contratoDao;

	@Autowired
	private PersonaDao personaDao;

	@Autowired
	private ExpedienteDao expedienteDao;

	@Autowired
	private AsuntoDao asuntoDao;

	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private GestorDocumentalWSApi gestorDocumentalWSApi;
	
	@Autowired
	private EXTExpedienteManager extExpedienteManager;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private AdjuntoPersonaDao adjuntoPersonaDao;
	
	@Autowired
	private AdjuntoExpedienteDao adjuntoExpedienteDao;
	
	@Autowired
	private AdjuntoContratoDao adjuntoContratoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	@Transactional(readOnly = false)
	public String altaDocumento(Long idEntidad, String tipoEntidadGrid, String tipoDocumento, WebFileItem uploadForm) {

		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		FileItem fileItem = uploadForm.getFileItem();

		// En caso de que el fichero esté vacio, no subimos nada
		if (fileItem == null || fileItem.getLength() <= 0) {
		}

		Integer max = getLimiteFichero(getParametroLimite(tipoEntidadGrid));

		if (fileItem.getLength() > max) {
			AbstractMessageSource ms = MessageUtils.getMessageSource();
			return ms.getMessage("fichero.limite.tamanyo",
					new Object[] { (int) ((float) max / 1024f) },
					MessageUtils.DEFAULT_LOCALE);
		}

		String claveRel = guardarRecuperarDatoEntidad(idEntidad, tipoEntidadGrid, uploadForm, tipoDocumento);

		outputDto = gestorDocumentalWSApi.ejecutar(rellenaInputDto(
				claveRel, ALTA_GESTOR_DOC, tipoDocumento,
				tipoEntidadGrid, uploadForm));

		return outputDto.getTxtError();
	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	@Transactional(readOnly = false)
	public List<AdjuntoGridDto> listadoDocumentos(String claveAsociacion, String tipoEntidadGrid, String tipoDocumento) {

		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		GestorDocumentalInputDto inputDto = rellenaInputDto(
				claveAsociacion, LISTADO_GESTOR_DOC, tipoDocumento,
				tipoEntidadGrid, null);
		outputDto = gestorDocumentalWSApi.ejecutar(inputDto);
		
		if(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidadGrid) || DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidadGrid)){
			
			for(GestorDocumentalOutputListDto olDto : outputDto.getLbListadoDocumentos()) {
				
				List<MapeoTipoFicheroAdjunto> mapeo = genericDao.getList(MapeoTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "tipoFicheroExterno", olDto.getTipoDoc()));
				if(!Checks.esNulo(mapeo) && mapeo.size()>0){
					
					if(mapeo.size() == 1){
						olDto.setTipoDoc(mapeo.get(0).getTipoFichero().getCodigo());
					}else{
						if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidadGrid)) {
							
							EXTAsunto extAsun = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "guid", claveAsociacion));
							List<EXTAdjuntoAsunto> adjsAsun = genericDao.getList(EXTAdjuntoAsunto.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", extAsun.getId()));
							if(!Checks.esNulo(adjsAsun) && adjsAsun.size() > 0){
								olDto.setTipoDoc(adjsAsun.get(0).getTipoFichero().getCodigo());
							}
							
						} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidadGrid)) {
							
							MEJProcedimiento procedimiento = genericDao.get(MEJProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "guid", claveAsociacion));
							List<EXTAdjuntoAsunto> adjsAsun = genericDao.getList(EXTAdjuntoAsunto.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", procedimiento.getId()));
							if(!Checks.esNulo(adjsAsun) && adjsAsun.size() > 0){
								olDto.setTipoDoc(adjsAsun.get(0).getTipoFichero().getCodigo());
							}
							
						}
					}
					
				}
				
			}	
		}
		
		return AdjuntoGridAssembler.outputDtoToAdjuntoGridDto(outputDto);
	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	@Transactional(readOnly = false)
	public AdjuntoGridDto recuperacionDocumento(String idRefCentera) {
		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		GestorDocumentalInputDto input = new GestorDocumentalInputDto();
		input.setOperacion(ConstantesGestorDocumental.CONSULTA_DOCUMENTO_OPERACION);
		input.setLocalizador(idRefCentera);
		outputDto = gestorDocumentalWSApi.ejecutar(input);
		return AdjuntoGridAssembler.outputDtoToAdjuntoGridDto(outputDto).get(0);

	}

	private GestorDocumentalInputDto rellenaInputDto(String claveAsociacion,
			String tipoGestion, String tipoDocumento, String tipoEntidadGrid,
			WebFileItem uploadForm) {
		GestorDocumentalInputDto inputDto = new GestorDocumentalInputDto();
		if (ALTA_GESTOR_DOC.equals(tipoGestion)) {
			inputDto.setOperacion(ConstantesGestorDocumental.ALTA_DOCUMENTO_OPERACION);
			inputDto.setExtensionFichero(uploadForm.getFileItem()
					.getContentType());
			inputDto.setOrigen(ConstantesGestorDocumental.GESTOR_DOCUMENTAL_ORIGEN);
			inputDto.setTipoAsociacion(getTipoAsociacion(tipoEntidadGrid));
			inputDto.setTipoDocumento(tipoDocumento);
			inputDto.setFicheroBase64(ficheroBase64(uploadForm));
			inputDto.setClaveAsociacion(claveAsociacion);
			if(!Checks.esNulo(uploadForm.getParameter("fechaCaducidad"))) {
				SimpleDateFormat frmt = new SimpleDateFormat("ddMMyyyy");
				try {
					inputDto.setFechaVigencia(frmt.parse(uploadForm.getParameter("fechaCaducidad")));
				} catch (ParseException e) {
					logger.error("Se ha producido un error al formatear la fecha de vigencia");
				}	
			}
		} else if (LISTADO_GESTOR_DOC.equals(tipoGestion)) {
			inputDto.setOperacion(ConstantesGestorDocumental.LISTADO_DOCUMENTO_OPERACION);
			inputDto.setTipoDocumento(tipoDocumento);
			inputDto.setClaveAsociacion(claveAsociacion);
			inputDto.setTipoAsociacion(getTipoAsociacion(tipoEntidadGrid));
		}

		return inputDto;
	}

	private String ficheroBase64(WebFileItem uploadForm) {
		InputStream inputStream = uploadForm.getFileItem().getInputStream();
		String ficheroBase64 = "";
		try {

			byte[] bytes = IOUtils.toByteArray(inputStream);
			byte[] encoded = Base64.encodeBase64(bytes);
			ficheroBase64 = new String(encoded);
		} catch (Exception e) {
			logger.error("Se ha producido un error al convertir el fichero en base64");
		}
		return ficheroBase64;

	}
	

	/**
	 * Recupera el límite de tamaño de un fichero.
	 * 
	 * @return
	 */
	private Integer getLimiteFichero(String limite) {
		try {
			Parametrizacion param = (Parametrizacion) executor
					.execute(
							ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
							limite);
			return Integer.valueOf(param.getValor());
		} catch (Exception e) {
			logger.warn("No esta parametrizado el límite máximo del fichero en bytes para personas, se toma un valor por defecto (2Mb)");
			return new Integer(2 * 1025 * 1024);
		}
	}

	private String getParametroLimite(String tipoEntidad) {
		String param = "";
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_EXPEDIENTE_GESTOR_DOCUMENTAL;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_PERSONA_GESTOR_DOCUMENTAL;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_CONTRATO_GESTOR_DOCUMENTAL;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)
				|| DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
						.equals(tipoEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_ASUNTO_GESTOR_DOCUMENTAL;
		}
		return param;
	}

	private String getTipoAsociacion(String codEntidad) {
		return ConstantesGestorDocumental.tipoAsociacionPorEntidad.get(codEntidad);
	}

	private String guardarRecuperarDatoEntidad(Long idEntidad, String tipoEntidad, WebFileItem uploadForm, String tipoDocumento) {
		String claveRel = "";
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			Expediente expediente = expedienteDao.get(idEntidad);
			if(uploadForm != null) {
				
				AdjuntoExpediente adjuntoexp;
				
				if(!Checks.esNulo(tipoDocumento) && !tipoDocumento.equals("")){
					DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem(), tpoAdjEnt);
				}else{
					adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem());
				}
				 
				adjuntoexp.setExpediente(expediente);
				adjuntoExpedienteDao.save(adjuntoexp);
			}
			claveRel = extExpedienteManager.prepareGuid(expediente).getGuid();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
			Persona persona = personaDao.get(idEntidad);
			if(uploadForm != null) {
				
				AdjuntoPersona adjPers;
				
				if(!Checks.esNulo(tipoDocumento) && !tipoDocumento.equals("")){
					DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					adjPers = new AdjuntoPersona(uploadForm.getFileItem(),tpoAdjEnt);
				}else{
					adjPers = new AdjuntoPersona(uploadForm.getFileItem());
				}
				
				adjPers.setPersona(persona);
				adjuntoPersonaDao.save(adjPers);
			}
			claveRel = persona.getCodClienteEntidad().toString();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			Contrato contrato = contratoDao.get(idEntidad);
			if(uploadForm != null) {
				
				AdjuntoContrato adjCnt;
				
				if(!Checks.esNulo(tipoDocumento) && !tipoDocumento.equals("")){
					DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					adjCnt = new AdjuntoContrato(uploadForm.getFileItem(),tpoAdjEnt);
				}else{
					adjCnt = new AdjuntoContrato(uploadForm.getFileItem());
				}
				
				adjCnt.setContrato(contrato);
				adjuntoContratoDao.save(adjCnt);
			}
			claveRel = contrato.getNroContrato();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
			EXTAsunto asunto = EXTAsunto.instanceOf(asuntoDao.get(idEntidad));
			if(uploadForm != null) {				
		        EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(uploadForm.getFileItem());
		        
		        if (!Checks.esNulo(tipoDocumento) && !tipoDocumento.equals("")) {
					DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
				}
				
		        adjuntoAsunto.setAsunto(asunto);
		        Auditoria.save(adjuntoAsunto);
		        asunto.getAdjuntos().add(adjuntoAsunto);
		        proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(asunto);
			}
			claveRel = asunto.getGuid();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
			MEJProcedimiento prc = MEJProcedimiento.instanceOf(procedimientoDao.get(idEntidad));
			if(uploadForm != null) {
		        EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(uploadForm.getFileItem());
		        
		        if (!Checks.esNulo(tipoDocumento) && !tipoDocumento.equals("")) {
					DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
					adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
				}
				
		        adjuntoAsunto.setAsunto(prc.getAsunto());
		        adjuntoAsunto.setProcedimiento(prc);
		        Auditoria.save(adjuntoAsunto);
		        prc.getAsunto().getAdjuntos().add(adjuntoAsunto);
		        proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(prc.getAsunto());
			}
			claveRel = extProcedimientoManager.prepareGuid(prc).getGuid();
		}
		return claveRel;
	}

}
