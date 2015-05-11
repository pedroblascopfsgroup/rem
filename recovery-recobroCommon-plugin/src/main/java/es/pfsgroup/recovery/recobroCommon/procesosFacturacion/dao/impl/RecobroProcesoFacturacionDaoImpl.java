package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dao.api.RecobroProcesoFacturacionDao;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;

@Repository("RecobroProcesoFacturacionDao")
public class RecobroProcesoFacturacionDaoImpl extends AbstractEntityDao<RecobroProcesoFacturacion, Long> implements RecobroProcesoFacturacionDao{

	@Override
	public Page buscaProcesoFacturacion(RecobroProcesosFacturacionDto dto) {
		String formatoFecha = "yyyy-MM-dd";
		
		Assertions.assertNotNull(dto, "RecobroProcesoFacturacionDto: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("select distinct proceso from RecobroProcesoFacturacion proceso");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "proceso.nombre", dto.getNombre() ,true);
		
		HQLBuilder.addFiltroBetweenSiNotNull(hb, "proceso.fechaDesde", parseaFecha(dto.getFechaInicioDesde(), formatoFecha), parseaFecha(dto.getFechaInicioHasta(), formatoFecha));
		HQLBuilder.addFiltroBetweenSiNotNull(hb, "proceso.fechaHasta", parseaFecha(dto.getFechaFinDesde(), formatoFecha), parseaFecha(dto.getFechaFinHasta(), formatoFecha));
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "proceso.estadoProcesoFacturable.codigo", dto.getEstadoProcesoFacturable());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public List<RecobroProcesoFacturacion> getProcesosByState(String estado) {
		HQLBuilder hb = new HQLBuilder("select distinct proceso from RecobroProcesoFacturacion proceso");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "proceso.estadoProcesoFacturable.codigo", estado);
		HQLBuilder.addFiltroIgualQue(hb, "proceso.auditoria.borrado", false);
		
		return (ArrayList<RecobroProcesoFacturacion>)HibernateQueryUtils.list(this,hb);
	}

	@Override
	public RecobroProcesoFacturacion buscaUltimoProcesoFacturado() {
		HQLBuilder hb = new HQLBuilder("select proceso from RecobroProcesoFacturacion proceso"
				+ " where proceso.estadoProcesoFacturable.codigo ='LBR' "
				+" and proceso.fechaHasta = (select max(fechaHasta)from RecobroProcesoFacturacion"
				+ " where estadoProcesoFacturable.codigo ='LBR')");
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
	private Date parseaFecha(final String fecha, final String formato) {
		if (Checks.esNulo(fecha) || fecha.equals("")) return null;
		
        final SimpleDateFormat sdf = new SimpleDateFormat(formato);
        try {
            return sdf.parse(fecha);
        } catch (ParseException e) {
            logger.error("No se ha podido parsear la fecha '" + fecha + "' al formato '" + formato + "'");
            return null;
        }
    }

	@Override
	public List<RecobroProcesoFacturacion> dameProcesosFacturacionRelacionadosModelo(
			Long idModelo) {
		HQLBuilder hb = new HQLBuilder("select proceso from RecobroProcesoFacturacion proceso"
				+ " join proceso.procesoSubcarteras procesoSubcartera"
				+ " where procesoSubcartera.modeloFacturacionActual.id = "+idModelo+""
						+ " or procesoSubcartera.modeloFacturacionInicial.id = "+idModelo+"");
	
		return HibernateQueryUtils.list(this, hb);		
	}


}
