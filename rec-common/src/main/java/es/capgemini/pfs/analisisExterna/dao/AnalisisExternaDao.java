package es.capgemini.pfs.analisisExterna.dao;

import java.util.List;

import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaFormulario;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaTabla;
import es.capgemini.pfs.analisisExterna.model.AnalisisExterna;
import es.capgemini.pfs.dao.AbstractDao;

public interface AnalisisExternaDao extends AbstractDao<AnalisisExterna, Long> {

    /**
     * Cuenta el número de resultados de la consulta
     * @param dto
     * @return
     */
    Long buscarCount(DtoAnalisisExternaFormulario dto) throws Exception;

    /**
     * Devuelve un listado de resultados agrupando por procedimiento
     * @param dto
     * @return
     * @throws Exception
     */
    List<DtoAnalisisExternaTabla> buscarAgrupandoPorTipoProcedimiento(DtoAnalisisExternaFormulario dto) throws Exception;

    /**
     * Devuelve un listado de resultados agrupando por despacho
     * @param dto
     * @return
     * @throws Exception
     */
    List<DtoAnalisisExternaTabla> buscarAgrupandoPorDespacho(DtoAnalisisExternaFormulario dto) throws Exception;

    /**
     * Devuelve un listado de resultados agrupando por gestor
     * @param dto
     * @return
     * @throws Exception
     */
    List<DtoAnalisisExternaTabla> buscarAgrupandoPorGestor(DtoAnalisisExternaFormulario dto) throws Exception;

    /**
     * Devuelve un listado de resultados agrupando por supervisor
     * @param dto
     * @return
     * @throws Exception
     */
    List<DtoAnalisisExternaTabla> buscarAgrupandoPorSupervisor(DtoAnalisisExternaFormulario dto) throws Exception;

    /**
     * Devuelve un listado de resultados agrupando por fase procesal
     * @param dto
     * @return
     * @throws Exception
     */
    List<DtoAnalisisExternaTabla> buscarAgrupandoPorFaseProcesal(DtoAnalisisExternaFormulario dto) throws Exception;

}
