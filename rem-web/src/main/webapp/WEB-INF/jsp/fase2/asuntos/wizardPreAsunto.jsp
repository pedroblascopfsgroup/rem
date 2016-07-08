<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

<%@ include file="../contratos/formBusquedaContratos.jsp" %>
var panel1=formBusquedaContratos();
panel1.contratosGrid.on('rowclick',function(){
	btnNext.setDisabled(false);
});
panel1.contratosGrid.on('rowdblclick',function(){
	step(1);
});
<%-- <%@ include file="formAltaEdicionProcedimiento.jsp" %> --%>
//var panel2=formAltaEdicionProcedimiento();
var panel2=new Ext.Panel({border:false,id:'panel2'});

var currentPanel=0;
var step=function(incr){
	currentPanel += incr;
    if (currentPanel > 1) {
        currentPanel = 1;
    }
    if (currentPanel < 0) {
        currentPanel = 0;
    }
		
	mainPanel.getLayout().setActiveItem(currentPanel);
	
	//btnNext.setDisabled(currentPanel==1);
	if(currentPanel==1){
		panel1.remove();
		panel2.load({
			url:app.resolveFlow('expedientes/editaProcedimiento')
			,scripts:true
			,method:'POST'
			//TODO:pasar parametros reales, que vendran de la pantalla anterior
			,params:{
				idContrato:1
				,idExpediente:1
				,idProcedimiento:0
				,pantalla:'seleccionContratos'
			}
		});
		
		btnNext.setText('Finalizar')
		btnNext.setHandler(function(){
			page.fireEvent(app.event.DONE);
			//page.submit({
			//	eventName : 'update'
			//	,formPanel : panel2
			//	,success : function(){ page.fireEvent(app.event.DONE) }
			//});
		})
	}else{
		btnNext.setHandler(function(){
			step(1)
		})
	}
	btnPrev.setDisabled(currentPanel==0);
	mainPanel.doLayout();
};

var btnNext=new Ext.Button({
	text:'Siguente'
	,disabled:true
	,iconCls:'icon_siguiente'
	,handler:function(){
		step(1)
	}
	
});
var btnPrev=new Ext.Button({
	text:'Atras'
	,iconCls:'icon_atras'
	,disabled:true
	,handler:function(){
		step(-1)
	}
});
var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls:'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});
var mainPanel=new Ext.Panel({
	layout:'card'
	,id:'mainPanel'
	,bodyStyle:'padding:10px'
	,layoutConfig:{
		deferredRender : true
	}
	,border : false
	,activeItem:0
	,autoHeight:true
	,tbar:[btnCancelar,'->',btnNext]
	,items:[panel1,panel2]
});
page.add(mainPanel);
</fwk:page>