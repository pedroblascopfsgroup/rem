package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;

/**
 * Dao del objeto MSVDireccionFechaNotificacion
 * @author manuel
 *
 */
@Repository("MSVDireccionFechaNotificacionDao")
public class MSVDireccionFechaNotificacionDaoImpl extends AbstractEntityDao<MSVDireccionFechaNotificacion, Long> implements MSVDireccionFechaNotificacionDao {

	@Autowired
	private ApiProxyFactory apiProxyFactory;	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao#getFechasNotificacion(java.lang.Long)
	 */
	@Override
	public List<MSVDireccionFechaNotificacion> getFechasNotificacion(Long idProcedimiento) {
		
		HQLBuilder hb = new HQLBuilder("from MSVDireccionFechaNotificacion dfn");
		//hb.appendWhere("auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "dfn.procedimiento.id", idProcedimiento);
		
		return HibernateQueryUtils.list(this, hb);

	}

	@Override
	public List<MSVDireccionFechaNotificacion> getFechasNotificacionPorPersona(Long idProcedimiento, Long idPersona) {
		
		HQLBuilder hb = new HQLBuilder("from MSVDireccionFechaNotificacion dfn");
		//hb.appendWhere("auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "dfn.procedimiento.id", idProcedimiento);
		HQLBuilder.addFiltroIgualQue(hb, "dfn.persona.id", idPersona);		
		
		return HibernateQueryUtils.list(this, hb);

	}
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao#getFechasNotificacion(es.capgemini.pfs.asunto.model.Procedimiento)
	 */
	@Override
	public List<MSVDireccionFechaNotificacion> getFechasNotificacion(Procedimiento procedimiento) {
		return this.getFechasNotificacion(procedimiento.getId());


		// C�digo de pruebas.
//		List<MSVDireccionFechaNotificacion> listado = new ArrayList<MSVDireccionFechaNotificacion>();
//		for (Persona persona: procedimiento.getPersonasAfectadas()){
//			for (Direccion direccion: persona.getDirecciones()){
//				listado.addAll(this.getFechasNotificacionPorDireccion(procedimiento.getId(), persona.getId(), direccion.getCodDireccion()));
//			}
//		}
//		return listado;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao#getMapaPersonasFechasNotificacion(es.capgemini.pfs.asunto.model.Procedimiento)
	 */
	@Override
	public Map<Long, List<MSVDireccionFechaNotificacion>> getMapaPersonasFechasNotificacion(Procedimiento procedimiento) {
		return this.mapeaDirecciones(this.getFechasNotificacion(procedimiento));
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao#getFechasNotificacionPorPersona(java.lang.Long, java.lang.Long)
	 */
//	@Override
//	public List<MSVDireccionFechaNotificacion> getFechasNotificacionPorPersona(Long idProcedimiento, Long idPersona) {
//		// TODO Auto-generated method stub
//		ArrayList<MSVDireccionFechaNotificacion> lista = new ArrayList<MSVDireccionFechaNotificacion>();
//		Random r = new Random();
//
//		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, r.nextLong()));
//		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, r.nextLong()));
//		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, r.nextLong()));
//		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, r.nextLong()));
//		
//		return lista;
//	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.dao.MSVDireccionFechaNotificacionDao#getFechasNotificacionPorDireccion(java.lang.Long, java.lang.Long, java.lang.Long)
	 */
	@Override
	public List<MSVDireccionFechaNotificacion> getFechasNotificacionPorDireccion(Long idProcedimiento, Long idPersona, String idDireccion) {
		// TODO Auto-generated method stub
		ArrayList<MSVDireccionFechaNotificacion> lista = new ArrayList<MSVDireccionFechaNotificacion>();

		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, idDireccion));
		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, idDireccion));
		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, idDireccion));
		lista.add(this.getMSVDireccionFechaNotificacionDummy(idProcedimiento, idPersona, idDireccion));
		
		return lista;
	}	
	
	/**
	 * Agrupa el listado de direcciones en un mapa con key el campo idPersona.
	 * @param listadoDirecciones
	 * @return
	 */
	private HashMap<Long,List<MSVDireccionFechaNotificacion>> mapeaDirecciones(List<MSVDireccionFechaNotificacion> listadoDirecciones){
		
		HashMap<Long,List<MSVDireccionFechaNotificacion>> mapaDirecciones = new HashMap<Long,List<MSVDireccionFechaNotificacion>>();
		for(MSVDireccionFechaNotificacion msvDireccionFechaNotificacion : listadoDirecciones){
			Long idPersona = msvDireccionFechaNotificacion.getPersona().getId();
			if (mapaDirecciones.containsKey(idPersona)){
				mapaDirecciones.get(idPersona).add(msvDireccionFechaNotificacion);
			}else{
				List<MSVDireccionFechaNotificacion> lista = new ArrayList<MSVDireccionFechaNotificacion>();
				lista.add(msvDireccionFechaNotificacion);
				mapaDirecciones.put(idPersona, lista);
			}
		}
		return mapaDirecciones;

	}
	
	private MSVDireccionFechaNotificacion getMSVDireccionFechaNotificacionDummy(Long idProcedimiento, Long idPersona, String idDireccion){
		
		Random r = new Random();
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = new MSVDireccionFechaNotificacion();
		Persona persona = new Persona();
		persona.setId(idPersona);
		Direccion direccion = new Direccion();
		direccion.setDomicilio("Domicilio " + new Random().nextInt(10));
		direccion.setCodDireccion(idDireccion);
		direccion.setId(r.nextLong());
		Procedimiento procedimiento = new Procedimiento();
		procedimiento.setId(idProcedimiento);
		msvDireccionFechaNotificacion.setId(r.nextLong());
		msvDireccionFechaNotificacion.setPersona(persona);
		msvDireccionFechaNotificacion.setProcedimiento(procedimiento);
		msvDireccionFechaNotificacion.setDireccion(direccion);
		msvDireccionFechaNotificacion.setFechaResultado(new Date());
		msvDireccionFechaNotificacion.setFechaSolicitud(new Date());
		msvDireccionFechaNotificacion.setTipoFecha(MSVDireccionFechaNotificacion.CODIGO_TIPO_FECHA_REQUERIMIENTO);
		
		return msvDireccionFechaNotificacion;
	
	}
	

}
