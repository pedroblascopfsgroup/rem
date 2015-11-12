package es.pfsgroup.recovery.cajamar.gestorDocumental.manager;

import java.util.Date;
import java.util.List;

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
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.ConstantesGestorDocumental;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

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
	
	//@Autowired
	//private GestorDocumentalWSApi gestorDocumentalWSApi;

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	@Transactional(readOnly = false)
	public String altaDocumento(String codEntidad, String tipoDocumento, WebFileItem uploadForm) {
		
		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		FileItem fileItem = uploadForm.getFileItem();

		// En caso de que el fichero esté vacio, no subimos nada
		if (fileItem == null || fileItem.getLength() <= 0) {
		}

		Integer max = getLimiteFichero(getParametroLimite(codEntidad));

		if (fileItem.getLength() > max) {
			AbstractMessageSource ms = MessageUtils.getMessageSource();
			return ms.getMessage("fichero.limite.tamanyo",
					new Object[] { (int) ((float) max / 1024f) },
					MessageUtils.DEFAULT_LOCALE);
		}

		guardarDatoEntidad(codEntidad, uploadForm);
		return null;
		

		//outputDto = gestorDocumentalWSApi.ejecutar(rellenaInputDto(ALTA_GESTOR_DOC, tipoDocumento, codEntidad, uploadForm));

	}
	
	private GestorDocumentalInputDto rellenaInputDto (String tipoGestion, String tipoDocumento, String codEntidad, WebFileItem uploadForm) {
		GestorDocumentalInputDto inputDto = new GestorDocumentalInputDto();
		if(ALTA_GESTOR_DOC.equals(tipoGestion)) {
			inputDto.setOperacion(ConstantesGestorDocumental.ALTA_DOCUMENTO_OPERACION);
			inputDto.setExtensionFichero(uploadForm.getFileItem().getContentType());
			inputDto.setOperacion(ConstantesGestorDocumental.GESTOR_DOCUMENTAL_ORIGEN);
			inputDto.setTipoAsociacion(getTipoAsociacion(codEntidad));
			inputDto.setTipoDocumento(tipoDocumento);
			inputDto.setFicheroBase64(uploadForm.getFileItem().getFileName());
			inputDto.setClaveAsociacion("");
			inputDto.setFechaVigencia(new Date());
		}else if(LISTADO_GESTOR_DOC.equals(tipoGestion)) {
			inputDto.setOperacion(ConstantesGestorDocumental.LISTADO_DOCUMENTO_OPERACION);
			inputDto.setTipoDocumento(tipoDocumento);
			inputDto.setTipoAsociacion(getTipoAsociacion(codEntidad));
		}else if(CONSULTA_GESTOR_DOC.equals(tipoGestion)) {
			inputDto.setOperacion(ConstantesGestorDocumental.CONSULTA_DOCUMENTO_OPERACION);
		}
		
		return inputDto;
	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	@Transactional(readOnly = false)
	public List<AdjuntoGridDto> listadoDocumentos(Long id, String tipoDocumento, String codEntidad) {
		
		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		return null;

		//outputDto = gestorDocumentalWSApi.ejecutar(rellenaInputDto(LISTADO_GESTOR_DOC, tipoDocumento, codEntidad, null));

	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	@Transactional(readOnly = false)
	public AdjuntoGridDto recuperacionDocumento(Long id) {
		
		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		return null;

		//outputDto = gestorDocumentalWSApi.ejecutar(rellenaInputDto(CONSULTA_GESTOR_DOC,null, null, null));


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

	private String getParametroLimite(String codEntidad) {
		String param = "";
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_EXPEDIENTE;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_PERSONA;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(codEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_CONTRATO;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codEntidad)
				|| DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
						.equals(codEntidad)) {
			param = Parametrizacion.LIMITE_FICHERO_ASUNTO;
		}
		return param;
	}
	
	private String getTipoAsociacion(String codEntidad) {
		String tipoAsociacion = "";
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codEntidad)) {
			tipoAsociacion = ConstantesGestorDocumental.GESTOR_DOCUMENTAL_TIPO_ASOCIACION_EXPEDIENTE;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codEntidad)) {
			tipoAsociacion = ConstantesGestorDocumental.GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PERSONA;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(codEntidad)) {
			tipoAsociacion = ConstantesGestorDocumental.GESTOR_DOCUMENTAL_TIPO_ASOCIACION_CONTRATO;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codEntidad)) {
			tipoAsociacion = ConstantesGestorDocumental.GESTOR_DOCUMENTAL_TIPO_ASOCIACION_ASUNTO;
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(codEntidad)) {
			tipoAsociacion = ConstantesGestorDocumental.GESTOR_DOCUMENTAL_TIPO_ASOCIACION_PROCEDIMIENTO;
		}
		return tipoAsociacion;
	}

	private void guardarDatoEntidad(String codEntidad, WebFileItem uploadForm) {
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(codEntidad)) {
			Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			expediente.addAdjunto(uploadForm.getFileItem());
			expedienteDao.save(expediente);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(codEntidad)) {
			Persona persona = personaDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			persona.addAdjunto(uploadForm.getFileItem());
			personaDao.save(persona);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(codEntidad)) {
			Contrato contrato = contratoDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			contrato.addAdjunto(uploadForm.getFileItem());
			contratoDao.save(contrato);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(codEntidad)
				|| DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
						.equals(codEntidad)) {
			Asunto asunto = asuntoDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			asunto.addAdjunto(uploadForm.getFileItem());
			asuntoDao.save(asunto);
		}
	}

}
