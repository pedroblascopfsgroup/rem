package es.pfsgroup.plugin.rem.activo;

import java.util.Date;
import java.util.List;

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
import es.pfsgroup.plugin.rem.activo.dao.ActivoTributoDao;
import es.pfsgroup.plugin.rem.adapter.TributoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;


@Service("activoTributoManager")
public class ActivoTributoManager extends BusinessOperationOverrider<ActivoTributoApi> implements ActivoTributoApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoTributoManager.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ActivoTributoDao activoTributoDao;
	
	@Autowired
	private TributoAdapter tributoAdapter;

	@Override
	@BusinessOperation(overrides = "activoTributoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}
	
	@Override
	@BusinessOperation(overrides = "activoTributoManager.getTributo")
	public ActivoTributos getTributo(Long id) {
		
		ActivoTributos activoTributo = activoTributoDao.get(id);
		
		return activoTributo;
	}

	@Override
	public String managerName() {
	return "activoTributoManager";
	}
	
	
	@Override
	@BusinessOperation(overrides = "activoTributoManager.upload")
	@Transactional(readOnly = false)
	public String upload(WebFileItem webFileItem) throws Exception {

		return upload2(webFileItem, null);

	}

	@Override
	@BusinessOperation(overrides = "activoTributoManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, ActivoTributos actTributo, String matricula) throws Exception {
		
		ActivoTributos activoTributo = null;
		DDTipoDocumentoTributos tipoDocumento = null;
		if (Checks.esNulo(actTributo)) {
			
			activoTributo = getTributo(Long.parseLong(webFileItem.getParameter("idTributo")));
			
			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = genericDao.get(DDTipoDocumentoTributos.class, filtro);
			
		} else {
			
			activoTributo = actTributo;
			
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento =  genericDao.get(DDTipoDocumentoTributos.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = genericDao.get(DDTipoDocumentoTributos.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activoTributo) && !Checks.esNulo(tipoDocumento)) {

				ActivoAdjuntoTributo activoAdjuntoTributo = new ActivoAdjuntoTributo();
				
				if (!gestorDocumentalAdapterApi.modoRestClientActivado()) {
					Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem()); 
					activoAdjuntoTributo.setAdjunto(adj);
				}
				
				activoAdjuntoTributo.setActivoTributo(activoTributo);
				
				activoAdjuntoTributo.setIdDocRestClient(idDocRestClient);

				activoAdjuntoTributo.setTipoDocumentoTributo(tipoDocumento);

				activoAdjuntoTributo.setContentType(webFileItem.getFileItem().getContentType());

				activoAdjuntoTributo.setTamanyo(webFileItem.getFileItem().getLength());

				activoAdjuntoTributo.setNombre(webFileItem.getFileItem().getFileName());

				activoAdjuntoTributo.setDescripcion(webFileItem.getParameter("descripcion"));

				activoAdjuntoTributo.setFechaDocumento(new Date());

				Auditoria.save(activoAdjuntoTributo);
				
				genericDao.save(ActivoAdjuntoTributo.class, activoAdjuntoTributo);

			} else {
				throw new Exception("No se ha encontrado activo, tributo o tipo para relacionar adjunto");
			}
		} catch (Exception e) {
			logger.error("Error en activoTributoManager", e);
		}

		return null;

	}

	@Override
	@BusinessOperation(overrides = "activoTributoManager.upload2")
	@Transactional(readOnly = false)
	public String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception {

		return uploadDocumento(webFileItem, idDocRestClient, null, null);


	}
	
	@Override
	@BusinessOperationDefinition("activoTributoManager.download")
	public FileItem download(Long id) throws Exception {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filter);
		return activoAdjuntoTributo.getAdjunto().getFileItem();
	}


	@Override
	public FileItem getFileItemAdjunto(DtoAdjuntoTributo dtoAdjunto) {

		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getIdActivo());
		
		Filter filtroTributo = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getIdTributo());
		
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		ActivoTributos activoTributo = genericDao.get(ActivoTributos.class, filtroActivo,filtroTributo,filtroAuditoria);
		
		if(!Checks.esNulo(activoTributo)) {
			Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "id", dtoAdjunto.getIdTributo());
			ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo);
			
			FileItem fileItem = activoAdjuntoTributo.getAdjunto().getFileItem();
			fileItem.setContentType(activoAdjuntoTributo.getContentType());
			fileItem.setFileName(activoAdjuntoTributo.getNombre());

			return activoAdjuntoTributo.getAdjunto().getFileItem();
		}
		
		return null;
		
	}

	@Override
	public ActivoAdjuntoTributo getAdjuntoTributo(Long idDocRestClient) {
		
		Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", idDocRestClient);
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo, filtroAuditoria);
		
		return activoAdjuntoTributo;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean deleteAdjuntoDeTributo(DtoAdjuntoTributo dto) {
		ActivoTributos tributo = getTributo(Long.parseLong(dto.getIdEntidad()));
		ActivoAdjuntoTributo adjunto = tributo.getAdjunto(dto.getId());

		if (adjunto == null) {
			return false;
		}
		tributo.getAdjuntos().remove(adjunto);
		activoTributoDao.save(tributo);
	
		return true;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Runnable deleteAdjuntosDeTributo(Long idTributo) {
		ActivoTributos tributo = getTributo(idTributo);
		DtoAdjuntoTributo dto = new DtoAdjuntoTributo();
		dto.setIdEntidad(idTributo.toString());
		List<ActivoAdjuntoTributo> adjuntos = tributo.getAdjuntos();
		Integer numAdjuntos = adjuntos.size();
		
		for(int i = numAdjuntos-1; i >= 0; i--) {
			ActivoAdjuntoTributo adj = adjuntos.get(i);
			
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				dto.setId(adj.getIdDocRestClient());
			}else {
				dto.setId(adj.getId());
			}
			tributoAdapter.deleteAdjunto(dto);
		}
		
		
		return null;
	}
}
