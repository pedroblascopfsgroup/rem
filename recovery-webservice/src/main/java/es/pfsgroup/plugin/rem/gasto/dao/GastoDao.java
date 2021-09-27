package es.pfsgroup.plugin.rem.gasto.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VGastosRefacturados;

public interface GastoDao extends AbstractDao<GastoProveedor, Long> {

    DtoPage getListGastos(DtoGastosFilter dtoGastosFilter, Long usuarioId);

    Long getNextNumGasto();
    
    Long getNextIdGasto();

    void deleteGastoTrabajoById(Long id);

    GastoProveedor getGastoById(Long id);

    /**
     * Devuelve un listado de gastos filtras por el proveedor contacto asociado al usuario pasado por parametro
     *
     * @param dtoGastosFilter: dto con los datos a filtrar.
     * @param idUsuario: Id del usuario.
     * @return Devuelve un dto de paginación con los resultados obtenidos.
     */
    DtoPage getListGastosFilteredByProveedorContactoAndGestoria(DtoGastosFilter dtoGastosFilter, Long idUsuario, Boolean isGestoriaAdm, Boolean isGenerateExcel);

    DtoPage getListGastosProvision(DtoGastosFilter dtoGastosFilter);

    DtoPage getListGastosExcel(DtoGastosFilter dtoGastosFilter, Long usuarioId);

    /**
     * Este método obtiene un GastoProveedor por el número de gasto en Haya pasado por parámetro.
     *
     * @param numeroGastoHaya: número de registro del gasto en Haya.
     * @return Devuelve un objeto de tipo GastoProveedor si encuentra alguno por el número de gasto, null si no encuentra nada.
     */
    GastoProveedor getGastoPorNumeroGastoHaya(Long numeroGastoHaya);

    List<VGastosRefacturados> getGastosRefacturados(String listaGastos);

	List<GastoRefacturable> getGastosRefacturablesDelGasto(Long id);

	Boolean updateGastosRefacturablesSiExiste(Long id, Long idPadre, String usuario);

	void saveGasto(GastoProveedor gasto);

	Long getIdProveedorByGasto(GastoProveedor gasto);

	Long getIdCarteraByGasto(GastoProveedor gasto);
	
	void deleteGastoSuplido(Long id);

	List<VBusquedaGastoActivo> getListGastosByIdActivos(List<Long> idActivos);

}
