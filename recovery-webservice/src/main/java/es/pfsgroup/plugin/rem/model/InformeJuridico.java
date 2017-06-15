package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
 * Modelo que gestiona la informacion de un informe juridico para un activo y un expediente comercial
 *  
 * @author David Gonzalez
 *
 */
@Entity
@Table(name = "ACT_ECO_INFORME_JURIDICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class InformeJuridico implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final String RESULTADO_FAVORABLE = "Favorable";
	public static final String RESULTADO_DESFAVORABLE = "Desfavorable";
		
	@Id
    @Column(name = "ACT_ECO_IJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "InformeJuridicoGenerator")
    @SequenceGenerator(name = "InformeJuridicoGenerator", sequenceName = "S_ACT_ECO_INFORME_JURIDICO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expedienteComercial;
    
	@ManyToOne
	@JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @Column(name = "ACT_ECO_FECHA_EMISION")
    private Date fechaEmision;
     
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

	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
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
