package es.capgemini.pfs.comite.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que mapea a un asistente a una sesión de comité.
 * @author pamuller
 *
 */
@Entity
@Table(name = "ACO_ASISTENTES_COMITE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Asistente implements Serializable,Auditable {

   private static final long serialVersionUID = -2693572571199581387L;

   @Id
   @Column(name = "ACO_ID")
   @GeneratedValue(strategy = GenerationType.AUTO, generator = "AsistentesGenerator")
   @SequenceGenerator(name = "AsistentesGenerator", sequenceName = "S_ACO_ASISTENTES_COMITE")
   private Long id;

   @ManyToOne
   @JoinColumn(name = "COM_ID")
   private Comite comite;

   @ManyToOne
   @JoinColumn(name = "SES_ID")
   private SesionComite sesionComite;

   @ManyToOne
   @JoinColumn(name = "USU_ID")
   private Usuario usuario;

   @Column(name = "ACO_RESTRICTIVO")
   private boolean restrictivo;

   @Column(name = "ACO_SUPERVISOR")
   private boolean supervisor;

   @Column(name = "ACO_ASISTIO")
   private boolean asistio;

   @Column(name = "ACO_DESCRIPCION")
   private String cargo;

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
    * @return the sesionComite
    */
   public SesionComite getSesionComite() {
      return sesionComite;
   }

   /**
    * @param sesionComite the sesionComite to set
    */
   public void setSesionComite(SesionComite sesionComite) {
      this.sesionComite = sesionComite;
   }

   /**
    * @return the usuario
    */
   public Usuario getUsuario() {
      return usuario;
   }

   /**
    * @param usuario the usuario to set
    */
   public void setUsuario(Usuario usuario) {
      this.usuario = usuario;
   }

   /**
    * @return the restrictivo
    */
   public boolean isRestrictivo() {
      return restrictivo;
   }

   /**
    * @param restrictivo the restrictivo to set
    */
   public void setRestrictivo(boolean restrictivo) {
      this.restrictivo = restrictivo;
   }

   /**
    * @return the supervisor
    */
   public boolean isSupervisor() {
      return supervisor;
   }

   /**
    * @param supervisor the supervisor to set
    */
   public void setSupervisor(boolean supervisor) {
      this.supervisor = supervisor;
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
    * @return the asistio
    */
   public boolean isAsistio() {
      return asistio;
   }

   /**
    * @param asistio the asistio to set
    */
   public void setAsistio(boolean asistio) {
      this.asistio = asistio;
   }

   /**
    * @return the cargo
    */
   public String getCargo() {
      return cargo;
   }

   /**
    * @param cargo the cargo to set
    */
   public void setCargo(String cargo) {
      this.cargo = cargo;
   }

}
