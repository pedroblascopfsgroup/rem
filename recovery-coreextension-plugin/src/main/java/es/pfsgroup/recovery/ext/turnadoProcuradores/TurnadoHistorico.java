package es.pfsgroup.recovery.ext.turnadoProcuradores;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
/*
@Entity
@Table(name = "TUP_HIS_HISTORICO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)*/
public class TurnadoHistorico {
	/*
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "HIS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TurnadoHistoricoGenerator")
    @SequenceGenerator(name = "TurnadoHistoricoGenerator", sequenceName = "S_TUP_HIS_HISTORICO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "EPT_ID")
	private EsquemaTurnadoProcurador esquemaTurnadoProcurador;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PLA_ID")
	private TipoPlaza tipoPlaza;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPO_ID")
	private TipoProcedimiento tipoProcedimiento;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@Embedded
    private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public EsquemaTurnadoProcurador getEsquemaTurnadoProcurador() {
		return esquemaTurnadoProcurador;
	}

	public void setEsquemaTurnadoProcurador(EsquemaTurnadoProcurador esquemaTurnadoProcurador) {
		this.esquemaTurnadoProcurador = esquemaTurnadoProcurador;
	}

	public TipoPlaza getTipoPlaza() {
		return tipoPlaza;
	}

	public void setTipoPlaza(TipoPlaza tipoPlaza) {
		this.tipoPlaza = tipoPlaza;
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}*/

}
