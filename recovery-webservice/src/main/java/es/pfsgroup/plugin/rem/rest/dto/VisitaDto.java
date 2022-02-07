package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Lista;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class VisitaDto implements Serializable {

	private static final long serialVersionUID = 3773651686763584927L;
	
	
	
	@NotNull(groups = { Insert.class, Update.class })
	private Long idVisitaWebcom;
	private Long idVisitaRem;
	@NotNull(groups = { Insert.class })
	@Lista(clase = ClienteComercial.class, message = "El idClienteRem no existe", groups = { Insert.class,
			Update.class },foreingField="idClienteRem")
	private Long idClienteRem;
	@NotNull(groups = { Insert.class })
	@Diccionary(clase = Activo.class, message = "El activo no existe", foreingField = "numActivo", groups = {
			Insert.class, Update.class })
	private Long idActivoHaya;
	
	@NotNull(groups = { Insert.class})
	@Diccionary(clase = DDEstadosVisita.class, message = "El codEstadoVisita no existe", groups = {
			Insert.class, Update.class })
	private String codEstadoVisita;
	//@NotNull(groups = { Insert.class})
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codDetalleEstadoVisita;
	@NotNull(groups = { Insert.class})
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemPrescriptor no existe", groups = { Insert.class,
		Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemPrescriptor;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemCustodio no existe", groups = { Insert.class,
		Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemCustodio;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemResponsable no existe", groups = { Insert.class,
		Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemResponsable;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemFdv no existe", groups = { Insert.class,
		Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemFdv;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemVisita no existe", groups = { Insert.class,
		Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemVisita;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorPrescriptorOportunidadREM no existe", groups = { Insert.class,
			Update.class },foreingField="codigoProveedorRem")
		private Long idProveedorPrescriptorOportunidadREM;
	@Size(max=1024,groups = { Insert.class, Update.class })
	private String observaciones;
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Usuario.class, message = "El usuario no existe", groups = { Insert.class,
		Update.class },foreingField="id")
	private Long idUsuarioRemAccion;
	private Date fecha;
	
	private String idLeadSalesforce;
	
	private Date fechaReasignacionRealizadorOportunidad;
	
	//Se añaden nuevos atributos petición HREOS-1396
	@Size(max=14,groups = { Insert.class, Update.class })
	private String telefonoContactoVisitas;
	
	@Diccionary(clase = DDOrigenComprador.class, message = "El codOrigenComprador no existe", groups = {
			Insert.class, Update.class })
	private String codOrigenComprador;
	
	private String idVisitaBC;
	
	public Long getIdVisitaWebcom() {
		return idVisitaWebcom;
	}
	public void setIdVisitaWebcom(Long idVisitaWebcom) {
		this.idVisitaWebcom = idVisitaWebcom;
	}
	public Long getIdVisitaRem() {
		return idVisitaRem;
	}
	public void setIdVisitaRem(Long idVisitaRem) {
		this.idVisitaRem = idVisitaRem;
	}
	public Long getIdClienteRem() {
		return idClienteRem;
	}
	public void setIdClienteRem(Long idClienteRem) {
		this.idClienteRem = idClienteRem;
	}
	public Long getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public String getCodEstadoVisita() {
		return codEstadoVisita;
	}
	public void setCodEstadoVisita(String codEstadoVisita) {
		this.codEstadoVisita = codEstadoVisita;
	}
	public String getCodDetalleEstadoVisita() {
		return codDetalleEstadoVisita;
	}
	public void setCodDetalleEstadoVisita(String codDetalleEstadoVisita) {
		this.codDetalleEstadoVisita = codDetalleEstadoVisita;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaVisita) {
		this.fechaAccion = fechaVisita;
	}
	public Long getIdProveedorRemPrescriptor() {
		return idProveedorRemPrescriptor;
	}
	public void setIdProveedorRemPrescriptor(Long idProveedorRemPrescriptor) {
		this.idProveedorRemPrescriptor = idProveedorRemPrescriptor;
	}
	public Long getIdProveedorRemCustodio() {
		return idProveedorRemCustodio;
	}
	public void setIdProveedorRemCustodio(Long idProveedorRemCustodio) {
		this.idProveedorRemCustodio = idProveedorRemCustodio;
	}
	public Long getIdProveedorRemResponsable() {
		return idProveedorRemResponsable;
	}
	public void setIdProveedorRemResponsable(Long idProveedorRemResponsable) {
		this.idProveedorRemResponsable = idProveedorRemResponsable;
	}
	public Long getIdProveedorRemFdv() {
		return idProveedorRemFdv;
	}
	public void setIdProveedorRemFdv(Long idProveedorRemFdv) {
		this.idProveedorRemFdv = idProveedorRemFdv;
	}
	public Long getIdProveedorRemVisita() {
		return idProveedorRemVisita;
	}
	public void setIdProveedorRemVisita(Long idProveedorRemVisita) {
		this.idProveedorRemVisita = idProveedorRemVisita;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getTelefonoContactoVisitas() {
		return telefonoContactoVisitas;
	}
	public void setTelefonoContactoVisitas(String telefonoContactoVisitas) {
		this.telefonoContactoVisitas = telefonoContactoVisitas;
	}	
	
	/*public Boolean getVisitaPrescriptor() {
		return visitaPrescriptor;
	}
	public void setVisitaPrescriptor(Boolean visitaPrescriptor) {
		this.visitaPrescriptor = visitaPrescriptor;
	}
	public Boolean getVisitaApiResponsable() {
		return visitaApiResponsable;
	}
	public void setVisitaApiResponsable(Boolean visitaApiResponsable) {
		this.visitaApiResponsable = visitaApiResponsable;
	}
	public Boolean getVisitaApiCustodio() {
		return visitaApiCustodio;
	}
	public void setVisitaApiCustodio(Boolean visitaApiCustodio) {
		this.visitaApiCustodio = visitaApiCustodio;
	}
	*/
	
	public String getIdLeadSalesforce() {
		return idLeadSalesforce;
	}
	public void setIdLeadSalesforce(String idLeadSalesforce) {
		this.idLeadSalesforce = idLeadSalesforce;
	}
	public String getCodOrigenComprador() {
		return codOrigenComprador;
	}
	public void setCodOrigenComprador(String codOrigenComprador) {
		this.codOrigenComprador = codOrigenComprador;
	}
	public Long getIdProveedorPrescriptorOportunidadREM() {
		return idProveedorPrescriptorOportunidadREM;
	}
	public void setIdProveedorPrescriptorOportunidadREM(Long idProveedorPrescriptorOportunidadREM) {
		this.idProveedorPrescriptorOportunidadREM = idProveedorPrescriptorOportunidadREM;
	}
	public Date getFechaReasignacionRealizadorOportunidad() {
		return fechaReasignacionRealizadorOportunidad;
	}
	public void setFechaReasignacionRealizadorOportunidad(Date fechaReasignacionRealizadorOportunidad) {
		this.fechaReasignacionRealizadorOportunidad = fechaReasignacionRealizadorOportunidad;
	}

	public String getIdVisitaBC() {
		return idVisitaBC;
	}

	public void setIdVisitaBC(String idVisitaBC) {
		this.idVisitaBC = idVisitaBC;
	}
}
