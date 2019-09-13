package es.pfsgroup.plugin.rem.gestorDocumental.api;

import es.capgemini.devon.files.FileItem;

public interface Downloader {
	
	FileItem getFileItem(Long id, String nombreDocumento) throws Exception;
	
	FileItem getFileItemPromocion(Long id, String nombreDocumento) throws Exception;
	
	String[] getKeys();

	FileItem getFileItemComunicacionGencat(Long id, String nombreDocumento);

	FileItem getFileItemTributo(Long id, String nombreDocumento)  throws Exception;

}
