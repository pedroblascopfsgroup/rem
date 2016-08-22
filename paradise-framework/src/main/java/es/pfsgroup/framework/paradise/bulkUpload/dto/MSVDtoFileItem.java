package es.pfsgroup.framework.paradise.bulkUpload.dto;

public class MSVDtoFileItem {

	private String nombre;
	private String ruta;
	private Long idTipoOperacion;
	private Long idProceso;
	private Long idTipoJuicio;
	private Long idTipoResolucion;
	private Long idResolucion;
	private String plaza;
	private String auto;
	private String juzgado;
	private Long idAsunto;
	private Double principal;
	private Long idTarea;
	
	public String getPlaza() {
		return plaza;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getAuto() {
		return auto;
	}
	public void setAuto(String auto) {
		this.auto = auto;
	}
	public String getJuzgado() {
		return juzgado;
	}
	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}
	public Long getIdAsunto() {
		return idAsunto;
	}
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
	
	public Long getIdTipoJuicio() {
		return idTipoJuicio;
	}
	public void setIdTipoJuicio(Long idTipoJuicio) {
		this.idTipoJuicio = idTipoJuicio;
	}
	public Long getIdTipoResolucion() {
		return idTipoResolucion;
	}
	public void setIdTipoResolucion(Long idTipoResolucion) {
		this.idTipoResolucion = idTipoResolucion;
	}
	public Long getIdResolucion() {
		return idResolucion;
	}
	public void setIdResolucion(Long idResolucion) {
		this.idResolucion = idResolucion;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	public Long getIdTipoOperacion() {
		return idTipoOperacion;
	}
	public void setIdTipoOperacion(Long idTipoOperacion) {
		this.idTipoOperacion = idTipoOperacion;
	}
	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}
	public Long getIdProceso() {
		return idProceso;
	}
	public Double getPrincipal() {
		return principal;
	}
	public void setPrincipal(Double principal) {
		this.principal = principal;
	}
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	
}
