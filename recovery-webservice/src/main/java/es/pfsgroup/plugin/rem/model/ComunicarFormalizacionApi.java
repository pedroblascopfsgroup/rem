package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona el modelo de Albaranes para la gestión, 
 * flujo e información de los trabajos.
 * 
 * @author Alberto Flores
 */
@Entity
@Table(name = "CFA_COMUNICAR_FORMALIZACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ComunicarFormalizacionApi implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ComunicarFormalizacionApiGenerator")
	@SequenceGenerator(name = "ComunicarFormalizacionApiGenerator", sequenceName = "S_CFA_COMUNICAR_FORMALIZACION")
	private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

	@Column(name = "CFA_LLAMADA_REALIZADA")
	private Integer llamadaRealizada;
	
	@Column(name = "CFA_FECHA_LLAMADA")
	private Date fechaLlamada;

	@Column(name = "CFA_BUROFAX_ENVIADO")
	private Integer burofaxEnviado;
	
	@Column(name = "CFA_FECHA_BUROFAX")
	private Date fechaBurofax;
	
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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Integer getLlamadaRealizada() {
		return llamadaRealizada;
	}

	public void setLlamadaRealizada(Integer llamadaRealizada) {
		this.llamadaRealizada = llamadaRealizada;
	}

	public Date getFechaLlamada() {
		return fechaLlamada;
	}

	public void setFechaLlamada(Date fechaLlamada) {
		this.fechaLlamada = fechaLlamada;
	}

	public Integer getBurofaxEnviado() {
		return burofaxEnviado;
	}

	public void setBurofaxEnviado(Integer burofaxEnviado) {
		this.burofaxEnviado = burofaxEnviado;
	}

	public Date getFechaBurofax() {
		return fechaBurofax;
	}

	public void setFechaBurofax(Date fechaBurofax) {
		this.fechaBurofax = fechaBurofax;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
}
