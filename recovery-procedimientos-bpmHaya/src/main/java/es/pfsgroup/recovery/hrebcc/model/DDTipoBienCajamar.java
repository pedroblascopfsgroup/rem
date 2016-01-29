package es.pfsgroup.recovery.hrebcc.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_TBC_TIPO_BIEN_CAJAMAR", schema = "${entity.schema}")
public class DDTipoBienCajamar implements Dictionary {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DD_TBI_ID", insertable = false, updatable = false)
    private Long id;

    @Column(name = "DD_TBI_CODIGO", insertable = false, updatable = false)
    private String codigo;

    @Column(name = "DD_TBI_DESCRIPCION", insertable = false, updatable = false)
    private String descripcion;

    @Column(name = "DD_TBI_DESCRIPCION_LARGA", insertable = false, updatable = false)
    private String descripcionLarga;

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

}
