package es.capgemini.pfs.contrato;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.dao.TipoProductoEntidadDao;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * Manager de TipoProductoEntidadManager.
 *
 */
@Service
public class TipoProductoEntidadManager {
    @Autowired
    private TipoProductoEntidadDao tipoProductoEntidadDao;

    /**
     * Devuelve la lista de tipo de productos entidad ordenados por descripcion
     * @return la lista de tipo de productos entidad
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_TIPO_PRODUC_ENT_MGR_GET_TIPOS_PRODUCTOS)
    public List<DDTipoProductoEntidad> getTiposProductoEntidad() {
        return tipoProductoEntidadDao.getOrderedList();
    }

 }
