package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_HISTORICO_REAGENDACIONES", schema = "${entity.schema}")
public class VGridHistoricoReagendaciones implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "hre_id")
	private Long id;

	@Column(name = "HRE_FECHA_REAGENDACION_INGRESO")
	private Date fechaReagendacionIngreso;

	@Column(name = "FIA_FECHA_AGENDACION_INGRESO")
	private Date fechaAgendacionIngreso;

	@Column(name = "FIA_IMPORTE")
	private Double importe;
	
	@Column(name = "FIA_FECHA_INGRESO")
	private String fechaIngreso;

	@Column(name = "FIA_IBAN_DEVOLUCION")
	private String ibanDevolucion;

	@Column(name = "OFR_NUM_OFERTA")
	private Long numeroOferta;

	@Column(name = "CVA_CUENTA_VIRTUAL")
	private String cuentaVirtual;

	@Column(name = "ECO_ID")
	private Long idExpedienteComercial;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaReagendacionIngreso() {
		return fechaReagendacionIngreso;
	}

	public void setFechaReagendacionIngreso(Date fechaReagendacionIngreso) {
		this.fechaReagendacionIngreso = fechaReagendacionIngreso;
	}

	public Date getFechaAgendacionIngreso() {
		return fechaAgendacionIngreso;
	}

	public void setFechaAgendacionIngreso(Date fechaAgendacionIngreso) {
		this.fechaAgendacionIngreso = fechaAgendacionIngreso;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getFechaIngreso() {
		return fechaIngreso;
	}

	public void setFechaIngreso(String fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}

	public Long getNumeroOferta() {
		return numeroOferta;
	}

	public void setNumeroOferta(Long numeroOferta) {
		this.numeroOferta = numeroOferta;
	}

	public String getCuentaVirtual() {
		return cuentaVirtual;
	}

	public void setCuentaVirtual(String cuentaVirtual) {
		this.cuentaVirtual = cuentaVirtual;
	}

	public Long getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(Long idExpedienteComercial) {
		this.idExpedienteComercial = idExpedienteComercial;
	}

}
