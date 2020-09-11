package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


@Entity
@Table(name = "GIL_GASTOS_IMPORTES_LIBERBANK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastosImportesLBK implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GDL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastosImportesGenerator")
	@SequenceGenerator(name = "GastosImportesGenerator", sequenceName = "S_GIL_GASTOS_IMPORTES_LIBERBANK")
	private Long id;
	
	@Column(name="GPV_ID")
	private Long idGastos;
	
	@Column(name="ENT_ID")
	private Long idEntidad;
	
	@Column(name="DD_ENT_ID")
	private Long entidadGasto;
	
	@Column(name="IMPORTE_ACTIVO")
	private Double importeActivo;
	
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

	public Long getIdEntidad() {
		return idEntidad;
	}

	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public Long getEntidadGasto() {
		return entidadGasto;
	}

	public void setEntidadGasto(Long entidadGasto) {
		this.entidadGasto = entidadGasto;
	}

	public Double getImporteActivo() {
		return importeActivo;
	}

	public void setImporteActivo(Double importeActivo) {
		this.importeActivo = importeActivo;
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
