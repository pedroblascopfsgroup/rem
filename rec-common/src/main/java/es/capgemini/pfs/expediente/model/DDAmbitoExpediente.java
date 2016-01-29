package es.capgemini.pfs.expediente.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Define un tipo de itinerario (seguimiento o recuperación).
 *
 * @author pjimenez
 */
@Entity
@Table(name = "DD_AEX_AMBITOS_EXPEDIENTE", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDAmbitoExpediente implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String CONTRATO_PASE = "CP";
    public static final String CONTRATOS_GRUPO = "CG";
    public static final String CONTRATOS_PRIMERA_GENERACION = "CPGRA";
    public static final String CONTRATOS_SEGUNDA_GENERACION = "CSGRA";

    public static final String PERSONA_PASE = "PP";
    public static final String PERSONAS_GRUPO = "PG";
    public static final String PERSONAS_PRIMERA_GENERACION = "PPGRA";
    public static final String PERSONAS_SEGUNDA_GENERACION = "PSGRA";
    
    public static final String EXPEDIENTE = "EXP";

    /**
     * Método estático que devuelve un listado de ambitos englobados en el ambito que se le pasa como parametro.
     * @param ambitoExpediente DDAmbitoExpediente
     * @return String[]
     */
    public static final String[] getListadoAmbitos(DDAmbitoExpediente ambitoExpediente) {
        String ambito = ambitoExpediente.getCodigo();
        if (CONTRATOS_SEGUNDA_GENERACION.equals(ambito)) { return new String[] { CONTRATOS_SEGUNDA_GENERACION, CONTRATOS_PRIMERA_GENERACION,
                CONTRATOS_GRUPO, CONTRATO_PASE }; }

        if (CONTRATOS_PRIMERA_GENERACION.equals(ambito)) { return new String[] { CONTRATOS_PRIMERA_GENERACION, CONTRATOS_GRUPO, CONTRATO_PASE }; }

        if (CONTRATOS_GRUPO.equals(ambito)) { return new String[] { CONTRATOS_GRUPO, CONTRATO_PASE }; }

        if (CONTRATO_PASE.equals(ambito)) { return new String[] { CONTRATO_PASE }; }

        if (PERSONAS_SEGUNDA_GENERACION.equals(ambito)) { return new String[] { PERSONAS_SEGUNDA_GENERACION, PERSONAS_PRIMERA_GENERACION,
                PERSONAS_GRUPO, PERSONA_PASE }; }

        if (PERSONAS_PRIMERA_GENERACION.equals(ambito)) { return new String[] { PERSONAS_PRIMERA_GENERACION, PERSONAS_GRUPO, PERSONA_PASE }; }

        if (PERSONAS_GRUPO.equals(ambito)) { return new String[] { PERSONAS_PRIMERA_GENERACION, PERSONAS_GRUPO, PERSONA_PASE }; }

        if (PERSONA_PASE.equals(ambito)) { return new String[] { PERSONA_PASE }; }

        return null;
    }

    @Id
    @Column(name = "DD_AEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDAmbitoExpedienteGenerator")
    @SequenceGenerator(name = "DDAmbitoExpedienteGenerator", sequenceName = "${master.schema}.S_DD_AEX_AMBITOS_EXPEDIENTE")
    private Long id;

    @Column(name = "DD_AEX_CODIGO")
    private String codigo;

    @Column(name = "DD_AEX_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_AEX_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return Boolean
     */
    public Boolean isAmbitoContrato() {
        return CONTRATO_PASE.equals(codigo) || CONTRATOS_GRUPO.equals(codigo) || CONTRATOS_PRIMERA_GENERACION.equals(codigo)
                || CONTRATOS_SEGUNDA_GENERACION.equals(codigo);
    }

    /**
     * @return Boolean
     */
    public Boolean isAmbitoPersona() {
        return !isAmbitoContrato();
    }
}
