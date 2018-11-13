package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
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

}
