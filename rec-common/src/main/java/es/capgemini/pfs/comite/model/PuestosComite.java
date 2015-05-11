package es.capgemini.pfs.comite.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Clase que represante un PuestoComite.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "PCO_PUESTOS_COMITE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PuestosComite implements Serializable, Auditable  {

   private static final long serialVersionUID = 534010366258980212L;

   @Id
   @Column(name = "PCO_ID")
   private Long id;

   @ManyToOne
   @JoinColumn(name = "COM_ID")
   private Comite comite;

   @ManyToOne
   @JoinColumn(name = "PEF_ID")
   private Perfil perfil;

   // No se que represante este campo pero lo llamo esXXX porque es boolean
   @Column(name = "PCO_RESTRICTIVO")
   private Boolean esRestrictivo;

   // No se que represante este campo pero lo llamo esXXX porque es boolean
   @Column(name = "PCO_SUPERVISOR")
   private Boolean esSupervisor;

   @ManyToOne
   @JoinColumn(name = "ZON_ID")
   private DDZona zona;

   @Version
   private Integer version;

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
    * @return the comite
    */
   public Comite getComite() {
      return comite;
   }

   /**
    * @param comite the comite to set
    */
   public void setComite(Comite comite) {
      this.comite = comite;
   }

   /**
    * @return the perfil
    */
   public Perfil getPerfil() {
      return perfil;
   }

   /**
    * @param perfil the perfil to set
    */
   public void setPerfil(Perfil perfil) {
      this.perfil = perfil;
   }

   /**
    * @return the esRestrictivo
    */
   public Boolean getEsRestrictivo() {
      return esRestrictivo;
   }

   /**
    * @param esRestrictivo the esRestrictivo to set
    */
   public void setEsRestrictivo(Boolean esRestrictivo) {
      this.esRestrictivo = esRestrictivo;
   }

   /**
    * @return the esSupervisor
    */
   public Boolean getEsSupervisor() {
      return esSupervisor;
   }

   /**
    * @param esSupervisor the esSupervisor to set
    */
   public void setEsSupervisor(Boolean esSupervisor) {
      this.esSupervisor = esSupervisor;
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
    * @return the serialVersionUID
    */
   public static long getSerialVersionUID() {
      return serialVersionUID;
   }

   /**
    * @param zona the zona to set
    */
   public void setZona(DDZona zona) {
      this.zona = zona;
   }

   /**
    * @return the zona
    */
   public DDZona getZona() {
      return zona;
   }
}
