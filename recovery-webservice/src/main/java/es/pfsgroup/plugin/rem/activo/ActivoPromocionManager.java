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
import es.pfsgroup.plugin.rem.api.ActivoPromocionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.AdjuntosPromocion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoPromocion;


@Service("activoPromocionManager")
public class ActivoPromocionManager extends BusinessOperationOverrider<ActivoPromocionApi> implements ActivoPromocionApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoPromocionManager.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	

	@Override
	@BusinessOperation(overrides = "activoPromocionManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}

	@Override
	public String managerName() {
	return "activoPromocionManager";
	}
	
	
	@Override
	@BusinessOperation(overrides = "activoPromocionManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {

		return upload2(webFileItem, null);

	}

	@Override
	@BusinessOperation(overrides = "activoPromocionManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula) throws Exception {
		Activo activo = null;
		DDTipoDocumentoPromocion tipoDocumento = null;
		if (Checks.esNulo(activoEntrada)) {
			activo = get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = (DDTipoDocumentoPromocion) genericDao.get(DDTipoDocumentoPromocion.class, filtro);
			
		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoPromocion) genericDao.get(DDTipoDocumentoPromocion.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = (DDTipoDocumentoPromocion) genericDao.get(DDTipoDocumentoPromocion.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

				AdjuntosPromocion adjuntoPromocion = new AdjuntosPromocion();
				
				adjuntoPromocion.setAdjunto(adj);
				
				adjuntoPromocion.setActivo(activo);
				
				adjuntoPromocion.setCodPromo(activo.getIdProp().toString()+"_"+activo.getCartera().getCodigo().toString());
				
				adjuntoPromocion.setIdDocRestClient(idDocRestClient);

				adjuntoPromocion.setTipoDocumentoPromocion(tipoDocumento);

				adjuntoPromocion.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoPromocion.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoPromocion.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoPromocion.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoPromocion.setFechaDocumento(new Date());

				Auditoria.save(adjuntoPromocion);

				activo.getAdjuntosPromocion().add(adjuntoPromocion);

				activoDao.save(activo);
			} else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto promocion");
			}
		} catch (Exception e) {
			logger.error("Error en activoPromocionManager", e);
		}

		return null;

	}

	@Override
	@BusinessOperation(overrides = "activoPromocionManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {

		return uploadDocumento(webFileItem, idDocRestClient, null, null);


	}
	
	@Override
	@BusinessOperationDefinition("activoPromocionManager.download")
	public FileItem download(Long id) throws Exception {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		AdjuntosPromocion adjuntoPromocion = (AdjuntosPromocion) genericDao.get(AdjuntosPromocion.class, filter);
		return adjuntoPromocion.getAdjunto().getFileItem();
	}


	@Override
	public FileItem getFileItemAdjunto(DtoAdjuntoPromocion dtoAdjunto) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getIdActivo());
		Activo activo = genericDao.get(Activo.class, filtro);
		
		AdjuntosPromocion adjuntoPromocion = activo.getAdjuntoPromocion(dtoAdjunto.getId());
		
		FileItem fileItem = adjuntoPromocion.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoPromocion.getContentType());
		fileItem.setFileName(adjuntoPromocion.getNombre());

		return adjuntoPromocion.getAdjunto().getFileItem();
	}

	@Override
	public List<DtoAdjuntoPromocion> getAdjuntos(Long idActivo) {

		List<DtoAdjuntoPromocion> listaAdjuntosPromocion = new ArrayList<DtoAdjuntoPromocion>();

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtro);

			for (AdjuntosPromocion adjunto : activo.getAdjuntosPromocion()) {
				DtoAdjuntoPromocion dto = new DtoAdjuntoPromocion();

				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdActivo(activo.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoPromocion().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				dto.setCodPromo(activo.getIdProp().toString()+"_"+activo.getCartera().getCodigo().toString());
				listaAdjuntosPromocion.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en ActivoPromocionManager", ex);
		}

		return listaAdjuntosPromocion;
	}

}
