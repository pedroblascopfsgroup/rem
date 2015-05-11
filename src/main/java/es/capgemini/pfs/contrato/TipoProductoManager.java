package es.capgemini.pfs.contrato;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.dao.TipoProductoDao;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * Manager de TipoProductoManager.
 *
 */
@Service
public class TipoProductoManager {
    @Autowired
    private TipoProductoDao tipoProductoDao;

    /**
     * Devuelve la lista de estados.
     * @return la lista de estados
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TIPO_PRODUC_MGR_GET_TIPOS_PRODUCTOS)
    public List<DDTipoProducto> getTiposProducto() {
        return tipoProductoDao.getList();
    }

    /**
     * @param codigo String
     * @return estado DDEstadoItinerario
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TIPO_PRODUC_MGR_FIND_BY_CODIGO)
    public DDTipoProducto findByCodigo(String codigo) {
        return tipoProductoDao.findByCodigo(codigo);
    }

	/**
	 * Retorna la lista de tipos de producto en base a la lista de códigos pasada.
	 * @param codigos Set String
	 * @return List DDTipoProducto
	 */
    @BusinessOperation(PrimariaBusinessOperation.BO_TIPO_PRODUC_MGR_TIPOS_PRODUCTOS_BY_CODIGO)
	public List<DDTipoProducto> getTiposProductoByCodigos(Set<String> codigos) {
		return tipoProductoDao.getTiposProductoByCodigos(codigos);
	}
}
