package es.pfsgroup.plugin.recovery.expediente.incidencia.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dao.IncidenciaExpedienteDao;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoFiltroIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.IncidenciaExpediente;

@Repository("IncidenciaExpedienteDao")
public class IncidenciaExpedienteDaoImpl extends AbstractEntityDao<IncidenciaExpediente, Long> implements IncidenciaExpedienteDao {
	
	@Override
	public Page getListadoIncidenciaExpediente(DtoFiltroIncidenciaExpediente dto) {
		
		HQLBuilder hb = new HQLBuilder(" from IncidenciaExpediente iex ");
		hb.appendWhere("iex.auditoria.borrado=0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "iex.expediente.id", dto.getIdExpediente(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "iex.despachoExterno.id", dto.getIdProveedor(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "iex.tipoIncidencia.id", dto.getIdTipoIncidencia(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "iex.usuario.id", dto.getIdUsuario());
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		if (StringUtils.hasText(dto.getFechaDesde()) || StringUtils.hasText(dto.getFechaHasta())){			
			try {
				Date fechaMin = StringUtils.hasText(dto.getFechaDesde()) ? df.parse(dto.getFechaDesde() +" 00:00:00") : null;
				Date fechaMax = StringUtils.hasText(dto.getFechaHasta()) ? df.parse(dto.getFechaHasta() +" 23:59:59") : null;
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "iex.auditoria.fechaCrear", fechaMin, fechaMax);						
			} catch (ParseException e) {
				logger.error("Error parseando la fecha de alta: ", e);
			}
			
		}
		
		//hb.orderBy("iex.auditoria.fechaCrear", "desc");
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public DespachoExterno buscarDespachoUnico(Usuario usuario) {
		
		HQLBuilder hb = new HQLBuilder(" from GestorDespacho des ");
		hb.appendWhere("des.auditoria.borrado=0");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "des.usuario.id", usuario.getId(), true);
		
		HibernateQueryUtils.list(this, hb);
		
		return null;
	}

	
	

}
