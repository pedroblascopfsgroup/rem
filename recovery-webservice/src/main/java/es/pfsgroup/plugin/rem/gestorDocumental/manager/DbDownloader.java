package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;

@Component
public class DbDownloader implements Downloader {

	@Autowired
	private GenericABMDao genericDao;
	
	private static final String DEFAULT = "DEFAULT";
	private static final String BASE_DE_DATOS = "DB";
	
	@Override
	public FileItem getFileItem(Long id) {
		Adjunto adj = genericDao.get(Adjunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		return adj.getFileItem();
	}

	@Override
	public String[] getKeys() {
		return new String[]{BASE_DE_DATOS, DEFAULT};
	}

}
