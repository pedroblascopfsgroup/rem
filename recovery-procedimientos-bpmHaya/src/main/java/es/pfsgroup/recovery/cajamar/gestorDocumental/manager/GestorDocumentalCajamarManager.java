package es.pfsgroup.recovery.cajamar.gestorDocumental.manager;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
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
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.AdjuntoGridAssembler;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.ConstantesGestorDocumental;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;
import es.pfsgroup.recovery.cajamar.serviciosonline.GestorDocumentalWSApi;
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

	@Autowired
	private GestorDocumentalWSApi gestorDocumentalWSApi;

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

		guardarRecuperarDatoEntidad(idEntidad, tipoEntidadGrid, uploadForm);

		outputDto = gestorDocumentalWSApi.ejecutar(rellenaInputDto(
				idEntidad.toString(), ALTA_GESTOR_DOC, tipoDocumento,
				tipoEntidadGrid, uploadForm));

		return outputDto.getTxtError();
	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	@Transactional(readOnly = false)
	public List<AdjuntoGridDto> listadoDocumentos(Long idEntidad,String tipoEntidad, String tipoEntidadGrid, String tipoDocumento) {

		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		GestorDocumentalInputDto inputDto = rellenaInputDto(
				idEntidad.toString(), LISTADO_GESTOR_DOC, tipoDocumento,
				tipoEntidadGrid, null);
		outputDto = gestorDocumentalWSApi.ejecutar(inputDto);
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
			// TODO Cual es la fecha de vigencia???
			inputDto.setFechaVigencia(new Date());
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
		FileOutputStream outputStream = null;
		String ficheroBase64 = "";
		try {
			// write the inputStream to a FileOutputStream
			outputStream = new FileOutputStream(new File(""));

			int read = 0;
			byte[] bytes = new byte[1024];

			while ((read = inputStream.read(bytes)) != -1) {
				outputStream.write(bytes, 0, read);
			}

			outputStream.close();
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

	private void guardarRecuperarDatoEntidad(Long idEntidad,
			String tipoEntidad, WebFileItem uploadForm) {
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			Expediente expediente = expedienteDao.get(idEntidad);
			expediente.addAdjunto(uploadForm.getFileItem());
			expedienteDao.save(expediente);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
			Persona persona = personaDao.get(idEntidad);
			persona.addAdjunto(uploadForm.getFileItem());
			personaDao.save(persona);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			Contrato contrato = contratoDao.get(idEntidad);
			contrato.addAdjunto(uploadForm.getFileItem());
			contratoDao.save(contrato);
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)
				|| DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
						.equals(tipoEntidad)) {
			Asunto asunto = asuntoDao.get(idEntidad);
			asunto.addAdjunto(uploadForm.getFileItem());
			asuntoDao.save(asunto);
		}
	}

}
