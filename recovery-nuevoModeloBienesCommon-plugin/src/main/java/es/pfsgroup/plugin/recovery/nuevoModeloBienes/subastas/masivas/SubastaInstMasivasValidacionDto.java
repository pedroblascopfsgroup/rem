package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.masivas;

import java.util.List;

import es.capgemini.devon.files.FileItem;

public class SubastaInstMasivasValidacionDto {

	private Long idProceso;
	private Boolean ficheroTieneErrores;
	private List<String> listaErrores;
	
	public Long getIdProceso() {
		return idProceso;
	}
	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}
	public void setFicheroTieneErrores(Boolean ficheroTieneErrores) {
		this.ficheroTieneErrores = ficheroTieneErrores;
	}
	public Boolean getFicheroTieneErrores() {
		return ficheroTieneErrores;
	}
	public List<String> getListaErrores() {
		return listaErrores;
	}
	public void setListaErrores(List<String> listaErrores) {
		this.listaErrores = listaErrores;
	}

}
