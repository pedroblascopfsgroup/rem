package es.pfsgroup.plugin.recovery.itinerarios.ddSiNo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.plugin.recovery.itinerarios.ddSiNo.dao.ITIddSiNoDao;

@Repository("ITIddSiNoDao")
public class ITIddSiNoDaoImpl extends AbstractEntityDao<DDSiNo, Long> implements ITIddSiNoDao {

}
