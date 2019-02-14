package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;

@Entity
@Table(name = "ACT_OFG_OFERTA_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class OfertaGencat implements Serializable, Auditable {

	private static final long serialVersionUID = -1347694172030486824L;
	
	@Id
    @Column(name = "OFG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaGencatGenerator")
    @SequenceGenerator(name = "OfertaGencatGenerator", sequenceName = "S_ACT_OFG_OFERTA_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "OFR_ID")
	private Oferta oferta;
	
	@Column(name = "OFG_IMPORTE")
	private Double importe;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPE_ID")
    private DDTiposPersona tiposPersona;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIP_ID")
    private DDSituacionesPosesoria situacionPosesoria;
	
	@Version   
	private Long version;
    
    @Embedded
	private Auditoria auditoria;
    
    @Column(name = "OFR_ID_ANT")
    private Long idOfertaAnterior;

    @Column(name = "BORRADO")
    private Boolean borrado;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ComunicacionGencat getComunicacion() {
		return comunicacion;
	}

	public void setComunicacion(ComunicacionGencat comunicacion) {
		this.comunicacion = comunicacion;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public DDTiposPersona getTiposPersona() {
		return tiposPersona;
	}

	public void setTiposPersona(DDTiposPersona tiposPersona) {
		this.tiposPersona = tiposPersona;
	}

	public DDSituacionesPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(DDSituacionesPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
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

	public Long getIdOfertaAnterior() {
		return idOfertaAnterior;
	}

	public void setIdOfertaAnterior(Long idOfertaAnterior) {
		this.idOfertaAnterior = idOfertaAnterior;
	}

	public Boolean getBorrado() {
		return borrado;
	}

	public void setEsborrado(Boolean borrado) {
		this.borrado = borrado;
	}
	
	
}
