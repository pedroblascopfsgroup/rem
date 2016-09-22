package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;
import es.pfsgroup.plugin.rem.model.dd.DDUbicacionActivo;
import es.pfsgroup.plugin.rem.rest.validator.Diccionary;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class InformeMediadorDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;

	@NotNull(groups = { Insert.class, Update.class })
	private Long idUsuarioRemAccion;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoActivo.class, message = "El codTipoActivo no existe")
	private String codTipoActivo;

	@NotNull(groups = { Insert.class, Update.class })
	private Long idActivoHaya;

	@NotNull(groups = Insert.class)
	private Long idProveedorRemAnterior;

	@NotNull(groups = Insert.class)
	private Long idProveedorRem;

	@NotNull(groups = Insert.class)
	private Boolean posibleInforme;

	@NotNull(groups = Insert.class)
	private String motivoNoPosibleInforme;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDSubtipoActivo.class, message = "El codSubtipoImueble no existe")
	private String codSubtipoImueble;
	
	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoVivienda.class, message = "El codTpoVivienda de activo no existe")
	private String codTpoVivienda;
	
	@NotNull(groups = Insert.class)
	private Date fechaUltimaVisita;
	
	@Diccionary(clase = DDTipoVia.class, message = "El codTpoVivienda de activo no existe")
	private String codTipoVia;

	@NotNull(groups = Insert.class)
	private String nombreCalle;
	
	@NotNull(groups = Insert.class)
	private String numeroCalle;
	
	private String escalera;
	
	private String planta;
	
	private String puerta;
	
	@NotNull(groups = Insert.class)
	@Diccionary(clase = Localidad.class, message = "El codMunicipio no existe")
	private String codMunicipio;
	
	@Diccionary(clase = DDUnidadPoblacional.class, message = "El codPedania no existe")
	private String codPedania;
	
	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDProvincia.class, message = "El codProvincia no existe")
	private String codProvincia;
	
	@NotNull(groups = Insert.class)
	private String codigoPostal;
	
	@NotNull(groups = Insert.class)
	private String zona;
	
	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDUbicacionActivo.class, message = "El codUbicacion no existe")
	private String codUbicacion;
	
	
	public String getCodTipoActivo() {
		return codTipoActivo;
	}

	public void setCodTipoActivo(String codTipoActivo) {
		this.codTipoActivo = codTipoActivo;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}

	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}

	public Long getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(Long idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

}
