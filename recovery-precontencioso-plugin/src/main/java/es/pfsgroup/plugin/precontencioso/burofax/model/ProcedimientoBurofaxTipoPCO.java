package es.pfsgroup.plugin.precontencioso.burofax.model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

@Entity
@Table(name = "PCO_TPO_TPE_TIPO_BUR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProcedimientoBurofaxTipoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -5969025352573277783L;

	@Id
	@Column(name = "PCO_TPO_TPE_TIPO_BUR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoBurofaxPCOGenerator")
	@SequenceGenerator(name = "ProcedimientoBurofaxPCOGenerator", sequenceName = "S_PCO_TPO_TPE_TIPO_BUR")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "DD_TPO_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private TipoProcedimiento tipoProcedimiento;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_BFT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoBurofaxPCO tipoBurofax;

	@ManyToOne
	@JoinColumn(name = "DD_TPE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoProductoEntidad tipoProductoEntidad;

	
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;



	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public DDTipoBurofaxPCO getTipoBurofax() {
		return tipoBurofax;
	}

	public void setTipoBurofax(DDTipoBurofaxPCO tipoBurofax) {
		this.tipoBurofax = tipoBurofax;
	}

	public DDTipoProductoEntidad getTipoProductoEntidad() {
		return tipoProductoEntidad;
	}

	public void setTipoProductoEntidad(DDTipoProductoEntidad tipoProductoEntidad) {
		this.tipoProductoEntidad = tipoProductoEntidad;
	}

	

	
}
