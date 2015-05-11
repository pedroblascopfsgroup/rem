package es.pfsgroup.procedimientos.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.dao.EXTTareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.dao.EXTTareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

@Component
public class PROTareaExternaManager implements PROTareaExternaManagerApi {

	@Autowired
	private TareaExternaValorDao tareaExternaValorDao;
	
	@Autowired
	private EXTTareaExternaDao tareaExternaDao;
	
	@Autowired
	private EXTTareaNotificacionDao tareaNotificacionDao;
	
	@BusinessOperation("recovery.plugin.procedimientos.guardarTareaExterna")
	@Override
	@Transactional
	public void guardarTareaExternaValor(TareaExternaValor tev,EXTTareaExterna tex, EXTTareaNotificacion tar){
		
		
		Long idTN = tareaNotificacionDao.save(tar);
		TareaNotificacion tn = tareaNotificacionDao.get(idTN);
		
		tex.setTareaPadre(tn);
		
		Long idTareaExterna = tareaExternaDao.save(tex);
		EXTTareaExterna te = tareaExternaDao.get(idTareaExterna);
		
		tev.setTareaExterna(te);
		tareaExternaValorDao.save(tev);
		
	}
}
