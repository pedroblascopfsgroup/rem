package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTributoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
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
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoAdapter adapter;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Override
	@BusinessOperation(overrides = "activoTributoManager.get")
	public Activo get(Long id) {
		return activoDao.get(id);
	}
	
	@Override
	@BusinessOperation(overrides = "activoTributoManager.getTributo")
	public ActivoTributos getTributo(Long id) {
		
		Filter filtroTributo = genericDao.createFilter(FilterType.EQUALS, "id", id);
		
		ActivoTributos activoTributo = genericDao.get(ActivoTributos.class, filtroTributo);
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
	public DtoAdjunto getAdjuntoTributo(Long idTributo) {
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id", idTributo);
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo, filtroAuditoria);
		
		if(!Checks.esNulo(activoAdjuntoTributo) && !Checks.esNulo(activoAdjuntoTributo.getAdjunto())) {
			dtoAdjunto.setId(activoAdjuntoTributo.getAdjunto().getId());
		
			return dtoAdjunto;
		}
		
		return null;
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean deleteAdjuntoDeTributo(Long idTributo) {
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id", idTributo);
		ActivoAdjuntoTributo activoAdjuntoTributo = null;
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			
			
			Filter filtroDocRest = genericDao.createFilter(FilterType.NOTNULL, "idDocRestClient");
	
			activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo, filtroDocRest,filtroAuditoria);
			
			if(!Checks.esNulo(activoAdjuntoTributo)) {
				if(adapter.deleteAdjuntoTributo(activoAdjuntoTributo.getIdDocRestClient())) {
					activoAdjuntoTributo.getAuditoria().setUsuarioBorrar(usuarioLogado.getNombre());
					activoAdjuntoTributo.getAuditoria().setFechaBorrar(new Date());
					activoAdjuntoTributo.getAuditoria().setBorrado(true);
				}
			}else{
				return false;
			}
		}else {
			 
			 Filter filtroDocRestNull = genericDao.createFilter(FilterType.NULL, "idDocRestClient");
	
			 activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo, filtroDocRestNull,filtroAuditoria);
			 if(!Checks.esNulo(activoAdjuntoTributo)) {
			 	activoAdjuntoTributo.getAuditoria().setUsuarioBorrar(usuarioLogado.getNombre());
				activoAdjuntoTributo.getAuditoria().setFechaBorrar(new Date());
				activoAdjuntoTributo.getAuditoria().setBorrado(true);
			 }else {
				 return false;
			 }
		}
		
		genericDao.update(ActivoAdjuntoTributo.class, activoAdjuntoTributo);
	
		return true;
	}
	
	@Override
	public Boolean comprobarSiExisteActivoTributo(WebFileItem webFileItem) throws GestorDocumentalException {
		ActivoTributos activoTributo = getTributo(Long.parseLong(webFileItem.getParameter("idTributo")));
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
		DtoAdjunto adjuntoTributo = gestorDocumentalAdapterApi.getAdjuntoTributo(activoTributo);
		
			if(Checks.esNulo(adjuntoTributo)) {
				return true;
			}else {
				return false;
			}
		}else {
		
			Filter filtroAdjuntoActivoTributo = genericDao.createFilter(FilterType.EQUALS, "activoTributo.id", activoTributo.getId());
			
			Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
	
			ActivoAdjuntoTributo activoAdjuntoTributo = genericDao.get(ActivoAdjuntoTributo.class, filtroAdjuntoActivoTributo, filtroAuditoria);
			
			if(Checks.esNulo(activoAdjuntoTributo)) {
				return true;
			}else {
				return false;
			}
		}
	}
}
