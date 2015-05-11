package es.capgemini.pfs.analisisExterna.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Mapeo de la tabla de tipos de plazos de aceptación 
 * @author pajimene
 *
 */
@Entity
@Table(name = "DD_PAC_PLAZO_ACEPTACION", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDPlazoAceptacion implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;

    public static final String CODIGO_PLAZO_MENOR_3_MESES = "1";
    public static final String CODIGO_PLAZO_MENOR_6_MESES = "2";
    public static final String CODIGO_PLAZO_MENOR_12_MESES = "3";
    public static final String CODIGO_PLAZO_MENOR_24_MESES = "4";
    public static final String CODIGO_PLAZO_MAYOR_24_MESES = "5";

    @Id
    @Column(name = "DD_PAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDPlazoAceptacionGenerator")
    @SequenceGenerator(name = "DDPlazoAceptacionGenerator", sequenceName = "${master.schema}.S_DD_PAC_PLAZO_ACEPTACION")
    private Long id;

    @Column(name = "DD_PAC_CODIGO")
    private String codigo;

    @Column(name = "DD_PAC_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_PAC_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
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

}
