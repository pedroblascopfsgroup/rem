package es.pfsgroup.recovery.bpmframework.api.dto;

import java.util.Map;

import es.capgemini.devon.files.FileItem;

/**
 * Informaci�n b�sica de un input
 * 
 * @author bruno
 * 
 */
public interface RecoveryBPMfwkInputInfo {

    FileItem getAdjunto();

    Map<String, Object> getDatos();

    String getCodigoTipoInput();

    Long getIdProcedimiento();

}
