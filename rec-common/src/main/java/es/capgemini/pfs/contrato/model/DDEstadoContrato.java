package es.capgemini.pfs.contrato.model;

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
@Table(name = "DD_ESC_ESTADO_CNT", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoContrato implements Dictionary, Auditable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -6637787813506547314L;

    public static final String ESTADO_CONTRATO_ACTIVO = "0";
    public static final String ESTADO_CONTRATO_SUSPENDIDO = "5";
    public static final String ESTADO_CONTRATO_VENCIDO = "8";
    public static final String ESTADO_CONTRATO_CANCELADO = "7";
    public static final String ESTADO_CONTRATO_NORECIBIDO = "6";

    @Id
    @Column(name = "DD_ESC_ID")
    private Long id;

    @Column(name = "DD_ESC_CODIGO")
    private String codigo;

    @Column(name = "DD_ESC_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_ESC_DESCRIPCION_LARGA")
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
