package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_TRABAJO", schema = "${entity.schema}")
public class VBusquedaActivosTrabajo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="VAT_ID")
	private String idVista;

	@Column(name= "TBJ_ID")
	private String idTrabajo;

	@Column(name = "ACT_ID")
	private String idActivo;
	
	@Column(name="SUBTIPO_ACTIVO_DESCRIPCION")
	private String subtipoActivoDescripcion;
	
	@Column(name="TIPO_ACTIVO_DESCRIPCION")
	private String tipoActivoDescripcion;	

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;  
	
	@Column(name = "ACT_NUM_ACTIVO_REM")
	private String numActivoRem;
    
    @Column(name = "ENTIDAD_PROPIETARIA_DESC")
    private String entidadPropietariaDescripcion;
	
	@Column(name = "LOCALIDAD_DESCRIPCION")
	private String localidadDescripcion;
	
	@Column(name = "PROVINCIA_DESCRIPCION")
	private String provinciaDescripcion;
	
	@Column(name = "BIE_LOC_NOMBRE_VIA")
	private String direccion;
	
	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercial;
	
	@Column(name = "SPS_OCUPADO")
	private String situacionPosesoriaOcupado;
	
	@Column(name = "SPS_CON_TITULO")
	private String situacionPosesoriaTitulo;
	
	@Column(name="DD_EST_CODIGO")
	private String codigoEstado;
	
	@Column(name="DD_EST_DESCRIPCION")
	private String descripcionEstado;
	
	@Column(name="DD_EST_ESTADO_CONTABLE")
	private String estadoContable;
	
	@Column(name="ACT_TBJ_PARTICIPACION")
	private Float participacion;
	
	public String getIdVista() {
		return idVista;
	}

	public void setIdVista(String idVista) {
		this.idVista = idVista;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(String idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}

	public String getSituacionPosesoriaOcupado() {
		return situacionPosesoriaOcupado;
	}

	public void setSituacionPosesoriaOcupado(String situacionPosesoriaOcupado) {
		this.situacionPosesoriaOcupado = situacionPosesoriaOcupado;
	}

	public String getSituacionPosesoriaTitulo() {
		return situacionPosesoriaTitulo;
	}

	public void setSituacionPosesoriaTitulo(String situacionPosesoriaTitulo) {
		this.situacionPosesoriaTitulo = situacionPosesoriaTitulo;
	}

	public String getCodigoEstado() {
		return codigoEstado;
	}

	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}

	public String getDescripcionEstado() {
		return descripcionEstado;
	}

	public void setDescripcionEstado(String descripcionEstado) {
		this.descripcionEstado = descripcionEstado;
	}

	public String getEstadoContable() {
		return estadoContable;
	}

	public void setEstadoContable(String estadoContable) {
		this.estadoContable = estadoContable;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Float getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Float participacion) {
		this.participacion = participacion;
	}
}
