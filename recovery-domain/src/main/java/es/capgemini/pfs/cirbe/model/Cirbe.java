package es.capgemini.pfs.cirbe.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que representa al registro de CIRBE.
 * @author pamuller
 *
 */
@Entity
@Table(name = "CIR_CIRBE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Cirbe implements Serializable, Auditable {

    private static final long serialVersionUID = 4248114133827056024L;

    @Id
	@Column(name = "CIR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CirbeGenerator")
	@SequenceGenerator(name = "CirbeGenerator", sequenceName = "S_CIR_CIRBE")
	private Long id;

	@ManyToOne
	@JoinColumn(name="PER_ID")
	private Persona persona;

	@Column(name="CIR_DISPONIBLE")
	private Double importeDisponible;

	@Column(name="CIR_DISPUESTO")
	private Double importeDispuesto;

	@ManyToOne
	@JoinColumn(name="CIRBE_ANTERIOR")
	private Cirbe anterior;

	@ManyToOne
	@JoinColumn(name="DD_CRC_ID")
	private DDClaseRiesgoCirbe claseRiesgoCirbe;

	@ManyToOne
	@JoinColumn(name="DD_COC_ID")
	private DDCodigoOperacionCirbe codigoOperacionCirbe;

	@ManyToOne
	@JoinColumn(name="DD_TGC_ID")
	private DDTipoGarantiaCirbe tipoGarantiaCirbe;

	@ManyToOne
	@JoinColumn(name="DD_TMC_ID")
	private DDTipoMonedaCirbe tipoMonedaCirbe;

	@ManyToOne
	@JoinColumn(name="DD_TSC_ID")
	private DDTipoSituacionCirbe tipoSituacionCirbe;

	@ManyToOne
	@JoinColumn(name="DD_TVC_ID")
	private DDTipoVencimientoCirbe tipoVencimientoCirbe;

    @ManyToOne
    @JoinColumn(name="DD_CIC_ID")
	private DDPais pais;

    @Column(name = "CIR_FECHA_ACTUALIZAC")
    private Date fechaCargaActualizacion;

    @Column(name="CIR_FECHA_EXTRACCION")
    private Date fechaExtraccionCirbe;

    @Column(name="CIR_CANT_PART_SOLID")
    private Long cantParticipantesSolidarios;

    @OneToMany
    @JoinColumns({
    	@JoinColumn(name="PER_ID", referencedColumnName="PER_ID"),
        @JoinColumn(name="DD_TVC_ID", referencedColumnName="DD_TVC_ID"),
        @JoinColumn(name="DD_COC_ID", referencedColumnName="DD_COC_ID"),
        @JoinColumn(name="DD_TGC_ID", referencedColumnName="DD_TGC_ID"),
        @JoinColumn(name="DD_TSC_ID", referencedColumnName="DD_TSC_ID")
	})
    private List<Cirbe> cirbeRelacionados1;

	@OneToMany
    @JoinColumns({
    	@JoinColumn(name="PER_ID", referencedColumnName="PER_ID"),
        @JoinColumn(name="DD_TVC_ID", referencedColumnName="DD_TVC_ID"),
        @JoinColumn(name="DD_COC_ID", referencedColumnName="DD_COC_ID"),
        @JoinColumn(name="DD_TGC_ID", referencedColumnName="DD_TGC_ID"),
        @JoinColumn(name="DD_TSC_ID", referencedColumnName="DD_TSC_ID")
	})
    private List<Cirbe> cirbesRelacionados2;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;


    /**
	 * @return the cirbeRelacionados1
	 */
	public List<Cirbe> getCirbeRelacionados1() {
		return cirbeRelacionados1;
	}
	/**
	 * @param cirbeRelacionados1 the cirbeRelacionados1 to set
	 */
	public void setCirbeRelacionados1(List<Cirbe> cirbeRelacionados1) {
		this.cirbeRelacionados1 = cirbeRelacionados1;
	}
	/**
	 * @return the cirbesRelacionados2
	 */
	public List<Cirbe> getCirbesRelacionados2() {
		return cirbesRelacionados2;
	}
	/**
	 * @param cirbesRelacionados2 the cirbesRelacionados2 to set
	 */
	public void setCirbesRelacionados2(List<Cirbe> cirbesRelacionados2) {
		this.cirbesRelacionados2 = cirbesRelacionados2;
	}

    /**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return the persona
	 */
	public Persona getPersona() {
		return persona;
	}
	/**
	 * @param persona the persona to set
	 */
	public void setPersona(Persona persona) {
		this.persona = persona;
	}
	/**
	 * @return the importeDisponible
	 */
	public Double getImporteDisponible() {
		return importeDisponible;
	}
	/**
	 * @param importeDisponible the importeDisponible to set
	 */
	public void setImporteDisponible(Double importeDisponible) {
		this.importeDisponible = importeDisponible;
	}
	/**
	 * @return the importeDispuesto
	 */
	public Double getImporteDispuesto() {
		return importeDispuesto;
	}
	/**
	 * @param importeDispuesto the importeDispuesto to set
	 */
	public void setImporteDispuesto(Double importeDispuesto) {
		this.importeDispuesto = importeDispuesto;
	}
	/**
	 * @return the anterior
	 */
	public Cirbe getAnterior() {
		return anterior;
	}
	/**
	 * @param anterior the anterior to set
	 */
	public void setAnterior(Cirbe anterior) {
		this.anterior = anterior;
	}
	/**
	 * @return the claseRiesgoCirbe
	 */
	public DDClaseRiesgoCirbe getClaseRiesgoCirbe() {
		return claseRiesgoCirbe;
	}
	/**
	 * @param claseRiesgoCirbe the claseRiesgoCirbe to set
	 */
	public void setClaseRiesgoCirbe(DDClaseRiesgoCirbe claseRiesgoCirbe) {
		this.claseRiesgoCirbe = claseRiesgoCirbe;
	}
	/**
	 * @return the codigoOperacionCirbe
	 */
	public DDCodigoOperacionCirbe getCodigoOperacionCirbe() {
		return codigoOperacionCirbe;
	}
	/**
	 * @param codigoOperacionCirbe the codigoOperacionCirbe to set
	 */
	public void setCodigoOperacionCirbe(DDCodigoOperacionCirbe codigoOperacionCirbe) {
		this.codigoOperacionCirbe = codigoOperacionCirbe;
	}
	/**
	 * @return the tipoGarantiaCirbe
	 */
	public DDTipoGarantiaCirbe getTipoGarantiaCirbe() {
		return tipoGarantiaCirbe;
	}
	/**
	 * @param tipoGarantiaCirbe the tipoGarantiaCirbe to set
	 */
	public void setTipoGarantiaCirbe(DDTipoGarantiaCirbe tipoGarantiaCirbe) {
		this.tipoGarantiaCirbe = tipoGarantiaCirbe;
	}
	/**
	 * @return the tipoMonedaCirbe
	 */
	public DDTipoMonedaCirbe getTipoMonedaCirbe() {
		return tipoMonedaCirbe;
	}
	/**
	 * @param tipoMonedaCirbe the tipoMonedaCirbe to set
	 */
	public void setTipoMonedaCirbe(DDTipoMonedaCirbe tipoMonedaCirbe) {
		this.tipoMonedaCirbe = tipoMonedaCirbe;
	}
	/**
     * @return the pais
     */
    public DDPais getPais() {
        return pais;
    }
    /**
     * @param pais the pais to set
     */
    public void setPais(DDPais pais) {
        this.pais = pais;
    }
    /**
	 * @return the tipoSituacionCirbe
	 */
	public DDTipoSituacionCirbe getTipoSituacionCirbe() {
		return tipoSituacionCirbe;
	}
	/**
	 * @param tipoSituacionCirbe the tipoSituacionCirbe to set
	 */
	public void setTipoSituacionCirbe(DDTipoSituacionCirbe tipoSituacionCirbe) {
		this.tipoSituacionCirbe = tipoSituacionCirbe;
	}
	/**
	 * @return the tipoVencimientoCirbe
	 */
	public DDTipoVencimientoCirbe getTipoVencimientoCirbe() {
		return tipoVencimientoCirbe;
	}
	/**
	 * @param tipoVencimientoCirbe the tipoVencimientoCirbe to set
	 */
	public void setTipoVencimientoCirbe(DDTipoVencimientoCirbe tipoVencimientoCirbe) {
		this.tipoVencimientoCirbe = tipoVencimientoCirbe;
	}
    /**
     * @return the fechaCargaActualizacion
     */
    public Date getFechaCargaActualizacion() {
        return fechaCargaActualizacion;
    }
    /**
     * @param fechaCargaActualizacion the fechaCargaActualizacion to set
     */
    public void setFechaCargaActualizacion(Date fechaCargaActualizacion) {
        this.fechaCargaActualizacion = fechaCargaActualizacion;
    }
    /**
     * @return the cantParticipantesSolidarios
     */
    public Long getCantParticipantesSolidarios() {
        return cantParticipantesSolidarios;
    }
    /**
     * @param cantParticipantesSolidarios the cantParticipantesSolidarios to set
     */
    public void setCantParticipantesSolidarios(Long cantParticipantesSolidarios) {
        this.cantParticipantesSolidarios = cantParticipantesSolidarios;
    }
    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }
    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }
    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }
    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
    /**
     * @return the fechaExtraccionCirbe
     */
    public Date getFechaExtraccionCirbe() {
        return fechaExtraccionCirbe;
    }
    /**
     * @param fechaExtraccionCirbe the fechaExtraccionCirbe to set
     */
    public void setFechaExtraccionCirbe(Date fechaExtraccionCirbe) {
        this.fechaExtraccionCirbe = fechaExtraccionCirbe;
    }
}
