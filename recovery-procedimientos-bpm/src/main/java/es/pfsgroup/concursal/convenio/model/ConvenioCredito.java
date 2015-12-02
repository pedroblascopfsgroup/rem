package es.pfsgroup.concursal.convenio.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.concursal.credito.model.Credito;

@Entity
@Table(name = "COV_CONVENIOS_CREDITOS", schema = "${entity.schema}")
public class ConvenioCredito implements Serializable,Auditable{

	private static final long serialVersionUID = 6631529213958910947L;

	@Id
	@Column(name = "COVCRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConvenioCreditoGenerator")
	@SequenceGenerator(name = "ConvenioCreditoGenerator", sequenceName = "S_COV_CONVENIOS_CREDITOS")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "COV_ID")
	private Convenio convenio;
	
	@ManyToOne
    @JoinColumn(name = "CRE_CEX_ID")
	private Credito credito;
	
	@Column(name = "COVCRE_QUITA")
	private Float quita;
	
	@Column(name = "COVCRE_ESPERA")
	private Float espera;
	
	@Column(name = "COVCRE_CARENCIA")
	private Float carencia;
	
	@Column(name = "COVCRE_COMENTARIO")
	private String comentario;
	
	@ManyToOne
    @JoinColumn(name = "DD_CC_ID")
	private DDConformidadConvenio conformidadConvenio;

	@Column(name = "SYS_GUID")
	private String guid;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Convenio getConvenio() {
		return convenio;
	}

	public void setConvenio(Convenio convenio) {
		this.convenio = convenio;
	}

	public Credito getCredito() {
		return credito;
	}

	public void setCredito(Credito credito) {
		this.credito = credito;
	}

	public Float getQuita() {
		return quita;
	}

	public void setQuita(Float quita) {
		this.quita = quita;
	}

	public Float getEspera() {
		return espera;
	}

	public void setEspera(Float espera) {
		this.espera = espera;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setCarencia(Float carencia) {
		this.carencia = carencia;
	}

	public Float getCarencia() {
		return carencia;
	}
	
	public DDConformidadConvenio getConformidadConvenio() {
		return conformidadConvenio;
	}


	public void setConformidadConvenio(DDConformidadConvenio conformidadConvenio) {
		this.conformidadConvenio = conformidadConvenio;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

}
