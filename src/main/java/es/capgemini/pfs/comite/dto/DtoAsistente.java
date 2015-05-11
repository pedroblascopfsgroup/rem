package es.capgemini.pfs.comite.dto;


import java.io.Serializable;

import es.capgemini.pfs.comite.model.Asistente;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Bean para transportar datos a la vistas de comité y la generación de actas.
 * @author Andr�s Esteban
 *
 */
public class DtoAsistente implements Serializable, Comparable<DtoAsistente> {

   private static final long serialVersionUID = 1L;
   private Boolean esSupervisor;
   private Boolean esRestrictivo;
   private Boolean asiste;
   private Usuario usuario;
   private Asistente asistente;
   private Comite comite;

   /**
    * @return the asistente
    */
   public Asistente getAsistente() {
      return asistente;
   }

   /**
    * @param asistente the asistente to set
    */
   public void setAsistente(Asistente asistente) {
      this.asistente = asistente;
   }

   /**
    * @return the esSupervisor
    */
   public Boolean getEsSupervisor() {
      if (esSupervisor == null) {
         return asistente.isSupervisor();
      }
      return esSupervisor;
   }

   /**
    * @param esSupervisor the esSupervisor to set
    */
   public void setEsSupervisor(Boolean esSupervisor) {
      this.esSupervisor = esSupervisor;
   }

   /**
    * @return the esRestrictivo
    */
   public Boolean getEsRestrictivo() {
      if (esRestrictivo == null) {
         return asistente.isRestrictivo();
      }
      return esRestrictivo;
   }

   /**
    * @param esRestrictivo the esRestrictivo to set
    */
   public void setEsRestrictivo(Boolean esRestrictivo) {
      this.esRestrictivo = esRestrictivo;
   }

   /**
    * @return the asiste
    */
   public Boolean getAsiste() {
      return asiste;
   }

   /**
    * @param asiste the asiste to set
    */
   public void setAsiste(Boolean asiste) {
      this.asiste = asiste;
   }

   /**
    * Retorna el boolean como "Si" o "No".
    * @return string
    */
   public String getEsRestrictivoToString() {
      return booleanToString(getEsRestrictivo());
   }

   /**
    * Retorna el boolean como "Si" o "No".
    * @return string
    */
   public String getEsSupervisorToString() {
      return booleanToString(getEsSupervisor());
   }

   /**
    * Transforma un boolean a "Si" o "No".
    * @param b
    * @return
    */
   private String booleanToString(Boolean b) {
      if (b) {
         return "Si";
      }
      return "No";
   }

   /**
    * @return the usuario
    */
   public Usuario getUsuario() {
      if (usuario == null) {
         usuario = asistente.getUsuario();
      }
      return usuario;
   }

   /**
    * @param usuario the usuario to set
    */
   public void setUsuario(Usuario usuario) {
      this.usuario = usuario;
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
    * Compara dtoAsistente.
    * @param dtoAsistente asistente
    * @return int
    */
   @Override
   public int compareTo(DtoAsistente dtoAsistente) {
      return this.getUsuario().getId().compareTo(dtoAsistente.getUsuario().getId());
   }

}
