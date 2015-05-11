package es.capgemini.pfs.alerta;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.alerta.dao.AlertaDao;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.scoring.dto.DtoAlerta;

/**
 * Manager del módilo de alertas, ver también SimulacionManager.
 * @author marruiz
 */
@Service
public class AlertaManager {

	@Autowired
	private AlertaDao alertaDao;

    /**
     * Recupera Dto's de las ultimas alertas cargadas.
     * @return lista de alertas
     */
	@BusinessOperation(PrimariaBusinessOperation.BO_ALERTA_MGR_GET_DTO_ALERTAS_ACTIVAS)
	public List<DtoAlerta> getDtoAlertasActivas(){
    	return alertaDao.getDtoAlertasActivas();
    }
}
