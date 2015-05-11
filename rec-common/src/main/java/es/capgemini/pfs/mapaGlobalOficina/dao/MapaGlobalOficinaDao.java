package es.capgemini.pfs.mapaGlobalOficina.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoBuscarMapaGlobalOficina;
import es.capgemini.pfs.mapaGlobalOficina.dto.DtoExportRow;
import es.capgemini.pfs.mapaGlobalOficina.model.MapaGlobalOficina;

/**
 * @author Andrï¿½s Esteban
 *
 */
public interface MapaGlobalOficinaDao extends AbstractDao<MapaGlobalOficina, Long> {

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD según los criterios
     * indicados en el dto.
     * @param dto criterios de busqueda.
     * @return lista de MapaGlobalOfina
     * @throws Exception e
     */
    List<MapaGlobalOficina> buscar(DtoBuscarMapaGlobalOficina dto) throws Exception;

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD según los criterios
     * indicados en el dto, y retorna la cantidad de registros encontrados.
     * @param dto criterios de busqueda.
     * @return int
     * @throws Exception e
     */
    int buscarCount(DtoBuscarMapaGlobalOficina dto) throws Exception;

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto
     * agrupados por producto.
     * @param dto criterios de busqueda y salida.
     * @return lista de MapaGlobalOfina
     * @throws Exception e
     */
    List<DtoExportRow> buscarAgrupandoPorProducto(DtoBuscarMapaGlobalOficina dto) throws Exception;

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto
     * agrupados por segmento.
     * @param dto criterios de busqueda y salida.
     * @return lista de MapaGlobalOfina
     * @throws Exception e
     */
    List<DtoExportRow> buscarAgrupandoPorSegmento(DtoBuscarMapaGlobalOficina dto) throws Exception;

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto
     * agrupados por subfases.
     * @param dto criterios de busqueda y salida.
     * @return lista de MapaGlobalOfina
     * @throws Exception e
     */
    List<DtoExportRow> buscarAgrupandoPorSubfases(DtoBuscarMapaGlobalOficina dto) throws Exception;

    /**
     * Busca los 'MapaGlobalOfina', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto
     * agrupados por jerarquia.
     * @param dto criterios de busqueda y salida.
     * @return lista de MapaGlobalOfina
     * @throws Exception e
     */
    List<DtoExportRow> buscarAgrupandoPorJerarquia(DtoBuscarMapaGlobalOficina dto) throws Exception;
}
