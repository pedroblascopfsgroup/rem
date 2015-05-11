package es.capgemini.pfs.tareaNotificacion.dao;

import java.util.Date;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.Festivo;


public interface FestivoDao extends AbstractDao<Festivo, Long>{

	Festivo buscaFestivo(Date fechaVenc);

}
