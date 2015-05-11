package es.capgemini.pfs.politica.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * @author Pablo Müller
 *
 */
public class DtoAnalisisPolitica extends WebDto {

    private static final long serialVersionUID = -5183424966744490312L;

    private Long idAnalisisPolitica;
    private String comentario;
    private Boolean esGestor;
    private Boolean esSupervisor;

    /**
     * @return the idAnalisisPolitica
     */
    public Long getIdAnalisisPolitica() {
        return idAnalisisPolitica;
    }

    /**
     * @param idAnalisisPolitica the idAnalisisPolitica to set
     */
    public void setIdAnalisisPolitica(Long idAnalisisPolitica) {
        this.idAnalisisPolitica = idAnalisisPolitica;
    }

    /**
     * @return the comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * @param comentario the comentario to set
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    /**
     * @return the esGestor
     */
    public Boolean getEsGestor() {
        return esGestor;
    }

    /**
     * @param esGestor the esGestor to set
     */
    public void setEsGestor(Boolean esGestor) {
        this.esGestor = esGestor;
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

}
