package es.capgemini.pfs.contrato.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * modelo de la tabla DD_TPE_TIPO_PROD_ENTIDAD.
 */
@Entity
@Table(name = "DD_TPE_TIPO_PROD_ENTIDAD", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoProductoEntidad implements Dictionary, Auditable {

   /**
   *  serial id.
   */
   private static final long serialVersionUID = -619953681126956466L;

   @Id
   @Column(name = "DD_TPE_ID")
   private Long id;

   @ManyToOne(fetch=FetchType.LAZY)
   @JoinColumn(name = "DD_TPR_ID")
   private DDTipoProducto tipoProducto;

   @Column(name = "DD_TPE_CODIGO")
   private String codigo;

   @Column(name = "DD_TPE_ACTIVO")
   private Boolean activo;

   @Column(name = "DD_TPE_DESCRIPCION")
   private String descripcion;

   @Column(name = "DD_TPE_DESCRIPCION_LARGA")
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
    * @param version
    *            the version to set
    */
   public void setVersion(Integer version) {
      this.version = version;
   }

   /**
    * @return the tipoProducto
    */
   public DDTipoProducto getTipoProducto() {
      return tipoProducto;
   }

   /**
    * @param tipoProducto the tipoProducto to set
    */
   public void setTipoProducto(DDTipoProducto tipoProducto) {
      this.tipoProducto = tipoProducto;
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
    * @return the activo
    */
   public Boolean getActivo() {
      return activo;
   }

   /**
    * @param activo the activo to set
    */
   public void setActivo(Boolean activo) {
      this.activo = activo;
   }

}
