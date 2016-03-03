package es.pfsgroup.recovery.ext.impl.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.ext.impl.contrato.dao.AtipicoContratoDao;
import es.pfsgroup.recovery.ext.impl.contrato.model.AtipicoContrato;

@Repository
public class AtipicoContratoDaoImpl extends
AbstractEntityDao<AtipicoContrato, Long> implements AtipicoContratoDao {
}