package es.capgemini.pfs.ingreso.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * CREATE TABLE ING_INGRESO.
(
   ING_ID               BIGINT NOT NULL AUTO_INCREMENT,
   DD_TIN_ID            BIGINT NOT NULL,
   PER_ID               BIGINT,
   ING_PERIODICIDAD     VARCHAR(50),
   ING_NETO_BRUTO       VARCHAR(50),
   USUARIOCREAR         VARCHAR(10) NOT NULL,
   FECHACREAR           DATE NOT NULL,
   USUARIOMODIFICAR     VARCHAR(10),
   FECHAMODIFICAR       DATE,
   USUARIOBORRAR        VARCHAR(10),
   FECHABORRAR          DATE,
   BORRADO              NUMERIC(1,0) NOT NULL DEFAULT 0,
   PRIMARY KEY (ING_ID)
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "ING_INGRESO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Ingreso implements Serializable,Auditable {

    private static final long serialVersionUID = -7803164332714851501L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "IngresoGenerator")
    @SequenceGenerator(name = "IngresoGenerator", sequenceName = "S_ING_INGRESO")
    @Column(name = "ING_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_TIG_ID")
    private DDTipoIngreso tipoIngreso;

    @ManyToOne
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Persona persona;

    @Column(name = "ING_PERIODICIDAD")
    private Long periodicidad;

    @Column(name = "ING_NETO_BRUTO")
    private Float ingNetoBruto;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;


    private static final int CANT_SEMANAS_ANIO = 52;
    /**
     * devuelve el total anual de este ingreso.
     * @return monto
     */
    public Float getTotalAnual(){
    	if (periodicidad ==null){
    		periodicidad = 1L;
    	}
    	Float monto = getIngNetoBruto()/periodicidad*CANT_SEMANAS_ANIO;
    	return monto;
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
	 * @return the tipoIngreso
	 */
	public DDTipoIngreso getTipoIngreso() {
		return tipoIngreso;
	}

	/**
	 * @param tipoIngreso the tipoIngreso to set
	 */
	public void setTipoIngreso(DDTipoIngreso tipoIngreso) {
		this.tipoIngreso = tipoIngreso;
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
	 * @return the periodicidad
	 */
	public Long getPeriodicidad() {
		return periodicidad;
	}

	/**
	 * @param periodicidad the periodicidad to set
	 */
	public void setPeriodicidad(Long periodicidad) {
		this.periodicidad = periodicidad;
	}

	/**
	 * @return the ingNetoBruto
	 */
	public Float getIngNetoBruto() {
		return ingNetoBruto;
	}

	/**
	 * @param ingNetoBruto the ingNetoBruto to set
	 */
	public void setIngNetoBruto(Float ingNetoBruto) {
		this.ingNetoBruto = ingNetoBruto;
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

}
