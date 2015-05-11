package es.pfsgroup.plugin.recovery.masivo.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

@Entity
@Table(name = "CIA_CONF_IMPULSO_AUTOMATICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause="borrado = 0")
public class MSVConfImpulsoAutomatico  implements Serializable, Auditable {

	private static final long serialVersionUID = 5928256450921397037L;

	@Id
	@Column(name = "CIA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVConfImpulsoAutomaticoGenerator")
	@SequenceGenerator(name = "MSVConfImpulsoAutomaticoGenerator", sequenceName = "S_CIA_CONF_IMPULSO_AUTOMATICO")
	private Long id;

	@Embedded
	private Auditoria auditoria;

	//Tipo de Procedimiento 
	// (filtrado por tipo de juicio que tiene los BPMs que nos interesan)
    @JoinColumn(name = "DD_TJ_ID")
	@ManyToOne
    private MSVDDTipoJuicio tipoJuicio;
	
	//Tipo de Tarea/Procedimiento (de un subconjunto definido)
    @JoinColumn(name = "TAP_ID")
	@ManyToOne
	private TareaProcedimiento tareaProcedimiento;
	
	//Con Procurador o Sin Procurador (un booleano que si vale true indicará Con Procurador).
	@Column(name="CIA_CON_PROCURADOR")
	private Boolean conProcurador;
	
	//Despacho.
    @JoinColumn(name = "DES_ID")
	@ManyToOne
	private DespachoExterno despacho;
	
	//Operador fecha última resolución recibida (<, <=, =, >=, >).
	@Column(name = "CIA_OPER_ULTIMA_RESOL")
	private String operUltimaResol;
	
	//Nº días del valor de última resolución recibida.
	@Column(name = "CIA_NUM_DIAS_ULTIMA_RESOL")
	private Integer numDiasUltimaResol;
	

	//Operador fecha último impulso recibida (<, <=, =, >=, >).
	@Column(name = "CIA_OPER_ULTIMO_IMPULSO")
	private String operUltimoImpulso;
	
	//Nº días del valor de último impulso.
	@Column(name = "CIA_NUM_DIAS_ULTIMO_IMPULSO")
	private Integer numDiasUltimoImpulso;

	//Cartera
	@Column(name = "CIA_CARTERA")
	private String cartera;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public MSVDDTipoJuicio getTipoJuicio() {
		return tipoJuicio;
	}

	public void setTipoJuicio(MSVDDTipoJuicio tipoJuicio) {
		this.tipoJuicio = tipoJuicio;
	}

	public Boolean getConProcurador() {
		return conProcurador;
	}

	public void setConProcurador(Boolean conProcurador) {
		this.conProcurador = conProcurador;
	}

	public DespachoExterno getDespacho() {
		return despacho;
	}

	public void setDespacho(DespachoExterno despacho) {
		this.despacho = despacho;
	}

	public String getOperUltimaResol() {
		return operUltimaResol;
	}

	public void setOperUltimaResol(String operUltimaResol) {
		this.operUltimaResol = operUltimaResol;
	}

	public Integer getNumDiasUltimaResol() {
		return numDiasUltimaResol;
	}

	public void setNumDiasUltimaResol(Integer numDiasUltimaResol) {
		this.numDiasUltimaResol = numDiasUltimaResol;
	}

	public String getOperUltimoImpulso() {
		return operUltimoImpulso;
	}

	public void setOperUltimoImpulso(String operUltimoImpulso) {
		this.operUltimoImpulso = operUltimoImpulso;
	}

	public Integer getNumDiasUltimoImpulso() {
		return numDiasUltimoImpulso;
	}

	public void setNumDiasUltimoImpulso(Integer numDiasUltimoImpulso) {
		this.numDiasUltimoImpulso = numDiasUltimoImpulso;
	}

	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	
}
