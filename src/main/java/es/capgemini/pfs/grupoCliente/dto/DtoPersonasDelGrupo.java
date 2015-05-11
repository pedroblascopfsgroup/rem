package es.capgemini.pfs.grupoCliente.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

/**
 * DTO para para pasar el Id de la persona de la que queremos saber
 * el resto de los integrantes del grupo en el tab de grupo de cliente.
 * @author marruiz
 */
public class DtoPersonasDelGrupo extends PaginationParamsImpl {

    private static final long serialVersionUID = -2672529457579217164L;

    private Long idGrupo;

    /**
     * @param idGrupo the idGrupo to set
     */
    public void setIdGrupo(Long idGrupo) {
        this.idGrupo = idGrupo;
    }

    /**
     * @return the idGrupo
     */
    public Long getIdGrupo() {
        return idGrupo;
    }
}
