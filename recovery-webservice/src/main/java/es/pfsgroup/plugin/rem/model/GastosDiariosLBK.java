package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


@Entity
@Table(name = "GDL_GASTOS_DIARIOS_LIBERBANK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastosDiariosLBK implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GDL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastosDiariosGenerator")
	@SequenceGenerator(name = "GastosDiariosGenerator", sequenceName = "S_GDL_GASTOS_DIARIOS_LIBERBANK")
	private Long id;
	
	@Column(name="GPV_ID")
	private Long idGastos;
	
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
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdGastos() {
		return idGastos;
	}

	public void setIdGastos(Long idGastos) {
		this.idGastos = idGastos;
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

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}
	
	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria arg0) {
		// TODO Auto-generated method stub
		
	}

	
	
}
