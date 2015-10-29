<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>

//----------------------------------------------------------------
// Datos sobre el estado del cumplimiento del acuerdo
//----------------------------------------------------------------

var crearCumplimiento=function(idAcuerdo){
  
	<pfs:hidden name="idAcuerdoHidden" value=""/>
	idAcuerdoHidden.setValue(idAcuerdo);
	

	<pfs:defineRecordType name="cumplimientoRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="usuario"/>
		<pfs:defineTextColumn name="cantidadPagada"/>
		<pfs:defineTextColumn name="fechaPago"/>
		<pfs:defineTextColumn name="cumplido"/>
		<pfs:defineTextColumn name="cerrado"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="parametro" paramId="" idAcuerdo="idAcuerdoHidden"/>	

	<pfs:remoteStore name="cumplimientoStore"
				dataFlow="cumplimientoacuerdo/listacumplimiento"
 				resultRootVar="cumplimiento"
 				recordType="cumplimientoRT"
 				parameters="parametro" 
 				autoload="true"/>
 	
 	<pfs:defineColumnModel name="cumplimientoCM">
		<pfs:defineHeader dataIndex="id" captionKey="plugin.mejoras.acuerdos.cumplimiento.id" caption="**Id" sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="usuario" captionKey="plugin.mejoras.acuerdos.cumplimiento.usuario" caption="**Usuario" sortable="true"/>
		<pfs:defineHeader dataIndex="cantidadPagada" captionKey="plugin.mejoras.acuerdos.cumplimiento.cantidad" caption="**Cantidad" sortable="true" />
		<pfs:defineHeader dataIndex="fechaPago" captionKey="plugin.mejoras.acuerdos.cumplimiento.fechaPago" caption="**Fecha pago" sortable="true" />
		<pfs:defineHeader dataIndex="cumplido" captionKey="plugin.mejoras.acuerdos.cumplimiento.cumplido" caption="**Cumplido" sortable="true" />
		<pfs:defineHeader dataIndex="cerrado" captionKey="plugin.mejoras.acuerdos.cumplimiento.cerrado" caption="**Cerrado" sortable="true" />
	</pfs:defineColumnModel>  
	
   
    var  cumplimientoGrid= app.crearGrid(cumplimientoStore,cumplimientoCM,{
         title : '<s:message code="plugin.mejoras.acuerdos.cumplimiento.grid.titulo" text="**Cumplimiento" />'
         <app:test id="cumplimientoGrid" addComa="true" />
         ,style:'padding-right:10px'
         ,autoHeight : true
		 ,border:true
		 ,margin:90
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
   }); 
   
    var panelCumplimiento=new Ext.Panel({
		layout:'form'
		,border : false
		,autoScroll:false
<!-- 		,bodyStyle:'padding:5px;margin:5px' -->
		,bodyStyle:'margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'cumplimiento'
		,items : [ 
 		 	cumplimientoGrid 
 		]
	});
   
   
   return panelCumplimiento;
  
<!--    return { -->
<%-- 		title:'<s:message code="plugin.mejoras.acuerdos.cumplimiento.titulo" text="**Detalles sobre el cumplimiento del acuerdo"/>' --%>
<!-- 		,autoHeight:true -->
<!-- 		,xtype:'fieldset' -->
<!-- 		,border:true -->
<!-- 		,bodyStyle:'padding:5px;cellspacing:20px;' -->
<!-- 		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true} -->
<!-- 		,items : [ -->
<!-- 		 	cumplimientoGrid -->
<!-- 		] -->
<!-- 	} -->
   


 };