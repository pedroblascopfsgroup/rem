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

	var factoriaFormularios = new es.pfs.plugins.procuradores.FactoriaFormularios();
	//var controlador = new es.pfs.plugins.masivo.ControladorAsincrono();
	
	var ayuda= { html:'<div style="font-size:0.75em;">${html}</div>', border:false};
	
	var idInput = '${idInput}';
	
	var datosResolucion = new Ext.form.FieldSet({
        autoHeight:'false'
        ,style:'padding:2px'
        ,title:'Datos de la Resoluci&oacute;n'
        ,hidden:false
        ,border:true
        ,layout : 'column'
        ,layoutConfig:{
            columns:2
        }
        ,width:810
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:3px'} 
        ,items : [ 
        
        		{
        			width:400
               	},
               	{
               		width:400
               	},
				{
					xtype:'hidden'
					,name:'idProcedimiento'
					,value:'${idProcedimiento}'
        		 },
        		 {
					xtype:'hidden'
					,name:'idTarea'
					,value:'${idTarea}'
        		 },
        		 {
					xtype:'hidden'
					,name:'idTipoResolucion'
					,value:'${idTipoResolucion}'
        		 }
        ]
    }); 
    
    datosResolucion.doLayout();
    datosResolucion.add(factoriaFormularios.getFormItems('${idTipoResolucion}','${idAsunto}', '${codigoTipoProc}', '${codigoPlaza}','${idProcedimiento}',true));
	factoriaFormularios.updateStores('${idTipoResolucion}');
	
	
	var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){
				page.fireEvent(app.event.CANCEL);
		}
	});
	
	

	var bottomBar = [];

	bottomBar.push(btnCancelar);
	
	
	var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:820
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			//,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:5px'
					,autoHeight:true
					,items:[ayuda,datosResolucion]
					//,columnWidth:.5
				}
			]
		}
		
	]
	,bbar:bottomBar   
});

page.add(panelEdicion);

Ext.onReady(function(){
	panelEdicion.getForm().findField('file').setVisible(false);
	Ext.Ajax.request({
		url: '/pfs/msvhistoricotareas/getDetalleResolucion.htm'
		,params: {idInput: idInput}
		,method: 'POST'
		,success: function (result, request){
			var r = Ext.util.JSON.decode(result.responseText);
			
			panelEdicion.getForm().reset();
			panelEdicion.getForm().setValues(r.resolucion);
			
			var itemsFormPanel = panelEdicion.getForm().items.items;
			for (i = 0; i < itemsFormPanel.length; i++) {
				if (itemsFormPanel[i].isXType('combo')) {
					itemsFormPanel[i].fireEvent('select',itemsFormPanel[i]);
				}
			}

		}
		,error : function (result, request){
			alert("error");
		}
	});
});

</fwk:page>