package es.capgemini.pfs.asunto.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase que mapea los estados de un asunto.
 * @author pamuller
 *
 */
@Entity
@Table(name = "DD_EAS_ESTADO_ASUNTOS", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoAsunto implements Dictionary, Auditable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6637787816506547311L;

    public static final String ESTADO_ASUNTO_PROPUESTO = "01";
    public static final String ESTADO_ASUNTO_EN_CONFORMACION = "07";
    public static final String ESTADO_ASUNTO_CONFIRMADO = "02";
    public static final String ESTADO_ASUNTO_ACEPTADO = "03";
    public static final String ESTADO_ASUNTO_VACIO = "04";
    public static final String ESTADO_ASUNTO_CANCELADO = "05";
    public static final String ESTADO_ASUNTO_CERRADO = "06";
    public static final String ESTADO_ASUNTO_GESTION_FINALIZADA = "20";

    @Id
    @Column(name = "DD_EAS_ID")
    private Long id;

    @Column(name = "DD_EAS_CODIGO")
    private String codigo;

    @Column(name = "DD_EAS_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EAS_DESCRIPCION_LARGA")
    private String descripcionLarga;

    /*@Version
    private Integer version;
    */
    @Embedded
    private Auditoria auditoria;

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
     * @return the version
     */
    /*public Integer getVersion() {
    	return version;
    }*/

    /**
     * @param version the version to set
     */
    /*public void setVersion(Integer version) {
    	this.version = version;
    }*/

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
