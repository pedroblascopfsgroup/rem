package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TurnadoDespachosManagerImpl implements TurnadoDespachosManager {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EsquemaTurnadoDao esquemaTurnadoDao;
	
	@Override
	public List<EsquemaTurnado> listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto) {
		return null;
	}

	@Override
	public EsquemaTurnado get(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@Transactional
	public EsquemaTurnado save(EsquemaTurnadoDto dto) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@Transactional
	public void activarEsquema(Long idEsquema) throws ActivarEsquemaDeTurnadoException {
		// TODO Auto-generated method stub

	}

	@Override
	@Transactional
	public void turnar(Long idAsunto) throws AplicarTurnadoException {
		// TODO Auto-generated method stub

	}

	@Override
	public EsquemaTurnado getEsquemaVigente() {
		EsquemaTurnado esquemaTurnado = esquemaTurnadoDao.getEsquemaVigente();
		return esquemaTurnado;
	}

	@Override
	public void delete(Long id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void copy(Long id) {
		// TODO Auto-generated method stub
		
	}

}
