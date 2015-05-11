package es.capgemini.pfs.bien;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.bien.dao.DDTipoBienDao;
import es.capgemini.pfs.bien.model.DDTipoBien;

/**
 * Manager para los tipos de bienes.
 *
 */
@Service("tipoBienManager")
public class DDTipoBienManager {

    @Autowired
    private DDTipoBienDao tipoBienDao;

    /**
     * @return Lista de los tipos de bienes.
     */
    @BusinessOperation
    public List<DDTipoBien> getList() {
        return tipoBienDao.getList();
    }

    /**
     * Recupera un Tipo de bien.
     * @param id long
     * @return tipo bien
     */
    public DDTipoBien get(Long id) {
        return tipoBienDao.get(id);
    }

    /**
     * Devuelve el tipo de bien a partir de su código.
     * @param codigo el codigo del tipo de bien
     * @return el tipo de bien
     */
    @BusinessOperation
    public Object getByCodigo(String codigo) {
        return tipoBienDao.getByCodigo(codigo);
    }

}
