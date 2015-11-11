package es.pfsgroup.gestorDocumental.manager;

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
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalOutputDto;

@Component
public class GestorDocumentalManager implements GestorDocumentalApi {

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

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_ALTA_DOCUMENTO)
	@Transactional(readOnly = false)
	public <T> GestorDocumentalOutputDto altaDocumento(
			GestorDocumentalInputDto inputDto, Class<T> entidad,
			WebFileItem uploadForm) {
		GestorDocumentalOutputDto outputDto = new GestorDocumentalOutputDto();
		FileItem fileItem = uploadForm.getFileItem();

		// En caso de que el fichero esté vacio, no subimos nada
		if (fileItem == null || fileItem.getLength() <= 0) {
			return null;
		}

		Integer max = getLimiteFichero(getParametroLimite(entidad));

		if (fileItem.getLength() > max) {
			AbstractMessageSource ms = MessageUtils.getMessageSource();
			outputDto.setTxtError(ms.getMessage("fichero.limite.tamanyo",
					new Object[] { (int) ((float) max / 1024f) },
					MessageUtils.DEFAULT_LOCALE));
			return outputDto;
		}

		guardarDatoEntidad(entidad, uploadForm);

		return null;

	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_LISTADO_DOCUMENTO)
	@Transactional(readOnly = false)
	public <T> GestorDocumentalOutputDto listadoDocumentos(Long id,
			Class<T> entidad) {
		return null;

	}

	@BusinessOperation(BO_GESTOR_DOCUMENTAL_RECUPERACION_DOCUMENTO)
	@Transactional(readOnly = false)
	public GestorDocumentalOutputDto recuperacionDocumento(Long id) {
		return null;

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

	private <T> String getParametroLimite(Object entidad) {
		String param = "";
		if (entidad instanceof Expediente) {
			param = Parametrizacion.LIMITE_FICHERO_EXPEDIENTE;
		} else if (entidad instanceof Persona) {
			param = Parametrizacion.LIMITE_FICHERO_PERSONA;
		} else if (entidad instanceof Contrato) {
			param = Parametrizacion.LIMITE_FICHERO_CONTRATO;
		} else if (entidad instanceof Asunto) {
			param = Parametrizacion.LIMITE_FICHERO_ASUNTO;
		}
		return param;
	}

	private void guardarDatoEntidad(Object entidad, WebFileItem uploadForm) {
		if (entidad instanceof Expediente) {
			Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			expediente.addAdjunto(uploadForm.getFileItem());
			expedienteDao.save(expediente);
		} else if (entidad instanceof Persona) {
			Persona persona = personaDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			persona.addAdjunto(uploadForm.getFileItem());
			personaDao.save(persona);
		} else if (entidad instanceof Contrato) {
			Contrato contrato = contratoDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			contrato.addAdjunto(uploadForm.getFileItem());
			contratoDao.save(contrato);
		} else if (entidad instanceof Asunto
				|| entidad instanceof Procedimiento) {
			Asunto asunto = asuntoDao.get(Long.parseLong(uploadForm
					.getParameter("id")));
			asunto.addAdjunto(uploadForm.getFileItem());
			asuntoDao.save(asunto);
		}
	}

}
