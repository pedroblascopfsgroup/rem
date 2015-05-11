package es.capgemini.pfs.procesosJudiciales;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;

/**
 * Clase manager de los juzgados-plaza.
 * @author pajimene
 */
@Service
public class JuzgadosManager {

    @Autowired
    private JuzgadoDao juzgadoDao;

    /**
     * Devuelve la lista de juzgados de una plaza.
     * @param codigoPlaza string
     * @return la lista de juzgados.
     */
    @BusinessOperation(ExternaBusinessOperation.BO_JUZGADO_MGR_GET_JUZGADOS_BY_PLAZA)
    public List<TipoJuzgado> getJuzgadosByPlaza(String codigoPlaza) {
        return juzgadoDao.getJuzgadosByPlaza(codigoPlaza);
    }
}
