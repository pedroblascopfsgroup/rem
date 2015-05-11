package es.capgemini.pfs.asunto.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.asunto.model.Procedimiento;

/**
 * Dto para el procedimiento jerarquico.
 *
 */
public class ProcedimientoJerarquiaDto extends WebDto {

    private static final long serialVersionUID = 7092416525831458599L;
    private Integer nivel;
    private Procedimiento procedimiento;

    /**
     * Constructor vacio para que funcione el contexto de los tests.
     */
    @Deprecated
    public ProcedimientoJerarquiaDto() {
        super();
    }

    /**
     * Constructor.
     * @param nivel integer
     * @param procedimiento procedimiento
     */
    public ProcedimientoJerarquiaDto(Integer nivel, Procedimiento procedimiento) {
        super();
        this.nivel = nivel;
        this.procedimiento = procedimiento;
    }

    /**
     * @return the nivel
     */
    public Integer getNivel() {
        return nivel;
    }

    /**
     * @param nivel the nivel to set
     */
    public void setNivel(Integer nivel) {
        this.nivel = nivel;
    }

    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }


}
