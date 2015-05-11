package es.capgemini.pfs.procesosJudiciales;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.DDFaseProcesalDao;
import es.capgemini.pfs.procesosJudiciales.model.DDFaseProcesal;

/**
 * Clase manager de las fases procesales
 * @author pajimene
 */
@Service("DDFaseProcesalManager")
public class DDFaseProcesalManager {

    @Autowired
    private DDFaseProcesalDao faseProcesalDao;

    /**
     * Devuelve la lista de juzgados de una plaza.
     * @param codigoPlaza string
     * @return la lista de juzgados.
     */
    @BusinessOperation
    public List<DDFaseProcesal> getFasesProcesales() {
        return faseProcesalDao.getList();
    }
}
