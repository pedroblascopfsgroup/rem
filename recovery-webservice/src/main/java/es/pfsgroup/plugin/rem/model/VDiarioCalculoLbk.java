package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Vista que recoge los datos necesario para el calculo comité liberbank.
 * 
 * @author Jonathan Ovalle
 */
@Entity
@Table(name = "V_DIARIOS_CALCULO_LBK", schema = "${entity.schema}")
public class VDiarioCalculoLbk implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="GPV_ID")
	private Long id;
	
	@Column(name="DIARIO1")
	private String diario1;
	
	@Column(name="DIARIO1_BASE")
	private Double diario1Base;
	
	@Column(name="DIARIO1_TIPO")
	private Double diario1Tipo;
	
	@Column(name="DIARIO1_CUOTA")
	private Double diario1Cuota;
	
	@Column(name="DIARIO2")
	private String diario2;
	
	@Column(name="DIARIO2_BASE")
	private Double diario2Base;
	
	@Column(name="DIARIO2_TIPO")
	private Double diario2Tipo;
	
	@Column(name="DIARIO2_CUOTA")
	private Double diario2Cuota;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDiario1() {
		return diario1;
	}

	public void setDiario1(String diario1) {
		this.diario1 = diario1;
	}

	public Double getDiario1Base() {
		return diario1Base;
	}

	public void setDiario1Base(Double diario1Base) {
		this.diario1Base = diario1Base;
	}

	public Double getDiario1Tipo() {
		return diario1Tipo;
	}

	public void setDiario1Tipo(Double diario1Tipo) {
		this.diario1Tipo = diario1Tipo;
	}

	public Double getDiario1Cuota() {
		return diario1Cuota;
	}

	public void setDiario1Cuota(Double diario1Cuota) {
		this.diario1Cuota = diario1Cuota;
	}

	public String getDiario2() {
		return diario2;
	}

	public void setDiario2(String diario2) {
		this.diario2 = diario2;
	}

	public Double getDiario2Base() {
		return diario2Base;
	}

	public void setDiario2Base(Double diario2Base) {
		this.diario2Base = diario2Base;
	}

	public Double getDiario2Tipo() {
		return diario2Tipo;
	}

	public void setDiario2Tipo(Double diario2Tipo) {
		this.diario2Tipo = diario2Tipo;
	}

	public Double getDiario2Cuota() {
		return diario2Cuota;
	}

	public void setDiario2Cuota(Double diario2Cuota) {
		this.diario2Cuota = diario2Cuota;
	}
	
	
}
