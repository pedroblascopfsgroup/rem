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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "TUP_HIS_HISTORICO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class TurnadoHistorico {
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "HIS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TurnadoHistoricoGenerator")
    @SequenceGenerator(name = "TurnadoHistoricoGenerator", sequenceName = "S_TUP_HIS_HISTORICO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "EPT_ID")
	private EsquemaPlazasTpo esquemaPlazasTpo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PLA_ID")
	private TipoPlaza tipoPlaza;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPO_ID")
	private TipoProcedimiento tipoProcedimiento;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="USU_ID_ASIGNADO")
	private Usuario procuAsign;
	
	@Column(name = "IMPORTE")
	private Double importe;
	
	@Column(name = "MENSAJE")
	private String mensaje;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="USU_ID_REAL")
	private Usuario procuGaa;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="ASU_ID")
	private Asunto asunto;
	
	@Embedded
    private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public EsquemaPlazasTpo getEsquemaPlazasTpo() {
		return esquemaPlazasTpo;
	}

	public void setEsquemaPlazasTpo(EsquemaPlazasTpo esquemaPlazasTpo) {
		this.esquemaPlazasTpo = esquemaPlazasTpo;
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
	}
	
	public Double getImporte(){
		return importe;
	}
	
	public void setImporte(Double importe){
		this.importe = importe;
	}
	
	public String getMensaje(){
		return mensaje;
	}
	
	public void setMensaje(String mensaje){
		this.mensaje = mensaje;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public Usuario getProcuAsign() {
		return procuAsign;
	}

	public void setProcuAsign(Usuario procuAsign) {
		this.procuAsign = procuAsign;
	}
	
	public Usuario getProcuGaa() {
		return procuGaa;
	}

	public void setProcuGaa(Usuario procuGaa) {
		this.procuGaa = procuGaa;
	}
	
	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}
}
