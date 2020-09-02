package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


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
	private Long diario1;
	
	@Column(name="DIARIO1_BASE")
	private Long diario1Base;
	
	@Column(name="DIARIO1_TIPO")
	private Long diario1Tipo;
	
	@Column(name="DIARIO1_CUOTA")
	private Long diario1Cuota;
	
	@Column(name="DIARIO2")
	private Long diario2;
	
	@Column(name="DIARIO2_BASE")
	private Long diario2Base;
	
	@Column(name="DIARIO2_TIPO")
	private Long diario2Tipo;
	
	@Column(name="DIARIO2_CUOTA")
	private Long diario2Cuota;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getDiario1() {
		return diario1;
	}

	public void setDiario1(Long diario1) {
		this.diario1 = diario1;
	}

	public Long getDiario1Base() {
		return diario1Base;
	}

	public void setDiario1Base(Long diario1Base) {
		this.diario1Base = diario1Base;
	}

	public Long getDiario1Tipo() {
		return diario1Tipo;
	}

	public void setDiario1Tipo(Long diario1Tipo) {
		this.diario1Tipo = diario1Tipo;
	}

	public Long getDiario1Cuota() {
		return diario1Cuota;
	}

	public void setDiario1Cuota(Long diario1Cuota) {
		this.diario1Cuota = diario1Cuota;
	}

	public Long getDiario2() {
		return diario2;
	}

	public void setDiario2(Long diario2) {
		this.diario2 = diario2;
	}

	public Long getDiario2Base() {
		return diario2Base;
	}

	public void setDiario2Base(Long diario2Base) {
		this.diario2Base = diario2Base;
	}

	public Long getDiario2Tipo() {
		return diario2Tipo;
	}

	public void setDiario2Tipo(Long diario2Tipo) {
		this.diario2Tipo = diario2Tipo;
	}

	public Long getDiario2Cuota() {
		return diario2Cuota;
	}

	public void setDiario2Cuota(Long diario2Cuota) {
		this.diario2Cuota = diario2Cuota;
	}
	
	
}
