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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoAdjuntosAgrupacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.AdjuntosPromocion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoPromocion;

@Service("activoAdjuntoAgrupacionManager")
public class ActivoAdjuntoAgrupacionManager  implements ActivoAdjuntosAgrupacionApi { 
	
	protected static final Log logger = LogFactory.getLog(ActivoAdjuntoAgrupacionManager.class);
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, ActivoAgrupacion agrupacion) throws Exception {
		DDTipoDocumentoAgrupacion tipoDocumento = null;
		if (Checks.esNulo(agrupacion)) {
			throw new Exception("Se debe de indicar la agrupacion");
		}else if (webFileItem.getParameter("tipo") == null) {
			throw new Exception("Tipo no valido");
		}else {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipoDocumento"));
			tipoDocumento = genericDao.get(DDTipoDocumentoAgrupacion.class, filtro);
		}
			
	/* TODO: Añadir la obtencion de la matricula;
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoPromocion) genericDao.get(DDTipoDocumentoPromocion.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = (DDTipoDocumentoPromocion) genericDao.get(DDTipoDocumentoPromocion.class, filtro);
			}
		}*/

		try {
			if (!Checks.esNulo(agrupacion) && !Checks.esNulo(tipoDocumento)) {
				ActivoAdjuntoAgrupacion adjuntoAgrupacion = new ActivoAdjuntoAgrupacion();
				
				//Si es nulo el idDocRestClient es que el gestor documental está desactivado
				if (Checks.esNulo(idDocRestClient)) {
					Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
					adjuntoAgrupacion.setAdjunto(adj);
				}
				adjuntoAgrupacion.setAgrupacion(agrupacion);
				
				adjuntoAgrupacion.setIdDocRestClient(idDocRestClient);

				adjuntoAgrupacion.setTipoDocumentoAgrupacion(tipoDocumento);

				adjuntoAgrupacion.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoAgrupacion.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoAgrupacion.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoAgrupacion.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoAgrupacion.setFechaDocumento(new Date());
				
				genericDao.save(ActivoAdjuntoAgrupacion.class, adjuntoAgrupacion);

			} else {
				throw new Exception("No se ha encontrado agrupacion o tipo del adjunto");
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
				BeanUtils.copyProperty(dto, "fechaSubida", adjunto.getAuditoria().getFechaCrear());
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

}
