package es.capgemini.pfs.subfase;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.subfase.dao.FaseDao;
import es.capgemini.pfs.subfase.dao.SubfaseDao;
import es.capgemini.pfs.subfase.model.DDFase;
import es.capgemini.pfs.subfase.model.Subfase;

/**
 * Manager para las fases y subfases.
 */
@Service
public class FaseManager {

    @Autowired
    private FaseDao faseDao;

    @Autowired
    private SubfaseDao subfaseDao;

    /**
     * Retorna la lista de fases existentes.
     * @return Lista de fases
     */
    @BusinessOperation
    public List<DDFase> getFases() {
        return faseDao.getList();
    }

    /**
     * Retorna las lista de subfase de la fase indicada.
     * @param codigoFase String
     * @return List Subfase
     */
    @BusinessOperation
    public List<Subfase> getSubfases(String codigoFase) {
        return subfaseDao.findByCodigoDeLaFase(codigoFase);
    }

    /**
     * @param codigo String
     * @return Fase
     */
    @BusinessOperation
    public DDFase getFaseByCodigo(String codigo) {
        return faseDao.getByCodigo(codigo);
    }

    /**
     * Devuelve la Fase, si el código es vacío devuelve un objeto
     * <code>Fase</code> vacío.
     * @param codigo String
     * @return Fase
     */
    @BusinessOperation
    public DDFase getFaseByCodigoOrEmptyObj(String codigo) {
        DDFase fase;
        if(codigo==null || codigo.equals("")) {
            fase = new DDFase();
            fase.setDescripcion("");
        } else {
            fase = faseDao.getByCodigo(codigo);
        }
        return fase;
    }

    /**
     * @param codigos Set String
     * @return List Subfase
     */
    @BusinessOperation
    public List<Subfase> getSubfasesByCodigos(Set<String> codigos) {
        return subfaseDao.getByCodigos(codigos);
    }
}
