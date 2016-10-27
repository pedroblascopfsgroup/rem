package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Vista que recoge los tramites de un activo. Los nombres de los campos se han puesto
 * conforme DtoListadoTramites, para aprovecharlo.
 * @author jros
 *
 */
@Entity
@Table(name = "V_BUSQUEDA_TRAMITES_ACTIVO", schema = "${entity.schema}")
public class VBusquedaTramitesActivo implements Serializable {
	

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="TRA_ID")
	private Long idTramite;

	@Column(name="TIPO_TRAMITE_ID")
	private Long idTipoTramite;
	
	@Column(name="TIPO_TRAMITE_CODIGO")
	private String codigoTipoTramite;
	
	@Column(name="TIPO_TRAMITE_DESCRIPCION")
	private String tipoTramite;
	
	@Column(name="TRAMITE_PADRE_ID")
	private Long idTramitePadre;

	@Column(name="ACT_ID")
	private Long idActivo;
	
	@Column(name="NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name="NOMBRE")//Coincide con tipoTramite, pero así esta en el dto
	private String nombre;
	
	@Column(name="ESTADO_CODIGO")
	private String codigoEstado;
	
	@Column(name="ESTADO_DESCRIPCION")
	private String estado;
	
	@Column(name="SUBTIPO_TBJ_CODIGO")
	private String codigoSubtipoTrabajo;
	
	@Column(name="SUBTIPO_TBJ_DESCRIPCION")
	private String subtipoTrabajo;
	
	@Column(name="FECHA_INICIO")
	private Date fechaInicio;
	
	@Column(name="FECHA_FIN")
	private Date fechaFinalizacion;
	
	

	public Long getIdTramite() {
		return idTramite;
	}

	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}

	public Long getIdTipoTramite() {
		return idTipoTramite;
	}

	public void setIdTipoTramite(Long idTipoTramite) {
		this.idTipoTramite = idTipoTramite;
	}

	public String getCodigoTipoTramite() {
		return codigoTipoTramite;
	}

	public void setCodigoTipoTramite(String codigoTipoTramite) {
		this.codigoTipoTramite = codigoTipoTramite;
	}

	public String getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(String tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public Long getIdTramitePadre() {
		return idTramitePadre;
	}

	public void setIdTramitePadre(Long idTramitePadre) {
		this.idTramitePadre = idTramitePadre;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCodigoEstado() {
		return codigoEstado;
	}

	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getCodigoSubtipoTrabajo() {
		return codigoSubtipoTrabajo;
	}

	public void setCodigoSubtipoTrabajo(String codigoSubtipoTrabajo) {
		this.codigoSubtipoTrabajo = codigoSubtipoTrabajo;
	}

	public String getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(String subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFinalizacion() {
		return fechaFinalizacion;
	}

	public void setFechaFinalizacion(Date fechaFinalizacion) {
		this.fechaFinalizacion = fechaFinalizacion;
	}
	
	
	
}
