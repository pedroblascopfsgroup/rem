package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoProyectoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.AdjuntosProyecto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoProyecto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProyecto;


@Service("activoProyectoManager")
public class ActivoProyectoManager extends BusinessOperationOverrider<ActivoProyectoApi> implements ActivoProyectoApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoProyectoManager.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	

	@Override
	@BusinessOperation(overrides = "activoProyectoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}

	@Override
	public String managerName() {
	return "activoProyectoManager";
	}
	
	
	@Override
	@BusinessOperation(overrides = "activoProyectoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {

		return upload2(webFileItem, null);

	}

	@Override
	@BusinessOperation(overrides = "activoProyectoManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRest, Activo activoEntrada, String matricula) throws Exception {
		Activo activo = null;
		DDTipoDocumentoProyecto tipoDocumento = null;
		if (Checks.esNulo(activoEntrada)) {
			activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = (DDTipoDocumentoProyecto) genericDao.get(DDTipoDocumentoProyecto.class, filtro);
			
		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoProyecto) genericDao.get(DDTipoDocumentoProyecto.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = (DDTipoDocumentoProyecto) genericDao.get(DDTipoDocumentoProyecto.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

				AdjuntosProyecto adjuntoProyecto = new AdjuntosProyecto();
				
				adjuntoProyecto.setAdjunto(adj);
				
				adjuntoProyecto.setActivo(activo);
				
				ActivoAgrupacion activoAgrupacionProyecto = null;
				for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) {
					if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
						activoAgrupacionProyecto = activoAgrupacionActivo.getAgrupacion();
						break;
					}
				}
				
				if (Checks.esNulo(activoAgrupacionProyecto)) {
					throw new Exception("No hay agrupaciones de tipo proyecto");
				}
				adjuntoProyecto.setAgrupacion(activoAgrupacionProyecto);
				
				adjuntoProyecto.setIdDocRest(idDocRest);

				adjuntoProyecto.setTipoDocumentoProyecto(tipoDocumento);

				adjuntoProyecto.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoProyecto.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoProyecto.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoProyecto.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoProyecto.setFechaDocumento(new Date());

				Auditoria.save(adjuntoProyecto);

				activo.getAdjuntosProyecto().add(adjuntoProyecto);

				activoDao.save(activo);
			} else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto Proyecto");
			}
		} catch (Exception e) {
			logger.error("Error en activoProyectoManager", e);
		}

		return null;

	}

	@Override
	@BusinessOperation(overrides = "activoProyectoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {

		return uploadDocumento(webFileItem, idDocRestClient, null, null);


	}
	
	@Override
	@BusinessOperationDefinition("activoProyectoManager.download")
	public FileItem download(Long id) throws Exception {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		AdjuntosProyecto adjuntoProyecto = (AdjuntosProyecto) genericDao.get(AdjuntosProyecto.class, filter);
		return adjuntoProyecto.getAdjunto().getFileItem();
	}


	@Override
	public FileItem getFileItemAdjunto(DtoAdjuntoProyecto dtoAdjunto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getIdActivo());
		Activo activo = genericDao.get(Activo.class, filtro);
		
		AdjuntosProyecto adjuntoProyecto = activo.getAdjuntoProyecto(dtoAdjunto.getId());
		
		FileItem fileItem = adjuntoProyecto.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoProyecto.getContentType());
		fileItem.setFileName(adjuntoProyecto.getNombre());

		return adjuntoProyecto.getAdjunto().getFileItem();
	}

	@Override
	public List<DtoAdjuntoProyecto> getAdjuntos(Long idActivo) {

		List<DtoAdjuntoProyecto> listaAdjuntosProyecto = new ArrayList<DtoAdjuntoProyecto>();

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtro);

			for (AdjuntosProyecto adjunto : activo.getAdjuntosProyecto()) {
				DtoAdjuntoProyecto dto = new DtoAdjuntoProyecto();

				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdActivo(activo.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoProyecto().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				dto.setCodProyecto(activo.getIdProp().toString()+"_"+activo.getCartera().getCodigo().toString());
				listaAdjuntosProyecto.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en ActivoProyectoManager", ex);
		}

		return listaAdjuntosProyecto;
	}
	
	@Override
	@BusinessOperation(overrides = "activoProyectoManager.deleteAdjunto")
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		Activo activo = get(dtoAdjunto.getIdEntidad());
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getId());
		AdjuntosProyecto adjunto = genericDao.get(AdjuntosProyecto.class, filtro);
		
		if (adjunto == null) {
			return false;
		}
		
		genericDao.deleteById(AdjuntosProyecto.class, dtoAdjunto.getId());
		
		activo.getAdjuntosProyecto().remove(adjunto);
		activoDao.save(activo);

		return true;
	}
	

}
