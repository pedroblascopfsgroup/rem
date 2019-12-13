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

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAdjuntosAgrupacionApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;

@Service("activoAdjuntoAgrupacionManager")
public class ActivoAdjuntoAgrupacionManager  implements ActivoAdjuntosAgrupacionApi { 
	
	protected static final Log logger = LogFactory.getLog(ActivoAdjuntoAgrupacionManager.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Override
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, ActivoAgrupacion agrupacion, String matricula, Usuario usuarioLogado) throws Exception {
		DDTipoDocumentoAgrupacion tipoDocumento = null;
		if (Checks.esNulo(agrupacion)) {
			throw new Exception("Se debe de indicar la agrupacion");
		}else if (webFileItem.getParameter("tipoDocumentoAgrupacion") == null) {
			throw new Exception("Tipo no valido");
		}else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipoDocumentoAgrupacion"));
			tipoDocumento = genericDao.get(DDTipoDocumentoAgrupacion.class, filtro);
		}
		if (!Checks.esNulo(matricula)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
			tipoDocumento = (DDTipoDocumentoAgrupacion) genericDao.get(DDTipoDocumentoAgrupacion.class, filtro);
		}

		

		try {
			if (!Checks.esNulo(agrupacion) && !Checks.esNulo(tipoDocumento)) {
 				ActivoAdjuntoAgrupacion adjuntoActivoAgrupacion = new ActivoAdjuntoAgrupacion();
				if(Checks.esNulo(idDocRestClient)){
					Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
					adjuntoActivoAgrupacion.setAdjunto(adj);
				}
 				adjuntoActivoAgrupacion.setAgrupacion(agrupacion);
				adjuntoActivoAgrupacion.setIdDocRestClient(idDocRestClient);
				adjuntoActivoAgrupacion.setTipoDocumentoAgrupacion(tipoDocumento);
				adjuntoActivoAgrupacion.setContentType(webFileItem.getFileItem().getContentType());
				adjuntoActivoAgrupacion.setTamanyo(webFileItem.getFileItem().getLength());
				adjuntoActivoAgrupacion.setNombre(webFileItem.getFileItem().getFileName());
				adjuntoActivoAgrupacion.setDescripcion(webFileItem.getParameter("descripcion"));
				adjuntoActivoAgrupacion.setFechaDocumento(new Date());
				adjuntoActivoAgrupacion.setAuditoria(Auditoria.getNewInstance());
				genericDao.save(ActivoAdjuntoAgrupacion.class, adjuntoActivoAgrupacion);
				
				return adjuntoActivoAgrupacion.getId().toString();
			} else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto");
			}
		} catch (Exception e) {
			logger.error("Error en activoAdjuntoAgrupacionManager", e);
		}

		return null;

	}
	
	public FileItem download(Long id) throws Exception {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "adjunto.id", id);
		ActivoAdjuntoAgrupacion adjuntoAgrupacion = (ActivoAdjuntoAgrupacion) genericDao.get(ActivoAdjuntoAgrupacion.class, filter);
		return adjuntoAgrupacion.getAdjunto().getFileItem();
	}

	@Override
	public List<DtoAdjuntoAgrupacion> getAdjuntos(Long idAgrupacion) {

		List<DtoAdjuntoAgrupacion> listaAdjuntosPromocion = new ArrayList<DtoAdjuntoAgrupacion>();

		try {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
			List<ActivoAdjuntoAgrupacion> adjuntosAgrupacion = genericDao.getList(ActivoAdjuntoAgrupacion.class, filtro);

			for (ActivoAdjuntoAgrupacion adjunto : adjuntosAgrupacion) {
				DtoAdjuntoAgrupacion dto = new DtoAdjuntoAgrupacion();
				BeanUtils.copyProperties(dto, adjunto);
				BeanUtils.copyProperty(dto, "idAgrupacion", adjunto.getAgrupacion().getId());
				BeanUtils.copyProperty(dto, "idDoc", adjunto.getAdjunto().getId());
				BeanUtils.copyProperty(dto, "codTipoDocumento", adjunto.getTipoDocumentoAgrupacion().getCodigo());
				BeanUtils.copyProperty(dto, "descripcionTipo", adjunto.getTipoDocumentoAgrupacion().getDescripcionLarga());
				BeanUtils.copyProperty(dto, "fechaDocumento", adjunto.getAuditoria().getFechaCrear());
				listaAdjuntosPromocion.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en ActivoAdjuntoAgrupacionManager", ex);
		}

		return listaAdjuntosPromocion;
	}

	@Override
	public FileItem getFileItemAdjunto(Long id, Long idAgrupacion) throws Exception {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "adjunto.id", id);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
		ActivoAdjuntoAgrupacion agrupacionAdjunto = genericDao.get(ActivoAdjuntoAgrupacion.class, f1, f2);
		if ( !Checks.esNulo(agrupacionAdjunto) && !Checks.esNulo(agrupacionAdjunto.getAdjunto()) )
			return agrupacionAdjunto.getAdjunto().getFileItem();
	
		return null;
	}		
	
	@Override
	@Transactional(readOnly = false)
	public Boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
				borrado = deleteAdjuntoLocal(dtoAdjunto);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			borrado = this.deleteAdjuntoLocal(dtoAdjunto);
		}
		
		return borrado;
	}

	private boolean deleteAdjuntoLocal(DtoAdjunto dtoAdjunto) {
		Filter filtroAdjunto = genericDao.createFilter(FilterType.EQUALS, "adjunto.id", dtoAdjunto.getId());
 		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List <ActivoAdjuntoAgrupacion> resultActivoAdjuntoAgrupacion = genericDao.getList(ActivoAdjuntoAgrupacion.class,filtroAdjunto, filtroBorrado); 
		if (!Checks.estaVacio(resultActivoAdjuntoAgrupacion)){
			genericDao.deleteById(ActivoAdjuntoAgrupacion.class, resultActivoAdjuntoAgrupacion.get(0).getId());
		}
		
		return true;
	}
}
