package es.capgemini.pfs.cliente.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoListadoAsuntos extends WebDto {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    private Long idPersona;

    /**
     * @param idPersona the idPersona to set
     */
    public void setIdPersona(Long idPersona) {
        this.idPersona = idPersona;
    }

    /**
     * @return the idPersona
     */
    public Long getIdPersona() {
        return idPersona;
    }

}
