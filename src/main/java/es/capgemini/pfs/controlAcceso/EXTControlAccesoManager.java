package es.capgemini.pfs.controlAcceso;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.api.controlAcceso.EXTControlAccesoApi;
import es.capgemini.pfs.controlAcceso.dao.EXTControlAccesoDao;
import es.capgemini.pfs.controlAcceso.model.EXTControlAcceso;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

@Component
public class EXTControlAccesoManager implements EXTControlAccesoApi{

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	EXTControlAccesoDao controlAccesoDao;
	
	@SuppressWarnings("deprecation")
	@Override
	@BusinessOperation(BO_CORE_CONTROL_ACCESO_CREAR_REGISTRO)
	@Transactional(readOnly=false)
	public void registrarAccesoDeUsuario() {
		EventFactory.onMethodStart(this.getClass());
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Date hoy = new Date();
		Boolean registrado= false;
		List<EXTControlAcceso> controlHoy = controlAccesoDao.buscaAccesoHoy(usuarioLogado);
		if (!Checks.esNulo(controlHoy) && !Checks.estaVacio(controlHoy)){
			if (controlHoy.get(0).getAuditoria().getFechaCrear().getDate()==hoy.getDate() && 	
					controlHoy.get(0).getAuditoria().getFechaCrear().getMonth()== hoy.getMonth() &&
					controlHoy.get(0).getAuditoria().getFechaCrear().getYear()== hoy.getYear()){
				
						registrado=true;
			}
		}
		
		if (!registrado){     
			EXTControlAcceso registro =controlAccesoDao.createNewControlAcceso();
			registro.setUsuario(usuarioLogado);
			genericDao.save(EXTControlAcceso.class, registro);
		}
		
		EventFactory.onMethodStop(this.getClass());
	}

	
	
}
