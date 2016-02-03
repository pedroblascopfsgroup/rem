package es.pfsgroup.recovery.ext.turnadodespachos;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;


/**
 * Clase que representa un despacho externo.
 * @author pamuller
 *
 */
@Entity
@Table(name = "DAA_DESPACHO_AMBITO_ACTUACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DespachoAmbitoActuacion implements Serializable, Auditable {

    private static final long serialVersionUID = -4061616096861079806L;

    @Id
    @Column(name = "DAA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DespachoAmbitoActuacionGenerator")
    @SequenceGenerator(name = "DespachoAmbitoActuacionGenerator", sequenceName = "S_DAA_DESPACHO_AMBITO_ACTUACIO")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DES_ID")
    private DespachoExterno despacho;

    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;

    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_CCA_ID")
    private DDComunidadAutonoma comunidad;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;
    

    
    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ETC_ID_LITIGIO")
    private EsquemaTurnadoConfig etcLitigio;
    
    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ETC_ID_CONCURSO")
    private EsquemaTurnadoConfig etcConcurso;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DespachoExterno getDespacho() {
		return despacho;
	}

	public void setDespacho(DespachoExterno despacho) {
		this.despacho = despacho;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public DDComunidadAutonoma getComunidad() {
		return comunidad;
	}

	public void setComunidad(DDComunidadAutonoma comunidad) {
		this.comunidad = comunidad;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	

	public EsquemaTurnadoConfig getEtcLitigio() {
		return etcLitigio;
	}

	public void setEtcLitigio(EsquemaTurnadoConfig etcLitigio) {
		this.etcLitigio = etcLitigio;
	}

	public EsquemaTurnadoConfig getEtcConcurso() {
		return etcConcurso;
	}

	public void setEtcConcurso(EsquemaTurnadoConfig etcConcurso) {
		this.etcConcurso = etcConcurso;
	}
}
