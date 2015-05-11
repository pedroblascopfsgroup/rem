package es.capgemini.pfs.expediente.model;


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
 * Estados del contrato.
 * @author aesteban
 *
 */
@Entity
@Table(name = "DD_EEX_ESTADO_EXPEDIENTE", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoExpediente implements Dictionary, Auditable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = 6590527076541151302L;

	public static final String ESTADO_EXPEDIENTE_PROPUESTO = "0";
    public static final String ESTADO_EXPEDIENTE_ACTIVO = "1";
    public static final String ESTADO_EXPEDIENTE_CONGELADO = "2";
    public static final String ESTADO_EXPEDIENTE_DECIDIDO = "3";
    public static final String ESTADO_EXPEDIENTE_BLOQUEADO = "4";
    public static final String ESTADO_EXPEDIENTE_CANCELADO = "5";

    public static final String ESTADO_EXPEDIENTE_CANCELADO_STRING = "5";
    public static final String ESTADO_EXPEDIENTE_DECIDIDO_STRING = "3";
    public static final String ESTADO_EXPEDIENTE_CONGELADO_STRING = "2";

    @Id
    @Column(name = "DD_EEX_ID")
    private Long id;

    @Column(name = "DD_EEX_CODIGO")
    private String codigo;

    @Column(name = "DD_EEX_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EEX_DESCRIPCION_LARGA")
    private String descripcionLarga;

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
