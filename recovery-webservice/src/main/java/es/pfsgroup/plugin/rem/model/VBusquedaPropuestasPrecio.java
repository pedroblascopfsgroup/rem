package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_PROPUESTAS_PRECIO", schema = "${entity.schema}")
public class VBusquedaPropuestasPrecio implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "PRP_ID")
	private String id;
	
	@Column(name="PRP_NUM_PROPUESTA")
	private String numPropuesta;
	
	@Column(name="PRP_NOMBRE_PROPUESTA")
	private String nombrePropuesta;
	
	@Column(name="PRP_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name="PRP_FECHA_ENVIO")
	private Date fechaEnvio;
	
	@Column(name="PRP_FECHA_SANCION")
	private Date fechaSancion;
	
	@Column(name="PRP_FECHA_CARGA")
	private Date fechaCarga;
	
	@Column(name="TBJ_ID")
	private String idTrabajo;
	
	@Column(name="TBJ_NUM_TRABAJO")
	private String numTrabajo;
		
    @Column(name = "ENTIDAD_CODIGO")
    private String entidadPropietariaCodigo;
    
    @Column(name = "ENTIDAD_DESCRIPCION")
    private String entidadPropietariaDescripcion;
    
    @Column(name = "ESTADO_CODIGO")
    private String estadoCodigo;
    
    @Column(name = "ESTADO_DESCRIPCION")
    private String estadoDescripcion;
    
    @Column(name="TRA_ID")
    private String numTramite;
    
    @Column(name="DD_TPO_ID")
    private String idTipoProcedimiento;
    
    @Column(name="DD_TPO_DESCRIPCION")
    private String tipoProcedimientoDescripcion;
    
    @Column(name="PRP_OBSERVACIONES")
    private String observaciones;
    
    @Column(name="GESTOR_PRECIOS")
    private String gestor;

    @Column(name="TIPO_CODIGO")
    private String tipoPropuesta;
    
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNumPropuesta() {
		return numPropuesta;
	}

	public void setNumPropuesta(String numPropuesta) {
		this.numPropuesta = numPropuesta;
	}

	public String getNombrePropuesta() {
		return nombrePropuesta;
	}

	public void setNombrePropuesta(String nombrePropuesta) {
		this.nombrePropuesta = nombrePropuesta;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(String idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public String getEstadoCodigo() {
		return estadoCodigo;
	}

	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}

	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}

	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}

	public String getNumTramite() {
		return numTramite;
	}

	public void setNumTramite(String numTramite) {
		this.numTramite = numTramite;
	}

	public String getIdTipoProcedimiento() {
		return idTipoProcedimiento;
	}

	public void setIdTipoProcedimiento(String idTipoProcedimiento) {
		this.idTipoProcedimiento = idTipoProcedimiento;
	}

	public String getTipoProcedimientoDescripcion() {
		return tipoProcedimientoDescripcion;
	}

	public void setTipoProcedimientoDescripcion(String tipoProcedimientoDescripcion) {
		this.tipoProcedimientoDescripcion = tipoProcedimientoDescripcion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}

	public String getTipoPropuesta() {
		return tipoPropuesta;
	}

	public void setTipoPropuesta(String tipoPropuesta) {
		this.tipoPropuesta = tipoPropuesta;
	}
    
}
