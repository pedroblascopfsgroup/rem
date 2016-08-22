<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var prorrogas = {};

prorrogas.createBaseWin=function(title,contenido){
		var win = new Ext.Window({
			title:title
			,modal:true
			,width:350
			,autoHeight:true
			,resizable:false
			,bodyBorder:false
			,items:[contenido]
		});
		return win;
};

//rellenar con diccionarios
prorrogas.optionsSolProrroga = {diccionario:[{codigo:'1',descripcion:'Ausente'},{codigo:'2',descripcion:'Defuncion'}]};
//rellenar con diccionarios	
prorrogas.optionsAceptarProrroga = {diccionario:[{codigo:'1',descripcion:'Denegado, falta documentacion'},{codigo:'2',descripcion:'Reincidente'}]};
	
prorrogas.winSolicitarProrroga = function(){
	
		var optionsStore = new Ext.data.JsonStore({
	        fields: ['codigo', 'descripcion']
	        ,root: 'diccionario'
	        ,data : this.optionsSolProrroga
	    });
	    var label = new Ext.form.Label({
	    	text:'<s:message code="solicitarprorroga.descripcion" text="**Descripcion" />'
	    });
	    var btnOk = new Ext.Button({
			text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,handler:function(){
				win.close();
			}
		});
		var btnCancel= new Ext.Button({
			text:'<s:message code="app.botones.cancelar" text="**Cancelar" />'
			,handler:function(){
				win.close();
			}
		});
		var text = new Ext.form.TextArea({width:250});
		
		var buttonPanel = new Ext.Panel({
			layout:'column'
			,autoHeight:true
			,autoWidth:true
			,items:[{
				columnWidth:.5
				,items:btnOk
			},{
				columnWidth:.5
				,items:btnCancel
			}]
		});
		
		var combo = new Ext.form.ComboBox({
			store:optionsStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
    		,triggerAction: 'all'
    		,labelStyle:'font-weight:bolder'
    		,fieldLabel : '<s:message code="" text="**Seleccione el motivo" />'
		});
		var txtFecha = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="message" text="**Nueva Fecha" />'
    		,labelStyle:'font-weight:bolder'
    		,minValue : new Date()
    		//dias maximo de prorroga
    		,maxValue : new Date().add(Date.DAY,10)
		});
		
		var contenido = new Ext.Panel({
			bodyStyle : 'padding:5px'
			,bodyBorder:false
			,layout:'anchor'
			,autoHeight:true
			,autoWidth:true
				,defaults:{
					border:false
					,style:'padding:5px'
				}
				,items : [
					{
						anchor:'100%'
						,items:label
					},{
						anchor:'100%'
						,items:app.creaFieldSet([combo])
					},{
						anchor:'100%'
						,items:app.creaFieldSet([txtFecha])
					}
					,{
						anchor:'100%'
						,items:text
					}
					,{
						layout:'table'
						,style:'padding-top:10px;margin-left:30%'
						,items:[btnOk,{html:'&nbsp;',border:false},{html:'&nbsp;',border:false},btnCancel]
					}
				]
		});
		
		
		var win = this.createBaseWin(
			'<s:message code="message" text="**Solicitar Prorroga" />'
			,contenido
		);
		win.show();
}

prorrogas.winAccionProrroga = function(fecha,descripcion){
	
		var optionsStore = new Ext.data.JsonStore({
	        fields: ['codigo', 'descripcion']
	        ,root: 'diccionario'
	        ,data : this.optionsAceptarProrroga
	    });
	    var label = new Ext.form.Label({
	    	text:'<s:message code="" text="**Descripcion" />'
	    });
	    var fecha = app.creaLabel('<s:message code="" text="**Fecha"/>',fecha);
	    var desc  = app.creaLabel('<s:message code="" text="**Descripcion"/>',descripcion);
	    var btnOk = new Ext.Button({
			text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,handler:function(){
				win.close();
			}
		});
		var btnCancel= new Ext.Button({
			text:'<s:message code="app.botones.rechazar" text="**Rechazar" />'
			,handler:function(){
				win.close();
			}
		});
		var text = new Ext.form.TextArea({width:250});
		
		var buttonPanel = new Ext.Panel({
			layout:'column'
			,autoHeight:true
			,autoWidth:true
			,items:[{
				columnWidth:.5
				,items:btnOk
			},{
				columnWidth:.5
				,items:btnCancel
			}]
		});
		
		var combo = new Ext.form.ComboBox({
			store:optionsStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
    		,triggerAction: 'all'
    		,labelStyle:'font-weight:bolder'
    		,fieldLabel : '<s:message code="" text="**Seleccione el motivo" />'
		});
		
		var contenido = new Ext.Panel({
			bodyStyle : 'padding:5px'
			,bodyBorder:false
			,layout:'anchor'
			,autoHeight:true
			,autoWidth:true
				,defaults:{
					border:false
					,style:'padding:5px'
				}
				,items : [
					{
						anchor:'100%'
						,items:label
					},{
						anchor:'100%'
						,items:app.creaFieldSet([fecha])
					},{
						anchor:'100%'
						,items:app.creaFieldSet([desc])
					},{
						anchor:'100%'
						,items:app.creaFieldSet([combo])
					}
					,{
						anchor:'100%'
						,items:text
					}
					,{
						layout:'table'
						,style:'padding-top:10px;margin-left:30%'
						,items:[btnOk,{html:'&nbsp;',border:false},{html:'&nbsp;',border:false},btnCancel]
					}
				]
		});
		var win = this.createBaseWin(
			'<s:message code="message" text="**Acceptar/Rechazar Prorroga" />'
			,contenido
		);
		win.show();
}
