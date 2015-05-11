package es.capgemini.pfs.ingreso;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.ingreso.dao.DDTipoIngresoDao;
import es.capgemini.pfs.ingreso.dao.IngresoDao;
import es.capgemini.pfs.ingreso.dto.DtoIngreso;
import es.capgemini.pfs.ingreso.model.DDTipoIngreso;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.persona.PersonaManager;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * @author Mariano Ruiz
 */
@Service
public class IngresoManager {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private IngresoDao ingresoDao;

    @Autowired
    private DDTipoIngresoDao dDTipoIngresoDao;

    @Autowired
    private PersonaManager personaManager;

    /**
     * Retorna el Ingreso del Id pasado.
     * @param id Long
     * @return Ingreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_GET_INGRESO)
    @Transactional
    public Ingreso getIngreso(Long id) {
        return ingresoDao.get(id);
    }

    /**
     * Persiste el ingreso.
     * @param object DDTipoIngreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void saveOrUpdateIngreso(Ingreso object) {
        ingresoDao.saveOrUpdate(object);
    }

    /**
     * Crea o actualiza el ingreso de la persona.
     * @param dtoIngreso DtoIngreso
     * @param idPersona Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_CREATE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void createOrUpdate(DtoIngreso dtoIngreso, Long idPersona) {

        Ingreso ingreso = dtoIngreso.getIngreso();
        // Si estoy creando un ingreso nuevo
        if (ingreso.getId() == null) {
            Persona persona = personaManager.get(idPersona);
            ingreso.setPersona(persona);
            persona.getIngresos().add(ingreso);
        }
        saveOrUpdateIngreso(ingreso);
    }

    /**
     * Persiste el ingreso.
     * @param object DDTipoIngreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_SAVE_INGRESO)
    @Transactional(readOnly = false)
    public void saveIngreso(Ingreso object) {
        ingresoDao.save(object);
    }

    /**
     * Borra el ingreso.
     * @param id Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_DELETE_INGRESO)
    @Transactional(readOnly = false)
    public void deleteIngreso(Long id) {
        ingresoDao.deleteById(id);
    }

    /*
     *   Métodos para Tipos de ingreso.
     */

    /**
     * Retorna el Tipo de Ingreso del Id pasado.
     * @param id Long
     * @return DDTipoIngreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_GET_TIPO_INGRESO_BY_ID)
    @Deprecated
    public DDTipoIngreso getTipoIngreso(Long id) {
        logger.debug("Posible error: Acceso a entidad de diccionario DDTipoIngreso mediante Id.");
        return dDTipoIngresoDao.get(id);
    }

    /**
     * Retorna el Tipo de Ingreso del código pasado.
     * @param codigo Long
     * @return DDTipoIngreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_GET_TIPO_INGRESO_BY_CODIGO)
    public DDTipoIngreso getTipoIngresoByCodigo(String codigo) {
        return dDTipoIngresoDao.getByCodigo(codigo);
    }

    /**
     * Retorna todos los tipos de ingreso.
     * @return List
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_GET_LIST_TIPO_INGRESO)
    public List<DDTipoIngreso> getListTipoIngreso() {
        return dDTipoIngresoDao.getList();
    }

    /**
     * Persiste el tipo de ingreso.
     * @param object DDTipoIngreso
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_SAVE_OR_UPDATE_TIPO_INGRESO)
    @Transactional(readOnly = false)
    public void saveOrUpdateTipoIngreso(DDTipoIngreso object) {
        dDTipoIngresoDao.saveOrUpdate(object);
    }

    /**
     * Borra el tipo de ingreso.
     * @param id Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_INGRESO_MGR_DELETE_TIPO_INGRESO)
    @Transactional(readOnly = false)
    public void deleteTipoIngreso(Long id) {
        dDTipoIngresoDao.deleteById(id);
    }
}
