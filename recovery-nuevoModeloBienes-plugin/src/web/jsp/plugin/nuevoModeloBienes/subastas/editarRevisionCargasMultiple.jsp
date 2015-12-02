<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	var labelStyle = 'width:185px;font-weight:bolder,width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder,width:375';
	var labelStyleTextArea = 'font-weight:bolder,width:500';
	
	var idBienes=new Array();
	<c:forEach var="id" items="${idBienes}"> 
		    idBienes.push(<c:out value="${id}"/>);
	</c:forEach>
	

	<pfsforms:datefield labelKey="plugin.nuevoModeloBienes.cargas.fechaRevision" 
		label="**Fecha Revision" name="fechaRevision"/>

	var sinCargas = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.sinCargas" text="**Sin Cargas"/>'
		,name:'sinCargas'
		,labelStyle:labelStyle
		,disabled:true
	});
	sinCargas.checked = true;
	
	
	<%--
	if('${NMBbien.adicional.sinCargas}' == 'true'){
		sinCargas.checked = true;
	}
	else{
		sinCargas.checked = false;
	}--%>
	

	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.observaciones" text="**Observaciones" />'
		//,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.observaciones}" />'
		,name:'observaciones'
		,hideLabel: true
		,width:375
		,height: 140
		,readOnly:false
	});
	
	var getParametros = function() {
		
	 	var parametros = {};
	 	parametros.idBienes=idBienes;
		parametros.id=''; 
		parametros.fechaRevision = fechaRevision.getValue() ? fechaRevision.getValue().format('d/m/Y') : '';
		parametros.sinCargas = sinCargas.getValue();
	    parametros.observaciones = observaciones.getValue();
	 	
	 	return parametros;
	 }
	
	var btnGuardar = new Ext.Button({
		    text: '<s:message code="app.guardar" text="**Guardar" />'
			<app:test id="btnEditarSolvencia" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		    	var p = getParametros();
		    	Ext.Ajax.request({
						url : page.resolveUrl('subasta/saveRevisionCargasMultiple'), 
						params : p ,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
	        }
	});
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	

	var panelRevision = new Ext.form.FieldSet({
		height:290
		,width:400
		,style:'padding:0px; margin-right:20px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.revisionCargas.titulo" text="**Revision de cargas"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:400}
	    ,items : [{items:[fechaRevision,sinCargas,observaciones]}]
	});
	


	
	var panel = new Ext.Panel({
		 width:402
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [panelRevision]
		,bbar:[btnGuardar,btnCancelar]
		
	});
	
	
	page.add(panel);

</fwk:page>