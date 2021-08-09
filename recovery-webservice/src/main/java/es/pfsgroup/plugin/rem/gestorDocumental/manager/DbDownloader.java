package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoTributo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.AdjuntoComunicacion;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.AdjuntoGastoAsociado;
import es.pfsgroup.plugin.rem.model.AdjuntosPromocion;

@Component
public class DbDownloader implements Downloader {

	@Autowired
	private GenericABMDao genericDao;
	
	private static final String DEFAULT = "DEFAULT";
	private static final String BASE_DE_DATOS = "DB";
	
	@Override
	public FileItem getFileItem(Long id,String nombreDocumento) {
		ActivoAdjuntoActivo adjuntoActivo = genericDao.get(ActivoAdjuntoActivo.class, genericDao.createFilter(FilterType.EQUALS, "id", id));

		FileItem fileItem = adjuntoActivo.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoActivo.getContentType());
		fileItem.setFileName(adjuntoActivo.getNombre());

		return adjuntoActivo.getAdjunto().getFileItem();
	}

	@Override
	public String[] getKeys() {
		return new String[]{BASE_DE_DATOS, DEFAULT};
	}

	@Override
	public FileItem getFileItemPromocion(Long id, String nombreDocumento) throws Exception {
		AdjuntosPromocion adjPromo = genericDao.get(AdjuntosPromocion.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		FileItem fileItem = adjPromo.getAdjunto().getFileItem();
		fileItem.setContentType(adjPromo.getContentType());
		fileItem.setFileName(adjPromo.getNombre());

		return adjPromo.getAdjunto().getFileItem();
	}
	
	@Override
	public FileItem getFileItemComunicacionGencat(Long id,String nombreDocumento) {
		AdjuntoComunicacion adjuntoActivo = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "id", id));

		FileItem fileItem = adjuntoActivo.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoActivo.getContentType());
		fileItem.setFileName(adjuntoActivo.getNombre());

		return adjuntoActivo.getAdjunto().getFileItem();
	}
	@Override
	public FileItem getFileItemAgrupacion(Long id, String nombreDocumento) throws Exception {
		ActivoAdjuntoAgrupacion adjAgrupacion = genericDao.get(ActivoAdjuntoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "adjunto.id", id));
		FileItem fileItem = adjAgrupacion.getAdjunto().getFileItem();
		fileItem.setContentType(adjAgrupacion.getContentType());
		fileItem.setFileName(adjAgrupacion.getNombre());
		return adjAgrupacion.getAdjunto().getFileItem();
	}

	@Override
	public FileItem getFileItemTributo(Long id, String nombreDocumento) throws Exception {
		ActivoAdjuntoTributo adjunto = genericDao.get(ActivoAdjuntoTributo.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		FileItem fileItem = adjunto.getAdjunto().getFileItem();
		fileItem.setContentType(adjunto.getContentType());
		fileItem.setFileName(adjunto.getNombre());

		return adjunto.getAdjunto().getFileItem();
	}

	@Override
	public FileItem getFileItemFactura(Long id, String nombreDocumento) {
		AdjuntoGastoAsociado adjuntoGasto = genericDao.get(AdjuntoGastoAsociado.class, genericDao.createFilter(FilterType.EQUALS, "id", id));

		FileItem fileItem = adjuntoGasto.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoGasto.getTipoContenidoDocumento());
		fileItem.setFileName(adjuntoGasto.getNombreAdjuntoGastoAsociado());

		return adjuntoGasto.getAdjunto().getFileItem();
	}
	
	@Override
	public FileItem getFileItemExpediente(Long id,String nombreDocumento) {
		AdjuntoExpedienteComercial adjuntoExpedienteComercial = genericDao.get(AdjuntoExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "id", id));

		FileItem fileItem = adjuntoExpedienteComercial.getAdjunto().getFileItem();
		fileItem.setContentType(adjuntoExpedienteComercial.getContentType());
		fileItem.setFileName(adjuntoExpedienteComercial.getNombre());

		return adjuntoExpedienteComercial.getAdjunto().getFileItem();
	}
	
}
