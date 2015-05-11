package es.pfsgroup.plugin.recovery.iplus.controller;

import java.util.Map;

import org.springframework.ui.ModelMap;

public interface IPlusControllerApi {

	public String bajarDocumento(ModelMap map, Long idAsunto, String nombre, String descripcion);
	
	public String borrarAdjunto(ModelMap map, Long idAsunto, Long idAdjunto, String nombre, String descripcion);
}
