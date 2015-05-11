package es.capgemini.pfs.comite.model;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Set;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.comite.dto.DtoSesionComite;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase contenedora de los datos y métodos auxiliares para la generación del reporte de acta.
 * @author aesteban
 *
 */
public class DtoActa {

   private DtoSesionComite dtoSesion;
   private List<Asunto> asuntos;
   private List<Expediente> expedientes;
   private Usuario supervisor;
   private List<CicloMarcadoPolitica> marcadoPoliticas;
   private String tipoCierre;
   private Long numPoliticasGeneradas;


   /**
    * Retorna los asuntos del expediente indicado.
    * @param sExpId string
    * @return lista de asuntos
    */
   public List<Asunto> getAsuntoParaExpediente(String sExpId) {
      for (Expediente exp : expedientes) {
         if (exp.getId().equals(new Long(sExpId))) {
            return exp.getAsuntos();
         }
      }
      return null;
   }

   /**
    * @param id Long
    * @return CicloMarcadoPolitica de la lista con el id pasado
    */
   public CicloMarcadoPolitica getCicloMarcadoPolitica(String id) {
	   for(CicloMarcadoPolitica cicloMarcadoPolitica : marcadoPoliticas) {
		   if(cicloMarcadoPolitica.getId().equals(new Long(id))) {
			   return cicloMarcadoPolitica;
		   }
	   }
	   return null;
   }

   /**
    * Retorna el expediente indicado.
    * @param id string
    * @return expediente
    */
   public Expediente getExpediente(String id) {
      for(Expediente exp : expedientes) {
         if(exp.getId().equals(new Long(id))) {
            return exp;
         }
      }
      return null;
   }
   /**
    * Retorna los contratos del asunto indicado.
    * @param sAsuId string
    * @return lista de asuntos
    */
   public Set<Contrato> getContratosParaAsunto(String sAsuId) {
      for (Asunto asu : asuntos) {
         if (asu.getId().equals(new Long(sAsuId))) {
            return asu.getContratos();
         }
      }
      return null;
   }
   /**
    * @return comite.
    */
   public Comite getComite() {
      return dtoSesion.getComite();
   }

   /**
    * @return the dtoSesion
    */
   public DtoSesionComite getDtoSesion() {
      return dtoSesion;
   }

   /**
    * @return the SesionComite
    */
   public SesionComite getSesion() {
      return dtoSesion.getSesion();
   }

   /**
    * @param dtoSesion the dtoSesion to set
    */
   public void setDtoSesion(DtoSesionComite dtoSesion) {
      this.dtoSesion = dtoSesion;
   }

   /**
    * Retorna el nombre del documento.
    * @return string
    */
   public String getNombreDocumento() {
      return "actacomite_" + getNumero("dd/MM/yyyy HH:mm");
   }

   /**
    * Retorna el numero de acta.
    * @return string
    */
   public String getNumero() {
      return getNumero("dd/MM/yyyy");
   }

   private String getNumero(String formato) {
      DateFormat df = new SimpleDateFormat(formato);
      return dtoSesion.getComite().getId() + "_" + getSesion().getId() + "_" + df.format(getSesion().getFechaFin());
   }

   /**
    * Retorna la cantidad de expedientes tratados por la sesiÃ³n.
    * @return string
    */
   public int getPuntosTratados() {
      return expedientes.size();
   }

   /**
    * Indica como se cerró la sesion, "Manual" o "Automático".
    * @return string
    */
   public String getTipoCierre() {
      return tipoCierre;
   }

   /**
	* @param tipoCierre the tipoCierre to set
	*/
	public void setTipoCierre(String tipoCierre) {
		this.tipoCierre = tipoCierre;
	}

/**
    * Retorna la cantidad de asuntos generados en la sesiÃ³n.
    * @return string
    */
   public int getAsuntosGenerados() {
      return asuntos.size();
   }

   /**
    * @return the asuntos
    */
   public List<Asunto> getAsuntos() {
      return asuntos;
   }

   /**
    * @param asuntos the asuntos to set
    */
   public void setAsuntos(List<Asunto> asuntos) {
      this.asuntos = asuntos;
   }

   /**
    * @return the expedientes
    */
   public List<Expediente> getExpedientes() {
      return expedientes;
   }

	/**
	 * @return the marcadoPoliticas
	 */
	public List<CicloMarcadoPolitica> getMarcadoPoliticas() {
		return marcadoPoliticas;
	}

	/**
	 * @param marcadoPoliticas the marcadoPoliticas to set
	 */
	public void setMarcadoPoliticas(List<CicloMarcadoPolitica> marcadoPoliticas) {
		this.marcadoPoliticas = marcadoPoliticas;
	}

   /**
    * @param expedientes the expedientes to set
    */
   public void setExpedientes(List<Expediente> expedientes) {
      this.expedientes = expedientes;
   }

   /**
    * Retorna el supervisor del acta.
    * Se busca el asistente que sea supervisor de la sesiÃ³n.
    * @return usuario
    */
   public Usuario getSupervisor() {
      if (supervisor == null) {
         for (Asistente asistente : getSesion().getAsistentes()) {
            if(asistente.isSupervisor()) {
               supervisor = asistente.getUsuario();
            }
         }
      }
      return supervisor;
   }

	/**
	 * @return the numPoliticasGeneradas
	 */
	public Long getNumPoliticasGeneradas() {
		return numPoliticasGeneradas;
	}

	/**
	 * @param numPoliticasGeneradas the numPoliticasGeneradas to set
	 */
	public void setNumPoliticasGeneradas(Long numPoliticasGeneradas) {
		this.numPoliticasGeneradas = numPoliticasGeneradas;
	}
}
