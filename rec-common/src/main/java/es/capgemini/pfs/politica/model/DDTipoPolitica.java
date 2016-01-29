package es.capgemini.pfs.politica.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.persona.model.DDPolitica;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * Diccionario de los tipos de política.
 * @author Andrés Esteban
  */
@Entity
@Table(name = "TPL_TIPO_POLITICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoPolitica implements Dictionary, Auditable, RuleEndState {

    private static final long serialVersionUID = 3243197022893179396L;

    @Id
    @Column(name = "TPL_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "TEN_ID")
    private DDTendencia tendencia;

    @Column(name = "TPL_CODIGO")
    private String codigo;

    @Column(name = "TPL_DESCRIPCION")
    private String descripcion;

    @Column(name = "TPL_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @OneToOne
    @JoinColumn(name = "RD_ID")
    private RuleDefinition rule;

    @Column(name = "TPL_PRIORIDAD")
    private Long prioridad;

    @Column(name = "TPL_PESO")
    private Long peso;

    @Column(name = "TPL_PLAZO_VIGENCIA")
    private Long plazoVigencia;
    
    @ManyToOne
    @JoinColumn(name ="DD_POL_ID")
    private DDPolitica politicaEntidad;
    

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
     * @return the tendencia
     */
    public DDTendencia getTendencia() {
        return tendencia;
    }

    /**
     * @param tendencia the tendencia to set
     */
    public void setTendencia(DDTendencia tendencia) {
        this.tendencia = tendencia;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
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
     * @param rule the rule to set
     */
    public void setRule(RuleDefinition rule) {
        this.rule = rule;
    }

    @Override
    public String getName() {
        return codigo;
    }

    @Override
    public long getPriority() {
        return prioridad;
    }

    @Override
    public String getRuleDefinition() {
        return rule != null ? rule.getRuleDefinition() : null;
    }

    @Override
    public String getValue() {
        return id.toString();
    }

    /**
     * @param peso the peso to set
     */
    public void setPeso(Long peso) {
        this.peso = peso;
    }

    /**
     * @return the peso
     */
    public Long getPeso() {
        return peso;
    }

    /**
     * @param plazoVigencia the plazoVigencia to set
     */
    public void setPlazoVigencia(Long plazoVigencia) {
        this.plazoVigencia = plazoVigencia;
    }

    /**
     * @return the plazoVigencia
     */
    public Long getPlazoVigencia() {
        return plazoVigencia;
    }

	public DDPolitica getPoliticaEntidad() {
		return politicaEntidad;
	}

	public void setPoliticaEntidad(DDPolitica politicaEntidad) {
		this.politicaEntidad = politicaEntidad;
	}

}
