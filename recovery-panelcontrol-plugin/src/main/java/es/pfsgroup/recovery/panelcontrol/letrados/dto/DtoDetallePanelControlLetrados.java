package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoDetallePanelControlLetrados extends  WebDto{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2345472348736981181L;

	/**
	 *  Identificador del nivel de jerarquía
	 * **/
	private Long nivel;
	
	/***
	 * Identificador de la zona dentro de una jerarquía
	 * 
	 * */
	private Long idNivel;
	
	/***
	 * Indica el detalle del campo que queremos obtener. usado para los contratos y las tareas
	 * 
	 * */
	private Long detalle;
	
	private String cod;
	
	private String nombre;
	
	private String userName;
	
	/**
	 * Tipo de procedimiento seleccionado en el filtro de búsqueda
	 * 
	 * */
	private String tipoProcedimiento;
	
	/**
	 * Tipo de tarea seleccionada en el filtro de búsqueda
	 * 
	 * */
	private String tipoTarea;
	/**
	 * Indica si las tareas obtenidas son para asuntos o expedientes TAR/EXP
	 * 
	 * */
	private String tipo;
	private String letradoGestor;
	private String campanya;
    private Double minImporteFiltro;
    private Double maxImporteFiltro;
    
    private String panelTareas;
    private String rangoImporte;
    
    private String cartera;
    private String lote;
    
    private String idPlaza;
    private String idJuzgado;
    
	public void setNivel(Long nivel) {
		this.nivel = nivel;
	}
	public Long getNivel() {
		return nivel;
	}
	public void setIdNivel(Long idNivel) {
		this.idNivel = idNivel;
	}
	public Long getIdNivel() {
		return idNivel;
	}
	public void setDetalle(Long detalle) {
		this.detalle = detalle;
	}
	public Long getDetalle() {
		return detalle;
	}
	public void setCod(String cod) {
		this.cod = cod;
	}
	public String getCod() {
		return cod;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNombre() {
		return nombre;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public String getTipoTarea() {
		return tipoTarea;
	}
	public void setTipoTarea(String tipoTarea) {
		this.tipoTarea = tipoTarea;
	}
	public String getLetradoGestor() {
		return letradoGestor;
	}
	public void setLetradoGestor(String letradoGestor) {
		this.letradoGestor = letradoGestor;
	}
	public String getCampanya() {
		return campanya;
	}
	public void setCampanya(String campanya) {
		this.campanya = campanya;
	}
	public Double getMinImporteFiltro() {
		return minImporteFiltro;
	}
	public void setMinImporteFiltro(Double minImporteFiltro) {
		this.minImporteFiltro = minImporteFiltro;
	}
	public Double getMaxImporteFiltro() {
		return maxImporteFiltro;
	}
	public void setMaxImporteFiltro(Double maxImporteFiltro) {
		this.maxImporteFiltro = maxImporteFiltro;
	}
	public void setPanelTareas(String panelTareas) {
		this.panelTareas = panelTareas;
	}
	public String getPanelTareas() {
		return panelTareas;
	}
	public String getRangoImporte() {
		return rangoImporte;
	}
	public void setRangoImporte(String rangoImporte) {
		this.rangoImporte = rangoImporte;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getCartera() {
		return cartera;
	}
	public void setIdPlaza(String idPlaza) {
		this.idPlaza = idPlaza;
	}
	public String getIdPlaza() {
		return idPlaza;
	}
	public void setIdJuzgado(String idJuzgado) {
		this.idJuzgado = idJuzgado;
	}
	public String getIdJuzgado() {
		return idJuzgado;
	}
	public String getLote() {
		return lote;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	
}
