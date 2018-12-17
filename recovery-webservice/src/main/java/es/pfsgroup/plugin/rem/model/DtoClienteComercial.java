package es.pfsgroup.plugin.rem.model;


public class DtoClienteComercial {

	private Long id;
    private String razonSocial;
    private String nombreCliente;
    private String apellidosCliente;
	private String tipoPersonaCodigo;
	private String tipoPersonaDescripcion;
	private String estadoCivilCodigo;
	private String estadoCivilDescripcion;
	private String regimenMatrimonialCodigo;
	private String regimenMatrimonialDescripcion;
    private Boolean cesionDatos;
    private Boolean comunicacionTerceros;
    private Boolean transferenciasInternacionales;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getApellidosCliente() {
		return apellidosCliente;
	}
	public void setApellidosCliente(String apellidosCliente) {
		this.apellidosCliente = apellidosCliente;
	}
	public String getTipoPersonaCodigo() {
		return tipoPersonaCodigo;
	}
	public void setTipoPersonaCodigo(String tipoPersonaCodigo) {
		this.tipoPersonaCodigo = tipoPersonaCodigo;
	}
	public String getTipoPersonaDescripcion() {
		return tipoPersonaDescripcion;
	}
	public void setTipoPersonaDescripcion(String tipoPersonaDescripcion) {
		this.tipoPersonaDescripcion = tipoPersonaDescripcion;
	}
	public String getEstadoCivilCodigo() {
		return estadoCivilCodigo;
	}
	public void setEstadoCivilCodigo(String estadoCivilCodigo) {
		this.estadoCivilCodigo = estadoCivilCodigo;
	}
	public String getEstadoCivilDescripcion() {
		return estadoCivilDescripcion;
	}
	public void setEstadoCivilDescripcion(String estadoCivilDescripcion) {
		this.estadoCivilDescripcion = estadoCivilDescripcion;
	}
	public String getRegimenMatrimonialCodigo() {
		return regimenMatrimonialCodigo;
	}
	public void setRegimenMatrimonialCodigo(String regimenMatrimonialCodigo) {
		this.regimenMatrimonialCodigo = regimenMatrimonialCodigo;
	}
	public String getRegimenMatrimonialDescripcion() {
		return regimenMatrimonialDescripcion;
	}
	public void setRegimenMatrimonialDescripcion(String regimenMatrimonialDescripcion) {
		this.regimenMatrimonialDescripcion = regimenMatrimonialDescripcion;
	}
	public Boolean getCesionDatos() {
		return cesionDatos;
	}
	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}
	public Boolean getComunicacionTerceros() {
		return comunicacionTerceros;
	}
	public void setComunicacionTerceros(Boolean comunicacionTerceros) {
		this.comunicacionTerceros = comunicacionTerceros;
	}
	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}
	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
	}
}
