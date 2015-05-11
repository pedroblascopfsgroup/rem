package es.pfsgroup.recovery.recobroCommon.metasVolantes.model;

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
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

/**
 * Clase para el objeto Meta Volante
 * @author Vanesa
 *
 */
@Entity
@Table(name = "RCF_MVL_META_VOLANTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroMetaVolante implements Auditable, Serializable {
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = -8792180099258250925L;

	 @Id
	 @Column(name = "RCF_MVL_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "MetaVolanteGenerator")
	 @SequenceGenerator(name = "MetaVolanteGenerator", sequenceName = "S_RCF_MVL_META_VOLANTE")
	 private Long id;
	 
	 @Column(name = "RCF_MVL_ORDEN")
	 private Long orden;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_DD_MET_ID")
	 private RecobroDDTipoMetaVolante tipoMeta;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_ITV_ID", nullable = false)
	 private RecobroItinerarioMetasVolantes itinerario;
	 
	 @Column(name = "RCF_MVL_DIAS_ENT")
	 private Integer diasDesdeEntrega;
	
	 @Column(name = "RCF_MVL_BLOQUEO")
	 private Boolean bloqueo;
	 
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

	public Long getOrden() {
		return orden;
	}

	public void setOrden(Long orden) {
		this.orden = orden;
	}

	public RecobroDDTipoMetaVolante getTipoMeta() {
		return tipoMeta;
	}

	public void setTipoMeta(RecobroDDTipoMetaVolante tipoMeta) {
		this.tipoMeta = tipoMeta;
	}

	public RecobroItinerarioMetasVolantes getItinerario() {
		return itinerario;
	}

	public void setItinerario(RecobroItinerarioMetasVolantes itinerario) {
		this.itinerario = itinerario;
	}

	public Integer getDiasDesdeEntrega() {
		return diasDesdeEntrega;
	}

	public void setDiasDesdeEntrega(Integer diasDesdeEntrega) {
		this.diasDesdeEntrega = diasDesdeEntrega;
	}

	public Boolean getBloqueo() {
		return bloqueo;
	}

	public void setBloqueo(Boolean bloqueo) {
		this.bloqueo = bloqueo;
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

	
}
