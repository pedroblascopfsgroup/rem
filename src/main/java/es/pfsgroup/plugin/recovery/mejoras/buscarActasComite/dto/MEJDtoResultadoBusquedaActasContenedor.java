package es.pfsgroup.plugin.recovery.mejoras.buscarActasComite.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para Procedimientos Derivados.
 *
 * @author Lisandro Medrano
 *
 */
public class MEJDtoResultadoBusquedaActasContenedor extends WebDto {
	
	private static final long serialVersionUID = 6015680735564006223L;
	
	private List<MEJDtoResultadoBusquedaActas> listaSesiones;
	private int totalCount ;
	
	public List<MEJDtoResultadoBusquedaActas> getListaSesiones() {
		return listaSesiones;
	}
	public void setListaSesiones(List<MEJDtoResultadoBusquedaActas> listaSesiones) {
		this.listaSesiones = listaSesiones;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	
}
