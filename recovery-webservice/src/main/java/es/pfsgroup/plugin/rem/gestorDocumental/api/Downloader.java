package es.pfsgroup.plugin.rem.gestorDocumental.api;

import es.capgemini.devon.files.FileItem;

public interface Downloader {
	
	FileItem getFileItem(Long id) throws Exception;
	
	String[] getKeys();

}
