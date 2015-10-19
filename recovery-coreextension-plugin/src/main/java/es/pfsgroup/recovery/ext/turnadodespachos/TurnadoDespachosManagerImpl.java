package es.pfsgroup.recovery.ext.turnadodespachos;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

@Service
public class TurnadoDespachosManagerImpl implements TurnadoDespachosManager {

	private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private UsuarioManager usuarioManager;

	@Autowired
	private EsquemaTurnadoDao esquemaTurnadoDao;
	
	@Autowired
	private DespachoExternoDao despachoExternoDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public Page listaEsquemasTurnado(EsquemaTurnadoBusquedaDto dto) {
		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		Page page = esquemaTurnadoDao.buscarEsquemasTurnado(dto, usuarioLogado);
		return page;
	}

	@Override
	public EsquemaTurnado get(Long id) {
		return esquemaTurnadoDao.get(id);
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
