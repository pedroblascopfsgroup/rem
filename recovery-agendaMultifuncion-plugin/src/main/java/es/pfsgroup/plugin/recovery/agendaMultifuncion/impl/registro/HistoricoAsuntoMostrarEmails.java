//package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.registro;
//
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
//import org.springframework.stereotype.Component;
//
//import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
//import es.capgemini.pfs.registro.HistoricoAsuntoDto;
//
////@Component
//public class HistoricoAsuntoMostrarEmails implements HistoricoAsuntoBuilder{
//
//	@Override
//	public List<HistoricoAsuntoDto> getHistorico(long arg0) {
//		ArrayList<HistoricoAsuntoDto> historico = new ArrayList<HistoricoAsuntoDto>();
//		
//		historico.add(creaDto());
//		
//		return historico;
//	}
//
//	private HistoricoAsuntoDto creaDto() {
//		return new HistoricoAsuntoDto() {
//			
//			@Override
//			public long getTipoEntidad() {
//				return 1;
//			}
//			
//			@Override
//			public boolean getRespuesta() {
//				return true;
//			}
//			
//			@Override
//			public String getNombreUsuario() {
//				return "test usu";
//			}
//			
//			@Override
//			public String getNombreTarea() {
//				return "Prueba historico envio emails";
//			}
//			
//			@Override
//			public long getIdProcedimiento() {
//				return 0;
//			}
//			
//			@Override
//			public long getIdEntidad() {
//				// TODO Auto-generated method stub
//				return 0;
//			}
//			
//			@Override
//			public Date getFechaVencimiento() {
//				return new Date();
//			}
//			
//			@Override
//			public Date getFechaRegistro() {
//				return new Date();
//			}
//			
//			@Override
//			public Date getFechaIni() {
//				return new Date();
//			}
//			
//			@Override
//			public Date getFechaFin() {
//				return new Date();
//			}
//		};
//	}
//
//}
