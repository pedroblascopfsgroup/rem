package es.capgemini.pfs.mapaGlobalOficina.dto;

/**
 * @author marruiz
 */
public class DtoExportRowCount {

	private boolean hayGestionNormal;
	private boolean hayGestionPrimaria;
	private boolean hayGestionInterna;
	private boolean hayGestionExterna;


	/**
	 * @return the hayGestionNormal
	 */
	public boolean getHayGestionNormal() {
		return hayGestionNormal;
	}
	/**
	 * @param hayGestionNormal the hayGestionNormal to set
	 */
	public void setHayGestionNormal(boolean hayGestionNormal) {
		this.hayGestionNormal = hayGestionNormal;
	}
	/**
	 * @return the hayGestionPrimaria
	 */
	public boolean getHayGestionPrimaria() {
		return hayGestionPrimaria;
	}
	/**
	 * @param hayGestionPrimaria the hayGestionPrimaria to set
	 */
	public void setHayGestionPrimaria(boolean hayGestionPrimaria) {
		this.hayGestionPrimaria = hayGestionPrimaria;
	}
	/**
	 * @return the hayGestionInterna
	 */
	public boolean getHayGestionInterna() {
		return hayGestionInterna;
	}
	/**
	 * @param hayGestionInterna the hayGestionInterna to set
	 */
	public void setHayGestionInterna(boolean hayGestionInterna) {
		this.hayGestionInterna = hayGestionInterna;
	}
	/**
	 * @return the hayGestionExterna
	 */
	public boolean getHayGestionExterna() {
		return hayGestionExterna;
	}
	/**
	 * @param hayGestionExterna the hayGestionExterna to set
	 */
	public void setHayGestionExterna(boolean hayGestionExterna) {
		this.hayGestionExterna = hayGestionExterna;
	}
}
