package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_PREFACTURAS", schema = "${entity.schema}")
public class VbusquedaPrefacturas implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "PFA_ID")
	private Long pfa_id;
	
	@Column(name = "ALB_ID")
	private Long albaranId;
	
	@Column(name = "PFA_NUM_PREFACTURA")
	private Long numPrefactura;
	
	@Column(name = "PVE_NOMBRE")
	private String proveedor;
	
	@Column(name = "PRO_NOMBRE")
	private String propietario;
	
	@Column(name = "DD_EPF_DESCRIPCION")
	private String estadoAlbaran;
	
	@Column(name = "ANYO")
	private String anyo;
	
	@Column(name = "IMPORTE_TOTAL")
	private Double importeTotalDetalle;
	
	@Column(name = "IMPORTE_CLIENTE")
	private Double importeTotalClienteDetalle;
	
	@Column(name = "NUMTRABAJOS")
	private Long numeroTrabajos;
	
	@Column(name = "NUM_GASTOS")
	private Long numGasto;
	
	@Column(name= "ESTADO_GASTO")
	private String estadoGasto;
	
	@Column(name = "PFA_FECHA_PREFACTURA")
	private Date fechaPrefactura;
	
	@Column(name = "DD_IRE_DESCRIPCION")
	private String areaPeticionaria;
	
	@Column(name = "DD_IRE_CODIGO")
	private String codAreaPeticionaria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getPfa_id() {
		return pfa_id;
	}

	public void setPfa_id(Long pfa_id) {
		this.pfa_id = pfa_id;
	}

	public Long getNumPrefactura() {
		return numPrefactura;
	}

	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getEstadoAlbaran() {
		return estadoAlbaran;
	}

	public void setEstadoAlbaran(String estadoAlbaran) {
		this.estadoAlbaran = estadoAlbaran;
	}

	public String getAnyo() {
		return anyo;
	}

	public void setAnyo(String anyo) {
		this.anyo = anyo;
	}

	public Double getImporteTotalDetalle() {
		return importeTotalDetalle;
	}

	public void setImporteTotalDetalle(Double importeTotalDetalle) {
		this.importeTotalDetalle = importeTotalDetalle;
	}

	public Double getImporteTotalClienteDetalle() {
		return importeTotalClienteDetalle;
	}

	public void setImporteTotalClienteDetalle(Double importeTotalClienteDetalle) {
		this.importeTotalClienteDetalle = importeTotalClienteDetalle;
	}

	public Long getNumeroTrabajos() {
		return numeroTrabajos;
	}

	public void setNumeroTrabajos(Long numeroTrabajos) {
		this.numeroTrabajos = numeroTrabajos;
	}

	public String getEstadoGasto() {
		return estadoGasto;
	}

	public void setEstadoGasto(String estadoGasto) {
		this.estadoGasto = estadoGasto;
	}
	public Long getNumGasto() {
		return numGasto;
	}

	public void setNumGasto(Long numGasto) {
		this.numGasto = numGasto;
	}

	public Date getFechaPrefactura() {
		return fechaPrefactura;
	}

	public void setFechaPrefactura(Date fechaPrefactura) {
		this.fechaPrefactura = fechaPrefactura;
	}

	public Long getAlbaranId() {
		return albaranId;
	}

	public void setAlbaranId(Long albaranId) {
		this.albaranId = albaranId;
	}

	public String getAreaPeticionaria() {
		return areaPeticionaria;
	}

	public void setAreaPeticionaria(String areaPeticionaria) {
		this.areaPeticionaria = areaPeticionaria;
	}

	public String getCodAreaPeticionaria() {
		return codAreaPeticionaria;
	}

	public void setCodAreaPeticionaria(String codAreaPeticionaria) {
		this.codAreaPeticionaria = codAreaPeticionaria;
	}
	
}
