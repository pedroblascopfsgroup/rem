package es.pfsgroup.plugin.rem.testigos.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.TestigosObligatorios;

public interface TestigosDao extends AbstractDao<TestigosObligatorios, Long> {

	public List<TestigosObligatorios> getTestigosList();

	public void deleteTestigoById(Long id);

}
