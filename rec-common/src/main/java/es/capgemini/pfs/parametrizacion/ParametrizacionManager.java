package es.capgemini.pfs.parametrizacion;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.exceptions.NonRollbackException;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.parametrizacion.dto.DtoParametrizacion;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Manager de las parametrizaciones de la entidad.
 * @author marruiz
 */
@Service
public class ParametrizacionManager {

    @Autowired
    private ParametrizacionDao parametrizacionDao;

    /**
     * Busca el parametro que corresponda al nombre indicado.
     * Lanza error de parametrizacion si no existe o hay mas de un parámetro.
     * @param nombre string
     * @return Parametrizacion
     */
    @Transactional(noRollbackFor = NonRollbackException.class)
    @BusinessOperation(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE)
    public Parametrizacion buscarParametroPorNombre(String nombre) {
        return parametrizacionDao.buscarParametroPorNombre(nombre);
    }

    /**
     * Actualiza un registro de parametrización.
     * @param dto DtoNumIntervalo
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_UDPATE)
    @Transactional(readOnly = false)
    public void update(DtoParametrizacion dto) {
        Parametrizacion parametrizacion = parametrizacionDao.get(dto.getParametrizacion().getId());
        parametrizacion.setValor(dto.getParametrizacion().getValor());
        parametrizacionDao.update(parametrizacion);
    }
}
